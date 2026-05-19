import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

import 'output_target.dart';

// ---------------------------------------------------------------------------
// BluOSOutput
// Output BluOS via HTTP REST API on port 11000.
// Miroir de BluOSOutput.swift (iOS)
//
// Actions implementees :
//   Play, Pause, Stop, Volume, Status (position), Seek
// ---------------------------------------------------------------------------

class BluOSOutput implements OutputTarget {
  @override
  final String id;

  @override
  final String displayName;

  final String host;
  final int port;
  final http.Client _http;

  OutputReadyState _readyState = OutputReadyState.idle;
  double _volume = 1.0;
  bool _playing = false;
  String? _streamId;

  BluOSOutput({
    required this.id,
    required this.displayName,
    required this.host,
    this.port = 11000,
    http.Client? client,
  }) : _http = client ?? http.Client();

  String get _baseUrl => 'http://$host:$port';

  // ---------------------------------------------------------------------------
  // Lifecycle
  // ---------------------------------------------------------------------------

  @override
  Future<OutputResult> prepare() async {
    try {
      // Health check: query Status
      await _apiGet('Status');
      _readyState = OutputReadyState.ready;
      // Read current volume from device
      await _fetchCurrentVolume();
      return const OutputSuccess();
    } catch (e) {
      _readyState = OutputReadyState.error;
      return OutputFailure('BluOS prepare failed: $e');
    }
  }

  @override
  Future<void> dispose() async {
    _http.close();
    _readyState = OutputReadyState.idle;
    _playing = false;
  }

  // ---------------------------------------------------------------------------
  // Transport
  // ---------------------------------------------------------------------------

  @override
  Future<OutputResult> play(
    String url, {
    String? title,
    String? artist,
    String? album,
    String? albumArtUrl,
  }) async {
    try {
      // Stop current playback first
      await _apiGet('Stop');
      await Future.delayed(const Duration(milliseconds: 200));

      // Build Play parameters with metadata
      final params = <String, String>{'url': url};
      if (title != null) params['title'] = title;
      if (artist != null) params['artist'] = artist;
      if (album != null) params['album'] = album;
      if (albumArtUrl != null) params['image'] = albumArtUrl;

      await _apiGet('Play', params: params);
      _playing = true;
      _streamId = url;
      debugPrint('[BluOS] Playing: ${title ?? url} on $displayName');
      return const OutputSuccess();
    } catch (e) {
      return OutputFailure('BluOS Play failed: $e');
    }
  }

  @override
  Future<OutputResult> pause() async {
    try {
      await _apiGet('Pause');
      _playing = false;
      return const OutputSuccess();
    } catch (e) {
      return OutputFailure('BluOS Pause failed: $e');
    }
  }

  @override
  Future<OutputResult> resume() async {
    try {
      await _apiGet('Play');
      _playing = true;
      return const OutputSuccess();
    } catch (e) {
      return OutputFailure('BluOS Resume failed: $e');
    }
  }

  @override
  Future<OutputResult> stop() async {
    try {
      await _apiGet('Stop');
      _playing = false;
      _streamId = null;
      return const OutputSuccess();
    } catch (e) {
      return OutputFailure('BluOS Stop failed: $e');
    }
  }

  @override
  Future<OutputResult> seek(Duration position) async {
    try {
      final seconds = position.inSeconds;
      await _apiGet('Play', params: {'seek': '$seconds'});
      return const OutputSuccess();
    } catch (e) {
      return OutputFailure('BluOS Seek failed: $e');
    }
  }

  // ---------------------------------------------------------------------------
  // Volume
  // ---------------------------------------------------------------------------

  @override
  Future<OutputResult> setVolume(double volume) async {
    try {
      final level = (volume * 100).round().clamp(0, 100);
      await _apiGet('Volume', params: {'level': '$level'});
      _volume = volume;
      return const OutputSuccess();
    } catch (e) {
      return OutputFailure('BluOS SetVolume failed: $e');
    }
  }

  @override
  double? get currentVolume => _volume;

  Future<void> _fetchCurrentVolume() async {
    try {
      final response = await _apiGet('Volume');
      if (response != null) {
        final doc = XmlDocument.parse(response);
        final volStr = doc.descendants
            .whereType<XmlElement>()
            .firstWhere((e) => e.localName == 'volume',
                orElse: () => XmlElement(XmlName('volume')))
            .innerText
            .trim();
        final vol = int.tryParse(volStr);
        if (vol != null) {
          _volume = (vol / 100).clamp(0.0, 1.0);
        }
      }
    } catch (e) {
      debugPrint('[BluOS] fetchCurrentVolume error: $e');
    }
  }

  // ---------------------------------------------------------------------------
  // Position
  // ---------------------------------------------------------------------------

  @override
  Future<Duration?> currentPosition() async {
    try {
      final response = await _apiGet('Status');
      if (response == null) return null;
      final doc = XmlDocument.parse(response);
      final secsStr = doc.descendants
          .whereType<XmlElement>()
          .firstWhere((e) => e.localName == 'secs',
              orElse: () => XmlElement(XmlName('secs')))
          .innerText
          .trim();
      final secs = double.tryParse(secsStr);
      if (secs != null) {
        return Duration(milliseconds: (secs * 1000).round());
      }
    } catch (e) {
      debugPrint('[BluOS] currentPosition error: $e');
    }
    return null;
  }

  @override
  Future<Duration?> duration() async {
    try {
      final response = await _apiGet('Status');
      if (response == null) return null;
      final doc = XmlDocument.parse(response);
      final totStr = doc.descendants
          .whereType<XmlElement>()
          .firstWhere((e) => e.localName == 'totlen',
              orElse: () => XmlElement(XmlName('totlen')))
          .innerText
          .trim();
      final secs = double.tryParse(totStr);
      if (secs != null) {
        return Duration(milliseconds: (secs * 1000).round());
      }
    } catch (e) {
      debugPrint('[BluOS] duration error: $e');
    }
    return null;
  }

  // ---------------------------------------------------------------------------
  // State
  // ---------------------------------------------------------------------------

  @override
  OutputReadyState get readyState => _readyState;

  @override
  bool get isPlaying => _playing;

  @override
  bool get hasPendingStream => _streamId != null;

  // ---------------------------------------------------------------------------
  // HTTP REST helpers
  // ---------------------------------------------------------------------------

  Future<String?> _apiGet(String path, {Map<String, String>? params}) async {
    try {
      final uri = Uri.parse('$_baseUrl/$path').replace(queryParameters: params);
      final response = await _http
          .get(uri)
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return response.body;
      }
      return null;
    } catch (e) {
      debugPrint('[BluOS] API error ($path): $e');
      rethrow;
    }
  }
}
