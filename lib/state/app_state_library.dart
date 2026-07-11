part of 'app_state.dart';

// Extension AppState — bibliothèque locale + remote :
// - scan / addMusicFolder (engine local)
// - search (remote API ou engine local)
// - playDlnaItem (UPnP DIDL → queue + play)
// - clearLibrary / cleanupOrphans
// - refreshTracks
// - track favorites (toggle + refresh privé)
// - playlists (create/delete/rename/addTracks/removeTrack)

extension AppStateLibrary on AppState {

  // ---------------------------------------------------------------------------
  // Bibliothèque
  // ---------------------------------------------------------------------------

  Future<bool> requestStoragePermission() async {
    if (!Platform.isAndroid) return true;
    // Android 13+ : READ_MEDIA_AUDIO ; Android ≤12 : READ_EXTERNAL_STORAGE
    // On essaie les deux — le système ignorera celui qui n'est pas pertinent.
    final audioStatus = await Permission.audio.request();
    if (audioStatus.isGranted) return true;
    final storageStatus = await Permission.storage.request();
    return storageStatus.isGranted || storageStatus.isLimited;
  }

  Future<void> scanLibrary({bool full = false}) async {
    await requestStoragePermission();
    return engine.scanLibrary(full: full);
  }

  Future<void> addMusicFolder(String path) async {
    await requestStoragePermission();
    return engine.addMusicFolder(path);
  }

  Future<List<SearchResult>> search(String query) async {
    libraryState.setSearching(true);
    try {
      if (isRemoteMode && _apiClient != null) {
        final data = await _apiClient!.federatedSearch(query);
        final results = <SearchResult>[];

        // Parse local results
        final local = data['local'] as Map<String, dynamic>?;
        if (local != null) {
          for (final a in (local['artists'] as List? ?? [])) {
            results.add(ArtistSearchResult(artistFromJson(a as Map<String, dynamic>)));
          }
          for (final a in (local['albums'] as List? ?? [])) {
            results.add(AlbumSearchResult(albumFromJson(a as Map<String, dynamic>)));
          }
          for (final t in (local['tracks'] as List? ?? [])) {
            results.add(TrackSearchResult(trackFromJson(t as Map<String, dynamic>)));
          }
        }

        // Parse streaming service results
        final services = data['services'] as Map<String, dynamic>?;
        if (services != null) {
          for (final entry in services.entries) {
            final serviceId = entry.key;
            final svcData = entry.value as Map<String, dynamic>? ?? {};
            for (final item in _parseStreamingResults(serviceId, svcData)) {
              results.add(StreamingResult(item));
            }
          }
        }

        libraryState.setSearchResults(query, results);
        return results;
      }
      final results = await engine.search(query);
      libraryState.setSearchResults(query, results);
      return results;
    } catch (_) {
      libraryState.setSearching(false);
      return [];
    }
  }

  /// Parse streaming search results from the federated search API response.
  List<StreamingSearchResult> _parseStreamingResults(
    String serviceId,
    Map<String, dynamic> data,
  ) {
    final results = <StreamingSearchResult>[];
    for (final t in (data['tracks'] as List? ?? [])) {
      final m = t as Map<String, dynamic>;
      results.add(StreamingSearchResult(
        id: '${m['id'] ?? m['source_id'] ?? ''}',
        title: m['title'] as String? ?? '',
        artist: m['artist_name'] as String? ?? m['artist'] as String?,
        album: m['album_title'] as String? ?? m['album'] as String?,
        durationMs: m['duration_ms'] as int?,
        coverUrl: m['cover_path'] as String? ?? m['cover_url'] as String?,
        serviceId: serviceId,
        type: 'track',
      ));
    }
    for (final a in (data['albums'] as List? ?? [])) {
      final m = a as Map<String, dynamic>;
      results.add(StreamingSearchResult(
        id: '${m['id'] ?? m['source_id'] ?? ''}',
        title: m['title'] as String? ?? '',
        artist: m['artist_name'] as String? ?? m['artist'] as String?,
        coverUrl: m['cover_path'] as String? ?? m['cover_url'] as String?,
        serviceId: serviceId,
        type: 'album',
      ));
    }
    for (final a in (data['artists'] as List? ?? [])) {
      final m = a as Map<String, dynamic>;
      results.add(StreamingSearchResult(
        id: '${m['id'] ?? m['source_id'] ?? ''}',
        title: m['name'] as String? ?? m['title'] as String? ?? '',
        coverUrl: m['image_path'] as String? ?? m['cover_url'] as String?,
        serviceId: serviceId,
        type: 'artist',
      ));
    }
    return results;
  }

  void clearSearch() => libraryState.clearSearch();

  void clearHistory() => libraryState.setHistory(const []);

  /// Joue un item DIDL-Lite (UPnP/DLNA) directement dans la zone courante.
  Future<void> playDlnaItem(DIDLItem item, {int? zoneId}) async {
    final url = item.resourceUrl;
    if (url == null) return;
    final id = zoneId ?? zoneState.currentZoneId;
    final instance = engine.zoneManager.zone(id ?? -1);
    if (instance == null) return;

    final track = Track(
      id: 0,
      title: item.title,
      filePath: url,
      source: Source.local.rawValue,
      artistName: item.artist,
      albumTitle: item.album,
      durationMs: item.durationMs,
      coverPath: item.albumArtUrl,
      favorite: false,
    );

    instance.queue.load([track], startIndex: 0);
    await instance.player.play();
  }

  Future<void> clearLibrary() async {
    await engine.clearLibrary();
    await _refreshLibrarySummary();
  }

  Future<void> cleanupOrphans() async {
    await engine.cleanupOrphans();
    await _refreshLibrarySummary();
  }

  // ---------------------------------------------------------------------------
  // Refresh pistes
  // ---------------------------------------------------------------------------

  Future<void> refreshTracks() async {
    final tracks = await engine.db.trackRepo.all();
    libraryState.setTracks(tracks);
  }

  // ---------------------------------------------------------------------------
  // Favoris pistes
  // ---------------------------------------------------------------------------

  /// Toggle le flag favori d'une piste. Retourne le nouvel état.
  /// Rafraîchit les pistes et les favoris dans LibraryState.
  Future<bool> toggleTrackFavorite(int trackId) async {
    // Remote mode: the local Drift DB is empty, so the previous code toggled a
    // favourite that never reached the server and never showed up (Elie:
    // "le bouton favori clignote, rien n'est ajouté"). Toggle on the server —
    // /quick-fav flips the flag and returns the new state, which callers use to
    // update the heart icon. (There is no favourites-list endpoint yet, so the
    // Favoris tab is not refreshed in remote mode — tracked separately.)
    if (isRemoteMode && _apiClient != null) {
      final res = await _apiClient!.quickFavTrack(trackId);
      return res['is_favorite'] as bool? ?? false;
    }
    final isFav = await engine.db.trackRepo.toggleFavorite(trackId);
    await _refreshFavoriteTracks();
    // Si la liste complète des pistes est chargée, la rafraîchir aussi.
    if (libraryState.tracks.isNotEmpty) await refreshTracks();
    return isFav;
  }

  Future<void> refreshFavoriteTracks() => _refreshFavoriteTracks();
}
