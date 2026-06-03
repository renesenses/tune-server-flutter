import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'output_target.dart';

// ---------------------------------------------------------------------------
// SqueezeboxOutput
// Logitech Media Server JSON-RPC client (play/pause/stop/seek/volume/status).
// Miroir de squeezebox_output.rs (Rust)
//
// LMS JSON-RPC endpoint: http://<host>:9000/jsonrpc.js
// ---------------------------------------------------------------------------

class SqueezeboxOutput implements OutputTarget {
  @override
  final String id;

  @override
  final String displayName;

  /// LMS JSON-RPC endpoint URL (e.g. http://192.168.1.50:9000/jsonrpc.js)
  final String lmsUrl;

  /// Squeezebox player MAC address (player ID in LMS).
  final String playerId;

  final http.Client _http;

  OutputReadyState _readyState = OutputReadyState.idle;
  double _volume = 0.5;
  bool _playing = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  String? _currentUrl;

  SqueezeboxOutput({
    required this.id,
    required this.displayName,
    required this.lmsUrl,
    required this.playerId,
    http.Client? client,
  }) : _http = client ?? http.Client();

  // ---------------------------------------------------------------------------
  // OutputTarget — Lifecycle
  // ---------------------------------------------------------------------------

  @override
  Future<OutputResult> prepare() async {
    try {
      // Test connection by getting player status
      final status = await _playerStatus();
      if (status == null) {
        _readyState = OutputReadyState.error;
        return const OutputFailure('Cannot connect to LMS or player not found');
      }

      _readyState = OutputReadyState.ready;

      // Read current volume
      final vol = status['mixer volume'] as num?;
      if (vol != null) {
        _volume = (vol.toDouble() / 100.0).clamp(0.0, 1.0);
      }

      debugPrint('[Squeezebox] Connected to $playerId at $lmsUrl');
      return const OutputSuccess();
    } catch (e) {
      _readyState = OutputReadyState.error;
      return OutputFailure('Connection failed: $e');
    }
  }

  @override
  Future<void> dispose() async {
    _readyState = OutputReadyState.idle;
  }

  // ---------------------------------------------------------------------------
  // OutputTarget — Transport
  // ---------------------------------------------------------------------------

  @override
  Future<OutputResult> play(
    String url, {
    String? title,
    String? artist,
    String? album,
    String? albumArtUrl,
  }) async {
    _currentUrl = url;

    // Use playlist play to start a new track
    final result = await _rpc([
      playerId,
      ['playlist', 'play', url, title ?? ''],
    ]);

    if (result == null) return const OutputFailure('LMS command failed');

    _playing = true;
    _position = Duration.zero;
    return const OutputSuccess();
  }

  @override
  Future<OutputResult> pause() async {
    final result = await _rpc([
      playerId,
      ['pause', '1'],
    ]);
    if (result == null) return const OutputFailure('Pause failed');
    _playing = false;
    return const OutputSuccess();
  }

  @override
  Future<OutputResult> resume() async {
    final result = await _rpc([
      playerId,
      ['pause', '0'],
    ]);
    if (result == null) return const OutputFailure('Resume failed');
    _playing = true;
    return const OutputSuccess();
  }

  @override
  Future<OutputResult> stop() async {
    final result = await _rpc([
      playerId,
      ['stop'],
    ]);
    if (result == null) return const OutputFailure('Stop failed');
    _playing = false;
    _position = Duration.zero;
    _currentUrl = null;
    return const OutputSuccess();
  }

  @override
  Future<OutputResult> seek(Duration position) async {
    final seconds = position.inSeconds;
    final result = await _rpc([
      playerId,
      ['time', seconds.toString()],
    ]);
    if (result == null) return const OutputFailure('Seek failed');
    _position = position;
    return const OutputSuccess();
  }

  // ---------------------------------------------------------------------------
  // OutputTarget — Volume
  // ---------------------------------------------------------------------------

  @override
  Future<OutputResult> setVolume(double volume) async {
    final lmsVol = (volume * 100).round().clamp(0, 100);
    final result = await _rpc([
      playerId,
      ['mixer', 'volume', lmsVol.toString()],
    ]);
    if (result == null) return const OutputFailure('Volume failed');
    _volume = volume.clamp(0.0, 1.0);
    return const OutputSuccess();
  }

  @override
  double? get currentVolume => _volume;

  // ---------------------------------------------------------------------------
  // OutputTarget — Position
  // ---------------------------------------------------------------------------

  @override
  Future<Duration?> currentPosition() async {
    final status = await _playerStatus();
    if (status == null) return _position;

    final time = status['time'] as num?;
    if (time != null) {
      _position = Duration(seconds: time.toInt());
    }
    return _position;
  }

  @override
  Future<Duration?> duration() async {
    final status = await _playerStatus();
    if (status == null) return _duration;

    final dur = status['duration'] as num?;
    if (dur != null) {
      _duration = Duration(seconds: dur.toInt());
    }
    return _duration;
  }

  // ---------------------------------------------------------------------------
  // OutputTarget — State
  // ---------------------------------------------------------------------------

  @override
  OutputReadyState get readyState => _readyState;

  @override
  bool get isPlaying => _playing;

  @override
  bool get hasPendingStream => _currentUrl != null && _playing;

  // ---------------------------------------------------------------------------
  // LMS-specific methods
  // ---------------------------------------------------------------------------

  /// Get list of available Squeezebox players from LMS.
  static Future<List<Map<String, dynamic>>> discoverPlayers(
    String lmsUrl, {
    http.Client? client,
  }) async {
    final httpClient = client ?? http.Client();
    try {
      final body = jsonEncode({
        'id': 1,
        'method': 'slim.request',
        'params': ['', ['players', '0', '100']],
      });

      final response = await httpClient.post(
        Uri.parse(lmsUrl),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode != 200) return [];

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final result = json['result'] as Map<String, dynamic>?;
      final playersLoop = result?['players_loop'] as List<dynamic>? ?? [];

      return playersLoop.map((p) {
        final player = p as Map<String, dynamic>;
        return {
          'id': player['playerid'] as String? ?? '',
          'name': player['name'] as String? ?? '',
          'model': player['model'] as String? ?? '',
          'ip': player['ip'] as String? ?? '',
          'connected': (player['connected'] as int?) == 1,
          'power': (player['power'] as int?) == 1,
        };
      }).toList();
    } catch (e) {
      debugPrint('[Squeezebox] Player discovery error: $e');
      return [];
    } finally {
      if (client == null) httpClient.close();
    }
  }

  /// Get the current player power state.
  Future<bool> getPower() async {
    final status = await _playerStatus();
    return status?['power'] == 1;
  }

  /// Set the player power state.
  Future<OutputResult> setPower(bool on) async {
    final result = await _rpc([
      playerId,
      ['power', on ? '1' : '0'],
    ]);
    if (result == null) return const OutputFailure('Power command failed');
    return const OutputSuccess();
  }

  // ---------------------------------------------------------------------------
  // JSON-RPC
  // ---------------------------------------------------------------------------

  Future<Map<String, dynamic>?> _playerStatus() async {
    return _rpc([
      playerId,
      ['status', '-', '1', 'tags:adlN'],
    ]);
  }

  Future<Map<String, dynamic>?> _rpc(List<dynamic> params) async {
    try {
      final body = jsonEncode({
        'id': 1,
        'method': 'slim.request',
        'params': params,
      });

      final response = await _http
          .post(
            Uri.parse(lmsUrl),
            headers: {'Content-Type': 'application/json'},
            body: body,
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        debugPrint('[Squeezebox] RPC error: ${response.statusCode}');
        return null;
      }

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return json['result'] as Map<String, dynamic>?;
    } catch (e) {
      debugPrint('[Squeezebox] RPC error: $e');
      return null;
    }
  }
}
