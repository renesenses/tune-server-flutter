import 'dart:async';

// ---------------------------------------------------------------------------
// T2.1 — EventBus
// StreamController broadcast — miroir de EventBus.swift (iOS)
//
// Usage :
//   final sub = EventBus.instance.subscribe<TrackChangedEvent>((e) { … });
//   EventBus.instance.emit(TrackChangedEvent(track));
//   sub.cancel();
// ---------------------------------------------------------------------------

// ---------------------------------------------------------------------------
// Hiérarchie d'événements
// ---------------------------------------------------------------------------

/// Classe de base de tous les événements applicatifs.
abstract class AppEvent {
  const AppEvent();
}

// --- Playback ---

class PlaybackStateChangedEvent extends AppEvent {
  final String zoneId;
  final String state; // 'stopped' | 'playing' | 'paused' | 'buffering'
  const PlaybackStateChangedEvent(this.zoneId, this.state);
}

class TrackChangedEvent extends AppEvent {
  final String zoneId;
  final dynamic track; // Track (drift) | null
  const TrackChangedEvent(this.zoneId, this.track);
}

class PlaybackPositionEvent extends AppEvent {
  final String zoneId;
  final int positionMs;
  const PlaybackPositionEvent(this.zoneId, this.positionMs);
}

class QueueChangedEvent extends AppEvent {
  final String zoneId;
  const QueueChangedEvent(this.zoneId);
}

// --- Library ---

class LibraryScanStartedEvent extends AppEvent {
  /// ID du device UPnP en cours d'indexation, ou null pour un scan local/SMB.
  final String? deviceId;
  const LibraryScanStartedEvent({this.deviceId});
}

class LibraryScanProgressEvent extends AppEvent {
  final int scanned;
  final int total;
  const LibraryScanProgressEvent(this.scanned, this.total);
}

class LibraryScanCompletedEvent extends AppEvent {
  final int tracksAdded;
  final int tracksUpdated;
  const LibraryScanCompletedEvent(this.tracksAdded, this.tracksUpdated);
}

class LibraryScanErrorEvent extends AppEvent {
  final String message;
  const LibraryScanErrorEvent(this.message);
}

class LibraryEnrichProgressEvent extends AppEvent {
  final int processed;
  final int total;
  const LibraryEnrichProgressEvent(this.processed, this.total);
}

class LibraryEnrichCompletedEvent extends AppEvent {
  final int processed;
  final int total;
  const LibraryEnrichCompletedEvent(this.processed, this.total);
}

// --- Discovery ---

class DeviceDiscoveredEvent extends AppEvent {
  final dynamic device; // DiscoveredDevice
  const DeviceDiscoveredEvent(this.device);
}

class DeviceLostEvent extends AppEvent {
  final String deviceId;
  const DeviceLostEvent(this.deviceId);
}

// --- Radio ---

class RadioMetadataEvent extends AppEvent {
  final String stationName;
  final String? title;
  final String? artist;
  const RadioMetadataEvent(this.stationName, {this.title, this.artist});
}

// --- Peer discovery (Tune servers on LAN) ---

class PeerDiscoveredEvent extends AppEvent {
  final String name;
  final String host;
  final int port;
  final String version;
  final int trackCount;
  final int zoneCount;
  final String serverId;
  const PeerDiscoveredEvent({
    required this.name,
    required this.host,
    required this.port,
    this.version = '',
    this.trackCount = 0,
    this.zoneCount = 0,
    this.serverId = '',
  });
}

class PeerLostEvent extends AppEvent {
  final String name;
  final String host;
  const PeerLostEvent({required this.name, required this.host});
}

// --- Zones ---

class ZoneCreatedEvent extends AppEvent {
  final int zoneId;
  final String name;
  const ZoneCreatedEvent(this.zoneId, this.name);
}

class ZoneDeletedEvent extends AppEvent {
  final int zoneId;
  const ZoneDeletedEvent(this.zoneId);
}

class ZoneUpdatedEvent extends AppEvent {
  final int zoneId;
  const ZoneUpdatedEvent(this.zoneId);
}

class ZoneGroupedEvent extends AppEvent {
  final String groupId;
  final List<int> zoneIds;
  const ZoneGroupedEvent(this.groupId, this.zoneIds);
}

class ZoneUngroupedEvent extends AppEvent {
  final String groupId;
  const ZoneUngroupedEvent(this.groupId);
}

// --- Playback lifecycle (used by ServerEngine for state persistence) ---

class PlaybackStartedEvent extends AppEvent {
  final int zoneId;
  final int? positionMs;
  final int? durationMs;
  const PlaybackStartedEvent(this.zoneId, {this.positionMs, this.durationMs});
}

class PlaybackStoppedEvent extends AppEvent {
  final int zoneId;
  const PlaybackStoppedEvent(this.zoneId);
}

// --- Server lifecycle ---

class ServerStartedEvent extends AppEvent {
  final int port;
  const ServerStartedEvent(this.port);
}

class ServerStoppedEvent extends AppEvent {
  const ServerStoppedEvent();
}

class ServerErrorEvent extends AppEvent {
  final String message;
  const ServerErrorEvent(this.message);
}

// ---------------------------------------------------------------------------
// EventBus
// ---------------------------------------------------------------------------

class EventBus {
  EventBus._();
  static final EventBus instance = EventBus._();

  final StreamController<AppEvent> _controller =
      StreamController<AppEvent>.broadcast();

  /// Émet un événement vers tous les abonnés.
  void emit(AppEvent event) {
    if (!_controller.isClosed) _controller.add(event);
  }

  /// S'abonne aux événements d'un type précis.
  /// Retourne un [StreamSubscription] à annuler en dispose.
  StreamSubscription<T> subscribe<T extends AppEvent>(
    void Function(T event) handler,
  ) {
    return _controller.stream.where((e) => e is T).cast<T>().listen(handler);
  }

  /// Expose le stream brut pour les cas avancés (Riverpod, etc.).
  Stream<T> on<T extends AppEvent>() =>
      _controller.stream.where((e) => e is T).cast<T>();

  /// À appeler uniquement en fin de vie de l'application.
  Future<void> dispose() => _controller.close();
}
