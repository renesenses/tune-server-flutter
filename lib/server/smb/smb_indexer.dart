import 'dart:io';

import 'package:drift/drift.dart' show Value;

import '../database/database.dart';
import '../event_bus.dart';
import 'smb_music_client.dart';

// ---------------------------------------------------------------------------
// SmbIndexer — indexe un partage SMB dans la base de données locale.
// Miroir de SMBIndexer.swift (iOS / GRDB)
// ---------------------------------------------------------------------------

class SmbIndexer {
  final SmbMusicClient client;
  final TuneDatabase db;
  final String serverName;
  final String shareName;

  SmbIndexer({
    required this.client,
    required this.db,
    required this.serverName,
    required this.shareName,
  });

  Future<int> run({
    void Function(int count, String path)? onProgress,
  }) async {
    EventBus.instance.emit(const LibraryScanStartedEvent());
    int tracksAdded = 0;

    try {
      final files = await client.scanMusicFiles(
        progress: (count, path) {
          onProgress?.call(count, path);
          EventBus.instance.emit(LibraryScanProgressEvent(count, 0));
        },
      );

      // Grouper par répertoire parent (approximation album)
      final Map<String, List<SmbFile>> albumGroups = {};
      for (final file in files) {
        final dir = _parentPath(file.path);
        albumGroups.putIfAbsent(dir, () => []).add(file);
      }

      for (final entry in albumGroups.entries) {
        final dirPath = entry.key;
        final dirFiles = entry.value;

        final (artistName, albumName) = _parseArtistAlbum(dirPath);

        final artistId = await _findOrCreateArtist(artistName);
        final albumId = await _findOrCreateAlbum(albumName, artistId, artistName);

        final sortedFiles = List<SmbFile>.from(dirFiles)
          ..sort((a, b) => a.name.compareTo(b.name));

        int trackNumber = 1;
        for (final file in sortedFiles) {
          final title = _parseTrackTitle(file.name);
          final ext = file.name.split('.').last.toLowerCase();
          final smbPath = 'smb://$serverName/$shareName/${file.path}';

          // Vérifie l'existence avant d'insérer
          final existing = await db.trackRepo.byFilePath(smbPath);
          if (existing == null) {
            await db.trackRepo.insert(TracksCompanion.insert(
              title: title,
              albumId: Value(albumId),
              albumTitle: Value(albumName),
              artistId: Value(artistId),
              artistName: Value(artistName),
              trackNumber: Value(trackNumber),
              filePath: Value(smbPath),
              format: Value(ext.toUpperCase()),
            ));
            tracksAdded++;
          }

          trackNumber++;
        }

        // Télécharger la pochette si disponible
        await _downloadCover(dirPath, albumId);

        // Mettre à jour le track count de l'album
        await db.albumRepo.updateTrackCount(albumId);
      }
    } catch (e) {
      EventBus.instance.emit(LibraryScanErrorEvent(e.toString()));
    }

    EventBus.instance.emit(LibraryScanCompletedEvent(tracksAdded, 0));

    return tracksAdded;
  }

  // -------------------------------------------------------------------------
  // Helpers
  // -------------------------------------------------------------------------

  String _parentPath(String filePath) {
    final lastSlash = filePath.lastIndexOf('/');
    return lastSlash > 0 ? filePath.substring(0, lastSlash) : '';
  }

  (String artistName, String albumName) _parseArtistAlbum(String dirPath) {
    final components = dirPath.split('/').where((s) => s.isNotEmpty).toList();
    if (components.length >= 2) {
      return (components[components.length - 2], components.last);
    } else if (components.length == 1) {
      return ('Inconnu', components.first);
    }
    return ('Inconnu', 'Inconnu');
  }

  String _parseTrackTitle(String filename) {
    // Retire l'extension
    final noExt = filename.contains('.')
        ? filename.substring(0, filename.lastIndexOf('.'))
        : filename;
    // Retire les préfixes numériques courants: "01 - Title", "01. Title", etc.
    final patterns = [
      RegExp(r'^_?\d{1,3}\s*[-\.]\s*'),
      RegExp(r'^_?\d{1,3}\s+'),
      RegExp(r'^_?\d{1,3}_'),
    ];
    for (final re in patterns) {
      if (re.hasMatch(noExt)) {
        return noExt.replaceFirst(re, '').trim();
      }
    }
    return noExt.trim();
  }

  Future<int> _findOrCreateArtist(String name) async {
    final existing = await db.artistRepo.byName(name);
    if (existing != null) return existing.id;
    return db.artistRepo.insert(ArtistsCompanion.insert(name: name));
  }

  Future<int> _findOrCreateAlbum(
    String title,
    int artistId,
    String artistName,
  ) async {
    final existing = await db.albumRepo.findByTitleAndArtist(title, artistId);
    if (existing != null) return existing.id;
    return db.albumRepo.insert(AlbumsCompanion.insert(
      title: title,
      artistId: Value(artistId),
      artistName: Value(artistName),
      source: const Value('smb'),
    ));
  }

  static const _coverNames = {
    'folder.jpg', 'folder.png', 'cover.jpg', 'cover.png',
    'front.jpg', 'front.png', 'album.jpg', 'album.png',
  };
  static const _imageExts = {'jpg', 'jpeg', 'png'};

  Future<void> _downloadCover(String dirPath, int albumId) async {
    try {
      final album = await db.albumRepo.byId(albumId);
      if (album?.coverPath != null) return;

      final items = await client.listDirectory(path: dirPath);
      final coverItem = items.firstWhere(
        (i) => _coverNames.contains(i.name.toLowerCase()),
        orElse: () => items.firstWhere(
          (i) => _imageExts.contains(i.name.split('.').last.toLowerCase()) && !i.isDirectory,
          orElse: () => const SmbFile(name: '', path: '', isDirectory: false, size: 0),
        ),
      );
      if (coverItem.name.isEmpty) return;

      final coversDir = Directory('${Directory.systemTemp.path}/smb-covers');
      await coversDir.create(recursive: true);
      final ext = coverItem.name.split('.').last.toLowerCase();
      final dest = File('${coversDir.path}/$albumId.$ext');
      if (await dest.exists()) {
        await db.albumRepo.updateCover(albumId, dest.path);
        return;
      }

      final data = await client.downloadRaw(coverItem.path);
      await dest.writeAsBytes(data);
      await db.albumRepo.updateCover(albumId, dest.path);
    } catch (_) {
      // Pochette optionnelle — on ignore les erreurs
    }
  }
}
