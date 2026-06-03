import 'package:drift/drift.dart';

import '../database.dart';

// ---------------------------------------------------------------------------
// SettingsRepository
// Key-value settings store (get/set/delete/all)
// Miroir de settings_repository.rs (Rust)
// ---------------------------------------------------------------------------

class SettingsRepository {
  final TuneDatabase _db;

  const SettingsRepository(this._db);

  // ---------------------------------------------------------------------------
  // CRUD
  // ---------------------------------------------------------------------------

  /// Get a setting value by key.
  Future<String?> get(String key) async {
    final row = await (_db.select(_db.settings)
          ..where((s) => s.key.equals(key)))
        .getSingleOrNull();
    return row?.value;
  }

  /// Set a setting value (upsert).
  Future<void> set(String key, String value) async {
    final now = DateTime.now().toIso8601String();
    await _db.into(_db.settings).insertOnConflictUpdate(
      SettingsCompanion.insert(
        key: key,
        value: value,
        updatedAt: now,
      ),
    );
  }

  /// Delete a setting.
  Future<int> delete(String key) =>
      (_db.delete(_db.settings)..where((s) => s.key.equals(key))).go();

  /// Get all settings as a map.
  Future<Map<String, String>> all() async {
    final rows = await (_db.select(_db.settings)).get();
    return {for (final row in rows) row.key: row.value};
  }

  /// Get multiple settings by keys.
  Future<Map<String, String>> getMultiple(List<String> keys) async {
    if (keys.isEmpty) return {};
    final rows = await (_db.select(_db.settings)
          ..where((s) => s.key.isIn(keys)))
        .get();
    return {for (final row in rows) row.key: row.value};
  }

  /// Count all settings.
  Future<int> count() async {
    final result = await _db
        .customSelect('SELECT COUNT(*) AS c FROM settings')
        .getSingle();
    return result.read<int>('c');
  }
}
