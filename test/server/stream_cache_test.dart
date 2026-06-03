// Tests for StreamCache: put/get, eviction on overflow, TTL expiry,
// invalidation, clear.
// Ported from tune-core/src/streaming/stream_cache.rs
//
// Run with : flutter test test/server/stream_cache_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:tune_server/server/streaming/stream_cache.dart';

void main() {
  group('StreamCache -- put and get', () {
    test('stores and retrieves a value', () {
      final cache = StreamCache<String>(
        maxSize: 100,
        defaultTtl: const Duration(seconds: 60),
      );
      cache.put('t1', 'http://example.com/stream');
      expect(cache.get('t1'), 'http://example.com/stream');
      cache.dispose();
    });
  });

  group('StreamCache -- miss', () {
    test('returns null for unknown key', () {
      final cache = StreamCache<String>(
        maxSize: 100,
        defaultTtl: const Duration(seconds: 60),
      );
      expect(cache.get('unknown'), isNull);
      cache.dispose();
    });
  });

  group('StreamCache -- remove', () {
    test('remove deletes entry', () {
      final cache = StreamCache<String>(
        maxSize: 100,
        defaultTtl: const Duration(seconds: 60),
      );
      cache.put('t1', 'http://a.com');
      cache.remove('t1');
      expect(cache.get('t1'), isNull);
      expect(cache.isEmpty, isTrue);
      cache.dispose();
    });
  });

  group('StreamCache -- clear', () {
    test('removes all entries', () {
      final cache = StreamCache<String>(
        maxSize: 100,
        defaultTtl: const Duration(seconds: 60),
      );
      cache.put('t1', 'http://a.com');
      cache.put('t2', 'http://b.com');
      expect(cache.size, 2);
      cache.clear();
      expect(cache.isEmpty, isTrue);
      cache.dispose();
    });
  });

  group('StreamCache -- eviction on overflow', () {
    test('evicts oldest entry when max size exceeded', () {
      final cache = StreamCache<String>(
        maxSize: 2,
        defaultTtl: const Duration(seconds: 60),
      );
      cache.put('t1', 'http://a.com');
      cache.put('t2', 'http://b.com');
      cache.put('t3', 'http://c.com');
      expect(cache.size, 2);
      // t1 was the oldest (LRU), should have been evicted
      expect(cache.get('t1'), isNull);
      expect(cache.get('t2'), isNotNull);
      expect(cache.get('t3'), isNotNull);
      cache.dispose();
    });
  });

  group('StreamCache -- TTL expiry', () {
    test('expired entry returns null', () async {
      final cache = StreamCache<String>(
        maxSize: 100,
        defaultTtl: const Duration(milliseconds: 1),
      );
      cache.put('t1', 'http://a.com', ttl: Duration.zero);
      // Wait a tiny bit for the entry to expire
      await Future<void>.delayed(const Duration(milliseconds: 10));
      expect(cache.get('t1'), isNull);
      cache.dispose();
    });
  });

  group('StreamCache -- update existing', () {
    test('updating existing key keeps size at 1', () {
      final cache = StreamCache<String>(
        maxSize: 100,
        defaultTtl: const Duration(seconds: 60),
      );
      cache.put('t1', 'http://a.com');
      cache.put('t1', 'http://b.com');
      expect(cache.size, 1);
      expect(cache.get('t1'), 'http://b.com');
      cache.dispose();
    });
  });

  group('StreamCache -- containsKey', () {
    test('returns true for existing non-expired key', () {
      final cache = StreamCache<String>(
        maxSize: 100,
        defaultTtl: const Duration(seconds: 60),
      );
      cache.put('t1', 'http://a.com');
      expect(cache.containsKey('t1'), isTrue);
      expect(cache.containsKey('t2'), isFalse);
      cache.dispose();
    });
  });

  group('StreamCache -- getOrCompute', () {
    test('computes and caches on miss', () async {
      final cache = StreamCache<String>(
        maxSize: 100,
        defaultTtl: const Duration(seconds: 60),
      );
      var computeCount = 0;
      final value = await cache.getOrCompute('key1', () async {
        computeCount++;
        return 'computed';
      });
      expect(value, 'computed');
      expect(computeCount, 1);

      // Second call should use cache, not recompute
      final value2 = await cache.getOrCompute('key1', () async {
        computeCount++;
        return 'recomputed';
      });
      expect(value2, 'computed');
      expect(computeCount, 1);
      cache.dispose();
    });
  });

  group('StreamCache -- stats', () {
    test('reports size and maxSize', () {
      final cache = StreamCache<String>(
        maxSize: 500,
        defaultTtl: const Duration(minutes: 30),
      );
      cache.put('a', 'x');
      cache.put('b', 'y');
      final s = cache.stats;
      expect(s['size'], 2);
      expect(s['max_size'], 500);
      expect(s['ttl_seconds'], 1800);
      cache.dispose();
    });
  });
}
