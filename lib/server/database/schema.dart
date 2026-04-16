import 'package:drift/drift.dart';

// ---------------------------------------------------------------------------
// T1.1 — Schéma drift : miroir de Schema.swift (GRDB)
//
// Conventions drift :
//   - camelCase Dart → snake_case SQL automatiquement
//   - FTS5 virtual tables créés en raw SQL dans la migration (T1.2)
//     car plus fiable que l'API drift pour les content tables synchronisées.
// ---------------------------------------------------------------------------

// ---------------------------------------------------------------------------
// Artists
// ---------------------------------------------------------------------------

class Artists extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get sortName => text().nullable()();
  TextColumn get musicbrainzId => text().nullable()();
  TextColumn get discogsId => text().nullable()();
  TextColumn get bio => text().nullable()();
  TextColumn get imagePath => text().nullable()();
}

// ---------------------------------------------------------------------------
// Albums
// ---------------------------------------------------------------------------

class Albums extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  IntColumn get artistId =>
      integer().nullable().references(Artists, #id)();
  TextColumn get artistName => text().nullable()();
  IntColumn get year => integer().nullable()();
  TextColumn get genre => text().nullable()();
  IntColumn get discCount => integer().nullable()();
  IntColumn get trackCount => integer().nullable()();
  TextColumn get coverPath => text().nullable()();
  TextColumn get source => text().withDefault(const Constant('local'))();
  TextColumn get sourceId => text().nullable()();
}

// ---------------------------------------------------------------------------
// Tracks
// ---------------------------------------------------------------------------

class Tracks extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  IntColumn get albumId =>
      integer().nullable().references(Albums, #id)();
  TextColumn get albumTitle => text().nullable()();
  IntColumn get artistId =>
      integer().nullable().references(Artists, #id)();
  TextColumn get artistName => text().nullable()();
  IntColumn get discNumber => integer().nullable()();
  IntColumn get trackNumber => integer().nullable()();
  IntColumn get durationMs => integer().nullable()();
  TextColumn get filePath => text().nullable()();
  TextColumn get format => text().nullable()();
  IntColumn get sampleRate => integer().nullable()();
  IntColumn get bitDepth => integer().nullable()();
  IntColumn get channels => integer().nullable()();
  TextColumn get coverPath => text().nullable()();
  TextColumn get source => text().withDefault(const Constant('local'))();
  TextColumn get sourceId => text().nullable()();
  /// Marque la piste comme favori (migration v5)
  BoolColumn get favorite =>
      boolean().withDefault(const Constant(false))();
}

// ---------------------------------------------------------------------------
// Playlists
// ---------------------------------------------------------------------------

class Playlists extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  IntColumn get trackCount => integer().withDefault(const Constant(0))();
}

// ---------------------------------------------------------------------------
// PlaylistTracks (table de jointure)
// ---------------------------------------------------------------------------

class PlaylistTracks extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get playlistId =>
      integer().references(Playlists, #id, onDelete: KeyAction.cascade)();
  IntColumn get trackId =>
      integer().references(Tracks, #id, onDelete: KeyAction.cascade)();
  IntColumn get position => integer()();
}

// ---------------------------------------------------------------------------
// Zones
// ---------------------------------------------------------------------------

class Zones extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get outputType => text().nullable()();
  TextColumn get outputDeviceId => text().nullable()();
  RealColumn get volume => real().withDefault(const Constant(0.5))();
  TextColumn get groupId => text().nullable()();
  IntColumn get syncDelayMs => integer().withDefault(const Constant(0))();
  // state, currentTrack, positionMs, queueLength → runtime only, non persistés
}

// ---------------------------------------------------------------------------
// QueueItems
// ---------------------------------------------------------------------------

class QueueItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get zoneId =>
      integer().references(Zones, #id, onDelete: KeyAction.cascade)();
  IntColumn get trackId => integer()();
  IntColumn get position => integer()();
}

// ---------------------------------------------------------------------------
// Radios
// ---------------------------------------------------------------------------

class Radios extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get streamUrl => text()();
  TextColumn get logoUrl => text().nullable()();
  TextColumn get genre => text().nullable()();
  TextColumn get tags => text().nullable()();
  TextColumn get codec => text().nullable()();
  TextColumn get country => text().nullable()();
  TextColumn get homepageUrl => text().nullable()();
  BoolColumn get favorite => boolean().withDefault(const Constant(false))();
}

// ---------------------------------------------------------------------------
// MusicFolders
// ---------------------------------------------------------------------------

class MusicFolders extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get path => text().unique()();
  // bookmarkData non utilisé sur Android, nullable
  BlobColumn get bookmarkData => blob().nullable()();
  TextColumn get addedAt => text()();
}

// ---------------------------------------------------------------------------
// SavedDevices (migration v2)
// ---------------------------------------------------------------------------

class SavedDevices extends Table {
  // Clé primaire string (device_id)
  TextColumn get deviceId => text()();
  TextColumn get name => text()();
  TextColumn get type => text()();
  TextColumn get host => text()();
  IntColumn get port => integer()();
  TextColumn get capabilitiesJson => text().nullable()();
  TextColumn get addedAt => text()();

  @override
  Set<Column> get primaryKey => {deviceId};
}

// ---------------------------------------------------------------------------
// RadioFavorites (migration v3)
// ---------------------------------------------------------------------------

class RadioFavorites extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get artist => text()();
  TextColumn get stationName => text()();
  TextColumn get streamUrl => text()();
  TextColumn get coverPath => text().nullable()();
  TextColumn get savedAt => text()();
}

// ---------------------------------------------------------------------------
// StreamingAuth (migration v4)
// ---------------------------------------------------------------------------

class StreamingAuth extends Table {
  TextColumn get service => text()();
  TextColumn get tokenData => text()();
  TextColumn get updatedAt => text()();

  @override
  Set<Column> get primaryKey => {service};
}

// ---------------------------------------------------------------------------
// StreamingConfig (migration v4)
// ---------------------------------------------------------------------------

class StreamingConfig extends Table {
  TextColumn get service => text()();
  BoolColumn get enabled =>
      boolean().withDefault(const Constant(false))();
  TextColumn get configJson => text().nullable()();
  TextColumn get quality => text().nullable()();

  @override
  Set<Column> get primaryKey => {service};
}
