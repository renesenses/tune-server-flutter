part of 'tune_api_client.dart';

// Endpoints autour de la bibliothèque locale :
// - albums, artists, tracks (CRUD + paginés)
// - search, recent
// - artist metadata + track credits
// - artworkUrl helper

extension TuneApiClientLibrary on TuneApiClient {

  Future<List<dynamic>> getAlbums({int limit = 500, int offset = 0}) =>
      _get('/library/albums?limit=$limit&offset=$offset').then((d) => d as List);

  Future<List<dynamic>> getArtists({int limit = 500}) =>
      _get('/library/artists?limit=$limit').then((d) => d as List);

  Future<List<dynamic>> getTracks({int limit = 500, int offset = 0}) =>
      _get('/library/tracks?limit=$limit&offset=$offset').then((d) => d as List);

  Future<List<dynamic>> getArtistAlbums(int artistId) =>
      _get('/library/artists/$artistId/albums').then((d) => d as List);

  Future<Map<String, dynamic>> getArtistMetadata(int artistId) async {
    final response = await _get('/api/v1/artists/$artistId/metadata');
    return response;
  }

  Future<List<dynamic>> getArtistTracks(int artistId) =>
      _get('/library/artists/$artistId/tracks').then((d) => d as List);

  Future<List<dynamic>> getTrackCredits(int trackId) =>
      _get('/library/tracks/$trackId/credits').then((d) => d as List);

  Future<dynamic> enrichTrackCredits(int trackId) =>
      _post('/library/tracks/$trackId/credits/enrich');

  Future<List<dynamic>> getAlbumTracks(int albumId) =>
      _get('/library/albums/$albumId/tracks').then((d) => d as List);

  Future<dynamic> searchLibrary(String query, {int limit = 30}) =>
      _get('/library/search?q=${Uri.encodeComponent(query)}&limit=$limit');

  Future<List<dynamic>> getRecentAlbums({int limit = 30}) =>
      _get('/library/albums?limit=$limit&sort=recent').then((d) => d as List);

  String artworkUrl(String path) {
    if (path.startsWith('http')) return path;
    final filename = path.split('/').last;
    return '$baseUrl/library/artwork/$filename';
  }

  // ---------------------------------------------------------------------------
  // Library Scan
  // ---------------------------------------------------------------------------

  Future<dynamic> triggerScan({bool full = false}) =>
      _post('/library/scan', body: {'full': full});

  Future<Map<String, dynamic>> getScanStatus() =>
      _get('/library/scan/status').then((d) => d as Map<String, dynamic>);

  Future<Map<String, dynamic>> getLibraryStats() =>
      _get('/library/stats').then((d) => d as Map<String, dynamic>);
}
