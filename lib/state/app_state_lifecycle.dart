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

      // What's New — compare current app version to last seen version.
      await _checkWhatsNew();

      notify();
    } catch (e) {
      _errorMessage = e.toString();
      notify();
    }
  }

  Future<void> _checkWhatsNew() async {
    try {
      final info = await PackageInfo.fromPlatform();
      final current = info.version;
      final lastSeen = engine.config.lastSeenVersion;
      if (lastSeen == null || lastSeen != current) {
        _showWhatsNew = true;
        _whatsNewVersion = current;
        // Don't persist yet — persist when user dismisses the dialog.
      }
    } catch (_) {
      // Ignore — non-critical
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

  Future<void> connectToServer(String host, int port) async {
    await settingsState.setRemoteHost(host);
    await settingsState.setRemotePort(port);
    await connectRemote();
  }

  Future<void> connectRemote() async {
    final host = settingsState.remoteHost;
    if (host.isEmpty) {
      _errorMessage = 'Adresse serveur non configurée';
      notify();
      return;
    }
    // Clean up any previous connection to avoid resource leaks
    _wsSubscription?.cancel();
    _wsSubscription = null;
    _webSocket?.dispose();
    _webSocket = null;
    _remotePollingTimer?.cancel();
    _remotePollingTimer = null;
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
        loadStreamingFavorites(),
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
    _zoneRefreshDebounce?.cancel();
    _zoneRefreshDebounce = null;
    _trackNotificationService?.dispose();
    _trackNotificationService = null;
    _wsSubscription?.cancel();
    _wsSubscription = null;
    _webSocket?.dispose();
    _webSocket = null;
    _apiClient = null;
    _serverStarted = false;
    zoneState.stopSeekTimer();
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
      // Reset position to 0 (new track) and restart interpolation timer
      // immediately so the seek bar begins moving right away.
      if (zoneId != null) {
        final posMs = data['position_ms'] as int? ?? 0;
        zoneState.updatePosition(zoneId, posMs);
        if (zoneId == zoneState.currentZoneId) {
          // Stop + start to reset the timer cycle (may already be running
          // from a previous track).
          zoneState.stopSeekTimer();
          zoneState.startSeekTimer();
        }
      }
      // Still fetch full zone state from API for complete data
      refreshZonesRemote();
    } else if (type == 'playback.paused' || type == 'playback.stopped') {
      // Stop interpolation timer and sync position from event data
      final zoneId = data['zone_id'] as int?;
      if (zoneId != null && zoneId == zoneState.currentZoneId) {
        zoneState.stopSeekTimer();
        final posMs = data['position_ms'] as int?;
        if (posMs != null) {
          zoneState.updatePosition(zoneId, posMs);
        }
      }
      refreshZonesRemote();
    } else if (type == 'playback.resumed') {
      // Resume: start interpolation timer, sync position
      final zoneId = data['zone_id'] as int?;
      if (zoneId != null && zoneId == zoneState.currentZoneId) {
        final posMs = data['position_ms'] as int?;
        if (posMs != null) {
          zoneState.updatePosition(zoneId, posMs);
        }
        zoneState.startSeekTimer();
      }
      refreshZonesRemote();
    } else if (type == 'playback.seek') {
      // Seek confirmed by server — jump to new position immediately
      final zoneId = data['zone_id'] as int?;
      final posMs = data['position_ms'] as int?;
      if (zoneId != null && posMs != null && zoneId == zoneState.currentZoneId) {
        zoneState.updatePosition(zoneId, posMs);
        zoneState.startSeekTimer();
      }
    } else if (type == 'playback.position') {
      // Server-side position update — apply drift filter
      final zoneId = data['zone_id'] as int?;
      final posMs = data['position_ms'] as int?;
      if (zoneId != null && posMs != null && zoneId == zoneState.currentZoneId) {
        zoneState.syncPositionFromServer(zoneId, posMs);
      }
    } else if (type.startsWith('playback.') || type.startsWith('zone.') || type.startsWith('device.')) {
      _scheduleZoneRefresh();
    }
  }

  void _scheduleZoneRefresh() {
    _zoneRefreshDebounce?.cancel();
    _zoneRefreshDebounce = Timer(const Duration(milliseconds: 300), () {
      refreshZonesRemote();
    });
  }

  Future<void> refreshZonesRemote() async {
    if (_apiClient == null) return;
    if (_refreshingZones) return;
    _refreshingZones = true;
    try {
      final zonesJson = await _apiClient!.getZones();
      final zones = zonesJson.map((z) => ZoneWithState.fromJson(z as Map<String, dynamic>)).toList();

      // Before overwriting zones, capture the server-reported position for
      // the current zone so we can apply drift filtering below.
      final curId = zoneState.currentZoneId;
      int? serverPositionMs;
      PlaybackState? serverState;
      for (final z in zones) {
        if (z.id == curId) {
          serverPositionMs = z.positionMs;
          serverState = z.state;
          break;
        }
      }

      // setZones replaces the full list including positionMs. Capture the
      // locally-interpolated position first so we can avoid visible jumps.
      final localPosBefore = zoneState.currentZone?.positionMs ?? 0;

      // While playing, keep our interpolated value when the server position is
      // close (avoids stutter from the ~1s poll cadence).
      if (curId != null && serverPositionMs != null && serverState == PlaybackState.playing) {
        final drift = (localPosBefore - serverPositionMs).abs();
        if (drift <= 2000) {
          // Patch the incoming zone to keep local interpolated position
          final idx = zones.indexWhere((z) => z.id == curId);
          if (idx >= 0) {
            zones[idx] = zones[idx].copyWith(positionMs: localPosBefore);
          }
        }
      }

      zoneState.setZones(zones);

      // Manage seek timer based on current zone playback state
      if (curId != null && serverState != null) {
        if (serverState == PlaybackState.playing) {
          zoneState.startSeekTimer();
        } else {
          zoneState.stopSeekTimer();
          if (serverPositionMs != null) {
            // A just-paused zone can still report the pre-pause / last-seek
            // position for a beat, which would snap the displayed time
            // backwards (Elie: seek to 30s, play to 40s, pause → shows 30s).
            // Keep the local position when the server is only slightly behind;
            // the next refresh reconciles once the server catches up.
            final backDrift = localPosBefore - serverPositionMs;
            final pos = (backDrift > 0 && backDrift <= 4000)
                ? localPosBefore
                : serverPositionMs;
            zoneState.updatePosition(curId, pos);
          }
        }
      }

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
    } finally {
      _refreshingZones = false;
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
      final albumsJson = await _apiClient!.getAllAlbums();
      final albums = albumsJson.map((a) => albumFromJson(a as Map<String, dynamic>)).toList();
      libraryState.setAlbums(albums);

      final artistsJson = await _apiClient!.getAllArtists();
      final artists = artistsJson.map((a) => artistFromJson(a as Map<String, dynamic>)).toList();
      libraryState.setArtists(artists);

      final tracksJson = await _apiClient!.getAllTracks();
      final tracks = tracksJson.map((t) => trackFromJson(t as Map<String, dynamic>)).toList();
      libraryState.setTracks(tracks);

      try {
        final recentJson = await _apiClient!.getRecentAlbums(limit: 30);
        final recent = recentJson.map((a) => albumFromJson(a as Map<String, dynamic>)).toList();
        libraryState.setRecentAlbums(recent);
      } catch (_) {}
    } catch (e) {
      debugPrint('[Remote] refreshLibrary error: $e');
      _errorMessage = 'Erreur chargement bibliothèque: $e';
      notify();
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
