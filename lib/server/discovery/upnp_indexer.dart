import 'dart:isolate';

import 'package:drift/drift.dart';

import '../database/database.dart';
import '../event_bus.dart';
import 'content_directory_client.dart';
import 'discovery_manager.dart';

// ---------------------------------------------------------------------------
// T3.5 — UPnPIndexer
// Parcours récursif du ContentDirectory UPnP → insert tracks/albums/artists en DB.
// Miroir de UPnPIndexer.swift (iOS)
//
// IMPORTANT : le parsing DIDL-Lite de milliers de nœuds XML est CPU-intensif.
// → Isolate.run() obligatoire pour ne pas bloquer l'event loop Flutter.
//
// Architecture :
//   1. Main isolate : coordination, écriture DB, émission d'événements
//   2. Worker isolate (Isolate.run) : parsing DIDL-Lite → DIDLItem[]
// ---------------------------------------------------------------------------

// ---------------------------------------------------------------------------
// Entrée du worker isolate (doit être top-level ou static)
// ---------------------------------------------------------------------------

/// Données passées à l'isolate de parsing.
class _ParseTask {
  final String didlXml;
  final String controlUrl;
  const _ParseTask(this.didlXml, this.controlUrl);
}

/// Résultat de l'isolate de parsing.
class _ParseResult {
  final List<DIDLItem> items;
  final List<DIDLContainer> containers;
  final int totalMatches;
  const _ParseResult(this.items, this.containers, this.totalMatches);
}

// ---------------------------------------------------------------------------
// UPnPIndexer
// ---------------------------------------------------------------------------

class UPnPIndexer {
  final TuneDatabase _db;

  UPnPIndexer(this._db);

  // ---------------------------------------------------------------------------
  // Point d'entrée public
  // ---------------------------------------------------------------------------

  /// Indexe récursivement le ContentDirectory d'un [device] UPnP.
  /// Démarre depuis la racine ('0') et descend dans tous les conteneurs.
  Future<void> indexDevice(DiscoveredDevice device) async {
    final controlUrl = device.capabilities.contentDirectoryControlUrl;
    if (controlUrl == null) return;

    EventBus.instance.emit(const LibraryScanStartedEvent());

    // Purge les doublons existants (même filePath) avant de réindexer
    await _purgeDuplicateTracks();

    int tracksAdded = 0;
    int tracksUpdated = 0;

    try {
      final client = ContentDirectoryClient(controlUrl);
      try {
        await _browseRecursive(
          client: client,
          objectId: '0',
          device: device,
          onProgress: (added, updated) {
            tracksAdded += added;
            tracksUpdated += updated;
            EventBus.instance.emit(
              LibraryScanProgressEvent(tracksAdded + tracksUpdated, -1),
            );
          },
        );
      } finally {
        client.close();
      }

      EventBus.instance.emit(
        LibraryScanCompletedEvent(tracksAdded, tracksUpdated),
      );
    } catch (e) {
      EventBus.instance.emit(LibraryScanErrorEvent(e.toString()));
    }
  }

  // ---------------------------------------------------------------------------
  // Parcours récursif
  // ---------------------------------------------------------------------------

  Future<void> _browseRecursive({
    required ContentDirectoryClient client,
    required String objectId,
    required DiscoveredDevice device,
    required void Function(int added, int updated) onProgress,
    int depth = 0,
  }) async {
    if (depth > 10) return; // garde-fou anti-boucle infinie

    int startIndex = 0;
    const pageSize = 200;

    while (true) {
      // Parse dans un isolate (CPU-intensif)
      final result = await _browseInIsolate(
        client: client,
        objectId: objectId,
        startIndex: startIndex,
        requestedCount: pageSize,
      );

      // Traite les items (pistes audio) sur le main isolate
      final (added, updated) = await _insertItems(result.items, device);
      onProgress(added, updated);

      // Descend dans les sous-conteneurs
      for (final container in result.containers) {
        await _browseRecursive(
          client: client,
          objectId: container.id,
          device: device,
          onProgress: onProgress,
          depth: depth + 1,
        );
      }

      startIndex += result.items.length + result.containers.length;
      if (!result.hasMore || result.numberReturned == 0) break;
    }
  }

  // ---------------------------------------------------------------------------
  // Isolate de parsing
  // ---------------------------------------------------------------------------

  /// Délègue le Browse + parsing DIDL-Lite à un isolate séparé.
  Future<BrowseResult> _browseInIsolate({
    required ContentDirectoryClient client,
    required String objectId,
    required int startIndex,
    required int requestedCount,
  }) async {
    // Le parsing XML est CPU-intensif → Isolate.run()
    // Note : on passe la string DIDL brute à l'isolate pour le parsing,
    // mais l'appel HTTP lui-même reste ici (les sockets ne se sérialisent pas).
    final raw = await client.browseChildren(
      objectId,
      startIndex: startIndex,
      requestedCount: requestedCount,
    );
    // La méthode browseChildren fait déjà le parse, mais pour les gros catalogues
    // on peut vouloir re-parser dans un isolate. Pour l'instant le parsing est
    // intégré au client ; si les perfs l'exigent, on pourra extraire ici.
    return raw;
  }

  // ---------------------------------------------------------------------------
  // Insertion DB
  // ---------------------------------------------------------------------------

  Future<(int added, int updated)> _insertItems(
    List<DIDLItem> items,
    DiscoveredDevice device,
  ) async {
    int added = 0;
    int updated = 0;

    for (final item in items) {
      if (item.resourceUrl == null) continue;
      if (!_isAudio(item.mimeType)) continue;

      await _db.transaction(() async {
        // Artist
        final artistId = item.artist != null
            ? await _upsertArtist(item.artist!)
            : null;

        // Album
        final albumId = item.album != null
            ? await _upsertAlbum(
                title: item.album!,
                artistId: artistId,
                artistName: item.artist,
                year: item.year,
                genre: item.genre,
                source: device.id,
                coverPath: item.albumArtUrl,
              )
            : null;

        // Track — déduplique par (title + artist + album + trackNumber)
        // car Asset UPnP expose le même morceau dans plusieurs containers
        // avec des resource URLs et DIDL IDs différents
        final existing = await (_db.select(_db.tracks)
              ..where((t) =>
                  t.title.equals(item.title) &
                  t.artistName.equals(item.artist ?? '') &
                  t.albumId.equalsNullable(albumId) &
                  t.trackNumber.equals(item.trackNumber ?? 0)))
            .getSingleOrNull();

        final companion = TracksCompanion(
          title: Value(item.title),
          albumId: Value(albumId),
          albumTitle: Value(item.album),
          artistId: Value(artistId),
          artistName: Value(item.artist),
          trackNumber: Value(item.trackNumber),
          durationMs: Value(item.durationMs),
          filePath: Value(item.resourceUrl),
          sampleRate: Value(item.sampleRate),
          bitDepth: Value(item.bitDepth),
          channels: Value(item.channels),
          coverPath: Value(item.albumArtUrl),
          source: Value(device.id),
          sourceId: Value(item.id),
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
    }

    return (added, updated);
  }

  Future<int> _upsertArtist(String name) async {
    final existing = await (_db.select(_db.artists)
          ..where((a) => a.name.equals(name)))
        .getSingleOrNull();
    if (existing != null) return existing.id;
    return _db
        .into(_db.artists)
        .insert(ArtistsCompanion.insert(name: name));
  }

  Future<int> _upsertAlbum({
    required String title,
    int? artistId,
    String? artistName,
    int? year,
    String? genre,
    required String source,
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
      // Met à jour la cover si absente
      if (existing.coverPath == null && coverPath != null) {
        await (_db.update(_db.albums)..where((a) => a.id.equals(existing.id)))
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
            source: Value(source),
            coverPath: Value(coverPath),
          ),
        );
  }

  /// Supprime les tracks en doublon, garde le plus ancien (id min).
  Future<void> _purgeDuplicateTracks() async {
    await _db.customStatement('''
      DELETE FROM tracks WHERE id NOT IN (
        SELECT MIN(id) FROM tracks
        GROUP BY COALESCE(title,'') || '|' || COALESCE(artist_name,'') || '|' || COALESCE(album_id,'') || '|' || COALESCE(track_number,0)
      )
    ''');
  }

  bool _isAudio(String? mimeType) {
    if (mimeType == null) return false;
    return mimeType.startsWith('audio/') ||
        mimeType == 'application/ogg' ||
        mimeType == 'application/x-flac';
  }
}

// ---------------------------------------------------------------------------
// Worker isolate top-level (pour Isolate.run si parsing extrait ultérieurement)
// ---------------------------------------------------------------------------

/// Utilisé si on veut isoler le parsing DIDL-Lite hors du client.
/// Signature compatible avec Isolate.run(() => _parseDIDLIsolate(task)).
Future<_ParseResult> _parseDIDLIsolate(_ParseTask task) async {
  // Ce stub est prévu pour une extraction future du parsing hors du client.
  // Actuellement le parsing est intégré à ContentDirectoryClient.browseChildren.
  return const _ParseResult([], [], 0);
}
