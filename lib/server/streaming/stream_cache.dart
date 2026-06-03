import 'dart:async';

// ---------------------------------------------------------------------------
// StreamCache
// In-memory URL cache with TTL and max size eviction.
// Miroir de stream_cache.rs (Rust)
// ---------------------------------------------------------------------------

/// A cached entry with value and expiry timestamp.
class _CacheEntry<V> {
  final V value;
  final DateTime expiresAt;
  DateTime lastAccessedAt;

  _CacheEntry({
    required this.value,
    required this.expiresAt,
  }) : lastAccessedAt = DateTime.now();

  bool get isExpired => DateTime.now().isAfter(expiresAt);
}

class StreamCache<V> {
  final Map<String, _CacheEntry<V>> _cache = {};
  final int _maxSize;
  final Duration _defaultTtl;
  Timer? _cleanupTimer;

  /// Creates a stream cache.
  /// [maxSize] : maximum number of entries before LRU eviction.
  /// [defaultTtl] : time-to-live for entries (default 30 min).
  StreamCache({
    int maxSize = 500,
    Duration defaultTtl = const Duration(minutes: 30),
  })  : _maxSize = maxSize,
        _defaultTtl = defaultTtl {
    // Periodic cleanup every 5 minutes
    _cleanupTimer = Timer.periodic(
      const Duration(minutes: 5),
      (_) => _evictExpired(),
    );
  }

  // ---------------------------------------------------------------------------
  // CRUD
  // ---------------------------------------------------------------------------

  /// Store a value with optional custom TTL.
  void put(String key, V value, {Duration? ttl}) {
    // Evict if at capacity
    if (_cache.length >= _maxSize && !_cache.containsKey(key)) {
      _evictLru();
    }

    _cache[key] = _CacheEntry(
      value: value,
      expiresAt: DateTime.now().add(ttl ?? _defaultTtl),
    );
  }

  /// Get a value. Returns null if not found or expired.
  V? get(String key) {
    final entry = _cache[key];
    if (entry == null) return null;

    if (entry.isExpired) {
      _cache.remove(key);
      return null;
    }

    // Update last access time for LRU
    entry.lastAccessedAt = DateTime.now();
    return entry.value;
  }

  /// Check if a key exists and is not expired.
  bool containsKey(String key) {
    final entry = _cache[key];
    if (entry == null) return false;
    if (entry.isExpired) {
      _cache.remove(key);
      return false;
    }
    return true;
  }

  /// Remove an entry.
  V? remove(String key) {
    final entry = _cache.remove(key);
    return entry?.value;
  }

  /// Clear all entries.
  void clear() => _cache.clear();

  // ---------------------------------------------------------------------------
  // Stats
  // ---------------------------------------------------------------------------

  int get size => _cache.length;
  int get maxSize => _maxSize;
  bool get isEmpty => _cache.isEmpty;

  Map<String, dynamic> get stats => {
        'size': _cache.length,
        'max_size': _maxSize,
        'ttl_seconds': _defaultTtl.inSeconds,
      };

  // ---------------------------------------------------------------------------
  // Get or compute
  // ---------------------------------------------------------------------------

  /// Get a value, or compute and cache it if missing.
  Future<V> getOrCompute(
    String key,
    Future<V> Function() compute, {
    Duration? ttl,
  }) async {
    final existing = get(key);
    if (existing != null) return existing;

    final value = await compute();
    put(key, value, ttl: ttl);
    return value;
  }

  // ---------------------------------------------------------------------------
  // Eviction
  // ---------------------------------------------------------------------------

  /// Remove all expired entries.
  void _evictExpired() {
    _cache.removeWhere((_, entry) => entry.isExpired);
  }

  /// Evict the least recently used entry.
  void _evictLru() {
    if (_cache.isEmpty) return;

    String? oldestKey;
    DateTime? oldestAccess;

    for (final entry in _cache.entries) {
      if (entry.value.isExpired) {
        _cache.remove(entry.key);
        return;
      }
      if (oldestAccess == null || entry.value.lastAccessedAt.isBefore(oldestAccess)) {
        oldestKey = entry.key;
        oldestAccess = entry.value.lastAccessedAt;
      }
    }

    if (oldestKey != null) {
      _cache.remove(oldestKey);
    }
  }

  // ---------------------------------------------------------------------------
  // Dispose
  // ---------------------------------------------------------------------------

  void dispose() {
    _cleanupTimer?.cancel();
    _cleanupTimer = null;
    _cache.clear();
  }
}
