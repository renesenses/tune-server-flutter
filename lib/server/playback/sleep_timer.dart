import 'dart:async';

import 'package:flutter/foundation.dart';

import '../event_bus.dart';

// ---------------------------------------------------------------------------
// SleepTimer
// Timer with linear fade-out and volume restore on expiry.
// Miroir de sleep_timer.rs (Rust)
// ---------------------------------------------------------------------------

/// Event emitted when the sleep timer triggers.
class SleepTimerExpiredEvent extends AppEvent {
  final String zoneId;
  const SleepTimerExpiredEvent(this.zoneId);
}

/// Event emitted on sleep timer tick (for UI progress).
class SleepTimerTickEvent extends AppEvent {
  final String zoneId;
  final int remainingSeconds;
  final int totalSeconds;
  const SleepTimerTickEvent(this.zoneId, this.remainingSeconds, this.totalSeconds);
}

class SleepTimer {
  final String zoneId;

  /// Callback to set volume on the player (0.0 - 1.0).
  final Future<void> Function(double volume) setVolume;

  /// Callback to pause/stop playback.
  final Future<void> Function() stopPlayback;

  Timer? _timer;
  Timer? _fadeTimer;

  int _totalSeconds = 0;
  int _remainingSeconds = 0;
  double _originalVolume = 1.0;

  /// Duration of the fade-out phase in seconds (last N seconds before expiry).
  int fadeDurationSeconds;

  bool _active = false;

  SleepTimer({
    required this.zoneId,
    required this.setVolume,
    required this.stopPlayback,
    this.fadeDurationSeconds = 30,
  });

  // ---------------------------------------------------------------------------
  // State
  // ---------------------------------------------------------------------------

  bool get isActive => _active;
  int get remainingSeconds => _remainingSeconds;
  int get totalSeconds => _totalSeconds;

  // ---------------------------------------------------------------------------
  // Start / Cancel
  // ---------------------------------------------------------------------------

  /// Start a sleep timer for [minutes] minutes.
  /// Saves current volume for restore and begins countdown.
  void start(int minutes, {double currentVolume = 1.0}) {
    cancel(); // Cancel any existing timer

    _totalSeconds = minutes * 60;
    _remainingSeconds = _totalSeconds;
    _originalVolume = currentVolume;
    _active = true;

    debugPrint('[SleepTimer] Started: $minutes min for zone $zoneId');

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _remainingSeconds--;

      EventBus.instance.emit(SleepTimerTickEvent(
        zoneId,
        _remainingSeconds,
        _totalSeconds,
      ));

      // Start fade-out phase
      if (_remainingSeconds <= fadeDurationSeconds && _remainingSeconds > 0) {
        _applyFade();
      }

      if (_remainingSeconds <= 0) {
        _expire();
      }
    });
  }

  /// Cancel the sleep timer and restore volume.
  void cancel() {
    if (!_active) return;

    _timer?.cancel();
    _timer = null;
    _fadeTimer?.cancel();
    _fadeTimer = null;
    _active = false;

    // Restore volume
    setVolume(_originalVolume);
    debugPrint('[SleepTimer] Cancelled for zone $zoneId, volume restored');
  }

  /// Add more time to the running timer.
  void extend(int minutes) {
    if (!_active) return;
    _remainingSeconds += minutes * 60;
    _totalSeconds += minutes * 60;
    debugPrint('[SleepTimer] Extended by $minutes min, '
        '${_remainingSeconds}s remaining');
  }

  // ---------------------------------------------------------------------------
  // Internal
  // ---------------------------------------------------------------------------

  void _applyFade() {
    if (_remainingSeconds <= 0) return;

    // Linear fade from current volume to 0
    final progress = _remainingSeconds / fadeDurationSeconds;
    final targetVolume = (_originalVolume * progress).clamp(0.0, 1.0);
    setVolume(targetVolume);
  }

  Future<void> _expire() async {
    _timer?.cancel();
    _timer = null;
    _fadeTimer?.cancel();
    _fadeTimer = null;
    _active = false;

    // Final volume to 0, then stop
    await setVolume(0.0);
    await stopPlayback();

    // Restore volume for next session
    await setVolume(_originalVolume);

    EventBus.instance.emit(SleepTimerExpiredEvent(zoneId));
    debugPrint('[SleepTimer] Expired for zone $zoneId');
  }

  // ---------------------------------------------------------------------------
  // Dispose
  // ---------------------------------------------------------------------------

  void dispose() {
    _timer?.cancel();
    _fadeTimer?.cancel();
    _active = false;
  }
}
