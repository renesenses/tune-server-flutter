import 'package:drift/drift.dart';

import '../../../models/domain_models.dart';
import '../database.dart';

// ---------------------------------------------------------------------------
// T1.4 — AlbumRepository
// CRUD + forArtist, search FTS5, count, all
// Miroir de AlbumRepository.swift (GRDB)
// ---------------------------------------------------------------------------

class AlbumRepository {
  final TuneDatabase _db;

  const AlbumRepository(this._db);

  // ---------------------------------------------------------------------------
  // CRUD
  // ---------------------------------------------------------------------------

  Future<Album?> byId(int id) =>
      (_db.select(_db.albums)..where((a) => a.id.equals(id))).getSingleOrNull();

  Future<int> insert(AlbumsCompanion companion) =>
      _db.into(_db.albums).insert(companion);

  Future<bool> update(Album album) =>
      _db.update(_db.albums).replace(album);

  Future<int> delete(int id) =>
      (_db.delete(_db.albums)..where((a) => a.id.equals(id))).go();

  // ---------------------------------------------------------------------------
  // Requêtes métier
  // ---------------------------------------------------------------------------

  Future<List<Album>> all() =>
      (_db.select(_db.albums)
            ..orderBy([
              (a) => OrderingTerm(expression: a.title, mode: OrderingMode.asc),
            ]))
          .get();

  Future<List<Album>> recent({int limit = 30}) =>
      (_db.select(_db.albums)
            ..orderBy([
              (a) => OrderingTerm(expression: a.id, mode: OrderingMode.desc),
            ])
            ..limit(limit))
          .get();

  Future<List<Album>> forArtist(int artistId) =>
      (_db.select(_db.albums)
            ..where((a) => a.artistId.equals(artistId))
            ..orderBy([
              (a) => OrderingTerm(expression: a.year, mode: OrderingMode.desc),
              (a) => OrderingTerm(expression: a.title, mode: OrderingMode.asc),
            ]))
          .get();

  /// Recherche FTS5 sur title et artist_name.
  Future<List<Album>> search(String query, {int limit = 100}) async {
    final q = _sanitizeFts(query);
    if (q.isEmpty) return [];

    final rows = await _db
        .customSelect(
          'SELECT a.* FROM albums a '
          'INNER JOIN albums_fts ON albums_fts.rowid = a.id '
          'WHERE albums_fts MATCH ? '
          'ORDER BY albums_fts.rank '
          'LIMIT ?',
          variables: [Variable(q), Variable(limit)],
          readsFrom: {_db.albums},
        )
        .get();
    return Future.wait(rows.map((row) => _db.albums.mapFromRow(row)));
  }

  Future<int> count() async {
    final result = await _db
        .customSelect('SELECT COUNT(*) AS c FROM albums')
        .getSingle();
    return result.read<int>('c');
  }

  // ---------------------------------------------------------------------------
  // Audio quality info per album (derived from tracks)
  // ---------------------------------------------------------------------------

  /// Returns a map of albumId -> AlbumAudioInfo with format, sample rate,
  /// bit depth, and computed quality for each album.
  Future<Map<int, AlbumAudioInfo>> allAudioInfo() async {
    final rows = await _db.customSelect(
      '''
      SELECT
        album_id,
        format,
        MAX(sample_rate) AS max_sample_rate,
        MAX(bit_depth) AS max_bit_depth,
        COUNT(*) AS track_count
      FROM tracks
      WHERE album_id IS NOT NULL
      GROUP BY album_id
      ''',
      readsFrom: {_db.tracks},
    ).get();

    final map = <int, AlbumAudioInfo>{};
    for (final row in rows) {
      final albumId = row.read<int>('album_id');
      final format = row.readNullable<String>('format');
      final sampleRate = row.readNullable<int>('max_sample_rate');
      final bitDepth = row.readNullable<int>('max_bit_depth');

      map[albumId] = AlbumAudioInfo(
        albumId: albumId,
        format: format,
        sampleRate: sampleRate,
        bitDepth: bitDepth,
        quality: AlbumAudioInfo.computeQuality(format, sampleRate, bitDepth),
      );
    }
    return map;
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  String _sanitizeFts(String input) {
    final trimmed = input.trim().replaceAll('"', '');
    if (trimmed.isEmpty) return '';
    return '"$trimmed"*';
  }
}
