part of 'tune_api_client.dart';

// Endpoints autour de la gestion des métadonnées :
// - cleanup automatique (genres, années)
// - suggestions et auto-fix
// - duplicates / merge
// - enrichment + write tags
//
// Extension sur TuneApiClient — extraite du fichier core via `part`
// pour accéder aux helpers privés _get/_post/_patch.

extension TuneApiClientMetadata on TuneApiClient {

  // Completeness stats

  Future<Map<String, dynamic>> getCompletenessStats() =>
      _get('/library/stats/completeness').then((d) => d as Map<String, dynamic>);

  // Fix missing years

  Future<Map<String, dynamic>> fixYearsTidal() =>
      _post('/metadata/fix-years-tidal').then((d) => d as Map<String, dynamic>);

  Future<Map<String, dynamic>> fixYearsMusicBrainz() =>
      _post('/metadata/fix-years-musicbrainz').then((d) => d as Map<String, dynamic>);

  Future<Map<String, dynamic>> fixYearsDiscogs() =>
      _post('/metadata/fix-years-discogs').then((d) => d as Map<String, dynamic>);

  Future<Map<String, dynamic>> fixYearsTags() =>
      _post('/metadata/fix-years-tags').then((d) => d as Map<String, dynamic>);

  // Fix missing genres

  Future<Map<String, dynamic>> fixGenres() =>
      _post('/metadata/fix-genres').then((d) => d as Map<String, dynamic>);

  // Auto-fix

  Future<Map<String, dynamic>> startAutoFix() =>
      _post('/metadata/auto-fix').then((d) => d as Map<String, dynamic>);

  Future<Map<String, dynamic>> getAutoFixStatus() =>
      _get('/metadata/auto-fix/status').then((d) => d as Map<String, dynamic>);

  Future<Map<String, dynamic>> autoFixAlbums() =>
      _post('/metadata/auto-fix-albums').then((d) => d as Map<String, dynamic>);

  // Duplicates

  Future<Map<String, dynamic>> scanDuplicates({int limit = 5000}) =>
      _post('/metadata/duplicates/scan', body: {'limit': limit}).then((d) => d as Map<String, dynamic>);

  Future<List<dynamic>> listDuplicates() =>
      _get('/metadata/duplicates').then((d) => d as List);

  // Suggestions

  Future<List<dynamic>> getMetadataSuggestions({String status = 'pending', int limit = 100}) =>
      _get('/metadata/suggestions?status=$status&limit=$limit').then((d) => d as List);

  Future<Map<String, dynamic>> acceptSuggestion(int id) =>
      _post('/metadata/suggestions/$id/accept').then((d) => d as Map<String, dynamic>);

  Future<Map<String, dynamic>> rejectSuggestion(int id) =>
      _post('/metadata/suggestions/$id/reject').then((d) => d as Map<String, dynamic>);

  Future<Map<String, dynamic>> acceptAllSuggestions({double minConfidence = 0.9}) =>
      _post('/metadata/suggestions/accept-all?min_confidence=$minConfidence').then((d) => d as Map<String, dynamic>);

  // Enrichment

  Future<Map<String, dynamic>> enrichTrack(int trackId) =>
      _post('/metadata/enrich/$trackId').then((d) => d as Map<String, dynamic>);

  Future<Map<String, dynamic>> enrichAlbum(int albumId) =>
      _post('/metadata/enrich-album/$albumId').then((d) => d as Map<String, dynamic>);

  // Track/Album metadata update

  Future<Map<String, dynamic>> updateTrackMetadata(int trackId, Map<String, dynamic> updates) =>
      _patch('/metadata/tracks/$trackId', body: updates).then((d) => d as Map<String, dynamic>);

  Future<Map<String, dynamic>> updateAlbumMetadata(int albumId, Map<String, dynamic> updates) =>
      _patch('/metadata/albums/$albumId', body: updates).then((d) => d as Map<String, dynamic>);

  // Merge

  Future<Map<String, dynamic>> mergeAlbumDuplicates() =>
      _post('/library/albums/merge-duplicates').then((d) => d as Map<String, dynamic>);

  Future<Map<String, dynamic>> mergeAlbums(List<int> albumIds) =>
      _post('/metadata/albums/merge', body: {'album_ids': albumIds})
          .then((d) => d as Map<String, dynamic>);

  // Write tags

  Future<Map<String, dynamic>> writeAlbumTags(int albumId) =>
      _post('/metadata/albums/$albumId/write-tags')
          .then((d) => d as Map<String, dynamic>);

  // Doubtful albums

  Future<List<dynamic>> getDoubtfulAlbums() =>
      _get('/metadata/doubtful').then((d) => d as List);

  // Upload album artwork (multipart) — bypasse _client volontairement
  // (MultipartRequest n'utilise pas le client http injectable).

  Future<Map<String, dynamic>> uploadAlbumArtwork(int albumId, String filePath) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/library/albums/$albumId/artwork'),
    );
    request.files.add(await http.MultipartFile.fromPath('file', filePath));
    final streamed = await request.send().timeout(const Duration(seconds: 60));
    final resp = await http.Response.fromStream(streamed);
    if (resp.statusCode != 200 && resp.statusCode != 201) {
      throw Exception('Upload artwork failed: ${resp.statusCode}');
    }
    return resp.body.isNotEmpty ? jsonDecode(resp.body) as Map<String, dynamic> : {};
  }

  // Get all albums (large limit for metadata views)

  Future<List<dynamic>> getAllAlbums() =>
      _get('/library/albums?limit=10000').then((d) => d as List);
}
