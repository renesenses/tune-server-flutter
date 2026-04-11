import 'dart:convert';
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
    final resp = await http.get(Uri.parse('$baseUrl$path'));
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
    );
    if (resp.statusCode != 200 && resp.statusCode != 201) {
      throw Exception('POST $path failed: ${resp.statusCode}');
    }
    return resp.body.isNotEmpty ? jsonDecode(resp.body) : null;
  }

  Future<void> _delete(String path) async {
    final resp = await http.delete(Uri.parse('$baseUrl$path'));
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

  Future<List<dynamic>> getArtistTracks(int artistId) =>
      _get('/library/artists/$artistId/tracks').then((d) => d as List);

  Future<dynamic> searchLibrary(String query, {int limit = 30}) =>
      _get('/library/search?q=${Uri.encodeComponent(query)}&limit=$limit');

  Future<List<dynamic>> getRecentAlbums({int limit = 30}) =>
      _get('/library/albums?limit=$limit&sort=recent').then((d) => d as List);

  Future<dynamic> getQueue(int zoneId) => _get('/zones/$zoneId/queue');

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

  Future<dynamic> searchStreaming(String service, String query, {int limit = 20}) =>
      _get('/streaming/$service/search?q=${Uri.encodeComponent(query)}&limit=$limit');

  // ---------------------------------------------------------------------------
  // Playlists
  // ---------------------------------------------------------------------------

  Future<List<dynamic>> getPlaylists() =>
      _get('/playlists').then((d) => d as List);

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
}
