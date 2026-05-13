import 'dart:convert';

import 'package:http/http.dart' as http;

import 'streaming_service.dart';

// ---------------------------------------------------------------------------
// T6.7 — DeezerService
// ARL cookie auth + public API + gateway API.
// Miroir de DeezerService.swift (iOS)
//
// Public API : https://api.deezer.com (search, catalog — sans auth)
// Gateway API : POST https://www.deezer.com/ajax/gw-light.php (user data, ARL)
// Stream URL : preview URL depuis les données track.
// ---------------------------------------------------------------------------

class DeezerService implements StreamingService {
  static const _publicApiBase = 'https://api.deezer.com';
  static const _gatewayBase = 'https://www.deezer.com/ajax/gw-light.php';

  final http.Client _http;

  String? _arl; // ARL cookie pour l'auth
  String? _apiToken; // token gateway (checkForm)
  String? _accountName;
  String? _userId;
  bool _authenticated = false;

  DeezerService({http.Client? client}) : _http = client ?? http.Client();

  // ---------------------------------------------------------------------------
  // StreamingService
  // ---------------------------------------------------------------------------

  @override
  String get serviceId => 'deezer';

  @override
  String get displayName => 'Deezer';

  @override
  bool get isAuthenticated => _authenticated;

  // ---------------------------------------------------------------------------
  // Auth email/password — on utilise l'ARL à la place
  // ---------------------------------------------------------------------------

  @override
  Future<StreamingAuthResult> authenticateWithCredentials(
    String email,
    String password,
  ) async =>
      const StreamingAuthFailure(
          'Deezer utilise l\'authentification par cookie ARL. '
          'Utilisez authenticateWithArl().');

  // ---------------------------------------------------------------------------
  // Auth ARL cookie
  // ---------------------------------------------------------------------------

  /// Authentifie avec un cookie ARL Deezer.
  /// L'ARL est un cookie de session récupéré depuis le navigateur.
  Future<StreamingAuthResult> authenticateWithArl(String arl) async {
    _arl = arl.trim();
    try {
      // Valide l'ARL via le gateway
      final userData = await _gatewayCall('deezer.getUserData', {});
      final user = userData['USER'] as Map<String, dynamic>?;
      if (user == null || user['USER_ID'] == 0) {
        _arl = null;
        _authenticated = false;
        return const StreamingAuthFailure(
            'ARL invalide ou expiré. Récupérez un nouveau cookie ARL.');
      }

      _userId = user['USER_ID']?.toString();
      _accountName = user['BLOG_NAME'] as String? ??
          user['EMAIL'] as String? ??
          'Deezer';
      _apiToken = userData['checkForm'] as String?;
      _authenticated = true;

      return StreamingAuthSuccess(_accountName!);
    } catch (e) {
      _arl = null;
      _authenticated = false;
      return StreamingAuthFailure(e.toString());
    }
  }

  // ---------------------------------------------------------------------------
  // Device Code flow — non supporté par Deezer
  // ---------------------------------------------------------------------------

  @override
  Future<StreamingAuthResult> startDeviceCodeFlow() async =>
      const StreamingAuthFailure(
          'Device Code non supporté pour Deezer. Utilisez l\'ARL cookie.');

  @override
  Future<StreamingAuthResult> pollDeviceCodeFlow(
    StreamingDeviceCodeResult deviceCode,
  ) async =>
      const StreamingAuthFailure(
          'Device Code non supporté pour Deezer.');

  // ---------------------------------------------------------------------------
  // Auth — persistance
  // ---------------------------------------------------------------------------

  @override
  Future<void> saveAuth(String tokenJson) async {
    final data = jsonDecode(tokenJson) as Map<String, dynamic>;
    _arl = data['arl'] as String?;
    _apiToken = data['apiToken'] as String?;
    _accountName = data['accountName'] as String?;
    _userId = data['userId'] as String?;
    _authenticated = _arl != null && _arl!.isNotEmpty;
  }

  @override
  Future<bool> restoreAuth(String tokenJson) async {
    try {
      await saveAuth(tokenJson);
      if (_authenticated) {
        // Revalide l'ARL
        try {
          final userData = await _gatewayCall('deezer.getUserData', {});
          final user = userData['USER'] as Map<String, dynamic>?;
          if (user == null || user['USER_ID'] == 0) {
            _authenticated = false;
            return false;
          }
          _apiToken = userData['checkForm'] as String?;
        } catch (_) {
          // Si le réseau n'est pas dispo, on garde l'état tel quel
        }
      }
      return _authenticated;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<void> logout() async {
    _arl = null;
    _apiToken = null;
    _accountName = null;
    _userId = null;
    _authenticated = false;
  }

  /// Sérialise les tokens pour la persistance DB.
  String get tokenJson => jsonEncode({
        'arl': _arl,
        'apiToken': _apiToken,
        'accountName': _accountName,
        'userId': _userId,
      });

  // ---------------------------------------------------------------------------
  // Recherche (API publique — pas besoin d'auth)
  // ---------------------------------------------------------------------------

  @override
  Future<List<StreamingSearchResult>> search(
    String query, {
    int limit = 20,
  }) async {
    try {
      final results = <StreamingSearchResult>[];

      // Recherche tracks
      final trackData = await _publicGet('search/track', {
        'q': query,
        'limit': '$limit',
        'lang': 'fr',
      });
      final tracks = (trackData['data'] as List?) ?? [];
      results.addAll(tracks
          .map((t) => _mapTrack(t as Map<String, dynamic>))
          .whereType<StreamingSearchResult>());

      // Recherche albums
      final albumData = await _publicGet('search/album', {
        'q': query,
        'limit': '10',
        'lang': 'fr',
      });
      final albums = (albumData['data'] as List?) ?? [];
      results.addAll(albums
          .map((a) => _mapAlbum(a as Map<String, dynamic>))
          .whereType<StreamingSearchResult>());

      // Recherche artistes
      final artistData = await _publicGet('search/artist', {
        'q': query,
        'limit': '5',
        'lang': 'fr',
      });
      final artists = (artistData['data'] as List?) ?? [];
      for (final ar in artists) {
        final id = ar['id']?.toString();
        final name = ar['name'] as String?;
        if (id == null || name == null) continue;
        final img = ar['picture_medium'] as String? ??
            ar['picture_small'] as String?;
        results.add(StreamingSearchResult(
          id: id,
          title: name,
          coverUrl: img,
          serviceId: serviceId,
          type: 'artist',
        ));
      }

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
    try {
      final data = await _publicGet('track/$trackId', {'lang': 'fr'});
      return _mapTrack(data);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<String?> getStreamUrl(String trackId) async {
    try {
      // Preview URL depuis l'API publique
      final data = await _publicGet('track/$trackId', {});
      return data['preview'] as String?;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<StreamingSearchResult>> getAlbumTracks(String albumId) async {
    try {
      final data =
          await _publicGet('album/$albumId/tracks', {'lang': 'fr', 'limit': '200'});
      final items = (data['data'] as List?) ?? [];

      // Récupère les métadonnées album pour la cover
      String? albumTitle;
      String? albumCover;
      try {
        final albumData = await _publicGet('album/$albumId', {'lang': 'fr'});
        albumTitle = albumData['title'] as String?;
        albumCover = albumData['cover_medium'] as String? ??
            albumData['cover_small'] as String?;
      } catch (_) {}

      return items.map((t) {
        final raw = t as Map<String, dynamic>;
        final id = raw['id']?.toString();
        final title = raw['title'] as String?;
        if (id == null || title == null) return null;
        final artist = raw['artist']?['name'] as String?;
        final duration = raw['duration'] as int?;
        return StreamingSearchResult(
          id: id,
          title: title,
          artist: artist,
          album: albumTitle,
          durationMs: duration != null ? duration * 1000 : null,
          coverUrl: albumCover,
          previewUrl: raw['preview'] as String?,
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
    try {
      final data =
          await _publicGet('playlist/$playlistId/tracks', {'lang': 'fr', 'limit': '200'});
      final items = (data['data'] as List?) ?? [];
      return items
          .map((t) => _mapTrack(t as Map<String, dynamic>))
          .whereType<StreamingSearchResult>()
          .toList();
    } catch (_) {
      return [];
    }
  }

  // ---------------------------------------------------------------------------
  // Catalogue (album, artiste, playlists utilisateur)
  // ---------------------------------------------------------------------------

  /// Retourne l'album complet.
  Future<StreamingSearchResult?> getAlbum(String albumId) async {
    try {
      final data = await _publicGet('album/$albumId', {'lang': 'fr'});
      return _mapAlbum(data);
    } catch (_) {
      return null;
    }
  }

  /// Retourne l'artiste.
  Future<StreamingSearchResult?> getArtist(String artistId) async {
    try {
      final data = await _publicGet('artist/$artistId', {'lang': 'fr'});
      final id = data['id']?.toString();
      final name = data['name'] as String?;
      if (id == null || name == null) return null;
      final img = data['picture_medium'] as String? ??
          data['picture_small'] as String?;
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
    try {
      final data = await _publicGet('artist/$artistId/albums', {
        'lang': 'fr',
        'limit': '$limit',
      });
      final items = (data['data'] as List?) ?? [];
      return items
          .map((a) => _mapAlbum(a as Map<String, dynamic>))
          .whereType<StreamingSearchResult>()
          .toList();
    } catch (_) {
      return [];
    }
  }

  /// Retourne les playlists de l'utilisateur (nécessite ARL).
  Future<List<StreamingSearchResult>> getUserPlaylists() async {
    if (!_authenticated || _userId == null) return [];
    try {
      final data =
          await _publicGet('user/$_userId/playlists', {'lang': 'fr', 'limit': '100'});
      final items = (data['data'] as List?) ?? [];
      return items.map((p) {
        final raw = p as Map<String, dynamic>;
        final id = raw['id']?.toString();
        final name = raw['title'] as String? ?? '';
        final count = raw['nb_tracks'] as int? ?? 0;
        final cover = raw['picture_medium'] as String? ??
            raw['picture_small'] as String?;
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
        quality: 'high', // preview = 128kbps MP3
      );

  // ---------------------------------------------------------------------------
  // Helpers HTTP — API publique
  // ---------------------------------------------------------------------------

  Future<Map<String, dynamic>> _publicGet(
    String path,
    Map<String, String> params,
  ) async {
    final uri = Uri.parse('$_publicApiBase/$path').replace(
      queryParameters: params.isNotEmpty ? params : null,
    );
    final response =
        await _http.get(uri).timeout(const Duration(seconds: 15));
    if (response.statusCode != 200) {
      throw Exception('Deezer API ${response.statusCode}: $path');
    }
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    // L'API Deezer retourne les erreurs dans le body
    if (data.containsKey('error')) {
      final error = data['error'];
      final msg = error is Map ? error['message'] ?? 'Unknown' : '$error';
      throw Exception('Deezer API error: $msg');
    }
    return data;
  }

  // ---------------------------------------------------------------------------
  // Helpers HTTP — Gateway API (nécessite ARL)
  // ---------------------------------------------------------------------------

  Future<Map<String, dynamic>> _gatewayCall(
    String method,
    Map<String, dynamic> body,
  ) async {
    final uri = Uri.parse(_gatewayBase).replace(queryParameters: {
      'method': method,
      'input': '3',
      'api_version': '1.0',
      if (_apiToken != null) 'api_token': _apiToken!,
    });

    final response = await _http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Cookie': 'arl=$_arl',
      },
      body: jsonEncode(body),
    ).timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception('Deezer gateway ${response.statusCode}: $method');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final error = data['error'] as Map?;
    if (error != null && error.isNotEmpty) {
      throw Exception(
          'Deezer gateway error: ${error.values.first}');
    }
    return data['results'] as Map<String, dynamic>? ?? {};
  }

  // ---------------------------------------------------------------------------
  // Mapping
  // ---------------------------------------------------------------------------

  StreamingSearchResult? _mapTrack(Map<String, dynamic> t) {
    final id = t['id']?.toString();
    final title = t['title'] as String? ?? t['title_short'] as String?;
    if (id == null || title == null) return null;

    final artist = t['artist']?['name'] as String?;
    final album = t['album']?['title'] as String?;
    final duration = t['duration'] as int?;
    final cover = t['album']?['cover_medium'] as String? ??
        t['album']?['cover_small'] as String?;

    return StreamingSearchResult(
      id: id,
      title: title,
      artist: artist,
      album: album,
      durationMs: duration != null ? duration * 1000 : null,
      coverUrl: cover,
      previewUrl: t['preview'] as String?,
      serviceId: serviceId,
      raw: t,
    );
  }

  StreamingSearchResult? _mapAlbum(Map<String, dynamic> a) {
    final id = a['id']?.toString();
    final title = a['title'] as String?;
    if (id == null || title == null) return null;
    final artist = a['artist']?['name'] as String?;
    final cover = a['cover_medium'] as String? ??
        a['cover_small'] as String?;
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
