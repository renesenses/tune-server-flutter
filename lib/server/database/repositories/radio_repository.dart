import 'dart:io';

import 'package:drift/drift.dart';

import '../database.dart';

// ---------------------------------------------------------------------------
// T1.8 — RadioRepository
// CRUD + all — miroir de RadioRepository.swift (GRDB)
// T8.2 — Import/export M3U
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

  // ---------------------------------------------------------------------------
  // T8.2 — Import / Export M3U
  // ---------------------------------------------------------------------------

  /// Importe les stations depuis un fichier M3U.
  /// Retourne le nombre de stations ajoutées.
  Future<int> importM3U(String filePath) async {
    final file = File(filePath);
    if (!await file.exists()) return 0;

    final lines = await file.readAsLines();
    final stations = _parseM3U(lines);
    int added = 0;

    for (final station in stations) {
      // Déduplique par URL de stream
      final existing = await (_db.select(_db.radios)
            ..where((r) => r.streamUrl.equals(station.streamUrl)))
          .getSingleOrNull();
      if (existing != null) continue;

      await _db.into(_db.radios).insert(
            RadiosCompanion.insert(
              name: station.name,
              streamUrl: station.streamUrl,
              genre: Value(station.genre),
              tags: Value(station.tags),
            ),
          );
      added++;
    }
    return added;
  }

  /// Exporte toutes les stations en format M3U étendu.
  Future<String> exportM3U({bool favoritesOnly = false}) async {
    final stations =
        favoritesOnly ? await favorites() : await all();

    final buffer = StringBuffer();
    buffer.writeln('#EXTM3U');

    for (final station in stations) {
      // #EXTINF:-1 tvg-logo="url" group-title="genre",Name
      final logo = station.logoUrl != null ? ' tvg-logo="${station.logoUrl}"' : '';
      final group =
          station.genre != null ? ' group-title="${station.genre}"' : '';
      buffer.writeln('#EXTINF:-1$logo$group,${station.name}');
      buffer.writeln(station.streamUrl);
    }

    return buffer.toString();
  }

  /// Écrit le M3U exporté dans [outputPath].
  Future<void> exportM3UToFile(
    String outputPath, {
    bool favoritesOnly = false,
  }) async {
    final content = await exportM3U(favoritesOnly: favoritesOnly);
    await File(outputPath).writeAsString(content);
  }

  // ---------------------------------------------------------------------------
  // Parser M3U interne
  // ---------------------------------------------------------------------------

  List<_M3UEntry> _parseM3U(List<String> lines) {
    final entries = <_M3UEntry>[];
    String? pendingName;
    String? pendingGenre;
    String? pendingLogoUrl;

    for (final raw in lines) {
      final line = raw.trim();
      if (line.isEmpty || line == '#EXTM3U') continue;

      if (line.startsWith('#EXTINF:')) {
        // #EXTINF:-1 tvg-logo="url" group-title="genre",Name
        pendingName = _extractM3UName(line);
        pendingGenre = _extractM3UAttribute(line, 'group-title');
        pendingLogoUrl = _extractM3UAttribute(line, 'tvg-logo');
      } else if (!line.startsWith('#')) {
        // URL de stream
        final url = line;
        final name = pendingName ?? Uri.parse(url).host;
        entries.add(_M3UEntry(
          name: name,
          streamUrl: url,
          genre: pendingGenre,
          logoUrl: pendingLogoUrl,
          tags: pendingGenre,
        ));
        pendingName = null;
        pendingGenre = null;
        pendingLogoUrl = null;
      }
    }
    return entries;
  }

  String _extractM3UName(String extinf) {
    final comma = extinf.lastIndexOf(',');
    if (comma < 0) return 'Radio';
    return extinf.substring(comma + 1).trim();
  }

  String? _extractM3UAttribute(String line, String attr) {
    final pattern = RegExp('$attr="([^"]*)"');
    return pattern.firstMatch(line)?.group(1);
  }
}

class _M3UEntry {
  final String name;
  final String streamUrl;
  final String? genre;
  final String? logoUrl;
  final String? tags;
  const _M3UEntry({
    required this.name,
    required this.streamUrl,
    this.genre,
    this.logoUrl,
    this.tags,
  });
}
