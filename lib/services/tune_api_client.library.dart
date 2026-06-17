part of 'tune_api_client.dart';

// Endpoints autour de la bibliothèque locale :
// - albums, artists, tracks (CRUD + paginés)
// - search, recent
// - artist metadata + track credits
// - artworkUrl helper

extension TuneApiClientLibrary on TuneApiClient {

  /// Parse a paginated response: the Rust server returns
  /// `{"items": [...], "total": N, "limit": N, "offset": N}`.
  /// Older Python servers returned a bare `[...]`.
  /// This helper handles both formats.
  List<dynamic> _unwrapItems(dynamic d) {
    if (d is List) return d;
    if (d is Map<String, dynamic>) {
      return d['items'] as List? ?? [];
    }
    return [];
  }

  /// Extract total count from a paginated response.
  int _unwrapTotal(dynamic d) {
    if (d is Map<String, dynamic>) {
      return d['total'] as int? ?? 0;
    }
    return 0;
  }

  Future<List<dynamic>> getAlbums({int limit = 500, int offset = 0}) =>
      _get('/library/albums?limit=$limit&offset=$offset').then(_unwrapItems);

  /// Fetch ALL albums by paginating automatically. The server default page
  /// size is 50; we use 500 per page to minimise round-trips.
  Future<List<dynamic>> getAllAlbums() async {
    const pageSize = 500;
    final first = await _get('/library/albums?limit=$pageSize&offset=0');
    final items = _unwrapItems(first);
    final total = _unwrapTotal(first);
    if (total <= pageSize) return items;
    // Fetch remaining pages in parallel
    final pages = <Future<dynamic>>[];
    for (int offset = pageSize; offset < total; offset += pageSize) {
      pages.add(_get('/library/albums?limit=$pageSize&offset=$offset'));
    }
    final results = await Future.wait(pages);
    for (final page in results) {
      items.addAll(_unwrapItems(page));
    }
    return items;
  }

  Future<List<dynamic>> getArtists({int limit = 500, int offset = 0}) =>
      _get('/library/artists?limit=$limit&offset=$offset').then(_unwrapItems);

  /// Fetch ALL artists by paginating automatically.
  Future<List<dynamic>> getAllArtists() async {
    const pageSize = 500;
    final first = await _get('/library/artists?limit=$pageSize&offset=0');
    final items = _unwrapItems(first);
    final total = _unwrapTotal(first);
    if (total <= pageSize) return items;
    final pages = <Future<dynamic>>[];
    for (int offset = pageSize; offset < total; offset += pageSize) {
      pages.add(_get('/library/artists?limit=$pageSize&offset=$offset'));
    }
    final results = await Future.wait(pages);
    for (final page in results) {
      items.addAll(_unwrapItems(page));
    }
    return items;
  }

  Future<List<dynamic>> getTracks({int limit = 500, int offset = 0}) =>
      _get('/library/tracks?limit=$limit&offset=$offset').then(_unwrapItems);

  Future<List<dynamic>> getAllTracks() async {
    const pageSize = 500;
    final first = await _get('/library/tracks?limit=$pageSize&offset=0');
    final items = _unwrapItems(first);
    final total = _unwrapTotal(first);
    if (total <= pageSize) return items;
    final pages = <Future<dynamic>>[];
    for (int offset = pageSize; offset < total; offset += pageSize) {
      pages.add(_get('/library/tracks?limit=$pageSize&offset=$offset'));
    }
    final results = await Future.wait(pages);
    for (final page in results) {
      items.addAll(_unwrapItems(page));
    }
    return items;
  }

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

  /// Federated search: local library + all connected streaming services.
  /// Returns { local: { tracks, albums, artists }, services: { tidal: {...}, ... } }
  Future<Map<String, dynamic>> federatedSearch(String query, {
    int limit = 20,
    List<String>? sources,
  }) async {
    var path = '/api/v1/search?q=${Uri.encodeComponent(query)}&limit=$limit';
    if (sources != null && sources.isNotEmpty) {
      path += '&sources=${sources.join(',')}';
    }
    final data = await _get(path);
    return data as Map<String, dynamic>;
  }

  /// Fetch recent albums via the dedicated /albums/recent endpoint
  /// (returns a bare JSON array, not paginated).
  Future<List<dynamic>> getRecentAlbums({int limit = 30}) =>
      _get('/library/albums/recent?limit=$limit').then((d) {
        if (d is List) return d;
        // Fallback: paginated format
        if (d is Map<String, dynamic>) return d['items'] as List? ?? [];
        return <dynamic>[];
      });

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

  // ---------------------------------------------------------------------------
  // Library Browse (directory browsing)
  // ---------------------------------------------------------------------------

  Future<Map<String, dynamic>> getBrowseRoots() async {
    return await _get('/library/browse') as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> browseDirectory(String path) async {
    return await _get('/library/browse/dir?path=${Uri.encodeComponent(path)}') as Map<String, dynamic>;
  }

  // ---------------------------------------------------------------------------
  // Filtered tracks — used by SearchFilterView
  // ---------------------------------------------------------------------------

  /// GET /library/tracks with arbitrary query params for filter chips.
  /// Returns `{"items": [...], "total": N}` or bare list; both handled here.
  Future<Map<String, dynamic>> getTracksFiltered(
      Map<String, String> params) async {
    final qs = params.entries
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
        .join('&');
    final raw = await _getOptional('/library/tracks?$qs');
    if (raw == null) return {'items': <dynamic>[], 'total': 0};
    if (raw is Map<String, dynamic>) return raw;
    if (raw is List) {
      return {'items': raw, 'total': raw.length};
    }
    return {'items': <dynamic>[], 'total': 0};
  }
}
