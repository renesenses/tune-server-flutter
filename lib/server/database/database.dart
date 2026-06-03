import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'schema.dart';
import 'repositories/repositories.dart';

part 'database.g.dart';

/// Strips diacritics from a string for accent-insensitive search.
String foldAccents(String input) {
  const map = {
    'À': 'A', 'Á': 'A', 'Â': 'A', 'Ã': 'A', 'Ä': 'A', 'Å': 'A',
    'Æ': 'AE',
    'Ç': 'C',
    'È': 'E', 'É': 'E', 'Ê': 'E', 'Ë': 'E',
    'Ì': 'I', 'Í': 'I', 'Î': 'I', 'Ï': 'I',
    'Ð': 'D',
    'Ñ': 'N',
    'Ò': 'O', 'Ó': 'O', 'Ô': 'O', 'Õ': 'O', 'Ö': 'O', 'Ø': 'O',
    'Ù': 'U', 'Ú': 'U', 'Û': 'U', 'Ü': 'U',
    'Ý': 'Y',
    'ß': 'ss',
    'à': 'a', 'á': 'a', 'â': 'a', 'ã': 'a', 'ä': 'a', 'å': 'a',
    'æ': 'ae',
    'ç': 'c',
    'è': 'e', 'é': 'e', 'ê': 'e', 'ë': 'e',
    'ì': 'i', 'í': 'i', 'î': 'i', 'ï': 'i',
    'ð': 'd',
    'ñ': 'n',
    'ò': 'o', 'ó': 'o', 'ô': 'o', 'õ': 'o', 'ö': 'o', 'ø': 'o',
    'ù': 'u', 'ú': 'u', 'û': 'u', 'ü': 'u',
    'ý': 'y', 'ÿ': 'y',
    'Ā': 'A', 'ā': 'a', 'Ă': 'A', 'ă': 'a',
    'Ą': 'A', 'ą': 'a',
    'Ć': 'C', 'ć': 'c', 'Č': 'C', 'č': 'c',
    'Ď': 'D', 'ď': 'd', 'Đ': 'D', 'đ': 'd',
    'Ē': 'E', 'ē': 'e', 'Ę': 'E', 'ę': 'e', 'Ě': 'E', 'ě': 'e',
    'Ğ': 'G', 'ğ': 'g',
    'İ': 'I', 'ı': 'i',
    'Ł': 'L', 'ł': 'l',
    'Ń': 'N', 'ń': 'n', 'Ň': 'N', 'ň': 'n',
    'Ő': 'O', 'ő': 'o', 'Œ': 'OE', 'œ': 'oe',
    'Ř': 'R', 'ř': 'r',
    'Ś': 'S', 'ś': 's', 'Ş': 'S', 'ş': 's', 'Š': 'S', 'š': 's',
    'Ţ': 'T', 'ţ': 't', 'Ť': 'T', 'ť': 't',
    'Ů': 'U', 'ů': 'u', 'Ű': 'U', 'ű': 'u',
    'Ÿ': 'Y', 'Ź': 'Z', 'ź': 'z', 'Ż': 'Z', 'ż': 'z',
    'Ž': 'Z', 'ž': 'z',
  };
  final buf = StringBuffer();
  for (var i = 0; i < input.length; i++) {
    final c = input[i];
    buf.write(map[c] ?? c);
  }
  return buf.toString();
}

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
  SyncLinkSnapshots,
  AlbumRatings,
  ListenHistory,
  Settings,
  Tags,
  ItemTags,
  TrackSourceLinks,
])
class TuneDatabase extends _$TuneDatabase {
  TuneDatabase() : super(_openConnection());

  // ---------------------------------------------------------------------------
  // Repositories (T1.3–T1.8) — accès centralisé via la DB
  // ---------------------------------------------------------------------------

  late final TrackRepository trackRepo = TrackRepository(this);
  late final AlbumRepository albumRepo = AlbumRepository(this);
  late final ArtistRepository artistRepo = ArtistRepository(this);
  late final PlaylistRepository playlistRepo = PlaylistRepository(this);
  late final ZoneRepository zoneRepo = ZoneRepository(this);
  late final RadioRepository radioRepo = RadioRepository(this);
  late final RatingRepository ratingRepo = RatingRepository(this);
  late final HistoryRepository historyRepo = HistoryRepository(this);
  late final SettingsRepository settingsRepo = SettingsRepository(this);
  late final TagRepository tagRepo = TagRepository(this);
  late final SourceLinkRepository sourceLinkRepo = SourceLinkRepository(this);

  // Incrémenté à chaque nouvelle migration
  @override
  int get schemaVersion => 12;

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
          if (from < 5) {
            await m.addColumn(tracks, tracks.favorite);
          }
          if (from < 6) {
            await m.addColumn(albums, albums.originalYear);
            await m.addColumn(albums, albums.musicbrainzReleaseId);
            await m.addColumn(albums, albums.musicbrainzReleaseGroupId);
            await m.addColumn(tracks, tracks.musicbrainzRecordingId);
            await m.addColumn(tracks, tracks.fileMtime);
          }
          if (from < 7) {
            await m.addColumn(tracks, tracks.discSubtitle);
          }
          if (from < 8) {
            await m.addColumn(albums, albums.releaseDate);
            await m.addColumn(albums, albums.originalDate);
          }
          if (from < 9) {
            await m.createTable(syncLinkSnapshots);
            await customStatement(
                'CREATE INDEX IF NOT EXISTS idx_sync_snapshots_link '
                'ON sync_link_snapshots(playlist_link_id, side)');
          }
          if (from < 10) {
            await m.addColumn(artists, artists.imageSource);
          }
          if (from < 11) {
            await m.addColumn(zones, zones.normalizationEnabled);
            await m.addColumn(zones, zones.normalizationTargetLufs);
          }
          if (from < 12) {
            await m.createTable(albumRatings);
            await m.createTable(listenHistory);
            await m.createTable(settings);
            await m.createTable(tags);
            await m.createTable(itemTags);
            await m.createTable(trackSourceLinks);
            await customStatement(
                'CREATE INDEX IF NOT EXISTS idx_album_ratings_album '
                'ON album_ratings(album_id, profile_id)');
            await customStatement(
                'CREATE INDEX IF NOT EXISTS idx_listen_history_listened_at '
                'ON listen_history(listened_at)');
            await customStatement(
                'CREATE INDEX IF NOT EXISTS idx_listen_history_track '
                'ON listen_history(track_id)');
            await customStatement(
                'CREATE INDEX IF NOT EXISTS idx_item_tags_tag '
                'ON item_tags(tag_id)');
            await customStatement(
                'CREATE INDEX IF NOT EXISTS idx_item_tags_item '
                'ON item_tags(item_type, item_id)');
            await customStatement(
                'CREATE INDEX IF NOT EXISTS idx_track_source_links_track '
                'ON track_source_links(track_id)');
            await customStatement(
                'CREATE INDEX IF NOT EXISTS idx_track_source_links_service '
                'ON track_source_links(service)');
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
    await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_albums_mbid ON albums(musicbrainz_release_id)');
    await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_sync_snapshots_link ON sync_link_snapshots(playlist_link_id, side)');
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
