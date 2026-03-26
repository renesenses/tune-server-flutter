import 'dart:io';

import 'package:drift/drift.dart';
import 'package:path/path.dart' as p;

import '../database/database.dart';
import '../event_bus.dart';
import 'artwork_manager.dart';
import 'cover_art_fetcher.dart';
import 'metadata_reader.dart';

// ---------------------------------------------------------------------------
// T7.4 — LibraryScanner
// Parcours dossiers → MetadataReader (Isolate) → upsert DB → events scan.
// Miroir de LibraryScanner.swift (iOS)
//
// Architecture :
//   - LibraryScanner reste sur le main isolate (coordination + DB)
//   - Délègue le travail CPU à MetadataReader.readBatch() via Isolate.run()
//   - Émet LibraryScanProgress / LibraryScanCompleted sur l'EventBus
// ---------------------------------------------------------------------------

const _audioExtensions = {
  '.flac', '.mp3', '.m4a', '.aac', '.alac',
  '.ogg', '.opus', '.wav', '.aiff', '.aif',
  '.dsf', '.dff', '.wma',
};

class LibraryScanner {
  final TuneDatabase _db;
  final ArtworkManager _artworkManager;
  final CoverArtFetcher _coverFetcher;

  bool _scanning = false;
  bool _cancelRequested = false;

  LibraryScanner(this._db, {
    ArtworkManager? artworkManager,
    CoverArtFetcher? coverFetcher,
  })  : _artworkManager = artworkManager ?? ArtworkManager.instance,
        _coverFetcher = coverFetcher ?? CoverArtFetcher();

  bool get isScanning => _scanning;

  // ---------------------------------------------------------------------------
  // Scan principal
  // ---------------------------------------------------------------------------

  /// Scanne [folderPaths] récursivement et met à jour la DB.
  Future<void> scan(List<String> folderPaths) async {
    if (_scanning) return;
    _scanning = true;
    _cancelRequested = false;

    EventBus.instance.emit(const LibraryScanStartedEvent());

    int tracksAdded = 0;
    int tracksUpdated = 0;

    try {
      // 1. Collecte tous les fichiers audio
      final allFiles = <String>[];
      for (final folder in folderPaths) {
        allFiles.addAll(await _collectAudioFiles(folder));
      }

      if (allFiles.isEmpty) {
        EventBus.instance.emit(LibraryScanCompletedEvent(0, 0));
        return;
      }

      // 2. Filtre les fichiers déjà indexés (compare mtime DB vs disque)
      final toProcess = await _filterUnchanged(allFiles);
      final total = toProcess.length;

      if (total == 0) {
        EventBus.instance.emit(LibraryScanCompletedEvent(0, 0));
        return;
      }

      // 3. Lecture metadata en batch (Isolate dans MetadataReader)
      await for (final meta in MetadataReader.readBatch(
        toProcess,
        batchSize: 50,
        onProgress: (done, _) {
          EventBus.instance
              .emit(LibraryScanProgressEvent(done, total));
        },
      )) {
        if (_cancelRequested) break;

        final (added, updated) = await _upsertTrack(meta);
        tracksAdded += added;
        tracksUpdated += updated;
      }

      // 4. Cleanup orphelins (fichiers supprimés du disque)
      if (!_cancelRequested) {
        await _removeOrphans(allFiles.toSet());
      }

      EventBus.instance
          .emit(LibraryScanCompletedEvent(tracksAdded, tracksUpdated));
    } catch (e) {
      EventBus.instance.emit(LibraryScanErrorEvent(e.toString()));
    } finally {
      _scanning = false;
    }
  }

  void cancel() => _cancelRequested = true;

  // ---------------------------------------------------------------------------
  // Upsert d'une piste en DB
  // ---------------------------------------------------------------------------

  Future<(int added, int updated)> _upsertTrack(
      TrackMetadata meta) async {
    int added = 0;
    int updated = 0;

    await _db.transaction(() async {
      // Artist
      final artistId = meta.artist != null
          ? await _upsertArtist(meta.artist!, meta.albumArtist)
          : null;

      // Artwork : uniquement depuis le fichier (embarqué).
      // Le fetch réseau (iTunes/MusicBrainz) est exclu du scan pour ne pas
      // bloquer — il peut être lancé séparément via fetchArtworkForLibrary().
      final String? coverPath =
          meta.hasCoverData ? await _artworkManager.coverPathForTrack(meta.filePath) : null;

      // Album
      final albumId = meta.album != null
          ? await _upsertAlbum(
              title: meta.album!,
              artistId: artistId,
              artistName: meta.albumArtist ?? meta.artist,
              year: meta.year,
              genre: meta.genre,
              coverPath: coverPath,
            )
          : null;

      // Track — déduplique par filePath
      final existing = await (_db.select(_db.tracks)
            ..where((t) => t.filePath.equals(meta.filePath)))
          .getSingleOrNull();

      final companion = TracksCompanion(
        title: Value(meta.title),
        albumId: Value(albumId),
        albumTitle: Value(meta.album),
        artistId: Value(artistId),
        artistName: Value(meta.artist),
        trackNumber: Value(meta.trackNumber),
        discNumber: Value(meta.discNumber),
        durationMs: Value(meta.durationMs),
        filePath: Value(meta.filePath),
        format: Value(meta.format),
        sampleRate: Value(meta.sampleRate),
        bitDepth: Value(meta.bitDepth),
        channels: Value(meta.channels),
        coverPath: Value(coverPath),
        source: const Value('local'),
      );

      if (existing == null) {
        await _db.into(_db.tracks).insert(companion);
        added++;
      } else {
        await (_db.update(_db.tracks)
              ..where((t) => t.id.equals(existing.id)))
            .write(companion);
        updated++;
      }
    });

    return (added, updated);
  }

  // ---------------------------------------------------------------------------
  // Collecte des fichiers
  // ---------------------------------------------------------------------------

  Future<List<String>> _collectAudioFiles(String folderPath) async {
    final results = <String>[];
    final dir = Directory(folderPath);
    if (!await dir.exists()) return results;

    await for (final entity in dir.list(recursive: true, followLinks: false)) {
      if (entity is File) {
        final ext = p.extension(entity.path).toLowerCase();
        if (_audioExtensions.contains(ext)) {
          results.add(entity.path);
        }
      }
    }
    return results;
  }

  // ---------------------------------------------------------------------------
  // Filtrage des fichiers inchangés
  // ---------------------------------------------------------------------------

  /// Retourne les fichiers dont la piste DB est absente ou dont filePath
  /// n'est pas encore en base.
  Future<List<String>> _filterUnchanged(List<String> files) async {
    // Charge tous les filePaths déjà indexés
    final existing = await _db
        .customSelect('SELECT file_path FROM tracks WHERE source = \'local\'')
        .map((r) => r.read<String>('file_path'))
        .get();
    final indexed = existing.toSet();

    return files
        .where((f) => !indexed.contains(f))
        .toList();
  }

  // ---------------------------------------------------------------------------
  // Cleanup orphelins
  // ---------------------------------------------------------------------------

  Future<void> _removeOrphans(Set<String> presentFiles) async {
    final existing = await _db
        .customSelect('SELECT id, file_path FROM tracks WHERE source = \'local\'')
        .get();

    for (final row in existing) {
      final path = row.read<String>('file_path');
      if (!presentFiles.contains(path)) {
        final id = row.read<int>('id');
        await (_db.delete(_db.tracks)..where((t) => t.id.equals(id))).go();
      }
    }
  }

  // ---------------------------------------------------------------------------
  // Upsert helpers
  // ---------------------------------------------------------------------------

  Future<int> _upsertArtist(String name, String? sortName) async {
    final existing = await (_db.select(_db.artists)
          ..where((a) => a.name.equals(name)))
        .getSingleOrNull();
    if (existing != null) return existing.id;
    return _db.into(_db.artists).insert(
          ArtistsCompanion.insert(
            name: name,
            sortName: Value(sortName),
          ),
        );
  }

  Future<int> _upsertAlbum({
    required String title,
    int? artistId,
    String? artistName,
    int? year,
    String? genre,
    String? coverPath,
  }) async {
    final existing = await (_db.select(_db.albums)
          ..where((a) =>
              a.title.equals(title) &
              (artistId != null
                  ? a.artistId.equals(artistId)
                  : a.artistId.isNull())))
        .getSingleOrNull();

    if (existing != null) {
      // Met à jour la pochette si elle était absente
      if (existing.coverPath == null && coverPath != null) {
        await (_db.update(_db.albums)
              ..where((a) => a.id.equals(existing.id)))
            .write(AlbumsCompanion(coverPath: Value(coverPath)));
      }
      return existing.id;
    }

    return _db.into(_db.albums).insert(
          AlbumsCompanion.insert(
            title: title,
            artistId: Value(artistId),
            artistName: Value(artistName),
            year: Value(year),
            genre: Value(genre),
            coverPath: Value(coverPath),
            source: const Value('local'),
          ),
        );
  }
}
