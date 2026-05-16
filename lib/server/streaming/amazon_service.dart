import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'streaming_service.dart';

// ---------------------------------------------------------------------------
// T6.8 — AmazonService
// Device Code OAuth + proxy auth, HD/Ultra HD streaming.
// Mirrors amazon_plugin.py from tune-plugin-amazon.
//
// API Amazon Music — proxy-based auth + device code flow.
// Quality: SD (AAC), HD (FLAC 16/44), ULTRA_HD (FLAC 24/96).
// ---------------------------------------------------------------------------

class AmazonService implements StreamingService {
  static const _authBase = 'https://api.amazon.com/auth/o2';
  static const _apiBase = 'https://music.amazon.com/api';
  static const _clientId = 'amzn1.application-oa2-client.music';
  static const _pollInterval = 5; // seconds
  static const _pollTimeout = 300; // seconds

  final http.Client _http;

  String? _accessToken;
  String? _refreshToken;
  String _deviceId;
  String _region;
  String _quality; // SD | HD | ULTRA_HD
  String? _accountName;

  AmazonService({
    http.Client? client,
    String region = 'fr',
    String quality = 'HD',
    String? deviceId,
  })  : _http = client ?? http.Client(),
        _region = region,
        _quality = quality,
        _deviceId = deviceId ?? _generateDeviceId();

  static String _generateDeviceId() {
    // Simple UUID-like random ID
    final now = DateTime.now().microsecondsSinceEpoch;
    return '${now.toRadixString(16)}-flutter-amazon';
  }

  // ---------------------------------------------------------------------------
  // StreamingService
  // ---------------------------------------------------------------------------

  @override
  String get serviceId => 'amazon';

  @override
  String get displayName => 'Amazon Music';

  @override
  bool get isAuthenticated => _accessToken != null;

  // ---------------------------------------------------------------------------
  // Auth email/password — non supporté par Amazon
  // ---------------------------------------------------------------------------

  @override
  Future<StreamingAuthResult> authenticateWithCredentials(
    String email,
    String password,
  ) async =>
      const StreamingAuthFailure(
          'Authentification par email non supportée pour Amazon Music');

  // ---------------------------------------------------------------------------
  // OAuth Device Code
  // ---------------------------------------------------------------------------

  @override
  Future<StreamingAuthResult> startDeviceCodeFlow() async {
    try {
      final response = await _http.post(
        Uri.parse('$_authBase/create/codepair'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: 'response_type=device_code'
            '&client_id=$_clientId'
            '&scope=music%3A%3Aplayback+music%3A%3Alibrary',
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode != 200) {
        return StreamingAuthFailure(
            'Amazon device auth failed: HTTP ${response.statusCode}');
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return StreamingDeviceCodeResult(
        deviceCode: data['device_code'] as String? ?? '',
        userCode: data['user_code'] as String? ?? '',
        verificationUrl:
            data['verification_uri'] as String? ?? 'https://amazon.com/code',
        expiresInSeconds: _pollTimeout,
        intervalSeconds: _pollInterval,
      );
    } catch (e) {
      return StreamingAuthFailure(e.toString());
    }
  }

  @override
  Future<StreamingAuthResult> pollDeviceCodeFlow(
    StreamingDeviceCodeResult deviceCode,
  ) async {
    final deadline =
        DateTime.now().add(Duration(seconds: deviceCode.expiresInSeconds));
    final interval = Duration(seconds: deviceCode.intervalSeconds);

    while (DateTime.now().isBefore(deadline)) {
      await Future.delayed(interval);
      try {
        final response = await _http.post(
          Uri.parse('$_authBase/token'),
          headers: {'Content-Type': 'application/x-www-form-urlencoded'},
          body: 'grant_type=device_code'
              '&device_code=${deviceCode.deviceCode}'
              '&client_id=$_clientId',
        ).timeout(const Duration(seconds: 10));

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body) as Map<String, dynamic>;
          _accessToken = data['access_token'] as String?;
          _refreshToken = data['refresh_token'] as String?;
          _accountName = 'Amazon Music';
          return StreamingAuthSuccess(_accountName!);
        }

        if (response.statusCode == 400) {
          final body = jsonDecode(response.body) as Map<String, dynamic>?;
          final error = body?['error'] as String?;
          if (error == 'authorization_pending') {
            continue;
          } else if (error == 'slow_down') {
            await Future.delayed(const Duration(seconds: 5));
          } else {
            return StreamingAuthFailure(
                'Amazon auth error: ${error ?? "unknown"}');
          }
        }
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
    _deviceId = data['deviceId'] as String? ?? _deviceId;
    _region = data['region'] as String? ?? _region;
    _quality = data['quality'] as String? ?? _quality;
  }

  @override
  Future<bool> restoreAuth(String tokenJson) async {
    try {
      await saveAuth(tokenJson);
      if (_accessToken != null && _refreshToken != null) {
        // Try to refresh the token to validate
        final refreshed = await _refreshAccessToken();
        return refreshed;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<void> logout() async {
    _accessToken = null;
    _refreshToken = null;
    _accountName = null;
  }

  /// Sérialise les tokens pour la persistance DB.
  String get tokenJson => jsonEncode({
        'accessToken': _accessToken,
        'refreshToken': _refreshToken,
        'accountName': _accountName,
        'deviceId': _deviceId,
        'region': _region,
        'quality': _quality,
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
      final data = await _apiGet('search', {
        'query': query,
        'limit': '$limit',
      });
      final results = <StreamingSearchResult>[];

      for (final hit in (data['results'] as List?) ?? []) {
        final raw = hit as Map<String, dynamic>;
        final hitType = raw['type'] as String? ?? '';
        if (hitType == 'track') {
          final mapped = _mapTrack(raw);
          if (mapped != null) results.add(mapped);
        } else if (hitType == 'album') {
          final mapped = _mapAlbum(raw);
          if (mapped != null) results.add(mapped);
        } else if (hitType == 'artist') {
          final id = raw['id']?.toString() ?? raw['artistId']?.toString();
          final name = raw['name'] as String? ?? raw['artistName'] as String?;
          if (id != null && name != null) {
            results.add(StreamingSearchResult(
              id: id,
              title: name,
              serviceId: serviceId,
              type: 'artist',
              raw: raw,
            ));
          }
        }
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
    if (!isAuthenticated) return null;
    try {
      final data = await _apiGet('track/$trackId', {});
      return _mapTrack(data);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<String?> getStreamUrl(String trackId) async {
    if (!isAuthenticated) return null;
    try {
      final data = await _apiPost('stream', {
        'trackId': trackId,
        'quality': _quality,
        'deviceId': _deviceId,
      });
      return data['url'] as String? ?? data['streamUrl'] as String?;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<StreamingSearchResult>> getAlbumTracks(String albumId) async {
    if (!isAuthenticated) return [];
    try {
      final data = await _apiGet('album/$albumId/tracks', {});
      final items = (data['tracks'] as List?) ?? (data['items'] as List?) ?? [];
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
      final data = await _apiGet('playlist/$playlistId/tracks', {});
      final items = (data['tracks'] as List?) ?? (data['items'] as List?) ?? [];
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
        quality: _quality.toLowerCase(),
      );

  // ---------------------------------------------------------------------------
  // Helpers HTTP
  // ---------------------------------------------------------------------------

  String get _regionTld {
    const tldMap = {
      'us': 'com', 'uk': 'co.uk', 'de': 'de', 'fr': 'fr',
      'it': 'it', 'es': 'es', 'jp': 'co.jp', 'ca': 'ca',
      'au': 'com.au', 'br': 'com.br', 'mx': 'com.mx', 'in': 'in',
    };
    return tldMap[_region] ?? 'com';
  }

  Map<String, String> get _apiHeaders => {
        'Authorization': 'Bearer $_accessToken',
        'X-Amzn-Device-Id': _deviceId,
        'X-Amzn-Music-Domain': 'music.amazon.$_regionTld',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  Future<Map<String, dynamic>> _apiGet(
    String endpoint,
    Map<String, String> params,
  ) async {
    final uri = Uri.parse('$_apiBase/$endpoint').replace(
      queryParameters: params.isNotEmpty ? params : null,
    );
    final response = await _http
        .get(uri, headers: _apiHeaders)
        .timeout(const Duration(seconds: 15));

    if (response.statusCode == 401) {
      final refreshed = await _refreshAccessToken();
      if (refreshed) {
        return _apiGet(endpoint, params); // retry once
      }
      throw Exception('Amazon auth expired');
    }
    if (response.statusCode != 200) {
      throw Exception('Amazon API ${response.statusCode}: $endpoint');
    }
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> _apiPost(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    final uri = Uri.parse('$_apiBase/$endpoint');
    final response = await _http
        .post(uri, headers: _apiHeaders, body: jsonEncode(body))
        .timeout(const Duration(seconds: 15));

    if (response.statusCode == 401) {
      final refreshed = await _refreshAccessToken();
      if (refreshed) {
        return _apiPost(endpoint, body); // retry once
      }
      throw Exception('Amazon auth expired');
    }
    if (response.statusCode != 200) {
      throw Exception('Amazon API ${response.statusCode}: $endpoint');
    }
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  Future<bool> _refreshAccessToken() async {
    if (_refreshToken == null) return false;
    try {
      final response = await _http.post(
        Uri.parse('$_authBase/token'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: 'grant_type=refresh_token'
            '&refresh_token=$_refreshToken'
            '&client_id=$_clientId',
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        _accessToken = data['access_token'] as String?;
        final newRefresh = data['refresh_token'] as String?;
        if (newRefresh != null) {
          _refreshToken = newRefresh;
        }
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  // ---------------------------------------------------------------------------
  // Mapping
  // ---------------------------------------------------------------------------

  StreamingSearchResult? _mapTrack(Map<String, dynamic> t) {
    final id = t['id']?.toString() ?? t['trackId']?.toString();
    final title = t['title'] as String?;
    if (id == null || title == null) return null;

    String? artistName;
    final artist = t['artist'];
    if (artist is Map<String, dynamic>) {
      artistName = artist['name'] as String?;
    } else {
      artistName = t['artistName'] as String?;
    }

    String? albumTitle;
    final album = t['album'];
    if (album is Map<String, dynamic>) {
      albumTitle = album['title'] as String?;
    } else {
      albumTitle = t['albumTitle'] as String?;
    }

    final duration = t['duration'] as int?;
    final cover = t['coverUrl'] as String? ?? t['image'] as String?;

    return StreamingSearchResult(
      id: id,
      title: title,
      artist: artistName,
      album: albumTitle,
      durationMs: duration != null ? duration * 1000 : null,
      coverUrl: cover,
      serviceId: serviceId,
      raw: t,
    );
  }

  StreamingSearchResult? _mapAlbum(Map<String, dynamic> a) {
    final id = a['id']?.toString() ?? a['albumId']?.toString();
    final title = a['title'] as String?;
    if (id == null || title == null) return null;

    String? artistName;
    final artist = a['artist'];
    if (artist is Map<String, dynamic>) {
      artistName = artist['name'] as String?;
    } else {
      artistName = a['artistName'] as String?;
    }

    final cover = a['coverUrl'] as String? ?? a['image'] as String?;

    return StreamingSearchResult(
      id: id,
      title: title,
      artist: artistName,
      coverUrl: cover,
      serviceId: serviceId,
      type: 'album',
      raw: a,
    );
  }
}
