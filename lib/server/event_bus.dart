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
  const LibraryScanStartedEvent();
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
