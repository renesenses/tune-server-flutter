import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

/// REST client for connecting to a remote Tune server.
/// Mirrors TuneAPIClient.swift (iOS).
class TuneApiClient {
  final String baseUrl;
  TuneApiClient(this.baseUrl);

  // ---------------------------------------------------------------------------
  // Generic helpers
  // ---------------------------------------------------------------------------

  Future<dynamic> _get(String path) async {
    final resp = await http.get(Uri.parse('$baseUrl$path'))
        .timeout(const Duration(seconds: 60));
    if (resp.statusCode != 200) {
      throw Exception('GET $path failed: ${resp.statusCode}');
    }
    return jsonDecode(resp.body);
  }

  Future<dynamic> _post(String path, {Map<String, dynamic>? body}) async {
    final resp = await http.post(
      Uri.parse('$baseUrl$path'),
      headers: {'Content-Type': 'application/json'},
      body: body != null ? jsonEncode(body) : null,
    ).timeout(const Duration(seconds: 60));
    if (resp.statusCode != 200 && resp.statusCode != 201) {
      throw Exception('POST $path failed: ${resp.statusCode}');
    }
    return resp.body.isNotEmpty ? jsonDecode(resp.body) : null;
  }

  Future<dynamic> _patch(String path, {Map<String, dynamic>? body}) async {
    final resp = await http.patch(
      Uri.parse('$baseUrl$path'),
      headers: {'Content-Type': 'application/json'},
      body: body != null ? jsonEncode(body) : null,
    ).timeout(const Duration(seconds: 60));
    if (resp.statusCode != 200) {
      throw Exception('PATCH $path failed: ${resp.statusCode}');
    }
    return resp.body.isNotEmpty ? jsonDecode(resp.body) : null;
  }

  Future<void> _delete(String path) async {
    final resp = await http.delete(Uri.parse('$baseUrl$path'))
        .timeout(const Duration(seconds: 60));
    if (resp.statusCode != 200 && resp.statusCode != 204) {
      throw Exception('DELETE $path failed: ${resp.statusCode}');
    }
  }

  // ---------------------------------------------------------------------------
  // Zones
  // ---------------------------------------------------------------------------

  Future<List<dynamic>> getZones() => _get('/zones').then((d) => d as List);

  Future<dynamic> getZone(int zoneId) => _get('/zones/$zoneId');

  // ---------------------------------------------------------------------------
  // Playback
  // ---------------------------------------------------------------------------

  Future<dynamic> play(int zoneId, Map<String, dynamic> body) =>
      _post('/zones/$zoneId/play', body: body);

  Future<dynamic> pause(int zoneId) => _post('/zones/$zoneId/pause');

  Future<dynamic> resume(int zoneId) => _post('/zones/$zoneId/resume');

  Future<dynamic> next(int zoneId) => _post('/zones/$zoneId/next');

  Future<dynamic> previous(int zoneId) => _post('/zones/$zoneId/previous');

  Future<dynamic> seek(int zoneId, int positionMs) =>
      _post('/zones/$zoneId/seek', body: {'position_ms': positionMs});

  Future<dynamic> setVolume(int zoneId, double volume) =>
      _post('/zones/$zoneId/volume', body: {'volume': volume});

  Future<dynamic> setShuffle(int zoneId, bool enabled) =>
      _post('/zones/$zoneId/shuffle', body: {'enabled': enabled});

  Future<dynamic> setRepeat(int zoneId, String mode) =>
      _post('/zones/$zoneId/repeat', body: {'mode': mode});

  // ---------------------------------------------------------------------------
  // Queue
  // ---------------------------------------------------------------------------

  Future<dynamic> getQueue(int zoneId) => _get('/zones/$zoneId/queue');

  Future<dynamic> addToQueue(int zoneId, Map<String, dynamic> body) =>
      _post('/zones/$zoneId/queue/add', body: body);

  // ---------------------------------------------------------------------------
  // Library
  // ---------------------------------------------------------------------------

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
  // Radios
  // ---------------------------------------------------------------------------

  Future<List<dynamic>> getRadios() =>
      _get('/radios').then((d) => d as List);

  Future<dynamic> playRadio(int radioId, int zoneId) =>
      _post('/zones/$zoneId/play', body: {'radio_id': radioId});

  // ---------------------------------------------------------------------------
  // Streaming
  // ---------------------------------------------------------------------------

  Future<Map<String, dynamic>> getStreamingServices() =>
      _get('/streaming/services').then((d) => d as Map<String, dynamic>);

  Future<List<dynamic>> getStreamingPlaylists(String service) =>
      _get('/streaming/$service/playlists').then((d) => d as List);

  Future<List<dynamic>> getStreamingPlaylistTracks(String service, String playlistId) =>
      _get('/streaming/$service/playlists/$playlistId/tracks').then((d) => d as List);

  Future<dynamic> searchStreaming(String service, String query, {int limit = 20}) =>
      _get('/streaming/$service/search?q=${Uri.encodeComponent(query)}&limit=$limit');

  // ---------------------------------------------------------------------------
  // Playlists
  // ---------------------------------------------------------------------------

  Future<List<dynamic>> getPlaylists() =>
      _get('/playlists').then((d) => d as List);

  Future<List<dynamic>> getPlaylistTracks(int playlistId) =>
      _get('/playlists/$playlistId/tracks').then((d) => d as List);

  Future<Map<String, dynamic>> createPlaylist(String name, {String? description}) =>
      _post('/playlists', body: {
        'name': name,
        if (description != null) 'description': description,
      }).then((d) => d as Map<String, dynamic>);

  Future<void> deletePlaylist(int playlistId) =>
      _delete('/playlists/$playlistId');

  Future<Map<String, dynamic>> diffPlaylists({
    required String sourceService,
    required String sourcePlaylistId,
    required String targetService,
    required String targetPlaylistId,
  }) => _post('/playlists/diff', body: {
        'source_service': sourceService,
        'source_playlist_id': sourcePlaylistId,
        'target_service': targetService,
        'target_playlist_id': targetPlaylistId,
      }).then((d) => d as Map<String, dynamic>);

  Future<Map<String, dynamic>> recoverPlaylist(int playlistId) =>
      _post('/playlists/$playlistId/recover').then((d) => d as Map<String, dynamic>);

  Future<Map<String, dynamic>> applyPlaylistRecovery(
    int playlistId,
    List<Map<String, dynamic>> replacements,
  ) => _post('/playlists/$playlistId/recover/apply', body: {
        'replacements': replacements,
      }).then((d) => d as Map<String, dynamic>);

  Future<Map<String, dynamic>> importStreamingPlaylist({
    required String service,
    required String sourcePlaylistId,
    String? name,
  }) => _post('/playlists/import', body: {
        'service': service,
        'source_playlist_id': sourcePlaylistId,
        if (name != null) 'name': name,
      }).then((d) => d as Map<String, dynamic>);

  // ---------------------------------------------------------------------------
  // Playlist Manager
  // ---------------------------------------------------------------------------

  Future<Map<String, dynamic>> getPlaylistManagerServices() =>
      _get('/playlist-manager/services').then((d) => d as Map<String, dynamic>);

  Future<dynamic> transferPlaylist({
    required String sourceService, required String sourcePlaylistId,
    String targetService = 'local', String? targetName,
    double matchThreshold = 0.6, bool dryRun = false,
    bool createOnTarget = false, bool includeApproximate = true,
  }) => _post('/playlist-manager/transfer', body: {
    'source_service': sourceService, 'source_playlist_id': sourcePlaylistId,
    'target_service': targetService, 'target_name': targetName,
    'match_threshold': matchThreshold, 'dry_run': dryRun,
    'create_on_target': createOnTarget, 'include_approximate': includeApproximate,
  });

  Future<dynamic> batchTransfer({
    required String sourceService, String targetService = 'local',
    List<String>? playlistIds, double matchThreshold = 0.6,
  }) => _post('/playlist-manager/batch-transfer', body: {
    'source_service': sourceService, 'target_service': targetService,
    'playlist_ids': playlistIds, 'match_threshold': matchThreshold,
  });

  Future<dynamic> mergePlaylists({
    required List<Map<String, String>> playlists, required String targetName,
    bool deduplicate = true, String targetService = 'local',
  }) => _post('/playlist-manager/merge', body: {
    'playlists': playlists, 'target_name': targetName,
    'deduplicate': deduplicate, 'target_service': targetService,
  });

  Future<dynamic> backupPlaylists({List<String>? services}) =>
      _post('/playlist-manager/backup', body: {'services': services, 'include_tracks': true});

  Future<List<dynamic>> listPlaylistSnapshots({String? service}) {
    final q = service != null ? '?service=${Uri.encodeQueryComponent(service)}' : '';
    return _get('/playlist-manager/backups$q').then((d) => d as List);
  }

  Future<dynamic> restorePlaylistSnapshot(int id, {String? targetName, bool overwriteExisting = false}) =>
      _post('/playlist-manager/backups/$id/restore', body: {
        if (targetName != null) 'target_name': targetName,
        'overwrite_existing': overwriteExisting,
      });

  Future<void> deletePlaylistSnapshot(int id) =>
      _delete('/playlist-manager/backups/$id');

  Future<dynamic> updatePlaylistLink(int id, {String? syncDirection, int? syncIntervalMinutes}) =>
      _patch('/playlist-manager/links/$id', body: {
        if (syncDirection != null) 'sync_direction': syncDirection,
        if (syncIntervalMinutes != null) 'sync_interval_minutes': syncIntervalMinutes,
      });

  String databaseExportUrl() => '$baseUrl/system/database/export';

  Future<Map<String, dynamic>> exportDatabase({required String savePath}) async {
    final client = http.Client();
    try {
      final request = http.Request('GET', Uri.parse(databaseExportUrl()));
      final streamed = await client.send(request);
      if (streamed.statusCode != 200) {
        final body = await streamed.stream.bytesToString();
        throw Exception('Export failed (${streamed.statusCode}): $body');
      }
      final file = File(savePath);
      final sink = file.openWrite();
      int total = 0;
      await for (final chunk in streamed.stream) {
        sink.add(chunk);
        total += chunk.length;
      }
      await sink.close();
      return {'path': savePath, 'size': total};
    } finally {
      client.close();
    }
  }

  Future<Map<String, dynamic>> importDatabase(String filePath) async {
    final uri = Uri.parse('$baseUrl/system/database/import');
    final request = http.MultipartRequest('POST', uri);
    request.files.add(await http.MultipartFile.fromPath('file', filePath));
    final streamed = await request.send();
    final body = await streamed.stream.bytesToString();
    if (streamed.statusCode != 200) {
      throw Exception('Import failed (${streamed.statusCode}): $body');
    }
    return jsonDecode(body) as Map<String, dynamic>;
  }

  Future<dynamic> exportPlaylist(String service, String playlistId, String format) =>
      _post('/playlist-manager/export', body: {'service': service, 'playlist_id': playlistId, 'format': format});

  Future<List<dynamic>> getPlaylistLinks() =>
      _get('/playlist-manager/links').then((d) => d as List);

  Future<dynamic> createPlaylistLink({
    required int localPlaylistId, required String service,
    required String servicePlaylistId, String syncDirection = 'pull',
  }) => _post('/playlist-manager/links', body: {
    'local_playlist_id': localPlaylistId, 'service': service,
    'service_playlist_id': servicePlaylistId, 'sync_direction': syncDirection,
  });

  Future<dynamic> triggerPlaylistSync(int linkId) =>
      _post('/playlist-manager/links/$linkId/sync');

  Future<void> deletePlaylistLink(int linkId) =>
      _delete('/playlist-manager/links/$linkId');

  Future<List<dynamic>> getTransferHistory({int limit = 50}) =>
      _get('/playlist-manager/history?limit=$limit').then((d) => d as List);

  Future<dynamic> getTransferDetail(int transferId) =>
      _get('/playlist-manager/history/$transferId');

  // ---------------------------------------------------------------------------
  // Podcasts
  // ---------------------------------------------------------------------------

  Future<List<dynamic>> getRadioFrancePodcasts() =>
      _get('/podcasts/radiofrance').then((d) => d as List);

  Future<List<dynamic>> searchPodcasts(String query, {int limit = 20}) =>
      _get('/podcasts/search?q=${Uri.encodeComponent(query)}&limit=$limit').then((d) => d as List);

  Future<List<dynamic>> getPodcastEpisodes(String feedUrl, {String? showUrl, int limit = 30}) {
    var path = '/podcasts/episodes?limit=$limit';
    if (feedUrl.isNotEmpty) path += '&feed_url=${Uri.encodeComponent(feedUrl)}';
    if (showUrl != null && showUrl.isNotEmpty) path += '&show_url=${Uri.encodeComponent(showUrl)}';
    return _get(path).then((d) => d as List);
  }

  Future<dynamic> playPodcast(int zoneId, Map<String, dynamic> body) =>
      _post('/zones/$zoneId/play', body: body);

  // ---------------------------------------------------------------------------
  // Radio Favorites
  // ---------------------------------------------------------------------------

  Future<void> saveRadioFavorite(Map<String, dynamic> body) =>
      _post('/radio-favorites', body: body);

  Future<List<dynamic>> getRadioFavorites({int limit = 500}) =>
      _get('/radio-favorites?limit=$limit').then((d) => d as List);

  // ---------------------------------------------------------------------------
  // System
  // ---------------------------------------------------------------------------

  Future<dynamic> getSystemInfo() => _get('/system/info');

  /// Quick connectivity test
  Future<bool> testConnection() async {
    try {
      await _get('/system/health');
      return true;
    } catch (_) {
      return false;
    }
  }

  // ---------------------------------------------------------------------------
  // Metadata Manager
  // ---------------------------------------------------------------------------

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

  // Merge duplicates

  Future<Map<String, dynamic>> mergeAlbumDuplicates() =>
      _post('/library/albums/merge-duplicates').then((d) => d as Map<String, dynamic>);

  // Merge specific albums by IDs

  Future<Map<String, dynamic>> mergeAlbums(List<int> albumIds) =>
      _post('/metadata/albums/merge', body: {'album_ids': albumIds})
          .then((d) => d as Map<String, dynamic>);

  // Write tags to disk for a single album

  Future<Map<String, dynamic>> writeAlbumTags(int albumId) =>
      _post('/metadata/albums/$albumId/write-tags')
          .then((d) => d as Map<String, dynamic>);

  // Doubtful albums

  Future<List<dynamic>> getDoubtfulAlbums() =>
      _get('/metadata/doubtful').then((d) => d as List);

  // Upload album artwork (multipart)

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

  // ---------------------------------------------------------------------------
  // ── Zone Manager ──
  // ---------------------------------------------------------------------------

  // Overview

  Future<Map<String, dynamic>> getZoneOverview() =>
      _get('/zone-manager/overview').then((d) => d as Map<String, dynamic>);

  // Hot-swap

  Future<Map<String, dynamic>> hotSwapDevice(int zoneId, String outputType, {String? outputDeviceId}) =>
      _post('/zone-manager/zones/$zoneId/hot-swap', body: {
        'output_type': outputType,
        if (outputDeviceId != null) 'output_device_id': outputDeviceId,
      }).then((d) => d as Map<String, dynamic>);

  // Mute

  Future<Map<String, dynamic>> muteZone(int zoneId, bool muted) =>
      _post('/zone-manager/zones/$zoneId/mute', body: {'muted': muted})
          .then((d) => d as Map<String, dynamic>);

  // Groups

  Future<List<dynamic>> getZoneManagerGroups() =>
      _get('/zone-manager/groups').then((d) => d as List);

  Future<Map<String, dynamic>> createZoneGroup(int leaderZoneId, List<int> zoneIds, {String? name, double masterVolume = 0.5}) =>
      _post('/zone-manager/groups', body: {
        'leader_zone_id': leaderZoneId,
        'zone_ids': zoneIds,
        if (name != null) 'name': name,
        'master_volume': masterVolume,
      }).then((d) => d as Map<String, dynamic>);

  Future<Map<String, dynamic>> renameZoneGroup(String groupId, String name) =>
      _patch('/zone-manager/groups/$groupId', body: {'name': name})
          .then((d) => d as Map<String, dynamic>);

  Future<Map<String, dynamic>> deleteZoneGroup(String groupId) async {
    await _delete('/zone-manager/groups/$groupId');
    return {'deleted': groupId};
  }

  Future<Map<String, dynamic>> setGroupVolume(String groupId, {double? masterVolume, Map<int, double>? offsets}) =>
      _post('/zone-manager/groups/$groupId/volume', body: {
        if (masterVolume != null) 'master_volume': masterVolume,
        if (offsets != null) 'offsets': offsets.map((k, v) => MapEntry(k.toString(), v)),
      }).then((d) => d as Map<String, dynamic>);

  Future<Map<String, dynamic>> calibrateGroup(String groupId) =>
      _post('/zone-manager/groups/$groupId/calibrate')
          .then((d) => d as Map<String, dynamic>);

  // Profiles

  Future<List<dynamic>> getZoneProfiles() =>
      _get('/zone-manager/profiles').then((d) => d as List);

  Future<Map<String, dynamic>> createZoneProfile(String name, {String? description, String? icon}) =>
      _post('/zone-manager/profiles', body: {
        'name': name,
        if (description != null) 'description': description,
        if (icon != null) 'icon': icon,
      }).then((d) => d as Map<String, dynamic>);

  Future<Map<String, dynamic>> activateZoneProfile(int profileId) =>
      _post('/zone-manager/profiles/$profileId/activate')
          .then((d) => d as Map<String, dynamic>);

  Future<Map<String, dynamic>> deleteZoneProfile(int profileId) async {
    await _delete('/zone-manager/profiles/$profileId');
    return {'deleted': profileId};
  }

  // Latency & Health

  Future<Map<String, dynamic>> measureLatency(int zoneId) =>
      _post('/zone-manager/zones/$zoneId/measure-latency')
          .then((d) => d as Map<String, dynamic>);

  Future<Map<String, dynamic>> getZoneHealth(int zoneId) =>
      _get('/zone-manager/zones/$zoneId/health').then((d) => d as Map<String, dynamic>);

  Future<Map<String, dynamic>> getGroupHealth(String groupId) =>
      _get('/zone-manager/groups/$groupId/health').then((d) => d as Map<String, dynamic>);

  Future<Map<String, dynamic>> getSyncStats() =>
      _get('/zone-manager/sync/stats').then((d) => d as Map<String, dynamic>);

  // ---------------------------------------------------------------------------
  // ── Stereo Pairs ──
  // ---------------------------------------------------------------------------

  Future<Map<String, dynamic>> createStereoPair(
          String name, String leftDeviceId, String rightDeviceId) =>
      _post('/zones/stereo-pair', body: {
        'name': name,
        'left_device_id': leftDeviceId,
        'right_device_id': rightDeviceId,
      }).then((d) => d as Map<String, dynamic>);

  Future<void> dissolveStereoPair(String pairId) =>
      _delete('/zones/stereo-pair/$pairId');

  Future<List<Map<String, dynamic>>> listStereoPairs() =>
      _get('/zones/stereo-pairs/list').then((d) =>
          (d as List).map((e) => e as Map<String, dynamic>).toList());

  // ---------------------------------------------------------------------------
  // ── Streaming Enable/Disable ──
  // ---------------------------------------------------------------------------

  Future<void> enableStreamingService(String name) =>
      _post('/streaming/$name/enable').then((_) {});

  Future<void> disableStreamingService(String name) =>
      _post('/streaming/$name/disable').then((_) {});
}
