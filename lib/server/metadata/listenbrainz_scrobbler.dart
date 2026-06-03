import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../database/database.dart';

// ---------------------------------------------------------------------------
// ListenBrainzScrobbler
// ListenBrainz API: submit-listens (single + import) and playing_now.
// Miroir de listenbrainz_scrobbler.rs (Rust)
//
// API docs: https://listenbrainz.readthedocs.io/en/latest/users/api/
// ---------------------------------------------------------------------------

/// Result of a ListenBrainz API call.
class ScrobbleResult {
  final bool success;
  final String? error;

  const ScrobbleResult({required this.success, this.error});
}

class ListenBrainzScrobbler {
  static const _baseUrl = 'https://api.listenbrainz.org/1';

  final http.Client _http;
  String? _userToken;
  String? _username;

  ListenBrainzScrobbler({http.Client? client})
      : _http = client ?? http.Client();

  // ---------------------------------------------------------------------------
  // Auth
  // ---------------------------------------------------------------------------

  bool get isAuthenticated => _userToken != null;
  String? get username => _username;

  /// Set the ListenBrainz user token.
  /// Validates the token by calling /validate-token.
  Future<ScrobbleResult> authenticate(String token) async {
    try {
      final response = await _http.get(
        Uri.parse('$_baseUrl/validate-token'),
        headers: {
          'Authorization': 'Token $token',
        },
      );

      if (response.statusCode != 200) {
        return ScrobbleResult(
          success: false,
          error: 'Invalid token (HTTP ${response.statusCode})',
        );
      }

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final valid = json['valid'] as bool? ?? false;

      if (!valid) {
        return const ScrobbleResult(
          success: false,
          error: 'Token is not valid',
        );
      }

      _userToken = token;
      _username = json['user_name'] as String?;

      debugPrint('[ListenBrainz] Authenticated as $_username');
      return const ScrobbleResult(success: true);
    } catch (e) {
      return ScrobbleResult(success: false, error: 'Connection error: $e');
    }
  }

  void logout() {
    _userToken = null;
    _username = null;
  }

  // ---------------------------------------------------------------------------
  // Playing Now
  // ---------------------------------------------------------------------------

  /// Submit a "playing now" notification.
  Future<ScrobbleResult> playingNow(Track track) async {
    if (_userToken == null) {
      return const ScrobbleResult(success: false, error: 'Not authenticated');
    }

    final payload = {
      'listen_type': 'playing_now',
      'payload': [
        {
          'track_metadata': _trackMetadata(track),
        },
      ],
    };

    return _submitListens(payload);
  }

  // ---------------------------------------------------------------------------
  // Submit Listen
  // ---------------------------------------------------------------------------

  /// Submit a completed listen.
  /// [listenedAt] is the Unix timestamp when the track started playing.
  Future<ScrobbleResult> submitListen(Track track, {DateTime? listenedAt}) async {
    if (_userToken == null) {
      return const ScrobbleResult(success: false, error: 'Not authenticated');
    }

    final timestamp = (listenedAt ?? DateTime.now()).millisecondsSinceEpoch ~/ 1000;

    final payload = {
      'listen_type': 'single',
      'payload': [
        {
          'listened_at': timestamp,
          'track_metadata': _trackMetadata(track),
        },
      ],
    };

    return _submitListens(payload);
  }

  /// Submit multiple listens (import).
  Future<ScrobbleResult> submitImport(
    List<Map<String, dynamic>> listens,
  ) async {
    if (_userToken == null) {
      return const ScrobbleResult(success: false, error: 'Not authenticated');
    }

    final payload = {
      'listen_type': 'import',
      'payload': listens,
    };

    return _submitListens(payload);
  }

  // ---------------------------------------------------------------------------
  // Internal
  // ---------------------------------------------------------------------------

  Map<String, dynamic> _trackMetadata(Track track) {
    final metadata = <String, dynamic>{
      'track_name': track.title,
      'artist_name': track.artistName ?? 'Unknown Artist',
    };

    if (track.albumTitle != null) {
      metadata['release_name'] = track.albumTitle;
    }

    // Additional info
    final additionalInfo = <String, dynamic>{};

    if (track.musicbrainzRecordingId != null &&
        track.musicbrainzRecordingId!.isNotEmpty) {
      additionalInfo['recording_mbid'] = track.musicbrainzRecordingId;
    }

    if (track.durationMs != null) {
      additionalInfo['duration_ms'] = track.durationMs;
    }

    if (track.trackNumber != null) {
      additionalInfo['tracknumber'] = track.trackNumber;
    }

    additionalInfo['media_player'] = 'Tune';
    additionalInfo['submission_client'] = 'Tune';
    additionalInfo['submission_client_version'] = '1.0';

    if (additionalInfo.isNotEmpty) {
      metadata['additional_info'] = additionalInfo;
    }

    return metadata;
  }

  Future<ScrobbleResult> _submitListens(Map<String, dynamic> payload) async {
    try {
      final response = await _http.post(
        Uri.parse('$_baseUrl/submit-listens'),
        headers: {
          'Authorization': 'Token $_userToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        return const ScrobbleResult(success: true);
      }

      final errorBody = response.body;
      debugPrint('[ListenBrainz] Submit error ${response.statusCode}: $errorBody');

      return ScrobbleResult(
        success: false,
        error: 'HTTP ${response.statusCode}: $errorBody',
      );
    } catch (e) {
      debugPrint('[ListenBrainz] Submit error: $e');
      return ScrobbleResult(success: false, error: 'Connection error: $e');
    }
  }

  void dispose() {
    _http.close();
  }
}
