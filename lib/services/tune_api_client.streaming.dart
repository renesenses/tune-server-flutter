part of 'tune_api_client.dart';

// Endpoints autour des services de streaming + radios.

extension TuneApiClientStreaming on TuneApiClient {

  // Radios

  Future<List<dynamic>> getRadios() =>
      _get('/radios').then((d) => d as List);

  Future<dynamic> playRadio(int radioId, int zoneId) =>
      _post('/zones/$zoneId/play', body: {'radio_id': radioId});

  // Streaming services

  Future<Map<String, dynamic>> getStreamingServices() =>
      _get('/streaming/services').then((d) => d as Map<String, dynamic>);

  Future<List<dynamic>> getStreamingPlaylists(String service) =>
      _get('/streaming/$service/playlists').then((d) => d as List);

  Future<List<dynamic>> getStreamingPlaylistTracks(String service, String playlistId) =>
      _get('/streaming/$service/playlists/$playlistId/tracks').then((d) => d as List);

  Future<dynamic> searchStreaming(String service, String query, {int limit = 20}) =>
      _get('/streaming/$service/search?q=${Uri.encodeComponent(query)}&limit=$limit');
}
