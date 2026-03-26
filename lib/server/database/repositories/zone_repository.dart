import 'package:drift/drift.dart';

import '../database.dart';

// ---------------------------------------------------------------------------
// T1.7 — ZoneRepository
// CRUD simple sur les zones persistées en DB.
// L'état runtime (playback, currentTrack…) est géré par ZoneInstance (Phase 5).
// Miroir de ZoneRepository.swift (GRDB)
// ---------------------------------------------------------------------------

class ZoneRepository {
  final TuneDatabase _db;

  const ZoneRepository(this._db);

  // ---------------------------------------------------------------------------
  // CRUD
  // ---------------------------------------------------------------------------

  Future<Zone?> byId(int id) =>
      (_db.select(_db.zones)..where((z) => z.id.equals(id))).getSingleOrNull();

  Future<List<Zone>> all() =>
      (_db.select(_db.zones)
            ..orderBy([
              (z) => OrderingTerm(expression: z.name, mode: OrderingMode.asc),
            ]))
          .get();

  Future<int> insert(ZonesCompanion companion) =>
      _db.into(_db.zones).insert(companion);

  Future<bool> update(Zone zone) =>
      _db.update(_db.zones).replace(zone);

  Future<int> delete(int id) =>
      (_db.delete(_db.zones)..where((z) => z.id.equals(id))).go();

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  /// Renomme une zone.
  Future<void> rename(int zoneId, String newName) async {
    await (_db.update(_db.zones)..where((z) => z.id.equals(zoneId)))
        .write(ZonesCompanion(name: Value(newName)));
  }

  /// Met à jour uniquement le volume persisté d'une zone.
  Future<void> setVolume(int zoneId, double volume) async {
    await (_db.update(_db.zones)..where((z) => z.id.equals(zoneId)))
        .write(ZonesCompanion(volume: Value(volume)));
  }

  /// Met à jour l'output (type + deviceId) d'une zone.
  Future<void> setOutput(
      int zoneId, String? outputType, String? outputDeviceId) async {
    await (_db.update(_db.zones)..where((z) => z.id.equals(zoneId))).write(
      ZonesCompanion(
        outputType: Value(outputType),
        outputDeviceId: Value(outputDeviceId),
      ),
    );
  }
}
