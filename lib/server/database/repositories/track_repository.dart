import 'package:drift/drift.dart';

import '../database.dart';

// ---------------------------------------------------------------------------
// T1.3 — TrackRepository
// CRUD + forAlbum, forArtist, search FTS5, count
// Miroir de TrackRepository.swift (GRDB)
// ---------------------------------------------------------------------------

class TrackRepository {
  final TuneDatabase _db;

  const TrackRepository(this._db);

  // ---------------------------------------------------------------------------
  // CRUD
  // ---------------------------------------------------------------------------

  Future<Track?> byId(int id) =>
      (_db.select(_db.tracks)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<Track?> byFilePath(String path) =>
      (_db.select(_db.tracks)..where((t) => t.filePath.equals(path)))
          .getSingleOrNull();

  Future<int> insert(TracksCompanion companion) =>
      _db.into(_db.tracks).insert(companion);

  Future<bool> update(Track track) =>
      _db.update(_db.tracks).replace(track);

  Future<int> delete(int id) =>
      (_db.delete(_db.tracks)..where((t) => t.id.equals(id))).go();

  // ---------------------------------------------------------------------------
  // Requêtes métier
  // ---------------------------------------------------------------------------

  Future<List<Track>> forAlbum(int albumId) =>
      (_db.select(_db.tracks)
            ..where((t) => t.albumId.equals(albumId))
            ..orderBy([
              (t) => OrderingTerm(expression: t.discNumber, mode: OrderingMode.asc),
              (t) => OrderingTerm(expression: t.trackNumber, mode: OrderingMode.asc),
            ]))
          .get();

  Future<List<Track>> all({int limit = 5000}) =>
      (_db.select(_db.tracks)
            ..orderBy([
              (t) => OrderingTerm(expression: t.artistName, mode: OrderingMode.asc),
              (t) => OrderingTerm(expression: t.albumTitle, mode: OrderingMode.asc),
              (t) => OrderingTerm(expression: t.discNumber, mode: OrderingMode.asc),
              (t) => OrderingTerm(expression: t.trackNumber, mode: OrderingMode.asc),
            ])
            ..limit(limit))
          .get();

  Future<List<Track>> forArtist(int artistId) =>
      (_db.select(_db.tracks)
            ..where((t) => t.artistId.equals(artistId))
            ..orderBy([
              (t) => OrderingTerm(expression: t.albumTitle, mode: OrderingMode.asc),
              (t) => OrderingTerm(expression: t.discNumber, mode: OrderingMode.asc),
              (t) => OrderingTerm(expression: t.trackNumber, mode: OrderingMode.asc),
            ]))
          .get();

  /// Recherche FTS5 full-text sur title, artist_name, album_title.
  /// Utilise un prefix match (`query*`) — correspondance iOS FTS5().
  Future<List<Track>> search(String query, {int limit = 100}) async {
    final q = _sanitizeFts(query);
    if (q.isEmpty) return [];

    // Récupère les rowids triés par rank FTS5 puis mappe vers Track
    final rows = await _db
        .customSelect(
          'SELECT t.* FROM tracks t '
          'INNER JOIN tracks_fts ON tracks_fts.rowid = t.id '
          'WHERE tracks_fts MATCH ? '
          'ORDER BY tracks_fts.rank '
          'LIMIT ?',
          variables: [Variable(q), Variable(limit)],
          readsFrom: {_db.tracks},
        )
        .get();
    return Future.wait(rows.map((row) => _db.tracks.mapFromRow(row)));
  }

  Future<int> count() async {
    final result = await _db
        .customSelect('SELECT COUNT(*) AS c FROM tracks')
        .getSingle();
    return result.read<int>('c');
  }

  // ---------------------------------------------------------------------------
  // Favoris
  // ---------------------------------------------------------------------------

  /// Toggle le flag favori de la piste et retourne le nouvel état.
  Future<bool> toggleFavorite(int trackId) async {
    final track = await byId(trackId);
    if (track == null) return false;
    final newValue = !track.favorite;
    await (_db.update(_db.tracks)..where((t) => t.id.equals(trackId)))
        .write(TracksCompanion(favorite: Value(newValue)));
    return newValue;
  }

  Future<bool> isFavorite(int trackId) async {
    final track = await byId(trackId);
    return track?.favorite ?? false;
  }

  Future<List<Track>> favorites({int limit = 5000}) =>
      (_db.select(_db.tracks)
            ..where((t) => t.favorite.equals(true))
            ..orderBy([
              (t) => OrderingTerm(expression: t.artistName, mode: OrderingMode.asc),
              (t) => OrderingTerm(expression: t.albumTitle, mode: OrderingMode.asc),
              (t) => OrderingTerm(expression: t.discNumber, mode: OrderingMode.asc),
              (t) => OrderingTerm(expression: t.trackNumber, mode: OrderingMode.asc),
            ])
            ..limit(limit))
          .get();

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  /// Échappe les guillemets et ajoute un wildcard de préfixe pour FTS5.
  String _sanitizeFts(String input) {
    final trimmed = input.trim().replaceAll('"', '');
    if (trimmed.isEmpty) return '';
    return '"$trimmed"*';
  }
}
