import 'package:drift/drift.dart';

import '../database.dart';

// ---------------------------------------------------------------------------
// T1.5 — ArtistRepository
// CRUD + search FTS5, count, all
// Miroir de ArtistRepository.swift (GRDB)
// ---------------------------------------------------------------------------

class ArtistRepository {
  final TuneDatabase _db;

  const ArtistRepository(this._db);

  // ---------------------------------------------------------------------------
  // CRUD
  // ---------------------------------------------------------------------------

  Future<Artist?> byId(int id) =>
      (_db.select(_db.artists)..where((a) => a.id.equals(id)))
          .getSingleOrNull();

  Future<Artist?> byName(String name) =>
      (_db.select(_db.artists)..where((a) => a.name.equals(name)))
          .getSingleOrNull();

  Future<int> insert(ArtistsCompanion companion) =>
      _db.into(_db.artists).insert(companion);

  Future<bool> update(Artist artist) =>
      _db.update(_db.artists).replace(artist);

  Future<int> delete(int id) =>
      (_db.delete(_db.artists)..where((a) => a.id.equals(id))).go();

  // ---------------------------------------------------------------------------
  // Requêtes métier
  // ---------------------------------------------------------------------------

  Future<List<Artist>> all() =>
      (_db.select(_db.artists)
            ..orderBy([
              (a) => OrderingTerm(
                    expression: coalesce([a.sortName, a.name]),
                    mode: OrderingMode.asc,
                  ),
            ]))
          .get();

  /// Recherche FTS5 sur le nom d'artiste.
  Future<List<Artist>> search(String query, {int limit = 100}) async {
    final q = _sanitizeFts(query);
    if (q.isEmpty) return [];

    final rows = await _db
        .customSelect(
          'SELECT a.* FROM artists a '
          'INNER JOIN artists_fts ON artists_fts.rowid = a.id '
          'WHERE artists_fts MATCH ? '
          'ORDER BY artists_fts.rank '
          'LIMIT ?',
          variables: [Variable(q), Variable(limit)],
          readsFrom: {_db.artists},
        )
        .get();
    return Future.wait(rows.map((row) => _db.artists.mapFromRow(row)));
  }

  Future<int> count() async {
    final result = await _db
        .customSelect('SELECT COUNT(*) AS c FROM artists')
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
