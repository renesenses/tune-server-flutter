import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

part 'tune_api_client.metadata.dart';
part 'tune_api_client.library.dart';
part 'tune_api_client.streaming.dart';

/// HTTP error with status code — allows callers to distinguish 404
/// (endpoint missing on Rust alpha) from other failures.
class TuneHttpException implements Exception {
  final String message;
  final int statusCode;
  const TuneHttpException(this.message, this.statusCode);
  bool get isNotFound => statusCode == 404;
  @override
  String toString() => message;
}

/// Callback invoked on 401 Unauthorized — lets the app clear auth state.
typedef OnUnauthorized = void Function();

/// REST client for connecting to a remote Tune server.
/// Mirrors TuneAPIClient.swift (iOS).
class TuneApiClient {
  final String baseUrl;
  final http.Client _client;

  /// Auth token injected by AuthService — added to all requests.
  String? authToken;

  /// Called when a 401 response is received — app should clear token and
  /// redirect to login.
  OnUnauthorized? onUnauthorized;

  /// Production : utilise le client http par défaut.
  TuneApiClient(this.baseUrl) : _client = http.Client();

  /// Test-only : permet d'injecter un MockClient (package:http/testing.dart).
  /// Utilisé par test/services/tune_api_client_test.dart.
  TuneApiClient.withClient(this.baseUrl, http.Client client) : _client = client;

  // ---------------------------------------------------------------------------
  // Generic helpers
  // ---------------------------------------------------------------------------

  /// Build request headers with optional auth token.
  Map<String, String> _headers({bool json = false}) {
    final h = <String, String>{'Accept': 'application/json'};
    if (json) h['Content-Type'] = 'application/json';
    if (authToken != null && authToken!.isNotEmpty) {
      h['Authorization'] = 'Bearer $authToken';
    }
    return h;
  }

  /// Check for 401 and fire callback.
  void _check401(int statusCode) {
    if (statusCode == 401) onUnauthorized?.call();
  }

  Future<dynamic> _get(String path) async {
    final resp = await _client.get(
      Uri.parse('$baseUrl$path'),
      headers: _headers(),
    ).timeout(const Duration(seconds: 60));
    _check401(resp.statusCode);
    if (resp.statusCode != 200) {
      throw TuneHttpException('GET $path failed: ${resp.statusCode}', resp.statusCode);
    }
    final body = resp.body;
    if (body.trimLeft().startsWith('<!') || body.trimLeft().startsWith('<html')) {
      throw TuneHttpException('GET $path returned HTML instead of JSON', 200);
    }
    return jsonDecode(body);
  }

  /// Like [_get] but returns `null` on 404 instead of throwing.
  /// Use for endpoints that may not exist on all server implementations
  /// (e.g. Rust alpha server lacks plugins, metadata endpoints).
  Future<dynamic> _getOptional(String path) async {
    final resp = await _client.get(
      Uri.parse('$baseUrl$path'),
      headers: _headers(),
    ).timeout(const Duration(seconds: 60));
    _check401(resp.statusCode);
    if (resp.statusCode == 404) return null;
    if (resp.statusCode != 200) {
      throw TuneHttpException('GET $path failed: ${resp.statusCode}', resp.statusCode);
    }
    return jsonDecode(resp.body);
  }

  Future<dynamic> _post(String path, {Map<String, dynamic>? body}) async {
    final resp = await _client.post(
      Uri.parse('$baseUrl$path'),
      headers: _headers(json: true),
      body: body != null ? jsonEncode(body) : null,
    ).timeout(const Duration(seconds: 60));
    _check401(resp.statusCode);
    if (resp.statusCode != 200 && resp.statusCode != 201) {
      throw TuneHttpException('POST $path failed: ${resp.statusCode}', resp.statusCode);
    }
    return resp.body.isNotEmpty ? jsonDecode(resp.body) : null;
  }

  /// Like [_post] but returns `null` on 404.
  Future<dynamic> _postOptional(String path, {Map<String, dynamic>? body}) async {
    final resp = await _client.post(
      Uri.parse('$baseUrl$path'),
      headers: _headers(json: true),
      body: body != null ? jsonEncode(body) : null,
    ).timeout(const Duration(seconds: 60));
    _check401(resp.statusCode);
    if (resp.statusCode == 404) return null;
    if (resp.statusCode != 200 && resp.statusCode != 201) {
      throw TuneHttpException('POST $path failed: ${resp.statusCode}', resp.statusCode);
    }
    return resp.body.isNotEmpty ? jsonDecode(resp.body) : null;
  }

  Future<dynamic> _patch(String path, {Map<String, dynamic>? body}) async {
    final resp = await _client.patch(
      Uri.parse('$baseUrl$path'),
      headers: _headers(json: true),
      body: body != null ? jsonEncode(body) : null,
    ).timeout(const Duration(seconds: 60));
    _check401(resp.statusCode);
    if (resp.statusCode != 200) {
      throw TuneHttpException('PATCH $path failed: ${resp.statusCode}', resp.statusCode);
    }
    return resp.body.isNotEmpty ? jsonDecode(resp.body) : null;
  }

  Future<dynamic> _put(String path, {Map<String, dynamic>? body}) async {
    final resp = await _client.put(
      Uri.parse('$baseUrl$path'),
      headers: _headers(json: true),
      body: body != null ? jsonEncode(body) : null,
    ).timeout(const Duration(seconds: 60));
    _check401(resp.statusCode);
    if (resp.statusCode != 200) {
      throw TuneHttpException('PUT $path failed: ${resp.statusCode}', resp.statusCode);
    }
    return resp.body.isNotEmpty ? jsonDecode(resp.body) : null;
  }

  Future<void> _delete(String path) async {
    final resp = await _client.delete(
      Uri.parse('$baseUrl$path'),
      headers: _headers(),
    ).timeout(const Duration(seconds: 60));
    _check401(resp.statusCode);
    if (resp.statusCode != 200 && resp.statusCode != 204) {
      throw TuneHttpException('DELETE $path failed: ${resp.statusCode}', resp.statusCode);
    }
  }

  // ---------------------------------------------------------------------------
  // Zones
  // ---------------------------------------------------------------------------

  Future<List<dynamic>> getZones() => _get('/zones').then((d) => d as List);

  Future<dynamic> getZone(int zoneId) => _get('/zones/$zoneId');

  Future<Map<String, dynamic>> createZoneRemote(String name, {String? outputType, String? outputDeviceId}) =>
      _post('/zones', body: {
        'name': name,
        if (outputType != null) 'output_type': outputType,
        if (outputDeviceId != null) 'output_device_id': outputDeviceId,
      }).then((d) => d as Map<String, dynamic>);

  Future<void> deleteZoneRemote(int zoneId) => _delete('/zones/$zoneId');

  Future<void> renameZoneRemote(int zoneId, String name) =>
      _put('/zones/$zoneId/name', body: {'name': name});

  Future<dynamic> patchZone(int zoneId, Map<String, dynamic> fields) =>
      _patch('/zones/$zoneId', body: fields);

  Future<List<dynamic>> getDiscoveredDevices() =>
      _get('/devices').then((d) => d as List);

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

  Future<dynamic> shuffleAll(int zoneId, {
    String? searchQuery,
    int? albumId,
    int? artistId,
    String? genre,
  }) {
    final params = <String, String>{'zone_id': '$zoneId'};
    if (searchQuery != null && searchQuery.isNotEmpty) {
      params['search_query'] = searchQuery;
    }
    if (albumId != null) params['album_id'] = '$albumId';
    if (artistId != null) params['artist_id'] = '$artistId';
    if (genre != null && genre.isNotEmpty) params['genre'] = genre;
    final qs = params.entries.map((e) => '${e.key}=${Uri.encodeComponent(e.value)}').join('&');
    return _post('/playback/shuffle-all?$qs');
  }

  // ---------------------------------------------------------------------------
  // Queue
  // ---------------------------------------------------------------------------

  Future<dynamic> getQueue(int zoneId) => _get('/zones/$zoneId/queue');

  Future<dynamic> addToQueue(int zoneId, Map<String, dynamic> body) =>
      _post('/zones/$zoneId/queue/add', body: body);

  Future<void> removeFromQueue(int zoneId, int position) =>
      _delete('/zones/$zoneId/queue/$position');

  Future<dynamic> jumpToQueuePosition(int zoneId, int position) =>
      _post('/zones/$zoneId/queue/jump', body: {'position': position});

  Future<void> moveQueueItem(int zoneId, int fromPosition, int toPosition) async {
    await _post('/zones/$zoneId/queue/move', body: {
      'from_position': fromPosition,
      'to_position': toPosition,
    });
  }

  Future<void> clearQueue(int zoneId) =>
      _delete('/zones/$zoneId/queue');

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

  /// Add tracks to an existing playlist.
  /// [trackIds] — local track IDs to add.
  /// [position] — optional insertion position (null = append).
  Future<Map<String, dynamic>> addPlaylistTracks(
    int playlistId,
    List<int> trackIds, {
    int? position,
  }) =>
      _post('/playlists/$playlistId/tracks', body: {
        'track_ids': trackIds,
        if (position != null) 'position': position,
      }).then((d) => d as Map<String, dynamic>);

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

  Future<Map<String, dynamic>> triggerPlaylistSync(int linkId) =>
      _post('/playlist-manager/links/$linkId/sync')
          .then((d) => d as Map<String, dynamic>);

  /// Alias for [triggerPlaylistSync] — matches `SyncResult` naming from Linux API.
  Future<Map<String, dynamic>> syncPlaylistLink(int linkId) =>
      triggerPlaylistSync(linkId);

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

  /// YouTube playback status on the (remote) server: whether the managed
  /// yt-dlp helper is installed. Returns null on older servers without the
  /// endpoint. Only meaningful in remote mode — the embedded server cannot run
  /// yt-dlp on iOS/Android (sandbox).
  Future<Map<String, dynamic>?> getYoutubeStatus() async {
    final d = await _getOptional('/system/youtube/status');
    return d as Map<String, dynamic>?;
  }

  /// Bug report as markdown (may return String or Map with 'report' key).
  /// Returns null if the endpoint doesn't exist on this server version.
  Future<dynamic> getBugReportMarkdown() => _getOptional('/api/v1/system/bug-report/markdown');

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

  // ---------------------------------------------------------------------------
  // ── DJ Mode ──
  // ---------------------------------------------------------------------------

  Future<Map<String, dynamic>> getDJStatus(int zoneId) async =>
      await _get('/dj/status/$zoneId') as Map<String, dynamic>;

  Future<Map<String, dynamic>> enableDJ(int zoneId) async =>
      await _post('/dj/enable/$zoneId') as Map<String, dynamic>;

  Future<Map<String, dynamic>> disableDJ(int zoneId) async =>
      await _post('/dj/disable/$zoneId') as Map<String, dynamic>;

  Future<Map<String, dynamic>> loadDeck(int zoneId, String deck, int trackId) async =>
      await _post('/dj/load/$zoneId/$deck', body: {'track_id': trackId}) as Map<String, dynamic>;

  Future<Map<String, dynamic>> playDeck(int zoneId, String deck) async =>
      await _post('/dj/play/$zoneId/$deck') as Map<String, dynamic>;

  Future<Map<String, dynamic>> pauseDeck(int zoneId, String deck) async =>
      await _post('/dj/pause/$zoneId/$deck') as Map<String, dynamic>;

  Future<Map<String, dynamic>> startCrossfade(int zoneId, {double duration = 5.0, String curve = 'linear'}) async =>
      await _post('/dj/crossfade/$zoneId', body: {'duration_seconds': duration, 'curve': curve}) as Map<String, dynamic>;

  Future<Map<String, dynamic>> toggleAutoCrossfade(int zoneId, bool enabled, {int beforeEnd = 10}) async =>
      await _post('/dj/auto-crossfade/$zoneId', body: {'enabled': enabled, 'before_end': beforeEnd}) as Map<String, dynamic>;

  Future<Map<String, dynamic>> getWaveform(int trackId) async =>
      await _get('/dj/waveform/$trackId') as Map<String, dynamic>;

  Future<void> analyzeTrack(int trackId) async =>
      await _post('/dj/analyze/$trackId');

  Future<Map<String, dynamic>> syncTempo(int zoneId) async =>
      await _post('/dj/sync-tempo/$zoneId') as Map<String, dynamic>;

  // ---------------------------------------------------------------------------
  // ── Party Mode ──
  // ---------------------------------------------------------------------------

  Future<Map<String, dynamic>> getPartyStatus() async =>
      await _get('/party/status') as Map<String, dynamic>;

  Future<Map<String, dynamic>> partyAddTrack(String query, {int? zoneId}) async =>
      await _post('/party/add', body: {'query': query, if (zoneId != null) 'zone_id': zoneId}) as Map<String, dynamic>;

  Future<List<dynamic>> getPartyQueue({int? zoneId}) async =>
      await _get('/party/queue${zoneId != null ? "?zone_id=$zoneId" : ""}') as List<dynamic>;

  Future<Map<String, dynamic>> partyVote(int position, {int? zoneId}) async =>
      await _post('/party/vote', body: {'position': position, if (zoneId != null) 'zone_id': zoneId}) as Map<String, dynamic>;

  // ---------------------------------------------------------------------------
  // ── Smart Playlists ──
  // ---------------------------------------------------------------------------

  Future<List<dynamic>> getSmartPlaylists() async =>
      await _get('/library/smart-playlists') as List<dynamic>;

  Future<List<dynamic>> getSmartPlaylistTracks(int id) async =>
      await _get('/library/smart-playlists/$id/tracks') as List<dynamic>;

  Future<void> deleteSmartPlaylist(int id) async =>
      await _delete('/library/smart-playlists/$id');

  Future<Map<String, dynamic>> createSmartPlaylist(Map<String, dynamic> body) async =>
      await _post('/api/v1/smart-playlists', body: body) as Map<String, dynamic>;

  Future<Map<String, dynamic>> updateSmartPlaylist(int id, Map<String, dynamic> body) async =>
      await _put('/api/v1/smart-playlists/$id', body: body) as Map<String, dynamic>;

  Future<List<dynamic>> previewSmartPlaylistTracks({
    required List<Map<String, dynamic>> rules,
    String matchMode = 'all',
    int limit = 50,
  }) async =>
      await _post('/api/v1/smart-playlists/preview', body: {
        'rules': rules,
        'match_mode': matchMode,
        'limit': limit,
      }) as List<dynamic>;

  // ---------------------------------------------------------------------------
  // ── EQ ──
  // ---------------------------------------------------------------------------

  Future<void> setEqualizer(int zoneId, String preset) async =>
      await _post('/zones/$zoneId/eq', body: {'preset': preset});

  /// Get current EQ bands state (10-band parametric)
  Future<Map<String, dynamic>> getEqualizerBands(int zoneId) async =>
      await _get('/zones/$zoneId/eq') as Map<String, dynamic>;

  /// Set 10-band EQ gains (list of 10 doubles, -12 to +12 dB)
  Future<void> setEqualizerBands(int zoneId, List<double> gains) async =>
      await _post('/zones/$zoneId/eq', body: {'bands': gains});

  // ---------------------------------------------------------------------------
  // ── Audiophile Mode ──
  // ---------------------------------------------------------------------------

  Future<Map<String, dynamic>> getAudiophileMode(int zoneId) async =>
      await _get('/zones/$zoneId/audiophile') as Map<String, dynamic>;

  Future<void> setAudiophileMode(int zoneId, bool enabled) async =>
      await _post('/zones/$zoneId/audiophile', body: {'enabled': enabled});

  // ---------------------------------------------------------------------------
  // ── Streaming Quality ──
  // ---------------------------------------------------------------------------

  Future<Map<String, dynamic>> getStreamingQuality(int zoneId) async =>
      await _get('/zones/$zoneId/quality') as Map<String, dynamic>;

  Future<void> setStreamingQuality(int zoneId, String quality) async =>
      await _post('/zones/$zoneId/quality', body: {'quality': quality});

  // ---------------------------------------------------------------------------
  // ── YouTube Music Browse ──
  // ---------------------------------------------------------------------------

  Future<Map<String, dynamic>> getYoutubeHome() async =>
      await _get('/streaming/youtube/home') as Map<String, dynamic>;

  Future<Map<String, dynamic>> getYoutubeCharts() async =>
      await _get('/streaming/youtube/charts') as Map<String, dynamic>;

  Future<List<dynamic>> getYoutubeMoods() async =>
      await _get('/streaming/youtube/moods') as List<dynamic>;

  // ---------------------------------------------------------------------------
  // ── Artist Image Report ──
  // ---------------------------------------------------------------------------

  Future<void> reportArtistImage(int artistId, {String? reason}) async =>
      await _post('/library/artists/$artistId/image/report', body: {
        if (reason != null) 'reason': reason,
      });

  // ---------------------------------------------------------------------------
  // ── Network Diagnostics ──
  // ---------------------------------------------------------------------------

  Future<Map<String, dynamic>> getNetworkDiagnostics() async =>
      await _getOptional('/system/diagnostics/network') as Map<String, dynamic>? ?? {};

  // ---------------------------------------------------------------------------
  // ── Config Export/Import ──
  // ---------------------------------------------------------------------------

  Future<Map<String, dynamic>> exportConfig() async =>
      await _get('/system/config/export') as Map<String, dynamic>;

  Future<Map<String, dynamic>> importConfig(Map<String, dynamic> config) async =>
      await _post('/system/config/import', body: config) as Map<String, dynamic>;

  // ---------------------------------------------------------------------------
  // ── Plugins ──
  // ---------------------------------------------------------------------------

  Future<List<dynamic>> getPlugins() async =>
      await _getOptional('/system/plugins') as List<dynamic>? ?? [];

  Future<Map<String, dynamic>> setPluginEnabled(String pluginId, bool enabled) async =>
      await _postOptional('/system/plugins/$pluginId', body: {'enabled': enabled}) as Map<String, dynamic>? ?? {};

  // ── Plugin Store (merged catalog + local) ──

  Future<List<dynamic>> getMergedPlugins() async =>
      await _getOptional('/plugins') as List<dynamic>? ?? [];

  Future<dynamic> installPlugin(String slug) async =>
      await _post('/plugins/${Uri.encodeComponent(slug)}/install');

  Future<dynamic> uninstallPlugin(String slug) async {
    await _delete('/plugins/${Uri.encodeComponent(slug)}');
    return {'success': true};
  }

  Future<dynamic> updatePlugin(String slug) async =>
      await _post('/plugins/${Uri.encodeComponent(slug)}/update');

  Future<dynamic> enablePlugin(String slug) async =>
      await _post('/system/plugins/${Uri.encodeComponent(slug)}/enable');

  Future<dynamic> disablePlugin(String slug) async =>
      await _post('/system/plugins/${Uri.encodeComponent(slug)}/disable');

  // ---------------------------------------------------------------------------
  // ── Share ──
  // ---------------------------------------------------------------------------

  Future<Map<String, dynamic>> shareNowPlaying(int zoneId) async =>
      await _get('/zones/$zoneId/share') as Map<String, dynamic>;

  // ---------------------------------------------------------------------------
  // ── Transfer Playback ──
  // ---------------------------------------------------------------------------

  Future<Map<String, dynamic>> transferPlayback(int fromZoneId, int toZoneId) async =>
      await _post('/zones/$fromZoneId/transfer/$toZoneId') as Map<String, dynamic>;

  // ---------------------------------------------------------------------------
  // ── Album Bio ──
  // ---------------------------------------------------------------------------

  Future<Map<String, dynamic>> getAlbumBio(int albumId) async =>
      await _get('/library/albums/$albumId/bio') as Map<String, dynamic>;

  // ---------------------------------------------------------------------------
  // ── Lyrics ──
  // ---------------------------------------------------------------------------

  Future<Map<String, dynamic>> getTrackLyrics(int trackId) async =>
      await _get('/library/tracks/$trackId/lyrics') as Map<String, dynamic>;

  // ---------------------------------------------------------------------------
  // ── Top Tracks / Artists ──
  // ---------------------------------------------------------------------------

  Future<List<dynamic>> getTopTracks({int limit = 20}) async =>
      await _get('/library/history/top-tracks?limit=$limit') as List<dynamic>;

  Future<List<dynamic>> getTopArtists({int limit = 20}) async =>
      await _get('/library/history/top-artists?limit=$limit') as List<dynamic>;

  // ---------------------------------------------------------------------------
  // ── Radio Favorites to Playlist ──
  // ---------------------------------------------------------------------------

  Future<Map<String, dynamic>> createPlaylistFromRadioFavorites(String service, String playlistName, {int limit = 200}) async =>
      await _post('/radio-favorites/create-playlist', body: {'service': service, 'playlist_name': playlistName, 'limit': limit}) as Map<String, dynamic>;

  // ---------------------------------------------------------------------------
  // ── v0.7.12 — Sleep Timer, Crossfade, Normalization, DSP, Queue Save,
  //               Recommendations, Dashboard, Album Rating ──
  // ---------------------------------------------------------------------------

  // Sleep Timer

  Future<void> setSleepTimer(int zoneId, int minutes) async =>
      await _post('/zones/$zoneId/sleep', body: {'minutes': minutes});

  // Crossfade

  Future<void> setCrossfade(int zoneId, bool enabled, {double duration = 3.0}) async =>
      await _post('/zones/$zoneId/crossfade', body: {'enabled': enabled, 'duration': duration});

  // Normalization

  Future<void> setNormalization(int zoneId, bool enabled) async =>
      await _post('/zones/$zoneId/normalization', body: {'enabled': enabled});

  // DSP

  Future<void> setDSP(int zoneId, String? crossfeed) async =>
      await _post('/zones/$zoneId/dsp', body: {'crossfeed': crossfeed});

  // DSP — EQ Profile (Master Profiler)

  /// Fetch the current DSP EQ profile for a zone.
  /// Returns null if the endpoint does not exist yet on this server version.
  Future<Map<String, dynamic>?> getDspProfile(int zoneId) async =>
      await _getOptional('/zones/$zoneId/dsp') as Map<String, dynamic>?;

  /// Send a new DSP EQ profile for a zone.
  Future<void> setDspProfile(int zoneId, EqProfile profile) async =>
      await _post('/zones/$zoneId/dsp', body: {'eq_profile': profile.toJson()});

  // Save queue as playlist

  Future<Map<String, dynamic>> saveQueueAsPlaylist(int zoneId, String name) async =>
      await _post('/zones/$zoneId/queue/save-as-playlist', body: {'name': name}) as Map<String, dynamic>;

  // Recommendations

  Future<Map<String, dynamic>> getRecommendations({int limit = 20}) async =>
      await _get('/library/recommendations?limit=$limit') as Map<String, dynamic>;

  // Dashboard

  Future<Map<String, dynamic>> getHistoryDashboard({String? period}) async =>
      await _get('/library/history/dashboard'
              '${period != null ? '?period=$period' : ''}')
          as Map<String, dynamic>;

  // Album Rating

  Future<void> rateAlbum(int albumId, int rating, {String? note}) async =>
      await _post('/library/albums/$albumId/rate', body: {'rating': rating, if (note != null) 'note': note});

  Future<Map<String, dynamic>> getAlbumRating(int albumId) async =>
      await _get('/library/albums/$albumId/rating') as Map<String, dynamic>;

  // ---------------------------------------------------------------------------
  // ── v0.7.13 — Alarm Clock, Quick Favorites, Collections, Activity Feed,
  //               Now Listening, Share Playlist, Smart Duplicates ──
  // ---------------------------------------------------------------------------

  // Alarm Clock

  Future<void> setAlarm(int zoneId, String? time, {int? albumId, int? playlistId, int fadeSeconds = 30}) async =>
      await _post('/zones/$zoneId/alarm', body: {'time': time, 'fade_seconds': fadeSeconds, if (albumId != null) 'album_id': albumId, if (playlistId != null) 'playlist_id': playlistId});

  Future<Map<String, dynamic>> getAlarm(int zoneId) async => await _get('/zones/$zoneId/alarm') as Map<String, dynamic>;

  Future<void> cancelAlarm(int zoneId) async => await _delete('/zones/$zoneId/alarm');

  // Quick Favorites

  Future<Map<String, dynamic>> quickFavTrack(int trackId) async => await _post('/library/tracks/$trackId/quick-fav') as Map<String, dynamic>;

  Future<Map<String, dynamic>> quickFavAlbum(int albumId) async => await _post('/library/albums/$albumId/quick-fav') as Map<String, dynamic>;

  // Collections

  Future<List<dynamic>> getCollections() async => await _get('/library/collections') as List<dynamic>;

  Future<Map<String, dynamic>> createCollection(String name, {String color = '#6366f1'}) async =>
      await _post('/library/collections', body: {'name': name, 'color': color}) as Map<String, dynamic>;

  Future<List<dynamic>> getCollectionAlbums(int id) async => await _get('/library/collections/$id/albums') as List<dynamic>;

  Future<void> addAlbumToCollection(int collectionId, int albumId) async =>
      await _post('/library/collections/$collectionId/albums', body: {'album_id': albumId});

  Future<void> deleteCollection(int id) async => await _delete('/library/collections/$id');

  // ── v0.8.0 — Smart Collections (rule-based album collections) ───────────
  // Membership computed server-side from JSON-encoded rules. The
  // `rules` field on each row stays a String here (we let the editor
  // decode it lazily) so we don't have to keep the Flutter model in
  // lockstep with every server-side rule grammar addition.

  Future<List<dynamic>> listSmartCollections() async =>
      await _get('/library/smart-collections') as List<dynamic>;

  Future<Map<String, dynamic>> getSmartCollection(int id) async =>
      await _get('/library/smart-collections/$id') as Map<String, dynamic>;

  Future<List<dynamic>> getSmartCollectionAlbums(int id) async =>
      await _get('/library/smart-collections/$id/albums') as List<dynamic>;

  Future<Map<String, dynamic>> createSmartCollection(Map<String, dynamic> payload) async =>
      await _post('/library/smart-collections', body: payload) as Map<String, dynamic>;

  Future<Map<String, dynamic>> updateSmartCollection(int id, Map<String, dynamic> payload) async =>
      await _put('/library/smart-collections/$id', body: payload) as Map<String, dynamic>;

  Future<void> deleteSmartCollection(int id) async =>
      await _delete('/library/smart-collections/$id');

  Future<Map<String, dynamic>> previewSmartCollection({
    required List<dynamic> rules,
    String matchMode = 'all',
    int maxAlbums = 1,
  }) async => await _post('/library/smart-collections/preview', body: {
        'rules': rules,
        'match_mode': matchMode,
        'max_albums': maxAlbums,
      }) as Map<String, dynamic>;

  // Activity Feed

  Future<List<dynamic>> getActivityFeed({int limit = 30}) async => await _get('/library/activity?limit=$limit') as List<dynamic>;

  // Now Listening

  Future<List<dynamic>> getNowListening() async => await _get('/zones/now-listening') as List<dynamic>;

  // Share Playlist

  Future<Map<String, dynamic>> sharePlaylist(int playlistId) async => await _get('/playlists/$playlistId/share') as Map<String, dynamic>;

  // Smart Duplicates

  Future<Map<String, dynamic>> getSmartDuplicates({int limit = 50}) async => await _get('/library/duplicates/smart?limit=$limit') as Map<String, dynamic>;

  // Spotify Connect (receiver) — only meaningful when connected to a remote
  // Tune Server. The embedded Flutter server does not implement it.

  Future<Map<String, dynamic>> getSpotifyConnectStatus() async =>
      await _getOptional('/spotify-connect/status') as Map<String, dynamic>? ?? {};

  Future<Map<String, dynamic>> enableSpotifyConnect({
    required int zoneId,
    String? deviceName,
  }) async =>
      await _post('/spotify-connect/enable', body: {
        'zone_id': zoneId,
        'device_name': deviceName,
      }) as Map<String, dynamic>;

  Future<Map<String, dynamic>> disableSpotifyConnect() async =>
      await _post('/spotify-connect/disable') as Map<String, dynamic>;

  // ---------------------------------------------------------------------------
  // ── Alarms ──
  // ---------------------------------------------------------------------------

  Future<List<dynamic>> getAlarms() async =>
      await _get('/api/v1/alarms/') as List<dynamic>;

  Future<Map<String, dynamic>> createAlarm(Map<String, dynamic> body) async =>
      await _post('/api/v1/alarms/', body: body) as Map<String, dynamic>;

  Future<Map<String, dynamic>> updateAlarm(int id, Map<String, dynamic> body) async =>
      await _put('/api/v1/alarms/$id', body: body) as Map<String, dynamic>;

  Future<void> deleteAlarm(int id) async =>
      await _delete('/api/v1/alarms/$id');

  // ---------------------------------------------------------------------------
  // ── Podcasts — Subscribe / Unsubscribe / Refresh ──
  // ---------------------------------------------------------------------------

  Future<List<dynamic>> getSubscribedPodcasts() async =>
      await _get('/api/v1/podcasts') as List<dynamic>;

  Future<Map<String, dynamic>> subscribePodcast(String feedUrl, {String? name}) async =>
      await _post('/api/v1/podcasts', body: {
        'feed_url': feedUrl,
        if (name != null) 'name': name,
      }) as Map<String, dynamic>;

  Future<void> unsubscribePodcast(String podcastId) async =>
      await _delete('/api/v1/podcasts/$podcastId');

  Future<List<dynamic>> getSubscribedPodcastEpisodes(String podcastId, {int limit = 50}) async =>
      await _get('/api/v1/podcasts/$podcastId/episodes?limit=$limit') as List<dynamic>;

  Future<Map<String, dynamic>> refreshPodcast(String podcastId) async =>
      await _post('/api/v1/podcasts/$podcastId/refresh') as Map<String, dynamic>;

  Future<void> refreshAllPodcasts() async =>
      await _post('/api/v1/podcasts/refresh');

  // ---------------------------------------------------------------------------
  // ── Last.fm Scrobble ──
  // ---------------------------------------------------------------------------

  Future<Map<String, dynamic>> lastfmAuthenticate({
    required String username,
    required String password,
  }) async =>
      await _post('/api/v1/lastfm/authenticate', body: {
        'username': username,
        'password': password,
      }) as Map<String, dynamic>;

  Future<Map<String, dynamic>> getLastfmStatus() async =>
      await _get('/api/v1/lastfm/status') as Map<String, dynamic>;

  Future<Map<String, dynamic>> disconnectLastfm() async =>
      await _post('/api/v1/lastfm/disconnect') as Map<String, dynamic>;

  // ---------------------------------------------------------------------------
  // ── Playlist Compare ──
  // ---------------------------------------------------------------------------

  Future<Map<String, dynamic>> comparePlaylists({
    required String sourceService,
    required String sourcePlaylistId,
    required String targetService,
    required String targetPlaylistId,
  }) async =>
      await _post('/api/v1/playlists/compare', body: {
        'source_service': sourceService,
        'source_playlist_id': sourcePlaylistId,
        'target_service': targetService,
        'target_playlist_id': targetPlaylistId,
      }) as Map<String, dynamic>;

  // ---------------------------------------------------------------------------
  // ── Diagnostics ──
  // ---------------------------------------------------------------------------

  Future<Map<String, dynamic>> getDiagnostics() async =>
      await _getOptional('/api/v1/system/diagnostics') as Map<String, dynamic>? ?? {};

  Future<dynamic> getSystemLogs({int limit = 200}) async =>
      await _getOptional('/api/v1/system/logs?limit=$limit') ?? [];

  Future<Map<String, dynamic>> audioCheck() async =>
      await _getOptional('/system/audio-check') as Map<String, dynamic>? ?? {};

  // ---------------------------------------------------------------------------
  // ── Profiles ──
  // ---------------------------------------------------------------------------

  Future<List<dynamic>> getProfiles() async =>
      await _get('/api/v1/profiles') as List<dynamic>;

  Future<Map<String, dynamic>> getProfile(int id) async =>
      await _get('/api/v1/profiles/$id') as Map<String, dynamic>;

  Future<Map<String, dynamic>> createProfile(Map<String, dynamic> body) async =>
      await _post('/api/v1/profiles', body: body) as Map<String, dynamic>;

  Future<Map<String, dynamic>> updateProfile(int id, Map<String, dynamic> body) async =>
      await _put('/api/v1/profiles/$id', body: body) as Map<String, dynamic>;

  Future<void> deleteProfile(int id) async =>
      await _delete('/api/v1/profiles/$id');

  // ---------------------------------------------------------------------------
  // ── Streaming Favorites ──
  // ---------------------------------------------------------------------------

  Future<List<dynamic>> getStreamingFavorites(String service, String type) async {
    final raw = await _get('/api/v1/streaming/$service/favorites/$type');
    // Server returns {"tracks": [...]} or {"albums": [...]} — unwrap the list.
    if (raw is Map<String, dynamic>) {
      final list = raw[type];
      if (list is List) return list;
      return [];
    }
    if (raw is List) return raw;
    return [];
  }

  Future<void> addStreamingFavorite(String service, String type, {required String itemId}) async =>
      await _post('/api/v1/streaming/$service/favorites/$type', body: {'item_id': itemId});

  Future<void> removeStreamingFavorite(String service, String type, {required String itemId}) async =>
      await _delete('/api/v1/streaming/$service/favorites/$type?item_id=${Uri.encodeComponent(itemId)}');

  // ---------------------------------------------------------------------------
  // ── Genre Tree ──
  // ---------------------------------------------------------------------------

  Future<Map<String, dynamic>> getGenreTree() async =>
      await _get('/api/v1/library/genre-tree') as Map<String, dynamic>;

  Future<Map<String, dynamic>> updateGenreTree(Map<String, dynamic> tree) async =>
      await _put('/api/v1/library/genre-tree', body: tree) as Map<String, dynamic>;

  // ---------------------------------------------------------------------------
  // -- Pins --
  // ---------------------------------------------------------------------------

  /// Get all pins for a zone.
  Future<List<dynamic>> getZonePins(int zoneId) async =>
      await _get('/zones/$zoneId/pins') as List<dynamic>;

  /// Create or update a pin at a specific index.
  Future<Map<String, dynamic>> setZonePin(int zoneId, Map<String, dynamic> body) async =>
      await _post('/zones/$zoneId/pins', body: body) as Map<String, dynamic>;

  /// Invoke (play) a pin at a given index.
  Future<Map<String, dynamic>> invokeZonePin(int zoneId, int index) async =>
      await _post('/zones/$zoneId/pins/$index/invoke') as Map<String, dynamic>;

  /// Delete a pin at a given index.
  Future<void> deleteZonePin(int zoneId, int index) async =>
      await _delete('/zones/$zoneId/pins/$index');

  // ---------------------------------------------------------------------------
  // ── Admin Dashboard ──
  // ---------------------------------------------------------------------------

  Future<Map<String, dynamic>> getAdminHealth() async =>
      await _get('/api/v1/admin/health') as Map<String, dynamic>;

  Future<List<dynamic>> getAdminZones() async =>
      await _get('/admin/zones') as List<dynamic>;

  Future<List<dynamic>> getAdminErrors({int limit = 50}) async =>
      await _get('/admin/errors?limit=$limit') as List<dynamic>;

  Future<List<dynamic>> getAdminDiscovery() async =>
      await _get('/admin/discovery') as List<dynamic>;

  // ---------------------------------------------------------------------------
  // ── M3U Import / Export ──
  // ---------------------------------------------------------------------------

  Future<Map<String, dynamic>> importM3U(String filePath) async {
    final uri = Uri.parse('$baseUrl/playlists/import/m3u');
    final request = http.MultipartRequest('POST', uri);
    request.files.add(await http.MultipartFile.fromPath('file', filePath));
    final streamed = await request.send();
    final body = await streamed.stream.bytesToString();
    if (streamed.statusCode != 200 && streamed.statusCode != 201) {
      throw Exception('M3U import failed (${streamed.statusCode}): $body');
    }
    return jsonDecode(body) as Map<String, dynamic>;
  }

  Future<String> exportM3U(int playlistId) async {
    final resp = await _client.get(
      Uri.parse('$baseUrl/playlists/$playlistId/export/m3u'),
    ).timeout(const Duration(seconds: 60));
    if (resp.statusCode != 200) {
      throw Exception('M3U export failed: ${resp.statusCode}');
    }
    return resp.body;
  }

  // ---------------------------------------------------------------------------
  // ── Alarm Enhanced (snooze) ──
  // ---------------------------------------------------------------------------

  Future<Map<String, dynamic>> snoozeAlarm(int alarmId, {int minutes = 5}) async =>
      await _post('/alarm/$alarmId/snooze', body: {'minutes': minutes})
          as Map<String, dynamic>;

  // ---------------------------------------------------------------------------
  // ── Tags ──
  // ---------------------------------------------------------------------------

  Future<List<dynamic>> getTags() async =>
      await _get('/api/v1/tags') as List<dynamic>;

  Future<Map<String, dynamic>> createTag(String name, {String? color}) async =>
      await _post('/api/v1/tags', body: {
        'name': name,
        if (color != null) 'color': color,
      }) as Map<String, dynamic>;

  Future<void> deleteTag(int tagId) async =>
      await _delete('/api/v1/tags/$tagId');

  Future<List<dynamic>> getItemTags(String itemType, int itemId) async =>
      await _get('/api/v1/tags/items/$itemType/$itemId') as List<dynamic>;

  Future<Map<String, dynamic>> addTagToItem(int tagId, String itemType, int itemId) async =>
      await _post('/api/v1/tags/$tagId/items', body: {
        'item_type': itemType,
        'item_id': itemId,
      }) as Map<String, dynamic>;

  Future<void> removeTagFromItem(int tagId, String itemType, int itemId) async =>
      await _delete('/api/v1/tags/$tagId/items/$itemType/$itemId');

  // ---------------------------------------------------------------------------
  // ── SMB Browser (network discovery) ──
  // ---------------------------------------------------------------------------

  Future<List<dynamic>> discoverSMBShares() async =>
      await _get('/network/smb/discover') as List<dynamic>;

  Future<Map<String, dynamic>> mountSMBShare(Map<String, dynamic> body) async =>
      await _post('/network/smb/mount', body: body) as Map<String, dynamic>;

  Future<Map<String, dynamic>> saveSMBCredentials(Map<String, dynamic> body) async =>
      await _post('/network/smb/credentials', body: body) as Map<String, dynamic>;

  // ---------------------------------------------------------------------------
  // ── Cloud Telemetry ──
  // ---------------------------------------------------------------------------

  Future<Map<String, dynamic>> getCloudTelemetryStatus() async =>
      await _getOptional('/api/v1/cloud/telemetry/status') as Map<String, dynamic>? ??
          {'enabled': false};

  Future<void> enableCloudTelemetry() async =>
      await _postOptional('/api/v1/cloud/telemetry/enable');

  Future<void> disableCloudTelemetry() async =>
      await _postOptional('/api/v1/cloud/telemetry/disable');

  // ---------------------------------------------------------------------------
  // ── Home Dashboard (continue listening, top mixes) ──
  // ---------------------------------------------------------------------------

  Future<List<dynamic>> getContinueListening({int limit = 20}) async =>
      await _getOptional('/api/v1/home/continue-listening?limit=$limit') as List<dynamic>? ?? [];

  // ---------------------------------------------------------------------------
  // ── Server Configuration (music dirs, config, restart) ──
  // ---------------------------------------------------------------------------

  Future<Map<String, dynamic>> getSystemConfig() async =>
      await _get('/system/config') as Map<String, dynamic>;

  Future<Map<String, dynamic>> updateSystemConfig(Map<String, dynamic> fields) async =>
      await _patch('/system/config', body: fields) as Map<String, dynamic>;

  Future<Map<String, dynamic>> getMusicDirs() async =>
      await _get('/system/music-dirs') as Map<String, dynamic>;

  Future<Map<String, dynamic>> addMusicDir(String path) async =>
      await _post('/system/music-dirs', body: {'path': path}) as Map<String, dynamic>;

  Future<Map<String, dynamic>> removeMusicDir(String path) async =>
      await _post('/system/music-dirs/remove', body: {'path': path}) as Map<String, dynamic>;

  Future<Map<String, dynamic>> browseDirs({String? path}) async {
    final q = path != null ? '?path=${Uri.encodeQueryComponent(path)}' : '';
    return await _get('/system/browse-dirs$q') as Map<String, dynamic>;
  }

  Future<void> restartServer() async =>
      await _post('/system/restart');

  Future<void> triggerScan({String? path, bool full = false}) async {
    final params = <String, String>{};
    if (path != null) params['path'] = path;
    if (full) params['full'] = 'true';
    final qs = params.entries.map((e) => '${e.key}=${Uri.encodeComponent(e.value)}').join('&');
    final url = qs.isNotEmpty ? '/system/scan?$qs' : '/system/scan';
    await _post(url);
  }

  // ---------------------------------------------------------------------------
  // ── Smart AutoPlay — Mood-based track suggestions ──
  // ---------------------------------------------------------------------------

  /// Call `POST /api/v1/smart-ai/mood` and return the server response.
  /// The server returns `{"tracks": [{id, title, artist_name, ...}]}`.
  Future<Map<String, dynamic>> getMoodTracks(String mood, {int limit = 20}) async =>
      await _post('/api/v1/smart-ai/mood', body: {
        'mood': mood,
        'limit': limit,
      }) as Map<String, dynamic>;
}

// ---------------------------------------------------------------------------
// EqProfile — perceptual room correction model (Master Profiler)
// Mirrors the Rust server EqProfile struct in zones/dsp.rs
// ---------------------------------------------------------------------------

enum ListeningMode { speakers, headphones }
enum RoomSize { small, medium, large }
enum SpeakerPlacement { nearWall, freeStanding }

class EqProfile {
  final bool enabled;
  final ListeningMode listening;
  final RoomSize roomSize;
  final SpeakerPlacement speakerPlacement;
  final double bassGainDb;
  final double midGainDb;
  final double trebleGainDb;

  const EqProfile({
    this.enabled = true,
    this.listening = ListeningMode.speakers,
    this.roomSize = RoomSize.medium,
    this.speakerPlacement = SpeakerPlacement.freeStanding,
    this.bassGainDb = 0.0,
    this.midGainDb = 0.0,
    this.trebleGainDb = 0.0,
  });

  factory EqProfile.fromJson(Map<String, dynamic> json) {
    return EqProfile(
      enabled: json['enabled'] as bool? ?? true,
      listening: json['listening'] == 'headphones'
          ? ListeningMode.headphones
          : ListeningMode.speakers,
      roomSize: switch (json['room_size'] as String?) {
        'small' => RoomSize.small,
        'large' => RoomSize.large,
        _ => RoomSize.medium,
      },
      speakerPlacement: json['speaker_placement'] == 'near_wall'
          ? SpeakerPlacement.nearWall
          : SpeakerPlacement.freeStanding,
      bassGainDb: (json['bass_gain_db'] as num?)?.toDouble() ?? 0.0,
      midGainDb: (json['mid_gain_db'] as num?)?.toDouble() ?? 0.0,
      trebleGainDb: (json['treble_gain_db'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {
    'enabled': enabled,
    'listening': listening == ListeningMode.headphones ? 'headphones' : 'speakers',
    'room_size': switch (roomSize) {
      RoomSize.small => 'small',
      RoomSize.large => 'large',
      RoomSize.medium => 'medium',
    },
    'speaker_placement': speakerPlacement == SpeakerPlacement.nearWall
        ? 'near_wall'
        : 'free_standing',
    'bass_gain_db': bassGainDb,
    'mid_gain_db': midGainDb,
    'treble_gain_db': trebleGainDb,
  };

  EqProfile copyWith({
    bool? enabled,
    ListeningMode? listening,
    RoomSize? roomSize,
    SpeakerPlacement? speakerPlacement,
    double? bassGainDb,
    double? midGainDb,
    double? trebleGainDb,
  }) => EqProfile(
    enabled: enabled ?? this.enabled,
    listening: listening ?? this.listening,
    roomSize: roomSize ?? this.roomSize,
    speakerPlacement: speakerPlacement ?? this.speakerPlacement,
    bassGainDb: bassGainDb ?? this.bassGainDb,
    midGainDb: midGainDb ?? this.midGainDb,
    trebleGainDb: trebleGainDb ?? this.trebleGainDb,
  );
}
