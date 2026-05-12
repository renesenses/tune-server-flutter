part of 'app_state.dart';

// Extension AppState — event loop EventBus :
// - _subscribeToEventBus : enregistre tous les abonnements typés
//   (PlaybackStateChanged, TrackChanged, Position, Queue, Devices,
//   LibraryScan*, RadioMetadata, Zone lifecycle/grouping, ServerError)
// - Handlers privés : _on* qui mettent à jour zoneState / libraryState
//   et déclenchent _refreshZones / _refreshLibrarySummary au besoin

extension AppStateEvents on AppState {

  // ---------------------------------------------------------------------------
  // Event loop — abonnements EventBus
  // ---------------------------------------------------------------------------

  void _subscribeToEventBus() {
    // Playback state
    _subs.add(EventBus.instance
        .subscribe<PlaybackStateChangedEvent>(_onPlaybackStateChanged));

    // Track changed
    _subs.add(EventBus.instance
        .subscribe<TrackChangedEvent>(_onTrackChanged));

    // Position
    _subs.add(EventBus.instance
        .subscribe<PlaybackPositionEvent>(_onPosition));

    // Queue
    _subs.add(EventBus.instance
        .subscribe<QueueChangedEvent>(_onQueueChanged));

    // Devices
    _subs.add(EventBus.instance
        .subscribe<DeviceDiscoveredEvent>(_onDeviceDiscovered));
    _subs.add(EventBus.instance
        .subscribe<DeviceLostEvent>(_onDeviceLost));

    // Library scan
    _subs.add(EventBus.instance
        .subscribe<LibraryScanStartedEvent>((e) => libraryState.setScanStarted(deviceId: e.deviceId)));
    _subs.add(EventBus.instance
        .subscribe<LibraryScanProgressEvent>(_onScanProgress));
    _subs.add(EventBus.instance
        .subscribe<LibraryScanCompletedEvent>(_onScanCompleted));
    _subs.add(EventBus.instance
        .subscribe<LibraryScanErrorEvent>(_onScanError));

    // Radio metadata
    _subs.add(EventBus.instance
        .subscribe<RadioMetadataEvent>(_onRadioMetadata));

    // Zone lifecycle — auto-refresh zones list on changes
    _subs.add(EventBus.instance
        .subscribe<ZoneCreatedEvent>((_) => _refreshZones()));
    _subs.add(EventBus.instance
        .subscribe<ZoneDeletedEvent>((_) => _refreshZones()));
    _subs.add(EventBus.instance
        .subscribe<ZoneUpdatedEvent>((_) => _refreshZones()));

    // Zone grouping
    _subs.add(EventBus.instance
        .subscribe<ZoneGroupedEvent>((_) => _refreshZones()));
    _subs.add(EventBus.instance
        .subscribe<ZoneUngroupedEvent>((_) => _refreshZones()));

    // Server errors
    _subs.add(EventBus.instance
        .subscribe<ServerErrorEvent>(_onServerError));
  }

  void _onPlaybackStateChanged(PlaybackStateChangedEvent e) {
    final zone = _findZone(e.zoneId);
    if (zone != null) {
      final state = PlaybackState.fromRawValue(e.state) ?? PlaybackState.stopped;
      zoneState.updateZone(zone.copyWith(state: state));
    }
  }

  void _onTrackChanged(TrackChangedEvent e) {
    final zone = _findZone(e.zoneId);
    if (zone != null) {
      final track = e.track as Track?;
      zoneState.updateZone(zone.copyWith(currentTrack: track));
      if (track != null) {
        libraryState.prependHistory(track, zoneName: zone.name);
      }
    }
  }

  void _onPosition(PlaybackPositionEvent e) {
    zoneState.updatePosition(
      int.tryParse(e.zoneId) ?? -1,
      e.positionMs,
    );
  }

  void _onQueueChanged(QueueChangedEvent e) {
    final zoneId = int.tryParse(e.zoneId);
    if (zoneId == null) return;
    final instance = engine.zoneManager.zone(zoneId);
    if (instance != null) {
      zoneState.setQueueSnapshot(instance.queue.snapshot());
      zoneState.updateZone(instance.snapshot());
    }
  }

  void _onDeviceDiscovered(DeviceDiscoveredEvent e) {
    zoneState.setDevices(engine.allDevices());
    notify();
  }

  void _onDeviceLost(DeviceLostEvent e) {
    zoneState.removeDevice(e.deviceId);
    notify();
  }

  void _onScanProgress(LibraryScanProgressEvent e) {
    libraryState.setScanProgress(e.scanned, e.total);
  }

  Future<void> _onScanCompleted(LibraryScanCompletedEvent e) async {
    libraryState.setScanCompleted(e.tracksAdded, e.tracksUpdated);
    await _refreshLibrarySummary();
    final stats = await engine.stats();
    libraryState.setStats(stats);
  }

  void _onScanError(LibraryScanErrorEvent e) {
    libraryState.setScanCompleted(0, 0);
  }

  void _onRadioMetadata(RadioMetadataEvent e) {
    // L'UI écoute RadioMetadataEvent via EventBus directement pour la radio
    // en cours — pas de stockage dans LibraryState (éphémère)
  }

  void _onServerError(ServerErrorEvent e) {
    _errorMessage = e.message;
    notify();
  }
}
