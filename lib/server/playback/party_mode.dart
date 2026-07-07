import '../database/database.dart';
import '../event_bus.dart';

// ---------------------------------------------------------------------------
// PartyMode
// Voting queue — users add tracks and vote, next track = highest votes.
// Miroir de party_mode.rs (Rust)
// ---------------------------------------------------------------------------

/// A track in the party queue with vote count.
class PartyTrackEntry {
  final Track track;
  final String addedBy;       // user identifier
  final DateTime addedAt;
  int votes;
  final Set<String> voters;   // track who voted to prevent double-voting

  PartyTrackEntry({
    required this.track,
    required this.addedBy,
    DateTime? addedAt,
    this.votes = 0,
  })  : addedAt = addedAt ?? DateTime.now(),
        voters = {};
}

/// Event emitted when party queue changes.
class PartyQueueChangedEvent extends AppEvent {
  final String zoneId;
  const PartyQueueChangedEvent(this.zoneId);
}

class PartyMode {
  final String zoneId;
  final List<PartyTrackEntry> _queue = [];
  bool _active = false;

  /// Maximum queue size to prevent unbounded growth.
  int maxQueueSize;

  PartyMode({required this.zoneId, this.maxQueueSize = 200});

  // ---------------------------------------------------------------------------
  // State
  // ---------------------------------------------------------------------------

  bool get isActive => _active;
  List<PartyTrackEntry> get queue => List.unmodifiable(_queue);
  int get length => _queue.length;
  bool get isEmpty => _queue.isEmpty;

  // ---------------------------------------------------------------------------
  // Lifecycle
  // ---------------------------------------------------------------------------

  void activate() {
    _active = true;
    _queue.clear();
  }

  void deactivate() {
    _active = false;
    _queue.clear();
  }

  // ---------------------------------------------------------------------------
  // Add / Remove tracks
  // ---------------------------------------------------------------------------

  /// Add a track to the party queue.
  /// Returns false if queue is full.
  bool addTrack(Track track, {required String userId}) {
    if (!_active) return false;
    if (_queue.length >= maxQueueSize) return false;

    // Check if track is already in queue
    final existing = _queue.indexWhere((e) => e.track.id == track.id);
    if (existing >= 0) return false; // already in queue

    _queue.add(PartyTrackEntry(
      track: track,
      addedBy: userId,
      votes: 1, // auto-vote by the person who added it
    )..voters.add(userId));

    EventBus.instance.emit(PartyQueueChangedEvent(zoneId));
    return true;
  }

  /// Remove a track from the party queue (admin action).
  bool removeTrack(int trackId) {
    _queue.removeWhere((e) => e.track.id == trackId);
    EventBus.instance.emit(PartyQueueChangedEvent(zoneId));
    return true;
  }

  // ---------------------------------------------------------------------------
  // Voting
  // ---------------------------------------------------------------------------

  /// Vote for a track. Returns false if already voted or track not found.
  bool vote(int trackId, {required String userId}) {
    if (!_active) return false;

    final entry = _queue.where((e) => e.track.id == trackId).firstOrNull;
    if (entry == null) return false;

    // Prevent double voting
    if (entry.voters.contains(userId)) return false;

    entry.votes++;
    entry.voters.add(userId);

    // Re-sort by votes descending
    _queue.sort((a, b) {
      final voteCompare = b.votes.compareTo(a.votes);
      if (voteCompare != 0) return voteCompare;
      return a.addedAt.compareTo(b.addedAt); // FIFO for equal votes
    });

    EventBus.instance.emit(PartyQueueChangedEvent(zoneId));
    return true;
  }

  /// Remove a vote. Returns false if user hasn't voted.
  bool unvote(int trackId, {required String userId}) {
    if (!_active) return false;

    final entry = _queue.where((e) => e.track.id == trackId).firstOrNull;
    if (entry == null) return false;

    if (!entry.voters.contains(userId)) return false;

    entry.votes--;
    entry.voters.remove(userId);

    // Re-sort
    _queue.sort((a, b) {
      final voteCompare = b.votes.compareTo(a.votes);
      if (voteCompare != 0) return voteCompare;
      return a.addedAt.compareTo(b.addedAt);
    });

    EventBus.instance.emit(PartyQueueChangedEvent(zoneId));
    return true;
  }

  // ---------------------------------------------------------------------------
  // Next track
  // ---------------------------------------------------------------------------

  /// Returns the next track to play (highest votes) and removes it from queue.
  Track? next() {
    if (_queue.isEmpty) return null;

    // Already sorted by votes desc — take first
    final entry = _queue.removeAt(0);

    EventBus.instance.emit(PartyQueueChangedEvent(zoneId));
    return entry.track;
  }

  /// Peek at the next track without removing it.
  Track? peek() {
    if (_queue.isEmpty) return null;
    return _queue.first.track;
  }

  // ---------------------------------------------------------------------------
  // Snapshot for API
  // ---------------------------------------------------------------------------

  List<Map<String, dynamic>> snapshot() {
    return _queue.map((e) => {
      'track_id': e.track.id,
      'title': e.track.title,
      'artist_name': e.track.artistName,
      'album_title': e.track.albumTitle,
      'added_by': e.addedBy,
      'votes': e.votes,
      'voter_count': e.voters.length,
    }).toList();
  }
}
