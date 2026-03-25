import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'streaming_service.dart';

// ---------------------------------------------------------------------------
// T6.3 — TidalService
// OAuth 2.0 Device Code + quality fallback.
// Miroir de TidalService.swift (iOS)
//
// API TIDAL OpenAPI v2 — client_id public (TV/device flow).
// ---------------------------------------------------------------------------

class TidalService implements StreamingService {
  static const _authBase = 'https://auth.tidal.com/v1/oauth2';
  static const _apiBase = 'https://openapi.tidal.com/v2';
  // clientId public pour le Device Code flow TV
  static const _clientId = 'CzET4vdadNUFQ5JU';

  final http.Client _http;

  String? _accessToken;
  String? _refreshToken;
  DateTime? _tokenExpiry;
  String? _accountName;
  String _quality = 'lossless'; // lossless | hi_res | high | low

  TidalService({http.Client? client}) : _http = client ?? http.Client();

  // ---------------------------------------------------------------------------
  // StreamingService
  // ---------------------------------------------------------------------------

  @override
  String get serviceId => 'tidal';

  @override
  String get displayName => 'Tidal';

  @override
  bool get isAuthenticated =>
      _accessToken != null &&
      (_tokenExpiry == null || DateTime.now().isBefore(_tokenExpiry!));

  // ---------------------------------------------------------------------------
  // Auth email/password — non supporté par Tidal
  // ---------------------------------------------------------------------------

  @override
  Future<StreamingAuthResult> authenticateWithCredentials(
    String email,
    String password,
  ) async =>
      const StreamingAuthFailure('Authentification par email non supportée pour Tidal');

  // ---------------------------------------------------------------------------
  // OAuth Device Code
  // ---------------------------------------------------------------------------

  @override
  Future<StreamingAuthResult> startDeviceCodeFlow() async {
    try {
      final response = await _http.post(
        Uri.parse('$_authBase/device_authorization'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: 'client_id=$_clientId&scope=r_usr+w_usr+w_sub',
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode != 200) {
        return StreamingAuthFailure(
            'Tidal device auth failed: HTTP ${response.statusCode}');
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return StreamingDeviceCodeResult(
        deviceCode: data['deviceCode'] as String,
        userCode: data['userCode'] as String,
        verificationUrl: data['verificationUriComplete'] as String? ??
            'https://link.tidal.com/${data['userCode']}',
        expiresInSeconds: data['expiresIn'] as int? ?? 300,
        intervalSeconds: data['interval'] as int? ?? 5,
      );
    } catch (e) {
      return StreamingAuthFailure(e.toString());
    }
  }

  @override
  Future<StreamingAuthResult> pollDeviceCodeFlow(
    StreamingDeviceCodeResult deviceCode,
  ) async {
    final deadline = DateTime.now()
        .add(Duration(seconds: deviceCode.expiresInSeconds));
    final interval = Duration(seconds: deviceCode.intervalSeconds);

    while (DateTime.now().isBefore(deadline)) {
      await Future.delayed(interval);
      try {
        final response = await _http.post(
          Uri.parse('$_authBase/token'),
          headers: {'Content-Type': 'application/x-www-form-urlencoded'},
          body: 'client_id=$_clientId'
              '&device_code=${deviceCode.deviceCode}'
              '&grant_type=urn:ietf:params:oauth:grant-type:device_code',
        ).timeout(const Duration(seconds: 10));

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body) as Map<String, dynamic>;
          _storeTokens(data);
          return StreamingAuthSuccess(_accountName ?? 'Tidal');
        }

        final error = jsonDecode(response.body)?['error'];
        if (error == 'expired_token') {
          return const StreamingAuthFailure('Code expiré. Recommencez.');
        }
        // 'authorization_pending' → on continue de poller
      } catch (_) {}
    }
    return const StreamingAuthFailure('Délai d\'autorisation dépassé.');
  }

  // ---------------------------------------------------------------------------
  // Auth — persistance
  // ---------------------------------------------------------------------------

  @override
  Future<void> saveAuth(String tokenJson) async {
    final data = jsonDecode(tokenJson) as Map<String, dynamic>;
    _accessToken = data['accessToken'] as String?;
    _refreshToken = data['refreshToken'] as String?;
    _accountName = data['accountName'] as String?;
    _quality = data['quality'] as String? ?? 'lossless';
    final expiryMs = data['expiryMs'] as int?;
    if (expiryMs != null) {
      _tokenExpiry =
          DateTime.fromMillisecondsSinceEpoch(expiryMs);
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
  }

  String get tokenJson => jsonEncode({
        'accessToken': _accessToken,
        'refreshToken': _refreshToken,
        'accountName': _accountName,
        'quality': _quality,
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
        'query': query,
        'limit': '$limit',
        'countryCode': 'FR',
      });
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
  // Pistes
  // ---------------------------------------------------------------------------

  @override
  Future<StreamingSearchResult?> getTrack(String trackId) async {
    if (!isAuthenticated) return null;
    try {
      await _ensureToken();
      final data = await _get('tracks/$trackId', {'countryCode': 'FR'});
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
      // Quality fallback : hi_res → lossless → high → low
      for (final q in _qualityFallback()) {
        try {
          final data = await _get('tracks/$trackId/playbackinfo', {
            'playbackmode': 'STREAM',
            'assetpresentation': 'FULL',
            'audioquality': q,
          });
          final manifest = data['manifest'] as String?;
          if (manifest != null) {
            final decoded =
                String.fromCharCodes(base64Decode(manifest));
            final mf = jsonDecode(decoded) as Map<String, dynamic>;
            return (mf['urls'] as List?)?.first as String?;
          }
        } catch (_) {
          continue;
        }
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<StreamingSearchResult>> getAlbumTracks(String albumId) async {
    if (!isAuthenticated) return [];
    try {
      await _ensureToken();
      final data =
          await _get('albums/$albumId/tracks', {'countryCode': 'FR'});
      final items = (data['items'] as List?) ?? [];
      return items
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
      await _ensureToken();
      final data = await _get('playlists/$playlistId/tracks', {});
      final items = (data['items'] as List?) ?? [];
      return items
          .map((t) => _mapTrack(t as Map<String, dynamic>))
          .whereType<StreamingSearchResult>()
          .toList();
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
        quality: _quality,
      );

  // ---------------------------------------------------------------------------
  // Helpers HTTP
  // ---------------------------------------------------------------------------

  Future<Map<String, dynamic>> _get(
    String path,
    Map<String, String> params,
  ) async {
    final uri =
        Uri.parse('$_apiBase/$path').replace(queryParameters: params);
    final response = await _http.get(uri, headers: {
      'Authorization': 'Bearer $_accessToken',
      'Accept': 'application/json',
    }).timeout(const Duration(seconds: 15));

    if (response.statusCode == 401) {
      await _refreshAccessToken();
      return _get(path, params); // retry une fois
    }
    if (response.statusCode != 200) {
      throw Exception('Tidal API ${response.statusCode}: $path');
    }
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  Future<void> _refreshAccessToken() async {
    if (_refreshToken == null) return;
    final response = await _http.post(
      Uri.parse('$_authBase/token'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: 'client_id=$_clientId'
          '&refresh_token=$_refreshToken'
          '&grant_type=refresh_token',
    );
    if (response.statusCode == 200) {
      _storeTokens(jsonDecode(response.body) as Map<String, dynamic>);
    }
  }

  Future<void> _ensureToken() async {
    if (!isAuthenticated) await _refreshAccessToken();
  }

  void _storeTokens(Map<String, dynamic> data) {
    _accessToken = data['access_token'] as String?;
    _refreshToken = data['refresh_token'] as String? ?? _refreshToken;
    final expiresIn = data['expires_in'] as int? ?? 3600;
    _tokenExpiry = DateTime.now().add(Duration(seconds: expiresIn));
    final user = data['user'] as Map<String, dynamic>?;
    _accountName = user?['email'] as String? ??
        user?['username'] as String?;
  }

  List<String> _qualityFallback() {
    switch (_quality) {
      case 'hi_res':
        return ['HI_RES', 'LOSSLESS', 'HIGH', 'LOW'];
      case 'lossless':
        return ['LOSSLESS', 'HIGH', 'LOW'];
      case 'high':
        return ['HIGH', 'LOW'];
      default:
        return ['LOW'];
    }
  }

  // ---------------------------------------------------------------------------
  // Mapping
  // ---------------------------------------------------------------------------

  StreamingSearchResult? _mapTrack(Map<String, dynamic> t) {
    final id = t['id']?.toString();
    final title = t['title'] as String?;
    if (id == null || title == null) return null;

    final artist = (t['artists'] as List?)
            ?.firstOrNull?['name'] as String? ??
        t['artist']?['name'] as String?;
    final album = t['album']?['title'] as String?;
    final duration = t['duration'] as int?;
    final cover = t['album']?['cover'] != null
        ? 'https://resources.tidal.com/images/${(t['album']['cover'] as String).replaceAll('-', '/')}/320x320.jpg'
        : null;

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
}
