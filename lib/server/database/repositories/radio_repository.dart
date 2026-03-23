import 'package:drift/drift.dart';

import '../database.dart';

// ---------------------------------------------------------------------------
// T1.8 — RadioRepository
// CRUD + all — miroir de RadioRepository.swift (GRDB)
// Import/export M3U traité en Phase 8.
// ---------------------------------------------------------------------------

class RadioRepository {
  final TuneDatabase _db;

  const RadioRepository(this._db);

  // ---------------------------------------------------------------------------
  // CRUD
  // ---------------------------------------------------------------------------

  Future<Radio?> byId(int id) =>
      (_db.select(_db.radios)..where((r) => r.id.equals(id))).getSingleOrNull();

  Future<List<Radio>> all() =>
      (_db.select(_db.radios)
            ..orderBy([
              (r) => OrderingTerm(expression: r.name, mode: OrderingMode.asc),
            ]))
          .get();

  Future<List<Radio>> favorites() =>
      (_db.select(_db.radios)
            ..where((r) => r.favorite.equals(true))
            ..orderBy([
              (r) => OrderingTerm(expression: r.name, mode: OrderingMode.asc),
            ]))
          .get();

  Future<int> insert(RadiosCompanion companion) =>
      _db.into(_db.radios).insert(companion);

  Future<bool> update(Radio radio) =>
      _db.update(_db.radios).replace(radio);

  Future<int> delete(int id) =>
      (_db.delete(_db.radios)..where((r) => r.id.equals(id))).go();

  // ---------------------------------------------------------------------------
  // Favoris radio
  // ---------------------------------------------------------------------------

  Future<void> setFavorite(int id, {required bool favorite}) async {
    await (_db.update(_db.radios)..where((r) => r.id.equals(id)))
        .write(RadiosCompanion(favorite: Value(favorite)));
  }

  // ---------------------------------------------------------------------------
  // RadioFavorites (historique des morceaux favoris sur une radio)
  // ---------------------------------------------------------------------------

  Future<List<RadioFavorite>> allFavorites() =>
      (_db.select(_db.radioFavorites)
            ..orderBy([
              (f) => OrderingTerm(expression: f.savedAt, mode: OrderingMode.desc),
            ]))
          .get();

  Future<int> insertFavorite(RadioFavoritesCompanion companion) =>
      _db.into(_db.radioFavorites).insert(companion);

  Future<int> deleteFavorite(int id) =>
      (_db.delete(_db.radioFavorites)..where((f) => f.id.equals(id))).go();
}
