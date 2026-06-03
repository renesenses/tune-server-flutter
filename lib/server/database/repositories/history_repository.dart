import 'package:drift/drift.dart';

import '../database.dart';

// ---------------------------------------------------------------------------
// HistoryRepository
// Listen history — record plays, recent paginated, top tracks/artists/albums,
// full dashboard with trends, hourly distribution, by-zone, by-source,
// completion stats.
// Miroir de history_repository.rs (Rust)
// ---------------------------------------------------------------------------

class HistoryRepository {
  final TuneDatabase _db;

  const HistoryRepository(this._db);

  // ---------------------------------------------------------------------------
  // Record a listen
  // ---------------------------------------------------------------------------

  Future<int> record({
    required int trackId,
    required String title,
    String? artistName,
    String? albumTitle,
    String source = 'local',
    int? durationMs,
    String? zoneId,
  }) async {
    return _db.into(_db.listenHistory).insert(ListenHistoryCompanion.insert(
      trackId: trackId,
      title: title,
      artistName: Value(artistName),
      albumTitle: Value(albumTitle),
      source: Value(source),
      durationMs: Value(durationMs),
      listenedAt: DateTime.now().toIso8601String(),
      zoneId: Value(zoneId),
    ));
  }

  // ---------------------------------------------------------------------------
  // Recent history (paginated)
  // ---------------------------------------------------------------------------

  Future<List<ListenHistoryData>> recent({int limit = 50, int offset = 0}) =>
      (_db.select(_db.listenHistory)
            ..orderBy([
              (h) => OrderingTerm(expression: h.listenedAt, mode: OrderingMode.desc),
            ])
            ..limit(limit, offset: offset))
          .get();

  // ---------------------------------------------------------------------------
  // Top tracks
  // ---------------------------------------------------------------------------

  Future<List<Map<String, dynamic>>> topTracks({
    int limit = 20,
    String? since,
  }) async {
    final whereClause = since != null ? 'WHERE listened_at >= ?' : '';
    final vars = <Variable>[
      if (since != null) Variable(since),
      Variable(limit),
    ];

    final rows = await _db.customSelect(
      'SELECT track_id, title, artist_name, COUNT(*) AS play_count '
      'FROM listen_history '
      '$whereClause '
      'GROUP BY track_id '
      'ORDER BY play_count DESC '
      'LIMIT ?',
      variables: vars,
      readsFrom: {_db.listenHistory},
    ).get();

    return rows.map((row) => {
      'track_id': row.read<int>('track_id'),
      'title': row.read<String>('title'),
      'artist_name': row.readNullable<String>('artist_name'),
      'play_count': row.read<int>('play_count'),
    }).toList();
  }

  // ---------------------------------------------------------------------------
  // Top artists
  // ---------------------------------------------------------------------------

  Future<List<Map<String, dynamic>>> topArtists({
    int limit = 20,
    String? since,
  }) async {
    final whereClause = since != null
        ? "WHERE listened_at >= ? AND artist_name IS NOT NULL AND artist_name != ''"
        : "WHERE artist_name IS NOT NULL AND artist_name != ''";
    final vars = <Variable>[
      if (since != null) Variable(since),
      Variable(limit),
    ];

    final rows = await _db.customSelect(
      'SELECT artist_name, COUNT(*) AS play_count '
      'FROM listen_history '
      '$whereClause '
      'GROUP BY artist_name '
      'ORDER BY play_count DESC '
      'LIMIT ?',
      variables: vars,
      readsFrom: {_db.listenHistory},
    ).get();

    return rows.map((row) => {
      'artist_name': row.read<String>('artist_name'),
      'play_count': row.read<int>('play_count'),
    }).toList();
  }

  // ---------------------------------------------------------------------------
  // Top albums
  // ---------------------------------------------------------------------------

  Future<List<Map<String, dynamic>>> topAlbums({
    int limit = 20,
    String? since,
  }) async {
    final whereClause = since != null
        ? "WHERE listened_at >= ? AND album_title IS NOT NULL AND album_title != ''"
        : "WHERE album_title IS NOT NULL AND album_title != ''";
    final vars = <Variable>[
      if (since != null) Variable(since),
      Variable(limit),
    ];

    final rows = await _db.customSelect(
      'SELECT album_title, artist_name, COUNT(*) AS play_count '
      'FROM listen_history '
      '$whereClause '
      'GROUP BY album_title, artist_name '
      'ORDER BY play_count DESC '
      'LIMIT ?',
      variables: vars,
      readsFrom: {_db.listenHistory},
    ).get();

    return rows.map((row) => {
      'album_title': row.read<String>('album_title'),
      'artist_name': row.readNullable<String>('artist_name'),
      'play_count': row.read<int>('play_count'),
    }).toList();
  }

  // ---------------------------------------------------------------------------
  // Dashboard — full stats
  // ---------------------------------------------------------------------------

  /// Returns a complete dashboard with multiple stat dimensions.
  Future<Map<String, dynamic>> dashboard({String? since}) async {
    final topT = await topTracks(limit: 10, since: since);
    final topAr = await topArtists(limit: 10, since: since);
    final topAl = await topAlbums(limit: 10, since: since);
    final hourly = await _hourlyDistribution(since: since);
    final byZone = await _byZone(since: since);
    final bySource = await _bySource(since: since);
    final totalCount = await count(since: since);
    final totalDuration = await _totalDurationMs(since: since);

    return {
      'total_listens': totalCount,
      'total_duration_ms': totalDuration,
      'top_tracks': topT,
      'top_artists': topAr,
      'top_albums': topAl,
      'hourly_distribution': hourly,
      'by_zone': byZone,
      'by_source': bySource,
    };
  }

  /// Hourly distribution (0-23) of listens.
  Future<List<Map<String, dynamic>>> _hourlyDistribution({String? since}) async {
    final whereClause = since != null ? 'WHERE listened_at >= ?' : '';
    final vars = <Variable>[if (since != null) Variable(since)];

    final rows = await _db.customSelect(
      "SELECT CAST(strftime('%H', listened_at) AS INTEGER) AS hour, "
      'COUNT(*) AS count '
      'FROM listen_history '
      '$whereClause '
      'GROUP BY hour '
      'ORDER BY hour',
      variables: vars,
      readsFrom: {_db.listenHistory},
    ).get();

    return rows.map((row) => {
      'hour': row.read<int>('hour'),
      'count': row.read<int>('count'),
    }).toList();
  }

  /// Listens grouped by zone.
  Future<List<Map<String, dynamic>>> _byZone({String? since}) async {
    final whereClause = since != null
        ? 'WHERE listened_at >= ? AND zone_id IS NOT NULL'
        : 'WHERE zone_id IS NOT NULL';
    final vars = <Variable>[if (since != null) Variable(since)];

    final rows = await _db.customSelect(
      'SELECT zone_id, COUNT(*) AS count '
      'FROM listen_history '
      '$whereClause '
      'GROUP BY zone_id '
      'ORDER BY count DESC',
      variables: vars,
      readsFrom: {_db.listenHistory},
    ).get();

    return rows.map((row) => {
      'zone_id': row.read<String>('zone_id'),
      'count': row.read<int>('count'),
    }).toList();
  }

  /// Listens grouped by source.
  Future<List<Map<String, dynamic>>> _bySource({String? since}) async {
    final whereClause = since != null ? 'WHERE listened_at >= ?' : '';
    final vars = <Variable>[if (since != null) Variable(since)];

    final rows = await _db.customSelect(
      'SELECT source, COUNT(*) AS count '
      'FROM listen_history '
      '$whereClause '
      'GROUP BY source '
      'ORDER BY count DESC',
      variables: vars,
      readsFrom: {_db.listenHistory},
    ).get();

    return rows.map((row) => {
      'source': row.read<String>('source'),
      'count': row.read<int>('count'),
    }).toList();
  }

  // ---------------------------------------------------------------------------
  // Aggregates
  // ---------------------------------------------------------------------------

  Future<int> count({String? since}) async {
    final whereClause = since != null ? 'WHERE listened_at >= ?' : '';
    final vars = <Variable>[if (since != null) Variable(since)];

    final result = await _db.customSelect(
      'SELECT COUNT(*) AS c FROM listen_history $whereClause',
      variables: vars,
    ).getSingle();
    return result.read<int>('c');
  }

  Future<int> _totalDurationMs({String? since}) async {
    final whereClause = since != null ? 'WHERE listened_at >= ?' : '';
    final vars = <Variable>[if (since != null) Variable(since)];

    final result = await _db.customSelect(
      'SELECT COALESCE(SUM(duration_ms), 0) AS total FROM listen_history $whereClause',
      variables: vars,
    ).getSingle();
    return result.read<int>('total');
  }

  // ---------------------------------------------------------------------------
  // Cleanup
  // ---------------------------------------------------------------------------

  /// Delete history older than [days] days.
  Future<int> deleteOlderThan(int days) async {
    final cutoff = DateTime.now()
        .subtract(Duration(days: days))
        .toIso8601String();
    return (_db.delete(_db.listenHistory)
          ..where((h) => h.listenedAt.isSmallerThanValue(cutoff)))
        .go();
  }
}
