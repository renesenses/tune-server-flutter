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

  Future<void> scanLibrary() async {
    await requestStoragePermission();
    return engine.scanLibrary();
  }

  Future<void> addMusicFolder(String path) async {
    await requestStoragePermission();
    return engine.addMusicFolder(path);
  }

  Future<List<SearchResult>> search(String query) async {
    libraryState.setSearching(true);
    try {
      if (isRemoteMode && _apiClient != null) {
        final data = await _apiClient!.searchLibrary(query);
        final results = <SearchResult>[];
        if (data is Map<String, dynamic>) {
          for (final t in (data['tracks'] as List? ?? [])) {
            results.add(TrackSearchResult(trackFromJson(t as Map<String, dynamic>)));
          }
          for (final a in (data['albums'] as List? ?? [])) {
            results.add(AlbumSearchResult(albumFromJson(a as Map<String, dynamic>)));
          }
          for (final a in (data['artists'] as List? ?? [])) {
            results.add(ArtistSearchResult(artistFromJson(a as Map<String, dynamic>)));
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
    final isFav = await engine.db.trackRepo.toggleFavorite(trackId);
    await _refreshFavoriteTracks();
    // Si la liste complète des pistes est chargée, la rafraîchir aussi.
    if (libraryState.tracks.isNotEmpty) await refreshTracks();
    return isFav;
  }

  Future<void> refreshFavoriteTracks() => _refreshFavoriteTracks();
}
