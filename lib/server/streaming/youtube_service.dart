import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'streaming_service.dart';

// ---------------------------------------------------------------------------
// T6.4 — YouTubeService
// Piped API (open-source) pour la recherche + extraction d'URL de stream.
// OAuth Google Device Code pour les playlists et favoris authentifiés.
// Miroir de YouTubeService.swift (iOS)
//
// Piped : https://github.com/TeamPiped/Piped
// Instance publique par défaut — configurable via StreamingManager.
// ---------------------------------------------------------------------------

class YouTubeService implements StreamingService {
  static const _pipedBase = 'https://pipedapi.kavin.rocks';
  static const _googleAuthBase = 'https://oauth2.googleapis.com';
  static const _googleApiBase = 'https://www.googleapis.com/youtube/v3';
  // clientId public Google TV (Device Code flow)
  static const _clientId =
      '861556708454-d6dlm3lh05idd8npek18k6be8ba3oc68.apps.googleusercontent.com';
  static const _clientSecret = 'SboVhoG9s0rNafixCSGGKXAT';

  final http.Client _http;
  final String _pipedInstance;

  String? _accessToken;
  String? _refreshToken;
  DateTime? _tokenExpiry;
  String? _accountName;
  bool _authenticated = false;

  YouTubeService({
    http.Client? client,
    String pipedInstance = _pipedBase,
  })  : _http = client ?? http.Client(),
        _pipedInstance = pipedInstance;

  // ---------------------------------------------------------------------------
  // StreamingService
  // ---------------------------------------------------------------------------

  @override
  String get serviceId => 'youtube';

  @override
  String get displayName => 'YouTube';

  @override
  bool get isAuthenticated => _authenticated;

  // ---------------------------------------------------------------------------
  // Auth email/password — non supporté par YouTube
  // ---------------------------------------------------------------------------

  @override
  Future<StreamingAuthResult> authenticateWithCredentials(
    String email,
    String password,
  ) async =>
      const StreamingAuthFailure('Authentification par email non supportée pour YouTube');

  // ---------------------------------------------------------------------------
  // OAuth Device Code (Google)
  // ---------------------------------------------------------------------------

  @override
  Future<StreamingAuthResult> startDeviceCodeFlow() async {
    try {
      final response = await _http.post(
        Uri.parse('$_googleAuthBase/device/code'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: 'client_id=$_clientId'
            '&scope=https://www.googleapis.com/auth/youtube.readonly',
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode != 200) {
        return StreamingAuthFailure(
            'YouTube device auth: HTTP ${response.statusCode}');
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return StreamingDeviceCodeResult(
        deviceCode: data['device_code'] as String,
        userCode: data['user_code'] as String,
        verificationUrl: data['verification_url'] as String,
        expiresInSeconds: data['expires_in'] as int? ?? 300,
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
    final deadline =
        DateTime.now().add(Duration(seconds: deviceCode.expiresInSeconds));
    final interval = Duration(seconds: deviceCode.intervalSeconds);

    while (DateTime.now().isBefore(deadline)) {
      await Future.delayed(interval);
      try {
        final response = await _http.post(
          Uri.parse('$_googleAuthBase/token'),
          headers: {'Content-Type': 'application/x-www-form-urlencoded'},
          body: 'client_id=$_clientId'
              '&client_secret=$_clientSecret'
              '&device_code=${deviceCode.deviceCode}'
              '&grant_type=urn:ietf:params:oauth:grant-type:device_code',
        ).timeout(const Duration(seconds: 10));

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body) as Map<String, dynamic>;
          await _storeTokens(data);
          return StreamingAuthSuccess(_accountName ?? 'YouTube');
        }

        final body = jsonDecode(response.body) as Map<String, dynamic>?;
        final error = body?['error'] as String?;
        if (error == 'expired_token' || error == 'access_denied') {
          return StreamingAuthFailure('Autorisation refusée ou expirée.');
        }
        // 'authorization_pending' ou 'slow_down' → on continue
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
    _authenticated = _accessToken != null;
    final expiryMs = data['expiryMs'] as int?;
    if (expiryMs != null) {
      _tokenExpiry = DateTime.fromMillisecondsSinceEpoch(expiryMs);
    }
  }

  @override
  Future<bool> restoreAuth(String tokenJson) async {
    try {
      await saveAuth(tokenJson);
      if (_accessToken != null &&
          _tokenExpiry != null &&
          DateTime.now().isAfter(_tokenExpiry!)) {
        await _refreshAccessToken();
      }
      return _authenticated;
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
    _authenticated = false;
  }

  String get tokenJson => jsonEncode({
        'accessToken': _accessToken,
        'refreshToken': _refreshToken,
        'accountName': _accountName,
        'expiryMs': _tokenExpiry?.millisecondsSinceEpoch,
      });

  // ---------------------------------------------------------------------------
  // Recherche (Piped — sans auth requise)
  // ---------------------------------------------------------------------------

  @override
  Future<List<StreamingSearchResult>> search(
    String query, {
    int limit = 20,
  }) async {
    try {
      final uri = Uri.parse('$_pipedInstance/search').replace(
        queryParameters: {'q': query, 'filter': 'music_songs'},
      );
      final response =
          await _http.get(uri).timeout(const Duration(seconds: 10));
      if (response.statusCode != 200) return [];

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final items = (data['items'] as List?) ?? [];

      return items
          .take(limit)
          .map((i) => _mapPipedItem(i as Map<String, dynamic>))
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
  Future<StreamingSearchResult?> getTrack(String videoId) async {
    try {
      final uri = Uri.parse('$_pipedInstance/streams/$videoId');
      final response =
          await _http.get(uri).timeout(const Duration(seconds: 10));
      if (response.statusCode != 200) return null;

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return StreamingSearchResult(
        id: videoId,
        title: data['title'] as String? ?? videoId,
        artist: data['uploader'] as String?,
        durationMs: ((data['duration'] as int?) ?? 0) * 1000,
        coverUrl: data['thumbnailUrl'] as String?,
        serviceId: serviceId,
        raw: data,
      );
    } catch (_) {
      return null;
    }
  }

  @override
  Future<String?> getStreamUrl(String videoId) async {
    try {
      final uri = Uri.parse('$_pipedInstance/streams/$videoId');
      final response =
          await _http.get(uri).timeout(const Duration(seconds: 10));
      if (response.statusCode != 200) return null;

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      // Cherche le meilleur stream audio uniquement
      final audioStreams = (data['audioStreams'] as List?) ?? [];
      if (audioStreams.isEmpty) return null;

      // Préfère opus > mp4a, bitrate le plus élevé
      audioStreams.sort((a, b) {
        final aBitrate = (a as Map)['bitrate'] as int? ?? 0;
        final bBitrate = (b as Map)['bitrate'] as int? ?? 0;
        return bBitrate.compareTo(aBitrate);
      });

      return audioStreams.first['url'] as String?;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<StreamingSearchResult>> getAlbumTracks(String playlistId) =>
      getPlaylistTracks(playlistId);

  @override
  Future<List<StreamingSearchResult>> getPlaylistTracks(
      String playlistId) async {
    try {
      final uri =
          Uri.parse('$_pipedInstance/playlists/$playlistId');
      final response =
          await _http.get(uri).timeout(const Duration(seconds: 10));
      if (response.statusCode != 200) return [];

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final videos = (data['relatedStreams'] as List?) ?? [];
      return videos
          .map((v) => _mapPipedItem(v as Map<String, dynamic>))
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
        quality: 'high',
      );

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  Future<void> _storeTokens(Map<String, dynamic> data) async {
    _accessToken = data['access_token'] as String?;
    _refreshToken = data['refresh_token'] as String? ?? _refreshToken;
    final expiresIn = data['expires_in'] as int? ?? 3600;
    _tokenExpiry = DateTime.now().add(Duration(seconds: expiresIn));
    _authenticated = _accessToken != null;

    // Récupère le profil Google (optionnel)
    try {
      final profile = await _http.get(
        Uri.parse(
            'https://www.googleapis.com/oauth2/v1/userinfo?alt=json'),
        headers: {'Authorization': 'Bearer $_accessToken'},
      );
      if (profile.statusCode == 200) {
        final p = jsonDecode(profile.body) as Map<String, dynamic>;
        _accountName = p['email'] as String? ?? p['name'] as String?;
      }
    } catch (_) {}
  }

  Future<void> _refreshAccessToken() async {
    if (_refreshToken == null) return;
    try {
      final response = await _http.post(
        Uri.parse('$_googleAuthBase/token'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: 'client_id=$_clientId'
            '&client_secret=$_clientSecret'
            '&refresh_token=$_refreshToken'
            '&grant_type=refresh_token',
      );
      if (response.statusCode == 200) {
        await _storeTokens(
            jsonDecode(response.body) as Map<String, dynamic>);
      }
    } catch (_) {}
  }

  StreamingSearchResult? _mapPipedItem(Map<String, dynamic> item) {
    final url = item['url'] as String?;
    final id = url?.replaceFirst('/watch?v=', '') ??
        item['id'] as String?;
    final title = item['title'] as String?;
    if (id == null || title == null) return null;

    return StreamingSearchResult(
      id: id,
      title: title,
      artist: item['uploaderName'] as String?,
      durationMs: ((item['duration'] as int?) ?? 0) * 1000,
      coverUrl: item['thumbnail'] as String?,
      serviceId: serviceId,
      raw: item,
    );
  }
}
