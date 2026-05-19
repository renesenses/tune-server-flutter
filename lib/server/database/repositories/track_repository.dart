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

  /// Recherche FTS5 full-text sur title, artist_name, album_title,
  /// with LIKE fallback for accented queries.
  Future<List<Track>> search(String query, {int limit = 100}) async {
    final q = _sanitizeFts(query);
    if (q.isEmpty) return [];

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
    if (rows.isNotEmpty) {
      return Future.wait(rows.map((row) => _db.tracks.mapFromRow(row)));
    }

    final folded = foldAccents(query.trim());
    final likePattern = '%$folded%';
    final likeRows = await _db
        .customSelect(
          'SELECT * FROM tracks '
          'WHERE title LIKE ? COLLATE NOCASE '
          'OR artist_name LIKE ? COLLATE NOCASE '
          'OR album_title LIKE ? COLLATE NOCASE '
          'LIMIT ?',
          variables: [Variable(likePattern), Variable(likePattern), Variable(likePattern), Variable(limit)],
          readsFrom: {_db.tracks},
        )
        .get();
    final tracks = await Future.wait(likeRows.map((row) => _db.tracks.mapFromRow(row)));
    final foldedLower = folded.toLowerCase();
    return tracks.where((t) =>
        foldAccents(t.title).toLowerCase().contains(foldedLower) ||
        (t.artistName != null && foldAccents(t.artistName!).toLowerCase().contains(foldedLower)) ||
        (t.albumTitle != null && foldAccents(t.albumTitle!).toLowerCase().contains(foldedLower))
    ).toList();
  }

  Future<int> count() async {
    final result = await _db
        .customSelect('SELECT COUNT(*) AS c FROM tracks')
        .getSingle();
    return result.read<int>('c');
  }

  /// Returns up to [limit] random tracks from the library.
  Future<List<Track>> random({int limit = 5000}) async {
    final rows = await _db
        .customSelect(
          'SELECT * FROM tracks ORDER BY RANDOM() LIMIT ?',
          variables: [Variable(limit)],
          readsFrom: {_db.tracks},
        )
        .get();
    return Future.wait(rows.map((row) => _db.tracks.mapFromRow(row)));
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
  // File mtime (incremental scan support)
  // ---------------------------------------------------------------------------

  /// Reset file_mtime to 0 on all local tracks — forces a full rescan.
  Future<void> resetAllMtimes() async {
    await _db.customUpdate(
      "UPDATE tracks SET file_mtime = 0 WHERE file_mtime IS NOT NULL AND source = 'local'",
      updates: {_db.tracks},
    );
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  static final _ftsBoolean = RegExp(r'\b(?:AND|OR|NOT|NEAR)\b', caseSensitive: false);

  String _sanitizeFts(String input) {
    var trimmed = input.trim().replaceAll('"', '');
    trimmed = trimmed.replaceAll(RegExp(r'[(){}:+\-^]'), '');
    trimmed = trimmed.replaceAll(_ftsBoolean, '');
    trimmed = trimmed.replaceAll(RegExp(r'\s+'), ' ').trim();
    if (trimmed.isEmpty) return '';
    return '"$trimmed"*';
  }
}
