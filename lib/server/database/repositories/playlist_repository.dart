import 'package:drift/drift.dart';

import '../database.dart';

// ---------------------------------------------------------------------------
// T1.6 — PlaylistRepository
// CRUD + tracks(playlistId:) via JOIN playlist_tracks ↔ tracks
// Miroir de PlaylistRepository.swift (GRDB)
// ---------------------------------------------------------------------------

class PlaylistRepository {
  final TuneDatabase _db;

  const PlaylistRepository(this._db);

  // ---------------------------------------------------------------------------
  // CRUD
  // ---------------------------------------------------------------------------

  Future<Playlist?> byId(int id) =>
      (_db.select(_db.playlists)..where((p) => p.id.equals(id)))
          .getSingleOrNull();

  Future<List<Playlist>> all() =>
      (_db.select(_db.playlists)
            ..orderBy([
              (p) => OrderingTerm(expression: p.name, mode: OrderingMode.asc),
            ]))
          .get();

  Future<int> insert(PlaylistsCompanion companion) =>
      _db.into(_db.playlists).insert(companion);

  Future<bool> update(Playlist playlist) =>
      _db.update(_db.playlists).replace(playlist);

  Future<int> delete(int id) =>
      (_db.delete(_db.playlists)..where((p) => p.id.equals(id))).go();

  // ---------------------------------------------------------------------------
  // Gestion des pistes
  // ---------------------------------------------------------------------------

  /// Retourne les tracks d'une playlist, triées par position.
  Future<List<Track>> tracks(int playlistId) async {
    final rows = await _db
        .customSelect(
          'SELECT t.* FROM tracks t '
          'INNER JOIN playlist_tracks pt ON pt.track_id = t.id '
          'WHERE pt.playlist_id = ? '
          'ORDER BY pt.position ASC',
          variables: [Variable(playlistId)],
          readsFrom: {_db.tracks, _db.playlistTracks},
        )
        .get();
    return Future.wait(rows.map((row) => _db.tracks.mapFromRow(row)));
  }

  /// Ajoute une piste en fin de playlist.
  /// Retourne `true` si la piste a été ajoutée, `false` si elle était déjà présente.
  Future<bool> addTrack(int playlistId, int trackId) async {
    final already = await (_db.select(_db.playlistTracks)
          ..where(
            (pt) =>
                pt.playlistId.equals(playlistId) &
                pt.trackId.equals(trackId),
          )
          ..limit(1))
        .getSingleOrNull();
    if (already != null) return false;

    final maxPos = await _db
        .customSelect(
          'SELECT COALESCE(MAX(position), -1) AS m FROM playlist_tracks WHERE playlist_id = ?',
          variables: [Variable(playlistId)],
        )
        .map((r) => r.read<int>('m'))
        .getSingle();

    await _db.into(_db.playlistTracks).insert(
          PlaylistTracksCompanion.insert(
            playlistId: playlistId,
            trackId: trackId,
            position: maxPos + 1,
          ),
        );
    await _updateTrackCount(playlistId);
    return true;
  }

  /// Supprime une piste d'une playlist.
  Future<void> removeTrack(int playlistId, int trackId) async {
    await (_db.delete(_db.playlistTracks)
          ..where(
            (pt) =>
                pt.playlistId.equals(playlistId) &
                pt.trackId.equals(trackId),
          ))
        .go();
    await _reorderPositions(playlistId);
    await _updateTrackCount(playlistId);
  }

  /// Déplace une piste de [fromPosition] à [toPosition].
  Future<void> moveTrack(
      int playlistId, int fromPosition, int toPosition) async {
    await _db.transaction(() async {
      // Récupère la piste à déplacer
      final rows = await (_db.select(_db.playlistTracks)
            ..where(
              (pt) =>
                  pt.playlistId.equals(playlistId) &
                  pt.position.equals(fromPosition),
            ))
          .get();
      if (rows.isEmpty) return;
      final moving = rows.first;

      if (fromPosition < toPosition) {
        // Décale vers le bas
        await _db.customUpdate(
          'UPDATE playlist_tracks SET position = position - 1 '
          'WHERE playlist_id = ? AND position > ? AND position <= ?',
          variables: [
            Variable(playlistId),
            Variable(fromPosition),
            Variable(toPosition),
          ],
          updates: {_db.playlistTracks},
        );
      } else {
        // Décale vers le haut
        await _db.customUpdate(
          'UPDATE playlist_tracks SET position = position + 1 '
          'WHERE playlist_id = ? AND position >= ? AND position < ?',
          variables: [
            Variable(playlistId),
            Variable(toPosition),
            Variable(fromPosition),
          ],
          updates: {_db.playlistTracks},
        );
      }

      await (_db.update(_db.playlistTracks)
            ..where(
              (pt) =>
                  pt.playlistId.equals(playlistId) & pt.id.equals(moving.id),
            ))
          .write(PlaylistTracksCompanion(position: Value(toPosition)));
    });
  }

  // ---------------------------------------------------------------------------
  // Helpers internes
  // ---------------------------------------------------------------------------

  Future<void> _updateTrackCount(int playlistId) async {
    final count = await _db
        .customSelect(
          'SELECT COUNT(*) AS c FROM playlist_tracks WHERE playlist_id = ?',
          variables: [Variable(playlistId)],
        )
        .map((r) => r.read<int>('c'))
        .getSingle();

    await (_db.update(_db.playlists)..where((p) => p.id.equals(playlistId)))
        .write(PlaylistsCompanion(trackCount: Value(count)));
  }

  Future<void> _reorderPositions(int playlistId) async {
    await _db.customUpdate(
      'UPDATE playlist_tracks SET position = ('
      '  SELECT COUNT(*) FROM playlist_tracks pt2 '
      '  WHERE pt2.playlist_id = playlist_tracks.playlist_id '
      '  AND pt2.position < playlist_tracks.position'
      ') WHERE playlist_id = ?',
      variables: [Variable(playlistId)],
      updates: {_db.playlistTracks},
    );
  }
}
