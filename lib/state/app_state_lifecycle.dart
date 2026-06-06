part of 'app_state.dart';

// Extension AppState — cycle de vie connexion :
// - Lifecycle serveur : startServer / stopServer (engine local) +
//   _refreshUpdateInfo (polling 30 min vers GitHub releases)
// - Remote mode : connectRemote / disconnectRemote, WebSocket events,
//   polling 3s, refresh zones / library / streaming services / radios

extension AppStateLifecycle on AppState {

  // ---------------------------------------------------------------------------
  // Lifecycle serveur
  // ---------------------------------------------------------------------------

  Future<void> startServer() async {
    try {
      await engine.start();
      _serverStarted = true;
      _errorMessage = null;

      // Charge les données initiales
      await Future.wait([
        _refreshZones(),
        _refreshLibrarySummary(),
        _refreshRadios(),
        _refreshPlaylists(),
        _refreshFavoriteTracks(),
        _refreshStreamingStatus(),
      ]);

      // Charge les devices déjà connus + relance le discovery SSDP
      zoneState.setDevices(engine.allDevices());
      engine.discoveryManager.refresh();

      // First update check + 30 min polling. We don't await — it's a
      // network call that shouldn't block server boot.
      _refreshUpdateInfo();
      _updateCheckTimer = Timer.periodic(
        const Duration(minutes: 30),
        (_) => _refreshUpdateInfo(),
      );

      notify();
    } catch (e) {
      _errorMessage = e.toString();
      notify();
    }
  }

  Future<void> _refreshUpdateInfo() async {
    try {
      _updateInfo = await UpdateChecker().check();
      notify();
    } catch (_) {
      // UpdateChecker.check already swallows network errors;
      // anything that bubbles here is a programming bug, not a
      // user-facing failure.
    }
  }

  Future<void> stopServer() async {
    _updateCheckTimer?.cancel();
    _updateCheckTimer = null;
    await engine.stop();
    _serverStarted = false;
    notify();
  }

  // ---------------------------------------------------------------------------
  // Remote mode — connect to a remote Tune server
  // ---------------------------------------------------------------------------

  Future<void> connectRemote() async {
    final host = settingsState.remoteHost;
    if (host.isEmpty) {
      _errorMessage = 'Adresse serveur non configurée';
      notify();
      return;
    }
    try {
      _apiClient = TuneApiClient(settingsState.remoteBaseUrl);

      // Inject auth token if available
      if (_authToken != null) {
        _apiClient!.authToken = _authToken;
      }
      // Wire 401 handler
      _apiClient!.onUnauthorized = () {
        _authToken = null;
        // Notify listeners so UI can react (show login screen)
        notify();
      };

      // Test connection
      final ok = await _apiClient!.testConnection();
      if (!ok) {
        _errorMessage = 'Impossible de se connecter à $host';
        _apiClient = null;
        notify();
        return;
      }

      // Connect WebSocket
      _webSocket = TuneWebSocket(settingsState.remoteWsUrl);
      await _webSocket!.connect();
      _wsSubscription = _webSocket!.eventStream.listen(_handleRemoteEvent);

      // Start track change notification service
      _trackNotificationService?.dispose();
      _trackNotificationService = TrackNotificationService(
        onTrackChanged: (info) => onTrackChangeNotification?.call(info),
      );
      _trackNotificationService!.listen(_webSocket!);

      _serverStarted = true;
      _errorMessage = null;

      // Load initial data
      await Future.wait([
        refreshZonesRemote(),
        _refreshRadiosRemote(),
        _refreshLibraryRemote(),
        _refreshStreamingServicesRemote(),
      ]);

      // Start polling for position updates (every 3s)
      _remotePollingTimer?.cancel();
      _remotePollingTimer = Timer.periodic(const Duration(seconds: 3), (_) {
        refreshZonesRemote();
      });

      notify();
    } catch (e) {
      _errorMessage = 'Erreur connexion: $e';
      _apiClient = null;
      notify();
    }
  }

  Future<void> disconnectRemote() async {
    _remotePollingTimer?.cancel();
    _remotePollingTimer = null;
    _trackNotificationService?.dispose();
    _trackNotificationService = null;
    _wsSubscription?.cancel();
    _wsSubscription = null;
    _webSocket?.dispose();
    _webSocket = null;
    _apiClient = null;
    _serverStarted = false;
    zoneState.reset();
    notify();
  }

  // ---------------------------------------------------------------------------
  // Mode switch — stop current mode, start new one
  // ---------------------------------------------------------------------------

  /// Switch between 'server' and 'remote' mode at runtime.
  /// Stops the current connection/engine and starts the new one.
  Future<void> switchMode(String newMode) async {
    final currentMode = settingsState.appMode;
    if (newMode == currentMode) return;

    // 1. Tear down current mode
    if (currentMode == 'remote') {
      await disconnectRemote();
    } else {
      await stopServer();
    }

    // 2. Persist new mode
    await settingsState.setAppMode(newMode);

    // 3. Start new mode
    if (newMode == 'remote') {
      // Only auto-connect if host is configured
      if (settingsState.remoteHost.isNotEmpty) {
        await connectRemote();
      }
    } else {
      await startServer();
    }
  }

  void _handleRemoteEvent(Map<String, dynamic> event) {
    final type = event['type'] as String? ?? '';
    final data = event['data'] as Map<String, dynamic>? ?? {};

    if (type == 'playback.started' || type == 'playback.track_changed') {
      // Optimistic update: use track metadata from event to update UI immediately
      final zoneId = data['zone_id'] as int?;
      final trackId = data['track_id'] as int?;
      final trackTitle = data['track_title'] as String?;
      if (zoneId != null && trackId != null && trackTitle != null) {
        final zone = zoneState.zones.where((z) => z.id == zoneId).firstOrNull;
        if (zone != null) {
          final optimisticTrack = trackFromJson({
            'id': trackId,
            'title': trackTitle,
            'artist_name': data['artist_name'],
            'album_title': data['album_title'],
            'cover_path': data['cover_path'],
          });
          zoneState.updateZone(zone.copyWith(
            state: PlaybackState.playing,
            currentTrack: optimisticTrack,
          ));
        }
      }
      // Still fetch full zone state from API for complete data
      refreshZonesRemote();
    } else if (type.startsWith('playback.') || type.startsWith('zone.')) {
      // Refresh zones from API
      refreshZonesRemote();
    }
  }

  Future<void> refreshZonesRemote() async {
    if (_apiClient == null) return;
    try {
      final zonesJson = await _apiClient!.getZones();
      final zones = zonesJson.map((z) => ZoneWithState.fromJson(z as Map<String, dynamic>)).toList();
      zoneState.setZones(zones);

      // Load queue for current zone
      final zoneId = zoneState.currentZoneId;
      if (zoneId != null) {
        try {
          final queueJson = await _apiClient!.getQueue(zoneId);
          if (queueJson is Map<String, dynamic>) {
            final tracksList = queueJson['tracks'] as List? ?? [];
            final tracks = tracksList
                .map((t) => trackFromJson(t as Map<String, dynamic>))
                .toList();
            final position = queueJson['position'] as int? ?? 0;
            final shuffle = queueJson['shuffle'] as bool? ?? false;
            final repeatStr = queueJson['repeat'] as String? ?? 'off';
            // Parse gapless indices from queue response
            final gaplessSet = <int>{};
            for (int i = 0; i < tracksList.length; i++) {
              final t = tracksList[i] as Map<String, dynamic>;
              if (t['gapless_next'] == true) {
                gaplessSet.add(i);
              }
            }
            zoneState.setQueueSnapshot(
              QueueSnapshot(
                tracks: tracks,
                position: position,
                shuffleEnabled: shuffle,
                repeatMode: RepeatMode.fromRawValue(repeatStr) ?? RepeatMode.off,
              ),
              gaplessIndices: gaplessSet,
            );
          }
        } catch (_) {}
      }
    } catch (e) {
      debugPrint('[Remote] refreshZones error: $e');
    }
  }

  Future<void> _refreshRadiosRemote() async {
    if (_apiClient == null) return;
    try {
      final radiosJson = await _apiClient!.getRadios();
      final radios = radiosJson.map((r) => radioFromJson(r as Map<String, dynamic>)).toList();
      libraryState.setRadios(radios);
    } catch (e) {
      debugPrint('[Remote] refreshRadios error: $e');
    }
  }

  Future<void> _refreshLibraryRemote() async {
    if (_apiClient == null) return;
    try {
      final albumsJson = await _apiClient!.getAlbums();
      final albums = albumsJson.map((a) => albumFromJson(a as Map<String, dynamic>)).toList();
      libraryState.setAlbums(albums);

      final artistsJson = await _apiClient!.getArtists();
      final artists = artistsJson.map((a) => artistFromJson(a as Map<String, dynamic>)).toList();
      libraryState.setArtists(artists);

      // Recent albums for Home view
      try {
        final recentJson = await _apiClient!.getRecentAlbums(limit: 30);
        final recent = recentJson.map((a) => albumFromJson(a as Map<String, dynamic>)).toList();
        libraryState.setRecentAlbums(recent);
      } catch (_) {}
    } catch (e) {
      debugPrint('[Remote] refreshLibrary error: $e');
    }
  }

  Future<void> _refreshStreamingServicesRemote() async {
    if (_apiClient == null) return;
    try {
      final data = await _apiClient!.getStreamingServices();
      final services = data.entries.map((e) {
        final info = e.value as Map<String, dynamic>;
        return StreamingServiceStatus(
          serviceId: e.key,
          enabled: info['authenticated'] as bool? ?? false,
          authenticated: info['authenticated'] as bool? ?? false,
          quality: info['quality'] as String?,
        );
      }).toList();
      libraryState.setStreamingServices(services);
    } catch (e) {
      debugPrint('[Remote] refreshStreamingServices error: $e');
    }
  }
}
