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

  Future<Album?> findByTitleAndArtist(String title, int artistId, {int? year}) async {
    if (year != null) {
      final exact = await (_db.select(_db.albums)
            ..where((a) => a.title.equals(title) & a.artistId.equals(artistId) & a.year.equals(year)))
          .getSingleOrNull();
      if (exact != null) return exact;
    }
    final fallback = await (_db.select(_db.albums)
          ..where((a) => a.title.equals(title) & a.artistId.equals(artistId)))
        .getSingleOrNull();
    if (fallback != null && year != null && fallback.year != null && fallback.year != year) {
      return null;
    }
    return fallback;
  }

  /// Title-only lookup — used for compilations and albums without artist.
  /// Returns the first match (oldest id) if multiple albums share the same title.
  /// When [year] is provided, prefers an exact year match before falling back.
  Future<Album?> findByTitle(String title, {int? year}) async {
    if (year != null) {
      final exact = await (_db.select(_db.albums)
            ..where((a) => a.title.equals(title) & a.year.equals(year))
            ..limit(1))
          .get();
      if (exact.isNotEmpty) return exact.first;
    }
    final results = await (_db.select(_db.albums)
          ..where((a) => a.title.equals(title))
          ..limit(1))
        .get();
    return results.isEmpty ? null : results.first;
  }

  /// Lookup by MusicBrainz release ID — authoritative discriminant.
  Future<Album?> getByMusicbrainzReleaseId(String releaseId) =>
      (_db.select(_db.albums)
            ..where((a) => a.musicbrainzReleaseId.equals(releaseId)))
          .getSingleOrNull();

  /// Backfill MusicBrainz IDs on an existing album (only if currently null/empty).
  Future<void> updateMusicbrainzIds(
      int albumId, String? releaseId, String? releaseGroupId) async {
    if (releaseId != null && releaseId.isNotEmpty) {
      await _db.customUpdate(
        'UPDATE albums SET musicbrainz_release_id = ? '
        'WHERE id = ? AND (musicbrainz_release_id IS NULL '
        "OR musicbrainz_release_id = '')",
        variables: [Variable(releaseId), Variable(albumId)],
        updates: {_db.albums},
      );
    }
    if (releaseGroupId != null && releaseGroupId.isNotEmpty) {
      await _db.customUpdate(
        'UPDATE albums SET musicbrainz_release_group_id = ? '
        'WHERE id = ? AND (musicbrainz_release_group_id IS NULL '
        "OR musicbrainz_release_group_id = '')",
        variables: [Variable(releaseGroupId), Variable(albumId)],
        updates: {_db.albums},
      );
    }
  }

  Future<void> updateTrackCount(int albumId) async {
    final count = await (_db.selectOnly(_db.tracks)
          ..addColumns([_db.tracks.id.count()])
          ..where(_db.tracks.albumId.equals(albumId)))
        .map((row) => row.read(_db.tracks.id.count()) ?? 0)
        .getSingle();
    await (_db.update(_db.albums)..where((a) => a.id.equals(albumId)))
        .write(AlbumsCompanion(trackCount: Value(count)));
  }

  Future<void> updateCover(int albumId, String coverPath) async {
    await (_db.update(_db.albums)..where((a) => a.id.equals(albumId)))
        .write(AlbumsCompanion(coverPath: Value(coverPath)));
    await (_db.update(_db.tracks)
          ..where((t) => t.albumId.equals(albumId) & t.coverPath.isNull()))
        .write(TracksCompanion(coverPath: Value(coverPath)));
  }

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
              (a) => OrderingTerm(expression: coalesce([a.originalYear, a.year]), mode: OrderingMode.asc),
              (a) => OrderingTerm(expression: a.title, mode: OrderingMode.asc),
            ]))
          .get();

  /// Recherche FTS5 sur title et artist_name, with LIKE fallback for accented queries.
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
    if (rows.isNotEmpty) {
      return Future.wait(rows.map((row) => _db.albums.mapFromRow(row)));
    }

    final folded = foldAccents(query.trim());
    final likePattern = '%$folded%';
    final likeRows = await _db
        .customSelect(
          'SELECT * FROM albums '
          'WHERE title LIKE ? COLLATE NOCASE '
          'OR artist_name LIKE ? COLLATE NOCASE '
          'LIMIT ?',
          variables: [Variable(likePattern), Variable(likePattern), Variable(limit)],
          readsFrom: {_db.albums},
        )
        .get();
    final albums = await Future.wait(likeRows.map((row) => _db.albums.mapFromRow(row)));
    final foldedLower = folded.toLowerCase();
    return albums.where((a) =>
        foldAccents(a.title).toLowerCase().contains(foldedLower) ||
        (a.artistName != null && foldAccents(a.artistName!).toLowerCase().contains(foldedLower))
    ).toList();
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
