part of 'app_state.dart';

// Extension AppState — lecture audio :
// - Contrôles de lecture (play/pause/resume/stop/next/prev/seek/volume/shuffle/repeat,
//   queue move/remove)
// - Lecture streaming (résolution URL à la volée via streamingManager)
// - Lecture par lot (playTracks avec résolution synchrone des URLs locales)
//
// Mode remote : passe par TuneApiClient + refreshZonesRemote.
// Mode local : passe par engine.zoneManager.zone().

extension AppStatePlayback on AppState {

  // ---------------------------------------------------------------------------
  // Contrôles de lecture
  // ---------------------------------------------------------------------------

  Future<void> play({Track? track, int? zoneId}) async {
    final id = zoneId ?? zoneState.currentZoneId;
    if (id == null) return;

    if (isRemoteMode && _apiClient != null) {
      if (track != null) {
        final body = <String, dynamic>{};
        if (track.id != 0 && track.source == Source.local.rawValue) {
          body['track_id'] = track.id;
        } else if (track.sourceId != null) {
          body['source'] = track.source;
          body['source_id'] = track.sourceId;
        } else if (track.filePath != null) {
          body['file_path'] = track.filePath;
        }
        await _apiClient!.play(id, body);
      } else {
        await _apiClient!.resume(id);
      }
      await refreshZonesRemote();
      return;
    }

    final instance = engine.zoneManager.zone(id);
    if (instance == null) return;

    if (track != null) {
      final url = await _resolveUrl(track);
      if (url == null) return;
      final resolved = url != track.filePath
          ? track.copyWith(filePath: Value(url))
          : track;
      instance.queue.load([resolved], startIndex: 0);
    }
    instance.player.crossfadeEnabled = settingsState.crossfadeEnabled;
    instance.player.crossfadeDuration = settingsState.crossfadeDuration;
    await instance.player.play();
  }

  Future<void> pause({int? zoneId}) async {
    final id = zoneId ?? zoneState.currentZoneId;
    if (id == null) return;
    if (isRemoteMode && _apiClient != null) {
      await _apiClient!.pause(id);
      await refreshZonesRemote();
      return;
    }
    await engine.zoneManager.zone(id)?.player.pause();
  }

  Future<void> resume({int? zoneId}) async {
    final id = zoneId ?? zoneState.currentZoneId;
    if (id == null) return;
    if (isRemoteMode && _apiClient != null) {
      await _apiClient!.resume(id);
      await refreshZonesRemote();
      return;
    }
    await engine.zoneManager.zone(id)?.player.resume();
  }

  Future<void> stop({int? zoneId}) async {
    final id = zoneId ?? zoneState.currentZoneId;
    if (id == null) return;
    if (isRemoteMode && _apiClient != null) {
      await _apiClient!.pause(id); // no stop endpoint, pause is fine
      return;
    }
    await engine.zoneManager.zone(id)?.player.stop();
  }

  Future<void> next({int? zoneId}) async {
    final id = zoneId ?? zoneState.currentZoneId;
    if (id == null) return;
    if (isRemoteMode && _apiClient != null) {
      await _apiClient!.next(id);
      await refreshZonesRemote();
      return;
    }
    await engine.zoneManager.zone(id)?.player.next();
  }

  Future<void> previous({int? zoneId}) async {
    final id = zoneId ?? zoneState.currentZoneId;
    if (id == null) return;
    if (isRemoteMode && _apiClient != null) {
      await _apiClient!.previous(id);
      await refreshZonesRemote();
      return;
    }
    await engine.zoneManager.zone(id)?.player.previous();
  }

  Future<void> seek(Duration position, {int? zoneId}) async {
    final id = zoneId ?? zoneState.currentZoneId;
    if (id == null) return;
    if (isRemoteMode && _apiClient != null) {
      await _apiClient!.seek(id, position.inMilliseconds);
      return;
    }
    await engine.zoneManager.zone(id)?.player.seek(position);
  }

  Future<void> setVolume(double volume, {int? zoneId}) async {
    final id = zoneId ?? zoneState.currentZoneId;
    if (id == null) return;
    if (isRemoteMode && _apiClient != null) {
      await _apiClient!.setVolume(id, volume);
      return;
    }
    await engine.zoneManager.setVolume(id, volume);
  }

  Future<void> setShuffle({required bool enabled, int? zoneId}) async {
    final id = zoneId ?? zoneState.currentZoneId;
    if (isRemoteMode && _apiClient != null) {
      if (id != null) await _apiClient!.setShuffle(id, enabled);
      await refreshZonesRemote();
      return;
    }
    final instance = engine.zoneManager.zone(id ?? -1);
    instance?.queue.setShuffle(enabled: enabled);
    if (instance != null) {
      zoneState.setQueueSnapshot(instance.queue.snapshot());
    }
  }

  Future<void> cycleRepeat({int? zoneId}) async {
    final id = zoneId ?? zoneState.currentZoneId;
    if (isRemoteMode && _apiClient != null) {
      // Cycle through off → all → one
      final current = zoneState.repeatMode;
      final next = current == RepeatMode.off ? 'all' : current == RepeatMode.all ? 'one' : 'off';
      if (id != null) await _apiClient!.setRepeat(id, next);
      await refreshZonesRemote();
      return;
    }
    final instance = engine.zoneManager.zone(id ?? -1);
    instance?.queue.cycleRepeat();
    if (instance != null) {
      zoneState.setQueueSnapshot(instance.queue.snapshot());
    }
  }

  Future<void> moveQueueItem(int fromIndex, int toIndex, {int? zoneId}) async {
    final id = zoneId ?? zoneState.currentZoneId;
    final instance = engine.zoneManager.zone(id ?? -1);
    if (instance == null) return;
    instance.queue.move(fromIndex, toIndex);
    zoneState.setQueueSnapshot(instance.queue.snapshot());
  }

  Future<void> removeQueueItem(int index, {int? zoneId}) async {
    final id = zoneId ?? zoneState.currentZoneId;
    final instance = engine.zoneManager.zone(id ?? -1);
    if (instance == null) return;
    instance.queue.remove(index);
    zoneState.setQueueSnapshot(instance.queue.snapshot());
  }

  // ---------------------------------------------------------------------------
  // Shuffle all — lecture aléatoire de toute la bibliothèque
  // ---------------------------------------------------------------------------

  /// Shuffle-play the entire local library (up to 5000 tracks).
  /// Remote mode: calls POST /playback/shuffle-all?zone_id=N with optional
  /// context filters (search_query, album_id, artist_id, genre).
  /// Local mode: fetches random tracks from DB, shuffles, plays.
  Future<void> shuffleAll({
    int? zoneId,
    String? searchQuery,
    int? albumId,
    int? artistId,
    String? genre,
  }) async {
    var id = zoneId ?? zoneState.currentZoneId;
    if (id == null && zoneState.zones.isNotEmpty) {
      id = zoneState.zones.first.id;
      zoneState.setCurrentZoneId(id);
    }
    if (id == null) {
      _lastPlaybackError = 'no_zone';
      notify();
      return;
    }

    if (isRemoteMode && _apiClient != null) {
      try {
        await _apiClient!.shuffleAll(
          id,
          searchQuery: searchQuery,
          albumId: albumId,
          artistId: artistId,
          genre: genre,
        );
        await refreshZonesRemote();
      } catch (e) {
        _lastPlaybackError = 'shuffle_all_failed';
        debugPrint('[shuffleAll] remote error: $e');
        notify();
      }
      return;
    }

    try {
      final tracks = await engine.db.trackRepo.random(limit: 5000);
      if (tracks.isEmpty) {
        _lastPlaybackError = 'library_empty';
        notify();
        return;
      }
      tracks.shuffle();
      await playTracks(tracks, zoneId: id);
    } catch (e) {
      _lastPlaybackError = 'shuffle_all_failed';
      debugPrint('[shuffleAll] local error: $e');
      notify();
    }
  }

  // ---------------------------------------------------------------------------
  // Lecture streaming (résolution URL à la volée)
  // ---------------------------------------------------------------------------

  Future<void> playStreaming(
    StreamingSearchResult item, {
    int? zoneId,
  }) async {
    final url = await engine.streamingManager
        .resolveStreamUrl(item.serviceId, item.id);
    if (url == null) return;

    final id = zoneId ?? zoneState.currentZoneId;
    final instance = engine.zoneManager.zone(id ?? -1);
    if (instance == null) return;

    final track = Track(
      id: 0,
      title: item.title,
      albumTitle: item.album,
      artistName: item.artist,
      filePath: url,
      source: item.serviceId,
      sourceId: item.id,
      favorite: false,
    );

    instance.queue.load([track], startIndex: 0);
    instance.player.crossfadeEnabled = settingsState.crossfadeEnabled;
    instance.player.crossfadeDuration = settingsState.crossfadeDuration;
    await instance.player.play();
  }

  /// Charge une liste de pistes streaming dans la queue avec résolution d'URL en parallèle.
  Future<void> playStreamingList(
    List<StreamingSearchResult> items, {
    int startIndex = 0,
    int? zoneId,
  }) async {
    if (items.isEmpty) return;

    final id = zoneId ?? zoneState.currentZoneId;
    final instance = engine.zoneManager.zone(id ?? -1);
    if (instance == null) return;

    // Résolution des URLs en parallèle
    final urls = await Future.wait(
      items.map((item) =>
          engine.streamingManager.resolveStreamUrl(item.serviceId, item.id)),
    );

    final tracks = <Track>[];
    for (var i = 0; i < items.length; i++) {
      final url = urls[i];
      if (url == null) continue;
      final item = items[i];
      tracks.add(Track(
        id: 0,
        title: item.title,
        albumTitle: item.album,
        artistName: item.artist,
        filePath: url,
        source: item.serviceId,
        sourceId: item.id,
        favorite: false,
      ));
    }

    if (tracks.isEmpty) return;
    instance.queue.load(tracks, startIndex: startIndex.clamp(0, tracks.length - 1));
    instance.player.crossfadeEnabled = settingsState.crossfadeEnabled;
    instance.player.crossfadeDuration = settingsState.crossfadeDuration;
    await instance.player.play();
  }

  // ---------------------------------------------------------------------------
  // Lecture par lot
  // ---------------------------------------------------------------------------

  /// Charge [tracks] dans la queue (URLs locales résolues) et lance la lecture.
  Future<void> playTracks(
    List<Track> tracks, {
    int startIndex = 0,
    int? zoneId,
  }) async {
    if (tracks.isEmpty) {
      debugPrint('[playTracks] bail-out: empty tracks list');
      return;
    }

    // Fallback si aucune zone sélectionnée : prend la première dispo.
    var id = zoneId ?? zoneState.currentZoneId;
    if (id == null && zoneState.zones.isNotEmpty) {
      id = zoneState.zones.first.id;
      zoneState.setCurrentZoneId(id);
      debugPrint(
          '[playTracks] auto-selected zone $id (no current zone set)');
    }
    if (id == null) {
      _lastPlaybackError = 'no_zone';
      debugPrint('[playTracks] ERROR: no zone available');
      notify();
      return;
    }

    if (isRemoteMode && _apiClient != null) {
      // Send the whole queue so server auto-advances. Sending only the
      // single track at `startIndex` left the queue at length 1 — playback
      // stopped at end-of-track. (Bug reported by Jacques on Android.)
      final localIds = <int>[];
      for (final t in tracks) {
        if (t.id != 0 && t.source == Source.local.rawValue) {
          localIds.add(t.id);
        }
      }
      if (localIds.length == tracks.length) {
        // Pure-local queue: server resolves IDs.
        final body = <String, dynamic>{
          'track_ids': localIds,
          if (startIndex > 0) 'start_index': startIndex,
        };
        await _apiClient!.play(id, body);
      } else {
        // Mixed/streaming: fall back to single track (no queue semantics
        // yet for streaming-mixed lists; can be added later via /queue/add).
        final track = tracks[startIndex];
        await play(track: track, zoneId: id);
      }
      await refreshZonesRemote();
      return;
    }

    final instance = engine.zoneManager.zone(id);
    if (instance == null) {
      _lastPlaybackError = 'zone_not_found';
      debugPrint('[playTracks] ERROR: zone $id not found in zoneManager');
      notify();
      return;
    }

    try {
      final resolved = tracks.map(_resolveTrackSync).toList();
      instance.queue.load(resolved, startIndex: startIndex);
      instance.player.crossfadeEnabled = settingsState.crossfadeEnabled;
      instance.player.crossfadeDuration = settingsState.crossfadeDuration;
      await instance.player.play();
    } catch (e, st) {
      _lastPlaybackError = 'playback_failed';
      debugPrint('[playTracks] EXCEPTION: $e\n$st');
      notify();
    }
  }

  /// Résout l'URL d'un track local de manière synchrone (sans await).
  Track _resolveTrackSync(Track track) {
    if (track.filePath == null) return track;
    var resolved = track;
    if (track.source == 'local' && !track.filePath!.startsWith('http')) {
      final url = engine.trackStreamUrl(track.filePath!);
      if (url != track.filePath) {
        resolved = resolved.copyWith(filePath: Value(url));
      }
    }
    // Resolve local cover path to HTTP URL for remote outputs (BluOS, DLNA…)
    if (track.coverPath != null &&
        track.coverPath!.startsWith('/') &&
        !track.coverPath!.startsWith('http')) {
      final coverUrl = engine.coverStreamUrl(track.coverPath!);
      resolved = resolved.copyWith(coverPath: Value(coverUrl));
    }
    return resolved;
  }
}
