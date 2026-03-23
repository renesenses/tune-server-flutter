import 'dart:io';

import 'package:flutter/services.dart';

import 'output_target.dart';

// ---------------------------------------------------------------------------
// T4.4 — AirPlayOutput
// Output AirPlay via platform channel iOS → AVRoutePickerView / AVPlayer.
// Masqué sur Android (Platform.isIOS guard dans OutputFactory).
// Miroir de AirPlayOutput.swift (iOS)
//
// Ce fichier est le côté Dart du channel.
// Le côté Swift est dans ios/Runner/AirPlayPlugin.swift.
// ---------------------------------------------------------------------------

class AirPlayOutput implements OutputTarget {
  static const _channel = MethodChannel('com.mozaiklabs.tuneserver/airplay');

  @override
  final String id;

  @override
  final String displayName;

  OutputReadyState _readyState = OutputReadyState.idle;
  bool _playing = false;
  double _volume = 1.0;

  AirPlayOutput({
    this.id = 'airplay',
    this.displayName = 'AirPlay',
  }) : assert(Platform.isIOS, 'AirPlayOutput est réservé à iOS');

  // ---------------------------------------------------------------------------
  // Lifecycle
  // ---------------------------------------------------------------------------

  @override
  Future<OutputResult> prepare() async {
    try {
      await _channel.invokeMethod<void>('prepare');
      _readyState = OutputReadyState.ready;
      return const OutputSuccess();
    } on PlatformException catch (e) {
      _readyState = OutputReadyState.error;
      return OutputFailure(e.message ?? 'AirPlay prepare failed');
    }
  }

  @override
  Future<void> dispose() async {
    try {
      await _channel.invokeMethod<void>('dispose');
    } catch (_) {}
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
    String? albumArtUrl,
  }) async {
    try {
      await _channel.invokeMethod<void>('play', {
        'url': url,
        if (title != null) 'title': title,
        if (artist != null) 'artist': artist,
        if (albumArtUrl != null) 'albumArtUrl': albumArtUrl,
      });
      _playing = true;
      return const OutputSuccess();
    } on PlatformException catch (e) {
      return OutputFailure(e.message ?? 'AirPlay play failed');
    }
  }

  @override
  Future<OutputResult> pause() async {
    try {
      await _channel.invokeMethod<void>('pause');
      _playing = false;
      return const OutputSuccess();
    } on PlatformException catch (e) {
      return OutputFailure(e.message ?? 'AirPlay pause failed');
    }
  }

  @override
  Future<OutputResult> resume() async {
    try {
      await _channel.invokeMethod<void>('resume');
      _playing = true;
      return const OutputSuccess();
    } on PlatformException catch (e) {
      return OutputFailure(e.message ?? 'AirPlay resume failed');
    }
  }

  @override
  Future<OutputResult> stop() async {
    try {
      await _channel.invokeMethod<void>('stop');
      _playing = false;
      return const OutputSuccess();
    } on PlatformException catch (e) {
      return OutputFailure(e.message ?? 'AirPlay stop failed');
    }
  }

  @override
  Future<OutputResult> seek(Duration position) async {
    try {
      await _channel.invokeMethod<void>('seek', {
        'positionMs': position.inMilliseconds,
      });
      return const OutputSuccess();
    } on PlatformException catch (e) {
      return OutputFailure(e.message ?? 'AirPlay seek failed');
    }
  }

  // ---------------------------------------------------------------------------
  // Volume
  // ---------------------------------------------------------------------------

  @override
  Future<OutputResult> setVolume(double volume) async {
    try {
      await _channel.invokeMethod<void>('setVolume', {
        'volume': volume.clamp(0.0, 1.0),
      });
      _volume = volume;
      return const OutputSuccess();
    } on PlatformException catch (e) {
      return OutputFailure(e.message ?? 'AirPlay setVolume failed');
    }
  }

  @override
  double? get currentVolume => _volume;

  // ---------------------------------------------------------------------------
  // Position
  // ---------------------------------------------------------------------------

  @override
  Future<Duration?> currentPosition() async {
    try {
      final ms = await _channel.invokeMethod<int>('currentPositionMs');
      if (ms == null) return null;
      return Duration(milliseconds: ms);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<Duration?> duration() async {
    try {
      final ms = await _channel.invokeMethod<int>('durationMs');
      if (ms == null) return null;
      return Duration(milliseconds: ms);
    } catch (_) {
      return null;
    }
  }

  // ---------------------------------------------------------------------------
  // État
  // ---------------------------------------------------------------------------

  @override
  OutputReadyState get readyState => _readyState;

  @override
  bool get isPlaying => _playing;

  /// Affiche le sélecteur de route AirPlay (AVRoutePickerView).
  Future<void> showRoutePicker() async {
    try {
      await _channel.invokeMethod<void>('showRoutePicker');
    } catch (_) {}
  }
}
