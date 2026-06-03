import '../event_bus.dart';

// ---------------------------------------------------------------------------
// CollaborativeMode
// Multi-user session with roles (host/dj/listener) and action permissions.
// Miroir de collaborative_mode.rs (Rust)
// ---------------------------------------------------------------------------

/// Roles in a collaborative session.
enum CollaborativeRole {
  host,     // Full control: play, pause, queue, skip, kick users
  dj,       // Can queue tracks and skip
  listener; // Can only listen and vote in party mode

  bool get canPlay => this == host;
  bool get canPause => this == host;
  bool get canSkip => this == host || this == dj;
  bool get canQueue => this == host || this == dj;
  bool get canKick => this == host;
  bool get canChangeVolume => this == host;
}

/// A participant in the collaborative session.
class CollaborativeParticipant {
  final String userId;
  final String displayName;
  CollaborativeRole role;
  final DateTime joinedAt;

  CollaborativeParticipant({
    required this.userId,
    required this.displayName,
    required this.role,
    DateTime? joinedAt,
  }) : joinedAt = joinedAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'display_name': displayName,
        'role': role.name,
        'joined_at': joinedAt.toIso8601String(),
      };
}

/// Event when a participant joins/leaves/changes role.
class CollaborativeSessionEvent extends AppEvent {
  final String zoneId;
  final String action; // 'joined' | 'left' | 'role_changed' | 'started' | 'ended'
  final String? userId;
  const CollaborativeSessionEvent(this.zoneId, this.action, {this.userId});
}

class CollaborativeMode {
  final String zoneId;
  final Map<String, CollaborativeParticipant> _participants = {};

  bool _active = false;
  String? _hostId;

  /// Session code for joining (simple random string).
  String? _sessionCode;

  CollaborativeMode({required this.zoneId});

  // ---------------------------------------------------------------------------
  // State
  // ---------------------------------------------------------------------------

  bool get isActive => _active;
  String? get hostId => _hostId;
  String? get sessionCode => _sessionCode;

  List<CollaborativeParticipant> get participants =>
      _participants.values.toList();

  int get participantCount => _participants.length;

  // ---------------------------------------------------------------------------
  // Session lifecycle
  // ---------------------------------------------------------------------------

  /// Start a collaborative session. The caller becomes the host.
  String start({required String hostUserId, required String hostDisplayName}) {
    if (_active) return _sessionCode ?? '';

    _active = true;
    _hostId = hostUserId;
    _sessionCode = _generateSessionCode();

    _participants[hostUserId] = CollaborativeParticipant(
      userId: hostUserId,
      displayName: hostDisplayName,
      role: CollaborativeRole.host,
    );

    EventBus.instance.emit(
      CollaborativeSessionEvent(zoneId, 'started', userId: hostUserId),
    );

    return _sessionCode!;
  }

  /// End the collaborative session (host only).
  bool end({required String requesterId}) {
    if (!_active) return false;
    if (requesterId != _hostId) return false;

    _active = false;
    _participants.clear();
    _hostId = null;
    _sessionCode = null;

    EventBus.instance.emit(
      CollaborativeSessionEvent(zoneId, 'ended'),
    );
    return true;
  }

  // ---------------------------------------------------------------------------
  // Participants
  // ---------------------------------------------------------------------------

  /// Join an existing session with the session code.
  bool join({
    required String userId,
    required String displayName,
    required String code,
    CollaborativeRole role = CollaborativeRole.listener,
  }) {
    if (!_active) return false;
    if (code != _sessionCode) return false;
    if (_participants.containsKey(userId)) return false;

    _participants[userId] = CollaborativeParticipant(
      userId: userId,
      displayName: displayName,
      role: role,
    );

    EventBus.instance.emit(
      CollaborativeSessionEvent(zoneId, 'joined', userId: userId),
    );
    return true;
  }

  /// Leave the session.
  bool leave({required String userId}) {
    if (!_active) return false;

    final removed = _participants.remove(userId);
    if (removed == null) return false;

    // If host leaves, end the session
    if (userId == _hostId) {
      end(requesterId: userId);
      return true;
    }

    EventBus.instance.emit(
      CollaborativeSessionEvent(zoneId, 'left', userId: userId),
    );
    return true;
  }

  /// Kick a participant (host only).
  bool kick({required String requesterId, required String targetUserId}) {
    if (!_active) return false;
    if (!checkPermission(requesterId, 'kick')) return false;
    if (targetUserId == _hostId) return false; // can't kick the host

    final removed = _participants.remove(targetUserId);
    if (removed == null) return false;

    EventBus.instance.emit(
      CollaborativeSessionEvent(zoneId, 'left', userId: targetUserId),
    );
    return true;
  }

  /// Change a participant's role (host only).
  bool changeRole({
    required String requesterId,
    required String targetUserId,
    required CollaborativeRole newRole,
  }) {
    if (!_active) return false;
    if (requesterId != _hostId) return false;
    if (targetUserId == _hostId) return false; // can't change host's role

    final participant = _participants[targetUserId];
    if (participant == null) return false;

    participant.role = newRole;

    EventBus.instance.emit(
      CollaborativeSessionEvent(zoneId, 'role_changed', userId: targetUserId),
    );
    return true;
  }

  // ---------------------------------------------------------------------------
  // Permission checks
  // ---------------------------------------------------------------------------

  /// Check if a user has permission for an action.
  bool checkPermission(String userId, String action) {
    if (!_active) return true; // No session = no restrictions

    final participant = _participants[userId];
    if (participant == null) return false;

    switch (action) {
      case 'play':
        return participant.role.canPlay;
      case 'pause':
        return participant.role.canPause;
      case 'skip':
      case 'next':
      case 'previous':
        return participant.role.canSkip;
      case 'queue':
      case 'add':
        return participant.role.canQueue;
      case 'kick':
        return participant.role.canKick;
      case 'volume':
        return participant.role.canChangeVolume;
      default:
        return participant.role == CollaborativeRole.host;
    }
  }

  /// Get participant by user ID.
  CollaborativeParticipant? getParticipant(String userId) =>
      _participants[userId];

  // ---------------------------------------------------------------------------
  // Snapshot for API
  // ---------------------------------------------------------------------------

  Map<String, dynamic> snapshot() => {
        'active': _active,
        'session_code': _sessionCode,
        'host_id': _hostId,
        'participant_count': _participants.length,
        'participants': _participants.values.map((p) => p.toJson()).toList(),
      };

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  static String _generateSessionCode() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final rng = DateTime.now().millisecondsSinceEpoch;
    final buf = StringBuffer();
    var seed = rng;
    for (var i = 0; i < 6; i++) {
      buf.write(chars[seed % chars.length]);
      seed = (seed * 1103515245 + 12345) & 0x7fffffff;
    }
    return buf.toString();
  }
}
