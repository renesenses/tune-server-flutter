import 'dart:async';

import 'package:flutter/foundation.dart';

import '../event_bus.dart';

// ---------------------------------------------------------------------------
// ScanScheduler
// Scheduled periodic scanning (configurable interval, startup scan).
// Miroir de scan_scheduler.rs (Rust)
// ---------------------------------------------------------------------------

class ScanScheduler {
  /// Callback to trigger a library scan.
  final Future<void> Function({bool full}) triggerScan;

  Timer? _timer;
  bool _running = false;

  /// Scan interval in minutes. Default: 60 (1 hour).
  int intervalMinutes;

  /// Whether to scan on startup.
  bool scanOnStartup;

  /// Timestamp of the last completed scan.
  DateTime? _lastScanAt;

  /// Whether a scan is currently in progress.
  bool _scanInProgress = false;

  ScanScheduler({
    required this.triggerScan,
    this.intervalMinutes = 60,
    this.scanOnStartup = true,
  });

  // ---------------------------------------------------------------------------
  // State
  // ---------------------------------------------------------------------------

  bool get isRunning => _running;
  DateTime? get lastScanAt => _lastScanAt;
  bool get scanInProgress => _scanInProgress;

  /// Minutes until next scheduled scan (null if not running).
  int? get minutesUntilNextScan {
    if (!_running || _lastScanAt == null) return null;
    final nextScan = _lastScanAt!.add(Duration(minutes: intervalMinutes));
    final remaining = nextScan.difference(DateTime.now()).inMinutes;
    return remaining < 0 ? 0 : remaining;
  }

  // ---------------------------------------------------------------------------
  // Lifecycle
  // ---------------------------------------------------------------------------

  Future<void> start() async {
    if (_running) return;
    _running = true;

    debugPrint('[ScanScheduler] Started, interval: ${intervalMinutes}min, '
        'scanOnStartup: $scanOnStartup');

    // Subscribe to scan completion events
    EventBus.instance.subscribe<LibraryScanCompletedEvent>((event) {
      _lastScanAt = DateTime.now();
      _scanInProgress = false;
    });

    // Startup scan
    if (scanOnStartup) {
      // Delay startup scan by a few seconds to let the server finish initializing
      await Future.delayed(const Duration(seconds: 5));
      await _doScan();
    }

    // Periodic scan
    _timer = Timer.periodic(Duration(minutes: intervalMinutes), (_) => _doScan());
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
    _running = false;
    debugPrint('[ScanScheduler] Stopped');
  }

  /// Force an immediate scan (resets the interval timer).
  Future<void> scanNow({bool full = false}) async {
    // Reset timer
    _timer?.cancel();
    if (_running) {
      _timer = Timer.periodic(Duration(minutes: intervalMinutes), (_) => _doScan());
    }
    await _doScan(full: full);
  }

  /// Update the scan interval. Restarts the timer.
  void setInterval(int minutes) {
    intervalMinutes = minutes;
    if (_running) {
      _timer?.cancel();
      _timer = Timer.periodic(Duration(minutes: intervalMinutes), (_) => _doScan());
    }
    debugPrint('[ScanScheduler] Interval updated to ${intervalMinutes}min');
  }

  void dispose() {
    stop();
  }

  // ---------------------------------------------------------------------------
  // Internal
  // ---------------------------------------------------------------------------

  Future<void> _doScan({bool full = false}) async {
    if (_scanInProgress) {
      debugPrint('[ScanScheduler] Scan already in progress, skipping');
      return;
    }

    _scanInProgress = true;
    debugPrint('[ScanScheduler] Triggering ${full ? "full" : "incremental"} scan');

    try {
      await triggerScan(full: full);
    } catch (e) {
      debugPrint('[ScanScheduler] Scan error: $e');
      _scanInProgress = false;
    }
  }

  // ---------------------------------------------------------------------------
  // Status for API
  // ---------------------------------------------------------------------------

  Map<String, dynamic> get status => {
        'running': _running,
        'interval_minutes': intervalMinutes,
        'scan_on_startup': scanOnStartup,
        'scan_in_progress': _scanInProgress,
        'last_scan_at': _lastScanAt?.toIso8601String(),
        'minutes_until_next': minutesUntilNextScan,
      };
}
