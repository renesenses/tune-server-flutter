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
  // NOTE: metadata endpoints may return 404 on Rust alpha server.

  Future<Map<String, dynamic>> getCompletenessStats() async =>
      await _getOptional('/library/stats/completeness') as Map<String, dynamic>? ?? {};

  // Fix missing years

  Future<Map<String, dynamic>> fixYearsTidal() async =>
      await _postOptional('/metadata/fix-years-tidal') as Map<String, dynamic>? ?? {};

  Future<Map<String, dynamic>> fixYearsMusicBrainz() async =>
      await _postOptional('/metadata/fix-years-musicbrainz') as Map<String, dynamic>? ?? {};

  Future<Map<String, dynamic>> fixYearsDiscogs() async =>
      await _postOptional('/metadata/fix-years-discogs') as Map<String, dynamic>? ?? {};

  Future<Map<String, dynamic>> fixYearsTags() async =>
      await _postOptional('/metadata/fix-years-tags') as Map<String, dynamic>? ?? {};

  // Fix missing genres

  Future<Map<String, dynamic>> fixGenres() async =>
      await _postOptional('/metadata/fix-genres') as Map<String, dynamic>? ?? {};

  // Auto-fix

  Future<Map<String, dynamic>> startAutoFix() async =>
      await _postOptional('/metadata/auto-fix') as Map<String, dynamic>? ?? {};

  Future<Map<String, dynamic>> getAutoFixStatus() async =>
      await _getOptional('/metadata/auto-fix/status') as Map<String, dynamic>? ?? {};

  Future<Map<String, dynamic>> autoFixAlbums() async =>
      await _postOptional('/metadata/auto-fix-albums') as Map<String, dynamic>? ?? {};

  // Duplicates

  Future<Map<String, dynamic>> scanDuplicates({int limit = 5000}) async =>
      await _postOptional('/metadata/duplicates/scan', body: {'limit': limit}) as Map<String, dynamic>? ?? {};

  Future<List<dynamic>> listDuplicates() async =>
      await _getOptional('/metadata/duplicates') as List? ?? [];

  // Suggestions

  Future<List<dynamic>> getMetadataSuggestions({String status = 'pending', int limit = 100}) async =>
      await _getOptional('/metadata/suggestions?status=$status&limit=$limit') as List? ?? [];

  Future<Map<String, dynamic>> acceptSuggestion(int id) async =>
      await _postOptional('/metadata/suggestions/$id/accept') as Map<String, dynamic>? ?? {};

  Future<Map<String, dynamic>> rejectSuggestion(int id) async =>
      await _postOptional('/metadata/suggestions/$id/reject') as Map<String, dynamic>? ?? {};

  Future<Map<String, dynamic>> acceptAllSuggestions({double minConfidence = 0.9}) async =>
      await _postOptional('/metadata/suggestions/accept-all?min_confidence=$minConfidence') as Map<String, dynamic>? ?? {};

  // Enrichment

  Future<Map<String, dynamic>> enrichTrack(int trackId) async =>
      await _postOptional('/metadata/enrich/$trackId') as Map<String, dynamic>? ?? {};

  Future<Map<String, dynamic>> enrichAlbum(int albumId) async =>
      await _postOptional('/metadata/enrich-album/$albumId') as Map<String, dynamic>? ?? {};

  // Track/Album metadata update

  Future<Map<String, dynamic>> updateTrackMetadata(int trackId, Map<String, dynamic> updates) async =>
      await _patch('/metadata/tracks/$trackId', body: updates) as Map<String, dynamic>? ?? {};

  Future<Map<String, dynamic>> updateAlbumMetadata(int albumId, Map<String, dynamic> updates) async =>
      await _patch('/metadata/albums/$albumId', body: updates) as Map<String, dynamic>? ?? {};

  // Merge

  Future<Map<String, dynamic>> mergeAlbumDuplicates() async =>
      await _postOptional('/library/albums/merge-duplicates') as Map<String, dynamic>? ?? {};

  Future<Map<String, dynamic>> mergeAlbums(List<int> albumIds) async =>
      await _postOptional('/metadata/albums/merge', body: {'album_ids': albumIds}) as Map<String, dynamic>? ?? {};

  // Write tags

  Future<Map<String, dynamic>> writeAlbumTags(int albumId) async =>
      await _postOptional('/metadata/albums/$albumId/write-tags') as Map<String, dynamic>? ?? {};

  // Doubtful albums

  Future<List<dynamic>> getDoubtfulAlbums() async =>
      await _getOptional('/metadata/doubtful') as List? ?? [];

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
