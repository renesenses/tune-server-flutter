import 'dart:math';

// ---------------------------------------------------------------------------
// ApiAnalytics
// Ring buffer of request records, stats with percentiles (p50/p95/p99),
// top and slowest endpoints.
// Miroir de api_analytics.rs (Rust)
// ---------------------------------------------------------------------------

/// A single API request record.
class RequestRecord {
  final String method;      // GET, POST, etc.
  final String path;        // /api/v1/library/albums
  final int statusCode;
  final int durationMs;
  final DateTime timestamp;

  const RequestRecord({
    required this.method,
    required this.path,
    required this.statusCode,
    required this.durationMs,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'method': method,
        'path': path,
        'status_code': statusCode,
        'duration_ms': durationMs,
        'timestamp': timestamp.toIso8601String(),
      };
}

class ApiAnalytics {
  ApiAnalytics._();
  static final ApiAnalytics instance = ApiAnalytics._();

  /// Ring buffer of recent requests.
  final List<RequestRecord> _records = [];

  /// Maximum number of records to keep.
  static const int maxRecords = 10000;

  /// Total counters (not affected by ring buffer eviction).
  int _totalRequests = 0;
  int _totalErrors = 0;
  int _totalDurationMs = 0;

  // ---------------------------------------------------------------------------
  // Record
  // ---------------------------------------------------------------------------

  /// Record an API request.
  void record({
    required String method,
    required String path,
    required int statusCode,
    required int durationMs,
  }) {
    _records.add(RequestRecord(
      method: method,
      path: path,
      statusCode: statusCode,
      durationMs: durationMs,
      timestamp: DateTime.now(),
    ));

    // Ring buffer eviction
    if (_records.length > maxRecords) {
      _records.removeAt(0);
    }

    _totalRequests++;
    _totalDurationMs += durationMs;
    if (statusCode >= 400) _totalErrors++;
  }

  // ---------------------------------------------------------------------------
  // Stats
  // ---------------------------------------------------------------------------

  /// Full stats summary.
  Map<String, dynamic> get stats {
    if (_records.isEmpty) {
      return {
        'total_requests': _totalRequests,
        'total_errors': _totalErrors,
        'avg_duration_ms': 0,
        'percentiles': {'p50': 0, 'p95': 0, 'p99': 0},
        'top_endpoints': <Map<String, dynamic>>[],
        'slowest_endpoints': <Map<String, dynamic>>[],
        'error_rate': 0.0,
      };
    }

    final durations = _records.map((r) => r.durationMs).toList()..sort();

    return {
      'total_requests': _totalRequests,
      'total_errors': _totalErrors,
      'recent_count': _records.length,
      'avg_duration_ms': _totalDurationMs ~/ max(1, _totalRequests),
      'percentiles': {
        'p50': _percentile(durations, 50),
        'p95': _percentile(durations, 95),
        'p99': _percentile(durations, 99),
      },
      'top_endpoints': topEndpoints(limit: 10),
      'slowest_endpoints': slowestEndpoints(limit: 10),
      'error_rate': _totalErrors / max(1, _totalRequests),
      'requests_per_minute': _requestsPerMinute(),
    };
  }

  /// Top endpoints by request count.
  List<Map<String, dynamic>> topEndpoints({int limit = 10}) {
    final counts = <String, int>{};
    final durations = <String, List<int>>{};

    for (final r in _records) {
      final key = '${r.method} ${r.path}';
      counts[key] = (counts[key] ?? 0) + 1;
      durations.putIfAbsent(key, () => []).add(r.durationMs);
    }

    final sorted = counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sorted.take(limit).map((e) {
      final durs = durations[e.key]!;
      final avgDur = durs.reduce((a, b) => a + b) ~/ durs.length;
      return {
        'endpoint': e.key,
        'count': e.value,
        'avg_duration_ms': avgDur,
      };
    }).toList();
  }

  /// Slowest endpoints by average duration.
  List<Map<String, dynamic>> slowestEndpoints({int limit = 10}) {
    final durations = <String, List<int>>{};

    for (final r in _records) {
      final key = '${r.method} ${r.path}';
      durations.putIfAbsent(key, () => []).add(r.durationMs);
    }

    final avgDurations = durations.entries.map((e) {
      final avg = e.value.reduce((a, b) => a + b) ~/ e.value.length;
      final maxDur = e.value.reduce((a, b) => a > b ? a : b);
      return {
        'endpoint': e.key,
        'avg_duration_ms': avg,
        'max_duration_ms': maxDur,
        'count': e.value.length,
      };
    }).toList();

    avgDurations.sort((a, b) =>
        (b['avg_duration_ms'] as int).compareTo(a['avg_duration_ms'] as int));

    return avgDurations.take(limit).toList();
  }

  /// Recent errors.
  List<Map<String, dynamic>> recentErrors({int limit = 20}) {
    return _records
        .where((r) => r.statusCode >= 400)
        .toList()
        .reversed
        .take(limit)
        .map((r) => r.toJson())
        .toList();
  }

  // ---------------------------------------------------------------------------
  // Reset
  // ---------------------------------------------------------------------------

  void reset() {
    _records.clear();
    _totalRequests = 0;
    _totalErrors = 0;
    _totalDurationMs = 0;
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  int _percentile(List<int> sorted, int percentile) {
    if (sorted.isEmpty) return 0;
    final index = ((percentile / 100.0) * (sorted.length - 1)).round();
    return sorted[index.clamp(0, sorted.length - 1)];
  }

  double _requestsPerMinute() {
    if (_records.length < 2) return 0.0;
    final oldest = _records.first.timestamp;
    final newest = _records.last.timestamp;
    final minutes = newest.difference(oldest).inSeconds / 60.0;
    if (minutes <= 0) return 0.0;
    return _records.length / minutes;
  }
}
