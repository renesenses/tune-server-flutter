part of 'app_state.dart';

// Extension AppState — sections diverses :
// - Playlists (CRUD + add/remove tracks)
// - Édition métadonnées (updateAlbum, updateTrack)
// - Streaming auth (credentials + device code flow + logout)
// - Devices / Sources (discovered devices, indexUPnP, probe, forget)

extension AppStateMisc on AppState {

  // ---------------------------------------------------------------------------
  // Playlists
  // ---------------------------------------------------------------------------

  /// Public wrapper for [_refreshPlaylists] — allows views (e.g. M3U import)
  /// to trigger a playlist list refresh from outside AppState.
  Future<void> refreshPlaylists() => _refreshPlaylists();

  Future<void> createPlaylist(String name) async {
    await engine.db.playlistRepo.insert(
      PlaylistsCompanion.insert(name: name),
    );
    await _refreshPlaylists();
  }

  Future<void> deletePlaylist(int id) async {
    await engine.db.playlistRepo.delete(id);
    await _refreshPlaylists();
  }

  /// Retourne `true` si la piste a été ajoutée, `false` si déjà présente.
  Future<bool> addTrackToPlaylist(int trackId, int playlistId) async {
    final added = await engine.db.playlistRepo.addTrack(playlistId, trackId);
    if (added) await _refreshPlaylists();
    return added;
  }

  /// Ajoute plusieurs pistes à une playlist.
  /// En mode remote, utilise l'API REST ; en local, le repo SQLite.
  /// Retourne le nombre de pistes effectivement ajoutées.
  Future<int> addTracksToPlaylist(List<int> trackIds, int playlistId) async {
    if (isRemoteMode && _apiClient != null) {
      try {
        final result = await _apiClient!.addPlaylistTracks(playlistId, trackIds);
        await _refreshPlaylists();
        return result['added'] as int? ?? trackIds.length;
      } catch (_) {
        return 0;
      }
    }
    final added = await engine.db.playlistRepo.addTracks(playlistId, trackIds);
    if (added > 0) await _refreshPlaylists();
    return added;
  }

  Future<void> removeTrackFromPlaylist(int trackId, int playlistId) async {
    await engine.db.playlistRepo.removeTrack(playlistId, trackId);
    await _refreshPlaylists();
  }

  // ---------------------------------------------------------------------------
  // Édition métadonnées
  // ---------------------------------------------------------------------------

  Future<void> updateAlbum(Album album) async {
    await engine.db.albumRepo.update(album);
    await _refreshLibrarySummary();
  }

  Future<void> updateTrack(Track track) async {
    await engine.db.trackRepo.update(track);
    if (libraryState.tracks.isNotEmpty) await refreshTracks();
  }

  // ---------------------------------------------------------------------------
  // Streaming auth
  // ---------------------------------------------------------------------------

  Future<StreamingAuthResult> authenticateService(
    String serviceId,
    String email,
    String password,
  ) async {
    final result = await engine.streamingManager
        .authenticateWithCredentials(serviceId, email, password);
    await _refreshStreamingStatus();
    return result;
  }

  Future<StreamingAuthResult> startDeviceCodeFlow(String serviceId) =>
      engine.streamingManager.startDeviceCodeFlow(serviceId);

  Future<StreamingAuthResult> pollDeviceCodeFlow(
    String serviceId,
    StreamingDeviceCodeResult code,
  ) async {
    final result =
        await engine.streamingManager.pollDeviceCodeFlow(serviceId, code);
    await _refreshStreamingStatus();
    return result;
  }

  Future<void> logoutService(String serviceId) async {
    await engine.streamingManager.logout(serviceId);
    await _refreshStreamingStatus();
  }

  // ---------------------------------------------------------------------------
  // Devices / Sources
  // ---------------------------------------------------------------------------

  List<DiscoveredDevice> get discoveredDevices => engine.allDevices();

  /// Lance l'indexation récursive du ContentDirectory d'un serveur UPnP.
  Future<void> indexUPnPServer(DiscoveredDevice device) =>
      engine.indexUPnPDevice(device);

  /// Probe manuel d'un hôte pour découvrir un device UPnP.
  /// Retourne null si aucun device trouvé.
  Future<DiscoveredDevice?> probeDevice(String host, {int port = 49152}) async {
    final device = await engine.probeDevice(host, port: port);
    if (device != null) notify();
    return device;
  }

  /// Oublie un device (supprime de la DB + du cache mémoire).
  Future<void> forgetDevice(String id) async {
    await engine.forgetDevice(id);
    notify();
  }
}
