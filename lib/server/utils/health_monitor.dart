import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';

import '../event_bus.dart';

// ---------------------------------------------------------------------------
// HealthMonitor
// Background health checks every 60s: memory, disk, playback stalls,
// renderer disconnects.
// Miroir de HealthMonitor.swift (iOS)
// ---------------------------------------------------------------------------

/// Severity level of a health alert.
enum HealthAlertLevel { info, warning, critical }

/// A single health alert.
class HealthAlert {
  final DateTime timestamp;
  final HealthAlertLevel level;
  final String category; // 'memory' | 'disk' | 'playback' | 'renderer'
  final String message;

  const HealthAlert({
    required this.timestamp,
    required this.level,
    required this.category,
    required this.message,
  });

  Map<String, dynamic> toJson() => {
        'timestamp': timestamp.toIso8601String(),
        'level': level.name,
        'category': category,
        'message': message,
      };
}

/// Event emitted when a new health alert is generated.
class HealthAlertEvent extends AppEvent {
  final HealthAlert alert;
  const HealthAlertEvent(this.alert);
}

class HealthMonitor {
  HealthMonitor._();
  static final HealthMonitor instance = HealthMonitor._();

  Timer? _timer;
  bool _running = false;

  /// Ring buffer of recent alerts (max 100).
  final List<HealthAlert> _alerts = [];
  static const _maxAlerts = 100;

  /// Current snapshot of system health.
  int _memoryUsageMB = 0;
  int _diskFreeMB = 0;
  int _playbackStalls = 0;
  int _rendererDisconnects = 0;

  // ---------------------------------------------------------------------------
  // Lifecycle
  // ---------------------------------------------------------------------------

  void start() {
    if (_running) return;
    _running = true;
    // Initial check
    _check();
    // Then every 60 seconds
    _timer = Timer.periodic(const Duration(seconds: 60), (_) => _check());
    debugPrint('[HealthMonitor] Started');
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
    _running = false;
    debugPrint('[HealthMonitor] Stopped');
  }

  bool get isRunning => _running;

  // ---------------------------------------------------------------------------
  // Alerts
  // ---------------------------------------------------------------------------

  List<HealthAlert> get alerts => List.unmodifiable(_alerts);

  /// Current health status summary.
  Map<String, dynamic> get status => {
        'running': _running,
        'memory_usage_mb': _memoryUsageMB,
        'disk_free_mb': _diskFreeMB,
        'playback_stalls': _playbackStalls,
        'renderer_disconnects': _rendererDisconnects,
        'alert_count': _alerts.length,
        'recent_alerts':
            _alerts.reversed.take(10).map((a) => a.toJson()).toList(),
      };

  // ---------------------------------------------------------------------------
  // External event hooks — call these from the Player and DiscoveryManager
  // ---------------------------------------------------------------------------

  /// Called when a playback stall is detected (position not advancing).
  void reportPlaybackStall(String zoneId) {
    _playbackStalls++;
    _addAlert(HealthAlert(
      timestamp: DateTime.now(),
      level: HealthAlertLevel.warning,
      category: 'playback',
      message: 'Playback stall detected in zone $zoneId',
    ));
  }

  /// Called when a renderer disconnects unexpectedly.
  void reportRendererDisconnect(String deviceName) {
    _rendererDisconnects++;
    _addAlert(HealthAlert(
      timestamp: DateTime.now(),
      level: HealthAlertLevel.warning,
      category: 'renderer',
      message: 'Renderer disconnected: $deviceName',
    ));
  }

  // ---------------------------------------------------------------------------
  // Periodic check
  // ---------------------------------------------------------------------------

  Future<void> _check() async {
    await _checkMemory();
    await _checkDisk();
  }

  Future<void> _checkMemory() async {
    try {
      // On Dart/Flutter, ProcessInfo is limited. Use the RSS from /proc on Linux
      // or estimate from Platform.
      final rss = ProcessInfo.currentRss; // bytes
      _memoryUsageMB = rss ~/ (1024 * 1024);

      if (_memoryUsageMB > 512) {
        _addAlert(HealthAlert(
          timestamp: DateTime.now(),
          level: HealthAlertLevel.warning,
          category: 'memory',
          message: 'High memory usage: ${_memoryUsageMB}MB',
        ));
      }
      if (_memoryUsageMB > 1024) {
        _addAlert(HealthAlert(
          timestamp: DateTime.now(),
          level: HealthAlertLevel.critical,
          category: 'memory',
          message: 'Critical memory usage: ${_memoryUsageMB}MB',
        ));
      }
    } catch (e) {
      debugPrint('[HealthMonitor] Memory check error: $e');
    }
  }

  Future<void> _checkDisk() async {
    try {
      final tempDir = Directory.systemTemp;
      // For now, check if temp dir is writable as a basic health check.
      // FileStat does not give free space directly on all platforms.
      final testFile = File('${tempDir.path}/.tune_health_check');
      try {
        await testFile.writeAsString('ok');
        await testFile.delete();
        _diskFreeMB = -1; // Unknown — marker that disk is at least writable
      } catch (e) {
        _diskFreeMB = 0;
        _addAlert(HealthAlert(
          timestamp: DateTime.now(),
          level: HealthAlertLevel.critical,
          category: 'disk',
          message: 'Cannot write to temp directory: ${tempDir.path}',
        ));
      }
    } catch (e) {
      debugPrint('[HealthMonitor] Disk check error: $e');
    }
  }

  void _addAlert(HealthAlert alert) {
    _alerts.add(alert);
    // Ring buffer: remove oldest if over limit
    if (_alerts.length > _maxAlerts) {
      _alerts.removeAt(0);
    }
    // Emit event for UI
    EventBus.instance.emit(HealthAlertEvent(alert));
    debugPrint('[HealthMonitor] ${alert.level.name}: ${alert.message}');
  }
}
