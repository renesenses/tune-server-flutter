import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;

import 'streaming_service.dart';

// ---------------------------------------------------------------------------
// T6.6 — SpotifyService
// OAuth 2.0 PKCE auth (public client, no client_secret).
// Miroir de SpotifyService.swift (iOS)
//
// API Spotify Web API — https://developer.spotify.com/documentation/web-api
// Stream URL : preview_url (30s, limitation Web API sans Connect).
// ---------------------------------------------------------------------------

class SpotifyService implements StreamingService {
  static const _authBase = 'https://accounts.spotify.com';
  static const _apiBase = 'https://api.spotify.com/v1';
  // Public client ID — à configurer via StreamingManager
  final String _clientId;

  final http.Client _http;

  String? _accessToken;
  String? _refreshToken;
  DateTime? _tokenExpiry;
  String? _accountName;

  // PKCE state
  String? _codeVerifier;

  SpotifyService({
    required String clientId,
    http.Client? client,
  })  : _clientId = clientId,
        _http = client ?? http.Client();

  // ---------------------------------------------------------------------------
  // StreamingService
  // ---------------------------------------------------------------------------

  @override
  String get serviceId => 'spotify';

  @override
  String get displayName => 'Spotify';

  @override
  bool get isAuthenticated =>
      _accessToken != null &&
      (_tokenExpiry == null || DateTime.now().isBefore(_tokenExpiry!));

  // ---------------------------------------------------------------------------
  // Auth email/password — non supporté par Spotify
  // ---------------------------------------------------------------------------

  @override
  Future<StreamingAuthResult> authenticateWithCredentials(
    String email,
    String password,
  ) async =>
      const StreamingAuthFailure(
          'Authentification par email non supportée pour Spotify');

  // ---------------------------------------------------------------------------
  // OAuth PKCE — step 1: generate auth URL (called externally)
  // ---------------------------------------------------------------------------

  /// Génère l'URL d'autorisation OAuth PKCE.
  /// L'appelant doit ouvrir cette URL dans un navigateur, puis appeler
  /// [exchangeCodeForToken] avec le code reçu via redirect.
  String generateAuthUrl(String redirectUri) {
    _codeVerifier = _generateCodeVerifier();
    final codeChallenge = _generateCodeChallenge(_codeVerifier!);

    final uri = Uri.parse('$_authBase/authorize').replace(
      queryParameters: {
        'client_id': _clientId,
        'response_type': 'code',
        'redirect_uri': redirectUri,
        'scope': 'user-read-private user-read-email '
            'playlist-read-private playlist-read-collaborative '
            'user-library-read',
        'code_challenge_method': 'S256',
        'code_challenge': codeChallenge,
      },
    );
    return uri.toString();
  }

  /// Échange le code d'autorisation contre un token.
  Future<StreamingAuthResult> exchangeCodeForToken(
    String code,
    String redirectUri,
  ) async {
    if (_codeVerifier == null) {
      return const StreamingAuthFailure(
          'PKCE code_verifier manquant. Relancez le flow.');
    }

    try {
      final response = await _http.post(
        Uri.parse('$_authBase/api/token'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: 'grant_type=authorization_code'
            '&code=${Uri.encodeComponent(code)}'
            '&redirect_uri=${Uri.encodeComponent(redirectUri)}'
            '&client_id=$_clientId'
            '&code_verifier=$_codeVerifier',
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode != 200) {
        return StreamingAuthFailure(
            'Spotify token exchange: HTTP ${response.statusCode}');
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      _storeTokens(data);

      // Récupère le profil utilisateur
      await _fetchProfile();

      return StreamingAuthSuccess(_accountName ?? 'Spotify');
    } catch (e) {
      return StreamingAuthFailure(e.toString());
    }
  }

  // ---------------------------------------------------------------------------
  // Device Code flow — non supporté par Spotify
  // ---------------------------------------------------------------------------

  @override
  Future<StreamingAuthResult> startDeviceCodeFlow() async =>
      const StreamingAuthFailure(
          'Device Code non supporté pour Spotify. Utilisez OAuth PKCE.');

  @override
  Future<StreamingAuthResult> pollDeviceCodeFlow(
    StreamingDeviceCodeResult deviceCode,
  ) async =>
      const StreamingAuthFailure(
          'Device Code non supporté pour Spotify.');

  // ---------------------------------------------------------------------------
  // Auth — persistance
  // ---------------------------------------------------------------------------

  @override
  Future<void> saveAuth(String tokenJson) async {
    final data = jsonDecode(tokenJson) as Map<String, dynamic>;
    _accessToken = data['accessToken'] as String?;
    _refreshToken = data['refreshToken'] as String?;
    _accountName = data['accountName'] as String?;
    final expiryMs = data['expiryMs'] as int?;
    if (expiryMs != null) {
      _tokenExpiry = DateTime.fromMillisecondsSinceEpoch(expiryMs);
    }
  }

  @override
  Future<bool> restoreAuth(String tokenJson) async {
    try {
      await saveAuth(tokenJson);
      if (!isAuthenticated && _refreshToken != null) {
        await _refreshAccessToken();
      }
      return isAuthenticated;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<void> logout() async {
    _accessToken = null;
    _refreshToken = null;
    _tokenExpiry = null;
    _accountName = null;
    _codeVerifier = null;
  }

  /// Sérialise les tokens pour la persistance DB.
  String get tokenJson => jsonEncode({
        'accessToken': _accessToken,
        'refreshToken': _refreshToken,
        'accountName': _accountName,
        'expiryMs': _tokenExpiry?.millisecondsSinceEpoch,
      });

  // ---------------------------------------------------------------------------
  // Recherche
  // ---------------------------------------------------------------------------

  @override
  Future<List<StreamingSearchResult>> search(
    String query, {
    int limit = 20,
  }) async {
    if (!isAuthenticated) return [];
    try {
      await _ensureToken();
      final data = await _get('search', {
        'q': query,
        'type': 'track,album,artist',
        'limit': '$limit',
        'market': 'FR',
      });
      final results = <StreamingSearchResult>[];

      // Albums
      final albums = (data['albums']?['items'] as List?) ?? [];
      results.addAll(albums
          .take(10)
          .map((a) => _mapAlbum(a as Map<String, dynamic>))
          .whereType<StreamingSearchResult>());

      // Artistes
      final artists = (data['artists']?['items'] as List?) ?? [];
      for (final ar in artists.take(5)) {
        final id = ar['id'] as String?;
        final name = ar['name'] as String?;
        if (id == null || name == null) continue;
        final images = (ar['images'] as List?) ?? [];
        final img = images.isNotEmpty ? images.first['url'] as String? : null;
        results.add(StreamingSearchResult(
          id: id,
          title: name,
          coverUrl: img,
          serviceId: serviceId,
          type: 'artist',
        ));
      }

      // Tracks
      final tracks = (data['tracks']?['items'] as List?) ?? [];
      results.addAll(tracks
          .take(limit)
          .map((t) => _mapTrack(t as Map<String, dynamic>))
          .whereType<StreamingSearchResult>());

      return results;
    } catch (_) {
      return [];
    }
  }

  // ---------------------------------------------------------------------------
  // Pistes
  // ---------------------------------------------------------------------------

  @override
  Future<StreamingSearchResult?> getTrack(String trackId) async {
    if (!isAuthenticated) return null;
    try {
      await _ensureToken();
      final data = await _get('tracks/$trackId', {'market': 'FR'});
      return _mapTrack(data);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<String?> getStreamUrl(String trackId) async {
    if (!isAuthenticated) return null;
    try {
      await _ensureToken();
      // Spotify Web API ne fournit que le preview_url (30s).
      // Le streaming complet nécessite Spotify Connect / SDK natif.
      final data = await _get('tracks/$trackId', {'market': 'FR'});
      return data['preview_url'] as String?;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<StreamingSearchResult>> getAlbumTracks(String albumId) async {
    if (!isAuthenticated) return [];
    try {
      await _ensureToken();
      // Récupère d'abord l'album pour les métadonnées (cover, artiste)
      final albumData = await _get('albums/$albumId', {'market': 'FR'});
      final albumTitle = albumData['name'] as String?;
      final albumArtist = (albumData['artists'] as List?)
              ?.firstOrNull?['name'] as String?;
      final images = (albumData['images'] as List?) ?? [];
      final cover = images.isNotEmpty ? images.first['url'] as String? : null;

      final tracks = (albumData['tracks']?['items'] as List?) ?? [];
      return tracks.map((t) {
        final raw = t as Map<String, dynamic>;
        final id = raw['id'] as String?;
        final title = raw['name'] as String?;
        if (id == null || title == null) return null;
        final artist = (raw['artists'] as List?)
                ?.firstOrNull?['name'] as String? ??
            albumArtist;
        final duration = raw['duration_ms'] as int?;
        return StreamingSearchResult(
          id: id,
          title: title,
          artist: artist,
          album: albumTitle,
          durationMs: duration,
          coverUrl: cover,
          previewUrl: raw['preview_url'] as String?,
          serviceId: serviceId,
          raw: raw,
        );
      }).whereType<StreamingSearchResult>().toList();
    } catch (_) {
      return [];
    }
  }

  @override
  Future<List<StreamingSearchResult>> getPlaylistTracks(
      String playlistId) async {
    if (!isAuthenticated) return [];
    try {
      await _ensureToken();
      final data = await _get('playlists/$playlistId/tracks', {
        'market': 'FR',
        'limit': '100',
      });
      final items = (data['items'] as List?) ?? [];
      return items.map((item) {
        final track = (item as Map<String, dynamic>)['track'];
        if (track == null) return null;
        return _mapTrack(track as Map<String, dynamic>);
      }).whereType<StreamingSearchResult>().toList();
    } catch (_) {
      return [];
    }
  }

  // ---------------------------------------------------------------------------
  // Catalogue (artistes, albums, playlists utilisateur)
  // ---------------------------------------------------------------------------

  /// Retourne l'album complet (métadonnées).
  Future<StreamingSearchResult?> getAlbum(String albumId) async {
    if (!isAuthenticated) return null;
    try {
      await _ensureToken();
      final data = await _get('albums/$albumId', {'market': 'FR'});
      return _mapAlbum(data);
    } catch (_) {
      return null;
    }
  }

  /// Retourne l'artiste.
  Future<StreamingSearchResult?> getArtist(String artistId) async {
    if (!isAuthenticated) return null;
    try {
      await _ensureToken();
      final data = await _get('artists/$artistId', {});
      final id = data['id'] as String?;
      final name = data['name'] as String?;
      if (id == null || name == null) return null;
      final images = (data['images'] as List?) ?? [];
      final img = images.isNotEmpty ? images.first['url'] as String? : null;
      return StreamingSearchResult(
        id: id,
        title: name,
        coverUrl: img,
        serviceId: serviceId,
        type: 'artist',
        raw: data,
      );
    } catch (_) {
      return null;
    }
  }

  /// Retourne les albums d'un artiste.
  Future<List<StreamingSearchResult>> getArtistAlbums(
    String artistId, {
    int limit = 20,
  }) async {
    if (!isAuthenticated) return [];
    try {
      await _ensureToken();
      final data = await _get('artists/$artistId/albums', {
        'include_groups': 'album,single',
        'market': 'FR',
        'limit': '$limit',
      });
      final items = (data['items'] as List?) ?? [];
      return items
          .map((a) => _mapAlbum(a as Map<String, dynamic>))
          .whereType<StreamingSearchResult>()
          .toList();
    } catch (_) {
      return [];
    }
  }

  /// Retourne les playlists de l'utilisateur.
  Future<List<StreamingSearchResult>> getUserPlaylists({
    int limit = 50,
  }) async {
    if (!isAuthenticated) return [];
    try {
      await _ensureToken();
      final data = await _get('me/playlists', {'limit': '$limit'});
      final items = (data['items'] as List?) ?? [];
      return items.map((p) {
        final raw = p as Map<String, dynamic>;
        final id = raw['id'] as String?;
        final name = raw['name'] as String? ?? '';
        final count = (raw['tracks'] as Map?)?['total'] as int? ?? 0;
        final images = (raw['images'] as List?) ?? [];
        final cover =
            images.isNotEmpty ? images.first['url'] as String? : null;
        return StreamingSearchResult(
          id: id ?? '',
          title: name,
          artist: '$count pistes',
          coverUrl: cover,
          serviceId: serviceId,
          type: 'playlist',
        );
      }).toList();
    } catch (_) {
      return [];
    }
  }

  // ---------------------------------------------------------------------------
  // État
  // ---------------------------------------------------------------------------

  @override
  StreamingServiceStatus get status => StreamingServiceStatus(
        serviceId: serviceId,
        enabled: true,
        authenticated: isAuthenticated,
        accountName: _accountName,
        quality: 'normal', // preview_url = 30s MP3
      );

  // ---------------------------------------------------------------------------
  // Helpers HTTP
  // ---------------------------------------------------------------------------

  Future<Map<String, dynamic>> _get(
    String path,
    Map<String, String> params,
  ) async {
    final uri = Uri.parse('$_apiBase/$path').replace(
      queryParameters: params.isNotEmpty ? params : null,
    );
    final response = await _http.get(uri, headers: {
      'Authorization': 'Bearer $_accessToken',
      'Accept': 'application/json',
    }).timeout(const Duration(seconds: 15));

    if (response.statusCode == 401) {
      await _refreshAccessToken();
      return _get(path, params); // retry une fois
    }
    if (response.statusCode != 200) {
      throw Exception('Spotify API ${response.statusCode}: $path');
    }
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  // ---------------------------------------------------------------------------
  // Token management
  // ---------------------------------------------------------------------------

  void _storeTokens(Map<String, dynamic> data) {
    _accessToken = data['access_token'] as String?;
    _refreshToken = data['refresh_token'] as String? ?? _refreshToken;
    final expiresIn = data['expires_in'] as int? ?? 3600;
    _tokenExpiry = DateTime.now().add(Duration(seconds: expiresIn));
  }

  Future<void> _refreshAccessToken() async {
    if (_refreshToken == null) return;
    final response = await _http.post(
      Uri.parse('$_authBase/api/token'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: 'grant_type=refresh_token'
          '&refresh_token=$_refreshToken'
          '&client_id=$_clientId',
    );
    if (response.statusCode == 200) {
      _storeTokens(jsonDecode(response.body) as Map<String, dynamic>);
    }
  }

  Future<void> _ensureToken() async {
    if (!isAuthenticated) await _refreshAccessToken();
  }

  Future<void> _fetchProfile() async {
    try {
      final data = await _get('me', {});
      _accountName = data['email'] as String? ??
          data['display_name'] as String?;
    } catch (_) {}
  }

  // ---------------------------------------------------------------------------
  // PKCE helpers
  // ---------------------------------------------------------------------------

  String _generateCodeVerifier() {
    const chars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~';
    final random = Random.secure();
    return List.generate(128, (_) => chars[random.nextInt(chars.length)])
        .join();
  }

  String _generateCodeChallenge(String verifier) {
    final bytes = utf8.encode(verifier);
    final digest = sha256.convert(bytes);
    return base64UrlEncode(digest.bytes).replaceAll('=', '');
  }

  // ---------------------------------------------------------------------------
  // Mapping
  // ---------------------------------------------------------------------------

  StreamingSearchResult? _mapTrack(Map<String, dynamic> t) {
    final id = t['id'] as String?;
    final title = t['name'] as String?;
    if (id == null || title == null) return null;

    final artist =
        (t['artists'] as List?)?.firstOrNull?['name'] as String?;
    final album = t['album']?['name'] as String?;
    final duration = t['duration_ms'] as int?;
    final images = (t['album']?['images'] as List?) ?? [];
    final cover =
        images.isNotEmpty ? images.first['url'] as String? : null;

    return StreamingSearchResult(
      id: id,
      title: title,
      artist: artist,
      album: album,
      durationMs: duration,
      coverUrl: cover,
      previewUrl: t['preview_url'] as String?,
      serviceId: serviceId,
      raw: t,
    );
  }

  StreamingSearchResult? _mapAlbum(Map<String, dynamic> a) {
    final id = a['id'] as String?;
    final title = a['name'] as String?;
    if (id == null || title == null) return null;
    final artist =
        (a['artists'] as List?)?.firstOrNull?['name'] as String?;
    final images = (a['images'] as List?) ?? [];
    final cover =
        images.isNotEmpty ? images.first['url'] as String? : null;
    return StreamingSearchResult(
      id: id,
      title: title,
      artist: artist,
      coverUrl: cover,
      serviceId: serviceId,
      type: 'album',
    );
  }
}
