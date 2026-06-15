part of 'tune_api_client.dart';

// Endpoints autour des services de streaming + radios.

extension TuneApiClientStreaming on TuneApiClient {

  // Radios

  Future<List<dynamic>> getRadios() =>
      _get('/radios').then((d) => d as List);

  Future<dynamic> playRadio(int radioId, int zoneId) =>
      _post('/zones/$zoneId/play', body: {'radio_id': radioId});

  Future<Map<String, dynamic>> createRadio({
    required String name,
    required String url,
    String? logoUrl,
    String? genre,
    String? country,
  }) => _post('/radios', body: {
        'name': name,
        'url': url,
        if (logoUrl != null) 'logo_url': logoUrl,
        if (genre != null) 'genre': genre,
        if (country != null) 'country': country,
      }).then((d) => d as Map<String, dynamic>);

  Future<Map<String, dynamic>> updateRadio(int id, {
    String? name,
    String? url,
    String? logoUrl,
    String? genre,
    String? country,
    bool? favorite,
  }) => _put('/radios/$id', body: {
        if (name != null) 'name': name,
        if (url != null) 'url': url,
        if (logoUrl != null) 'logo_url': logoUrl,
        if (genre != null) 'genre': genre,
        if (country != null) 'country': country,
        if (favorite != null) 'favorite': favorite,
      }).then((d) => d as Map<String, dynamic>);

  Future<void> deleteRadio(int id) => _delete('/radios/$id');

  Future<Map<String, dynamic>> toggleRadioFavorite(int id, {bool? favorite}) =>
      _post('/radios/$id/favorite', body: {
        if (favorite != null) 'favorite': favorite,
      }).then((d) => d as Map<String, dynamic>);

  Future<Map<String, dynamic>> importRadioStations(List<Map<String, dynamic>> stations) =>
      _post('/radios/import', body: {'stations': stations})
          .then((d) => d as Map<String, dynamic>);

  // Streaming services

  Future<Map<String, dynamic>> getStreamingServices() =>
      _get('/streaming/services').then((d) => d as Map<String, dynamic>);

  Future<List<dynamic>> getStreamingPlaylists(String service) =>
      _get('/streaming/$service/playlists').then((d) => d as List);

  Future<List<dynamic>> getStreamingPlaylistTracks(String service, String playlistId) =>
      _get('/streaming/$service/playlists/$playlistId/tracks').then((d) => d as List);

  Future<dynamic> searchStreaming(String service, String query, {int limit = 20}) =>
      _get('/streaming/$service/search?q=${Uri.encodeComponent(query)}&limit=$limit');

  // Spotify auth (OAuth PKCE)

  /// Demande au serveur de générer l'URL d'autorisation Spotify PKCE.
  Future<Map<String, dynamic>> getSpotifyAuthUrl(String redirectUri) =>
      _post('/streaming/spotify/auth-url', body: {'redirect_uri': redirectUri})
          .then((d) => d as Map<String, dynamic>);

  /// Échange le code d'autorisation Spotify contre un token.
  Future<Map<String, dynamic>> exchangeSpotifyCode(String code, String redirectUri) =>
      _post('/streaming/spotify/auth-callback', body: {
        'code': code,
        'redirect_uri': redirectUri,
      }).then((d) => d as Map<String, dynamic>);

  /// Déconnecte Spotify.
  Future<void> logoutSpotify() =>
      _post('/streaming/spotify/logout').then((_) {});

  // Deezer auth (ARL cookie)

  /// Authentifie Deezer avec un cookie ARL.
  Future<Map<String, dynamic>> authenticateDeezerArl(String arl) =>
      _post('/streaming/deezer/auth', body: {'arl': arl})
          .then((d) => d as Map<String, dynamic>);

  /// Déconnecte Deezer.
  Future<void> logoutDeezer() =>
      _post('/streaming/deezer/logout').then((_) {});

  // Streaming catalog (generic, works for all services)

  Future<List<dynamic>> getStreamingAlbumTracks(String service, String albumId) =>
      _get('/streaming/$service/albums/$albumId/tracks').then((d) => d as List);

  Future<dynamic> getStreamingTrack(String service, String trackId) =>
      _get('/streaming/$service/tracks/$trackId');

  Future<dynamic> getStreamingAlbum(String service, String albumId) =>
      _get('/streaming/$service/albums/$albumId');

  Future<dynamic> getStreamingArtist(String service, String artistId) =>
      _get('/streaming/$service/artists/$artistId');

  Future<List<dynamic>> getStreamingArtistAlbums(String service, String artistId) =>
      _get('/streaming/$service/artists/$artistId/albums').then((d) => d as List);
}
