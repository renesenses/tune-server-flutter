import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'schema.dart';

part 'database.g.dart';

// ---------------------------------------------------------------------------
// T1.2 — TuneDatabase : orchestrateur drift avec migrations + WAL
//        Miroir de Database.swift (GRDB)
// ---------------------------------------------------------------------------

@DriftDatabase(tables: [
  Artists,
  Albums,
  Tracks,
  Playlists,
  PlaylistTracks,
  Zones,
  QueueItems,
  Radios,
  MusicFolders,
  SavedDevices,
  RadioFavorites,
  StreamingAuth,
  StreamingConfig,
])
class TuneDatabase extends _$TuneDatabase {
  TuneDatabase() : super(_openConnection());

  // Incrémenté à chaque nouvelle migration
  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await _createFts5Tables(m);
          await _createIndexes(m);
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.createTable(savedDevices);
          }
          if (from < 3) {
            await m.createTable(radioFavorites);
          }
          if (from < 4) {
            await m.createTable(streamingAuth);
            await m.createTable(streamingConfig);
          }
        },
        beforeOpen: (details) async {
          // Active WAL mode + foreign keys à chaque ouverture
          await customStatement('PRAGMA journal_mode = WAL');
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );

  // ---------------------------------------------------------------------------
  // FTS5 virtual tables (content tables synchronisées)
  // Créés en raw SQL — même sémantique que GRDB FTS5()
  // ---------------------------------------------------------------------------

  Future<void> _createFts5Tables(Migrator m) async {
    await customStatement('''
      CREATE VIRTUAL TABLE IF NOT EXISTS tracks_fts
      USING fts5(
        title,
        artist_name,
        album_title,
        content=tracks,
        content_rowid=id
      )
    ''');

    await customStatement('''
      CREATE TRIGGER IF NOT EXISTS tracks_ai AFTER INSERT ON tracks BEGIN
        INSERT INTO tracks_fts(rowid, title, artist_name, album_title)
        VALUES (new.id, new.title, new.artist_name, new.album_title);
      END
    ''');

    await customStatement('''
      CREATE TRIGGER IF NOT EXISTS tracks_ad AFTER DELETE ON tracks BEGIN
        INSERT INTO tracks_fts(tracks_fts, rowid, title, artist_name, album_title)
        VALUES ('delete', old.id, old.title, old.artist_name, old.album_title);
      END
    ''');

    await customStatement('''
      CREATE TRIGGER IF NOT EXISTS tracks_au AFTER UPDATE ON tracks BEGIN
        INSERT INTO tracks_fts(tracks_fts, rowid, title, artist_name, album_title)
        VALUES ('delete', old.id, old.title, old.artist_name, old.album_title);
        INSERT INTO tracks_fts(rowid, title, artist_name, album_title)
        VALUES (new.id, new.title, new.artist_name, new.album_title);
      END
    ''');

    await customStatement('''
      CREATE VIRTUAL TABLE IF NOT EXISTS albums_fts
      USING fts5(
        title,
        artist_name,
        content=albums,
        content_rowid=id
      )
    ''');

    await customStatement('''
      CREATE TRIGGER IF NOT EXISTS albums_ai AFTER INSERT ON albums BEGIN
        INSERT INTO albums_fts(rowid, title, artist_name)
        VALUES (new.id, new.title, new.artist_name);
      END
    ''');

    await customStatement('''
      CREATE TRIGGER IF NOT EXISTS albums_ad AFTER DELETE ON albums BEGIN
        INSERT INTO albums_fts(albums_fts, rowid, title, artist_name)
        VALUES ('delete', old.id, old.title, old.artist_name);
      END
    ''');

    await customStatement('''
      CREATE TRIGGER IF NOT EXISTS albums_au AFTER UPDATE ON albums BEGIN
        INSERT INTO albums_fts(albums_fts, rowid, title, artist_name)
        VALUES ('delete', old.id, old.title, old.artist_name);
        INSERT INTO albums_fts(rowid, title, artist_name)
        VALUES (new.id, new.title, new.artist_name);
      END
    ''');

    await customStatement('''
      CREATE VIRTUAL TABLE IF NOT EXISTS artists_fts
      USING fts5(
        name,
        content=artists,
        content_rowid=id
      )
    ''');

    await customStatement('''
      CREATE TRIGGER IF NOT EXISTS artists_ai AFTER INSERT ON artists BEGIN
        INSERT INTO artists_fts(rowid, name) VALUES (new.id, new.name);
      END
    ''');

    await customStatement('''
      CREATE TRIGGER IF NOT EXISTS artists_ad AFTER DELETE ON artists BEGIN
        INSERT INTO artists_fts(artists_fts, rowid, name)
        VALUES ('delete', old.id, old.name);
      END
    ''');

    await customStatement('''
      CREATE TRIGGER IF NOT EXISTS artists_au AFTER UPDATE ON artists BEGIN
        INSERT INTO artists_fts(artists_fts, rowid, name)
        VALUES ('delete', old.id, old.name);
        INSERT INTO artists_fts(rowid, name) VALUES (new.id, new.name);
      END
    ''');
  }

  // ---------------------------------------------------------------------------
  // Index supplémentaires
  // ---------------------------------------------------------------------------

  Future<void> _createIndexes(Migrator m) async {
    await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_artists_name ON artists(name)');
    await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_albums_artist ON albums(artist_id)');
    await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_albums_title ON albums(title)');
    await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_tracks_album ON tracks(album_id)');
    await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_tracks_artist ON tracks(artist_id)');
    await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_tracks_filepath ON tracks(file_path)');
    await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_playlist_tracks ON playlist_tracks(playlist_id)');
    await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_queue_items_zone ON queue_items(zone_id)');
  }
}

// ---------------------------------------------------------------------------
// Ouverture de la connexion SQLite
// ---------------------------------------------------------------------------

QueryExecutor _openConnection() {
  return driftDatabase(
    name: 'tune_server',
    native: DriftNativeOptions(
      databaseDirectory: getApplicationSupportDirectory,
    ),
  );
}
