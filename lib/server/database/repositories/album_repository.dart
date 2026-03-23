import 'package:drift/drift.dart';

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

    return _db
        .customSelect(
          'SELECT a.* FROM albums a '
          'INNER JOIN albums_fts ON albums_fts.rowid = a.id '
          'WHERE albums_fts MATCH ? '
          'ORDER BY albums_fts.rank '
          'LIMIT ?',
          variables: [Variable(q), Variable(limit)],
          readsFrom: {_db.albums},
        )
        .map((row) => _db.albums.mapFromRow(row))
        .get();
  }

  Future<int> count() async {
    final result = await _db
        .customSelect('SELECT COUNT(*) AS c FROM albums')
        .getSingle();
    return result.read<int>('c');
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
