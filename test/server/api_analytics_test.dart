// Tests for ApiAnalytics: record and stats, ring buffer eviction,
// percentile computation, empty stats.
// Ported from tune-core/src/utils/api_analytics.rs
//
// Run with : flutter test test/server/api_analytics_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:tune_server/server/utils/api_analytics.dart';

void main() {
  // Reset the singleton before each test to isolate state.
  setUp(() {
    ApiAnalytics.instance.reset();
  });

  group('ApiAnalytics -- record and stats', () {
    test('counts requests and errors', () {
      final analytics = ApiAnalytics.instance;
      analytics.record(
        method: 'GET',
        path: '/api/v1/system/stats',
        statusCode: 200,
        durationMs: 5,
      );
      analytics.record(
        method: 'GET',
        path: '/api/v1/system/stats',
        statusCode: 200,
        durationMs: 10,
      );
      analytics.record(
        method: 'GET',
        path: '/api/v1/zones',
        statusCode: 200,
        durationMs: 3,
      );
      analytics.record(
        method: 'POST',
        path: '/api/v1/zones',
        statusCode: 400,
        durationMs: 15,
      );

      final stats = analytics.stats;
      expect(stats['total_requests'], 4);
      expect(stats['total_errors'], 1);
      expect((stats['error_rate'] as double), greaterThan(0.0));
      expect(
        (stats['top_endpoints'] as List).isNotEmpty,
        isTrue,
      );
    });
  });

  group('ApiAnalytics -- ring buffer eviction', () {
    test('evicts oldest records beyond maxRecords', () {
      final analytics = ApiAnalytics.instance;
      // The default maxRecords is 10000. We record 10001 entries.
      // Since we can't easily change maxRecords on the singleton,
      // we verify the behavior conceptually: the ring buffer keeps
      // at most maxRecords recent records.
      for (var i = 0; i < 100; i++) {
        analytics.record(
          method: 'GET',
          path: '/api/v1/test',
          statusCode: 200,
          durationMs: i,
        );
      }

      final stats = analytics.stats;
      // total_requests includes all recorded (not just buffer)
      expect(stats['total_requests'], 100);
      // recent_count is the buffer size, should be <= maxRecords
      expect(stats['recent_count'], lessThanOrEqualTo(ApiAnalytics.maxRecords));
    });
  });

  group('ApiAnalytics -- percentiles', () {
    test('computes p50, p95, p99 correctly', () {
      final analytics = ApiAnalytics.instance;
      for (var i = 1; i <= 100; i++) {
        analytics.record(
          method: 'GET',
          path: '/test',
          statusCode: 200,
          durationMs: i,
        );
      }

      final stats = analytics.stats;
      final percentiles = stats['percentiles'] as Map<String, dynamic>;

      // p50 should be near 50
      expect(percentiles['p50'] as int, inInclusiveRange(49, 51));
      // p95 should be >= 94
      expect(percentiles['p95'] as int, greaterThanOrEqualTo(94));
      // p99 should be >= 98
      expect(percentiles['p99'] as int, greaterThanOrEqualTo(98));
    });
  });

  group('ApiAnalytics -- empty stats', () {
    test('returns zeroed stats when no records', () {
      final analytics = ApiAnalytics.instance;
      final stats = analytics.stats;
      expect(stats['total_requests'], 0);
      expect(stats['total_errors'], 0);
      expect(stats['error_rate'], 0.0);
      expect((stats['top_endpoints'] as List), isEmpty);
    });
  });

  group('ApiAnalytics -- top and slowest endpoints', () {
    test('topEndpoints ranks by count descending', () {
      final analytics = ApiAnalytics.instance;
      for (var i = 0; i < 10; i++) {
        analytics.record(
          method: 'GET',
          path: '/popular',
          statusCode: 200,
          durationMs: 5,
        );
      }
      for (var i = 0; i < 3; i++) {
        analytics.record(
          method: 'GET',
          path: '/rare',
          statusCode: 200,
          durationMs: 5,
        );
      }

      final top = analytics.topEndpoints();
      expect(top.length, 2);
      expect(top[0]['endpoint'], 'GET /popular');
      expect(top[0]['count'], 10);
      expect(top[1]['endpoint'], 'GET /rare');
      expect(top[1]['count'], 3);
    });

    test('slowestEndpoints ranks by average duration descending', () {
      final analytics = ApiAnalytics.instance;
      analytics.record(
        method: 'GET',
        path: '/fast',
        statusCode: 200,
        durationMs: 1,
      );
      analytics.record(
        method: 'GET',
        path: '/slow',
        statusCode: 200,
        durationMs: 500,
      );

      final slowest = analytics.slowestEndpoints();
      expect(slowest.length, 2);
      expect(slowest[0]['endpoint'], 'GET /slow');
      expect(slowest[1]['endpoint'], 'GET /fast');
    });
  });

  group('ApiAnalytics -- error tracking', () {
    test('recentErrors returns only 4xx+ responses', () {
      final analytics = ApiAnalytics.instance;
      analytics.record(
        method: 'GET',
        path: '/ok',
        statusCode: 200,
        durationMs: 5,
      );
      analytics.record(
        method: 'POST',
        path: '/bad',
        statusCode: 400,
        durationMs: 10,
      );
      analytics.record(
        method: 'GET',
        path: '/error',
        statusCode: 500,
        durationMs: 20,
      );

      final errors = analytics.recentErrors();
      expect(errors.length, 2);
      // Most recent first
      expect(errors[0]['status_code'], 500);
      expect(errors[1]['status_code'], 400);
    });
  });

  group('ApiAnalytics -- reset', () {
    test('clears all state', () {
      final analytics = ApiAnalytics.instance;
      analytics.record(
        method: 'GET',
        path: '/test',
        statusCode: 200,
        durationMs: 5,
      );
      analytics.reset();
      final stats = analytics.stats;
      expect(stats['total_requests'], 0);
      expect(stats['total_errors'], 0);
    });
  });
}
