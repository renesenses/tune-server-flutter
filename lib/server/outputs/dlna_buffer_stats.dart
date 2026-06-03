import 'dart:async';

import 'package:flutter/foundation.dart';

import '../event_bus.dart';

// ---------------------------------------------------------------------------
// DLNABufferStats
// Buffer state machine (empty/buffering/ready/playing/underrun) per device.
// Miroir de dlna_buffer_stats.rs (Rust)
// ---------------------------------------------------------------------------

/// Buffer states for a DLNA renderer.
enum BufferState {
  empty,      // No data in buffer
  buffering,  // Actively filling buffer
  ready,      // Buffer full, ready to play
  playing,    // Actively consuming buffer
  underrun,   // Buffer depleted during playback
}

/// Event emitted on buffer state change.
class DLNABufferEvent extends AppEvent {
  final String deviceId;
  final BufferState state;
  final double fillPercent;
  const DLNABufferEvent(this.deviceId, this.state, this.fillPercent);
}

/// Stats for a single DLNA device's buffer.
class DeviceBufferStats {
  final String deviceId;
  BufferState state;
  double fillPercent;      // 0.0 - 1.0
  int totalBytes;
  int bufferedBytes;
  int underrunCount;
  DateTime lastStateChange;

  /// Rolling average buffer fill rate (bytes/sec).
  double fillRateBytesPerSec;

  /// Rolling average consumption rate (bytes/sec).
  double consumeRateBytesPerSec;

  DeviceBufferStats({
    required this.deviceId,
    this.state = BufferState.empty,
    this.fillPercent = 0.0,
    this.totalBytes = 0,
    this.bufferedBytes = 0,
    this.underrunCount = 0,
    this.fillRateBytesPerSec = 0.0,
    this.consumeRateBytesPerSec = 0.0,
  }) : lastStateChange = DateTime.now();

  Map<String, dynamic> toJson() => {
        'device_id': deviceId,
        'state': state.name,
        'fill_percent': fillPercent,
        'total_bytes': totalBytes,
        'buffered_bytes': bufferedBytes,
        'underrun_count': underrunCount,
        'fill_rate_bps': fillRateBytesPerSec,
        'consume_rate_bps': consumeRateBytesPerSec,
        'last_state_change': lastStateChange.toIso8601String(),
      };
}

class DLNABufferStatsManager {
  final Map<String, DeviceBufferStats> _devices = {};
  Timer? _monitorTimer;

  // ---------------------------------------------------------------------------
  // Lifecycle
  // ---------------------------------------------------------------------------

  void start() {
    // Monitor every 2 seconds for state transitions
    _monitorTimer = Timer.periodic(const Duration(seconds: 2), (_) => _monitor());
    debugPrint('[DLNABufferStats] Started monitoring');
  }

  void stop() {
    _monitorTimer?.cancel();
    _monitorTimer = null;
    debugPrint('[DLNABufferStats] Stopped monitoring');
  }

  void dispose() {
    stop();
    _devices.clear();
  }

  // ---------------------------------------------------------------------------
  // Device management
  // ---------------------------------------------------------------------------

  /// Register a device for buffer monitoring.
  DeviceBufferStats register(String deviceId) {
    return _devices.putIfAbsent(deviceId, () => DeviceBufferStats(deviceId: deviceId));
  }

  /// Unregister a device.
  void unregister(String deviceId) {
    _devices.remove(deviceId);
  }

  /// Get stats for a specific device.
  DeviceBufferStats? statsFor(String deviceId) => _devices[deviceId];

  /// Get stats for all devices.
  List<DeviceBufferStats> get allStats => _devices.values.toList();

  // ---------------------------------------------------------------------------
  // State updates (called by DLNAOutput)
  // ---------------------------------------------------------------------------

  /// Update buffer state from transport info.
  void updateState(String deviceId, {
    required BufferState newState,
    int? totalBytes,
    int? bufferedBytes,
  }) {
    final stats = register(deviceId);
    final oldState = stats.state;

    if (totalBytes != null) stats.totalBytes = totalBytes;
    if (bufferedBytes != null) stats.bufferedBytes = bufferedBytes;

    stats.fillPercent = stats.totalBytes > 0
        ? (stats.bufferedBytes / stats.totalBytes).clamp(0.0, 1.0)
        : 0.0;

    // State machine transitions
    if (newState != oldState) {
      stats.state = newState;
      stats.lastStateChange = DateTime.now();

      if (newState == BufferState.underrun) {
        stats.underrunCount++;
        debugPrint('[DLNABufferStats] Underrun #${stats.underrunCount} on $deviceId');
      }

      EventBus.instance.emit(
        DLNABufferEvent(deviceId, newState, stats.fillPercent),
      );
    }
  }

  /// Report bytes received (for fill rate calculation).
  void reportBytesReceived(String deviceId, int bytes, Duration elapsed) {
    final stats = _devices[deviceId];
    if (stats == null) return;

    if (elapsed.inMilliseconds > 0) {
      stats.fillRateBytesPerSec = bytes / (elapsed.inMilliseconds / 1000.0);
    }
    stats.bufferedBytes += bytes;
  }

  /// Report bytes consumed (for consumption rate calculation).
  void reportBytesConsumed(String deviceId, int bytes, Duration elapsed) {
    final stats = _devices[deviceId];
    if (stats == null) return;

    if (elapsed.inMilliseconds > 0) {
      stats.consumeRateBytesPerSec = bytes / (elapsed.inMilliseconds / 1000.0);
    }
    stats.bufferedBytes = (stats.bufferedBytes - bytes).clamp(0, stats.totalBytes);
  }

  /// Reset stats for a device (e.g. on new track).
  void reset(String deviceId) {
    final stats = _devices[deviceId];
    if (stats == null) return;

    stats.state = BufferState.empty;
    stats.fillPercent = 0.0;
    stats.bufferedBytes = 0;
    stats.totalBytes = 0;
    stats.fillRateBytesPerSec = 0.0;
    stats.consumeRateBytesPerSec = 0.0;
    stats.lastStateChange = DateTime.now();
  }

  // ---------------------------------------------------------------------------
  // Monitor
  // ---------------------------------------------------------------------------

  void _monitor() {
    for (final stats in _devices.values) {
      // Auto-detect underrun: if consuming faster than filling while playing
      if (stats.state == BufferState.playing &&
          stats.consumeRateBytesPerSec > 0 &&
          stats.fillRateBytesPerSec > 0 &&
          stats.fillPercent < 0.1) {
        updateState(stats.deviceId, newState: BufferState.underrun);
      }

      // Recover from underrun when buffer refills
      if (stats.state == BufferState.underrun && stats.fillPercent > 0.5) {
        updateState(stats.deviceId, newState: BufferState.playing);
      }
    }
  }

  // ---------------------------------------------------------------------------
  // Summary for API
  // ---------------------------------------------------------------------------

  Map<String, dynamic> get summary => {
        'device_count': _devices.length,
        'total_underruns': _devices.values.fold<int>(0, (sum, s) => sum + s.underrunCount),
        'devices': _devices.values.map((s) => s.toJson()).toList(),
      };
}
