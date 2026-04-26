import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;

import 'streaming_service.dart';

// ---------------------------------------------------------------------------
// T6.2 — QobuzService
// Auth email/password avec MD5 (= CryptoKit.Insecure.MD5 iOS).
// Miroir de QobuzService.swift (iOS)
//
// API Qobuz v0.2 — endpoints publics documentés.
// appId / appSecret : à configurer via StreamingManager.
// ---------------------------------------------------------------------------

class QobuzService implements StreamingService {
  static const _baseUrl = 'https://www.qobuz.com/api.json/0.2';

  // Ces valeurs sont à renseigner via les settings (non commitées en dur)
  final String _appId;
  final String _appSecret;
  final http.Client _http;

  String? _userAuthToken;
  String? _userId;
  String? _accountName;

  QobuzService({
    required String appId,
    required String appSecret,
    http.Client? client,
  })  : _appId = appId,
        _appSecret = appSecret,
        _http = client ?? http.Client();

  // ---------------------------------------------------------------------------
  // StreamingService
  // ---------------------------------------------------------------------------

  @override
  String get serviceId => 'qobuz';

  @override
  String get displayName => 'Qobuz';

  @override
  bool get isAuthenticated => _userAuthToken != null;

  // ---------------------------------------------------------------------------
  // Device Code flow — non supporté par Qobuz
  // ---------------------------------------------------------------------------

  @override
  Future<StreamingAuthResult> startDeviceCodeFlow() async =>
      const StreamingAuthFailure('Device Code non supporté pour Qobuz');

  @override
  Future<StreamingAuthResult> pollDeviceCodeFlow(
    StreamingDeviceCodeResult deviceCode,
  ) async =>
      const StreamingAuthFailure('Device Code non supporté pour Qobuz');

  // ---------------------------------------------------------------------------
  // Auth email/password
  // ---------------------------------------------------------------------------

  @override
  Future<StreamingAuthResult> authenticateWithCredentials(
    String email,
    String password,
  ) async {
    try {
      final uri = Uri.https('www.qobuz.com', '/api.json/0.2/user/login', {
        'email': email,
        'password': password,
        'app_id': _appId,
      });
      final response = await _http.get(uri, headers: {
        'User-Agent': 'TuneServer/1.0',
      }).timeout(const Duration(seconds: 15));

      if (response.statusCode != 200) {
        return StreamingAuthFailure(
            'Qobuz: ${response.body.length > 150 ? response.body.substring(0, 150) : response.body}');
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      if (data['user_auth_token'] == null) {
        return StreamingAuthFailure(
            data['message']?.toString() ?? 'Auth failed');
      }

      _userAuthToken = data['user_auth_token'] as String;
      _userId = data['user']?['id']?.toString();
      _accountName = data['user']?['email'] as String?;

      return StreamingAuthSuccess(_accountName ?? email);
    } catch (e) {
      return StreamingAuthFailure(e.toString());
    }
  }

  // ---------------------------------------------------------------------------
  // Auth — persistance
  // ---------------------------------------------------------------------------

  @override
  Future<void> saveAuth(String tokenJson) async {
    // Appelé par StreamingManager qui persiste en DB
    final data = jsonDecode(tokenJson) as Map<String, dynamic>;
    _userAuthToken = data['token'] as String?;
    _userId = data['userId'] as String?;
    _accountName = data['accountName'] as String?;
  }

  @override
  Future<bool> restoreAuth(String tokenJson) async {
    try {
      await saveAuth(tokenJson);
      return _userAuthToken != null;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<void> logout() async {
    _userAuthToken = null;
    _userId = null;
    _accountName = null;
  }

  /// Sérialise les tokens pour la persistance DB.
  String get tokenJson => jsonEncode({
        'token': _userAuthToken,
        'userId': _userId,
        'accountName': _accountName,
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
      final data = await _get('catalog/search', {
        'query': query,
        'limit': '$limit',
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
        final id = ar['id']?.toString();
        final name = ar['name'] as String?;
        if (id == null || name == null) continue;
        final img = ar['image']?['large'] as String? ?? ar['image']?['small'] as String?;
        results.add(StreamingSearchResult(
          id: id, title: name, coverUrl: img,
          serviceId: serviceId, type: 'artist',
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
      final data = await _get('track/get', {'track_id': trackId});
      return _mapTrack(data);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<String?> getStreamUrl(String trackId) async {
    if (!isAuthenticated) return null;
    try {
      final timestamp =
          (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();
      // Signature : MD5("trackgetFileUrlformat_id27intentstreamtrack_id{id}{ts}{secret}")
      // format_id : 27 = FLAC 24-bit Hi-Res, 6 = FLAC 16-bit, 5 = MP3 320
      const formatId = '27';
      final sigStr =
          'trackgetFileUrlformat_id${formatId}intentstreamtrack_id$trackId$timestamp$_appSecret';
      final sig = _md5(sigStr);

      final data = await _get('track/getFileUrl', {
        'track_id': trackId,
        'format_id': formatId,
        'intent': 'stream',
        'request_ts': timestamp,
        'request_sig': sig,
      });
      return data['url'] as String?;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<StreamingSearchResult>> getAlbumTracks(String albumId) async {
    if (!isAuthenticated) return [];
    try {
      final data = await _get('album/get', {'album_id': albumId});
      final tracks = (data['tracks']?['items'] as List?) ?? [];
      return tracks
          .map((t) => _mapTrack(t as Map<String, dynamic>))
          .whereType<StreamingSearchResult>()
          .toList();
    } catch (_) {
      return [];
    }
  }

  @override
  Future<List<StreamingSearchResult>> getPlaylistTracks(
      String playlistId) async {
    if (!isAuthenticated) return [];
    try {
      final data =
          await _get('playlist/get', {'playlist_id': playlistId, 'extra': 'tracks'});
      final tracks = (data['tracks']?['items'] as List?) ?? [];
      return tracks
          .map((t) => _mapTrack(t as Map<String, dynamic>))
          .whereType<StreamingSearchResult>()
          .toList();
    } catch (_) {
      return [];
    }
  }

  // ---------------------------------------------------------------------------
  // Catalogue (featured + playlists utilisateur)
  // ---------------------------------------------------------------------------

  /// Sections featured Qobuz.
  static const featuredSections = [
    ('new-releases', 'Nouvelles Sorties'),
    ('best-sellers', 'Meilleures Ventes'),
    ('press-awards', 'Récompenses Presse'),
    ('editor-picks', 'Sélection de la Rédaction'),
  ];

  /// Retourne les albums featured d'une section.
  Future<List<StreamingSearchResult>> getFeaturedAlbums(String section, {int limit = 20}) async {
    if (!isAuthenticated) return [];
    try {
      final data = await _get('album/getFeatured', {
        'type': section,
        'limit': '$limit',
      });
      final albums = (data['albums']?['items'] as List?) ?? [];
      return albums.map((a) => _mapAlbum(a as Map<String, dynamic>)).whereType<StreamingSearchResult>().toList();
    } catch (_) {
      return [];
    }
  }

  /// Retourne les playlists de l'utilisateur.
  Future<List<StreamingSearchResult>> getUserPlaylists() async {
    if (!isAuthenticated) return [];
    try {
      final data = await _get('playlist/getUserPlaylists', {});
      final playlists = (data['playlists']?['items'] as List?) ?? [];
      return playlists.map((p) {
        final id = p['id']?.toString();
        final name = p['name'] as String? ?? '';
        final count = p['tracks_count'] as int? ?? 0;
        final cover = p['images300']?.first as String?;
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

  StreamingSearchResult? _mapAlbum(Map<String, dynamic> a) {
    final id = a['id']?.toString();
    final title = a['title'] as String?;
    if (id == null || title == null) return null;
    final artist = a['artist']?['name'] as String?;
    final cover = a['image']?['large'] as String? ?? a['image']?['small'] as String?;
    return StreamingSearchResult(
      id: id,
      title: title,
      artist: artist,
      coverUrl: cover,
      serviceId: serviceId,
      type: 'album',
    );
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
        quality: 'hi_res', // format_id=27
      );

  // ---------------------------------------------------------------------------
  // Helpers HTTP
  // ---------------------------------------------------------------------------

  Future<Map<String, dynamic>> _get(
    String endpoint,
    Map<String, String> params,
  ) async {
    final uri = Uri.parse('$_baseUrl/$endpoint').replace(
      queryParameters: {
        ...params,
        'app_id': _appId,
        if (_userAuthToken != null) 'user_auth_token': _userAuthToken!,
      },
    );
    final response =
        await _http.get(uri).timeout(const Duration(seconds: 15));

    // 401/403: token revoked or app credentials rotated. Clear token and
    // surface a clear auth-expired error rather than a generic network error.
    if (response.statusCode == 401 || response.statusCode == 403) {
      _userAuthToken = null;
      throw Exception(
          'Qobuz auth expired (HTTP ${response.statusCode}): $endpoint');
    }
    if (response.statusCode != 200) {
      throw Exception('Qobuz API error ${response.statusCode}: $endpoint');
    }
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  // ---------------------------------------------------------------------------
  // Mapping
  // ---------------------------------------------------------------------------

  StreamingSearchResult? _mapTrack(Map<String, dynamic> t) {
    final id = t['id']?.toString();
    final title = t['title'] as String?;
    if (id == null || title == null) return null;

    final artist = t['performer']?['name'] as String? ??
        t['album']?['artist']?['name'] as String?;
    final album = t['album']?['title'] as String?;
    final duration = t['duration'] as int?;
    final cover = t['album']?['image']?['large'] as String? ??
        t['album']?['image']?['small'] as String?;

    return StreamingSearchResult(
      id: id,
      title: title,
      artist: artist,
      album: album,
      durationMs: duration != null ? duration * 1000 : null,
      coverUrl: cover,
      serviceId: serviceId,
      raw: t,
    );
  }

  // ---------------------------------------------------------------------------
  // Crypto
  // ---------------------------------------------------------------------------

  String _md5(String input) {
    final bytes = utf8.encode(input);
    return md5.convert(bytes).toString();
  }
}
