import 'package:drift/drift.dart';

import '../models/enums.dart';
import 'configuration.dart';
import 'database/database.dart';
import 'discovery/discovery_manager.dart';
import 'discovery/upnp_indexer.dart';
import 'event_bus.dart';
import 'library/apple_music_library.dart';
import 'library/artwork_manager.dart';
import 'library/library_scanner.dart';
import 'outputs/http_audio_streamer.dart';
import 'streaming/radio_metadata_service.dart';
import 'streaming/streaming_manager.dart';
import 'streaming/streaming_service.dart';
import 'utils/network_utils.dart';
import 'zones/zone_manager.dart';

// ---------------------------------------------------------------------------
// T9.1 — ServerEngine
// Orchestre tous les services. Point d'entrée unique pour l'AppState.
// Miroir de ServerEngine.swift (iOS)
// ---------------------------------------------------------------------------

/// Statistiques de la bibliothèque.
class LibraryStats {
  final int trackCount;
  final int albumCount;
  final int artistCount;
  final int playlistCount;
  final int radioCount;
  final int artworkCacheBytes;

  const LibraryStats({
    required this.trackCount,
    required this.albumCount,
    required this.artistCount,
    required this.playlistCount,
    required this.radioCount,
    required this.artworkCacheBytes,
  });
}

/// Résultat de recherche fédérée (bibliothèque locale + streaming).
sealed class SearchResult {
  const SearchResult();
}

class TrackSearchResult extends SearchResult {
  final Track track;
  const TrackSearchResult(this.track);
}

class AlbumSearchResult extends SearchResult {
  final Album album;
  const AlbumSearchResult(this.album);
}

class ArtistSearchResult extends SearchResult {
  final Artist artist;
  const ArtistSearchResult(this.artist);
}

class StreamingResult extends SearchResult {
  final StreamingSearchResult item;
  const StreamingResult(this.item);
}

class ServerEngine {
  // Services principaux
  final TuneDatabase db;
  final ServerConfiguration config;
  final ZoneManager zoneManager;
  final DiscoveryManager discoveryManager;
  final UPnPIndexer upnpIndexer;
  final StreamingManager streamingManager;
  final LibraryScanner libraryScanner;
  final HttpAudioStreamer httpStreamer;

  String? _localIp;
  bool _running = false;

  ServerEngine._({
    required this.db,
    required this.config,
    required this.zoneManager,
    required this.discoveryManager,
    required this.upnpIndexer,
    required this.streamingManager,
    required this.libraryScanner,
    required this.httpStreamer,
  });

  /// Crée et initialise le ServerEngine.
  static Future<ServerEngine> create({
    String qobuzAppId = '',
    String qobuzAppSecret = '',
  }) async {
    final db = TuneDatabase();
    final config = ServerConfiguration.instance;
    await config.load();

    final discoveryManager = DiscoveryManager(db);
    final upnpIndexer = UPnPIndexer(db);
    final zoneManager = ZoneManager(db, discoveryManager);
    final streamingManager = StreamingManager(
      db,
      qobuzAppId: qobuzAppId,
      qobuzAppSecret: qobuzAppSecret,
    );
    final httpStreamer = HttpAudioStreamer(port: config.httpStreamerPort);
    final libraryScanner = LibraryScanner(db);

    await ArtworkManager.instance.initialize();

    return ServerEngine._(
      db: db,
      config: config,
      zoneManager: zoneManager,
      discoveryManager: discoveryManager,
      upnpIndexer: upnpIndexer,
      streamingManager: streamingManager,
      libraryScanner: libraryScanner,
      httpStreamer: httpStreamer,
    );
  }

  bool get isRunning => _running;
  String? get localIp => _localIp;

  // ---------------------------------------------------------------------------
  // Lifecycle
  // ---------------------------------------------------------------------------

  Future<void> start() async {
    if (_running) return;

    // 1. IP locale
    _localIp = await NetworkUtils.localIpAddress();

    // 2. HTTP streamer
    await httpStreamer.start();

    // 3. Bootstrap DB → zones
    await zoneManager.bootstrap();

    // 4. Streaming services (restaure les tokens)
    await streamingManager.bootstrap();

    // 5. Discovery UPnP/DLNA
    await discoveryManager.start();

    _running = true;
    EventBus.instance.emit(ServerStartedEvent(config.httpStreamerPort));
  }

  Future<void> stop() async {
    if (!_running) return;
    RadioMetadataService.instance.stopAll();
    discoveryManager.stop();
    await httpStreamer.stop();
    await zoneManager.dispose();
    _running = false;
    EventBus.instance.emit(const ServerStoppedEvent());
  }

  // ---------------------------------------------------------------------------
  // Bibliothèque locale
  // ---------------------------------------------------------------------------

  /// Lance le scan de tous les dossiers enregistrés.
  Future<void> scanLibrary() async {
    final folders = await db.select(db.musicFolders).get();
    final paths = folders.map((f) => f.path).toList();

    // Sur iOS, inclut aussi la bibliothèque Apple Music si autorisée
    if (await _shouldIncludeAppleMusic()) {
      await _indexAppleMusicLibrary();
    }

    if (paths.isNotEmpty) {
      await libraryScanner.scan(paths);
    }
  }

  /// Ajoute un dossier musique et lance un scan incrémental.
  Future<void> addMusicFolder(String path) async {
    await db.into(db.musicFolders).insertOnConflictUpdate(
          MusicFoldersCompanion.insert(
            path: path,
            addedAt: DateTime.now().toIso8601String(),
          ),
        );
    await libraryScanner.scan([path]);
  }

  Future<void> removeMusicFolder(int id) async {
    await (db.delete(db.musicFolders)..where((f) => f.id.equals(id))).go();
  }

  Future<List<MusicFolder>> musicFolders() =>
      db.select(db.musicFolders).get();

  // ---------------------------------------------------------------------------
  // Recherche fédérée
  // ---------------------------------------------------------------------------

  Future<List<SearchResult>> search(String query, {int limit = 20}) async {
    final results = <SearchResult>[];

    // Bibliothèque locale (FTS5)
    final tracks = await db.trackRepo.search(query, limit: limit);
    final albums = await db.albumRepo.search(query, limit: limit ~/ 2);
    final artists = await db.artistRepo.search(query, limit: limit ~/ 4);

    results.addAll(artists.map(ArtistSearchResult.new));
    results.addAll(albums.map(AlbumSearchResult.new));
    results.addAll(tracks.map(TrackSearchResult.new));

    // Services streaming en parallèle
    final streamingResults =
        await streamingManager.searchAll(query, limitPerService: limit);
    for (final items in streamingResults.values) {
      results.addAll(items.map(StreamingResult.new));
    }

    return results;
  }

  // ---------------------------------------------------------------------------
  // Statistiques
  // ---------------------------------------------------------------------------

  Future<LibraryStats> stats() async {
    final trackCount = await db.trackRepo.count();
    final albumCount = await db.albumRepo.count();
    final artistCount = await db.artistRepo.count();
    final playlists = await db.playlistRepo.all();
    final radios = await db.radioRepo.all();
    final artworkSize = await ArtworkManager.instance.cacheSize();

    return LibraryStats(
      trackCount: trackCount,
      albumCount: albumCount,
      artistCount: artistCount,
      playlistCount: playlists.length,
      radioCount: radios.length,
      artworkCacheBytes: artworkSize,
    );
  }

  // ---------------------------------------------------------------------------
  // Devices
  // ---------------------------------------------------------------------------

  List<DiscoveredDevice> allDevices() => discoveryManager.allDevices();
  List<DiscoveredDevice> upnpServers() => discoveryManager.servers();
  List<DiscoveredDevice> dlnaRenderers() => discoveryManager.renderers();

  Future<void> forgetDevice(String id) => discoveryManager.forgetDevice(id);

  /// Indexe récursivement le ContentDirectory d'un serveur UPnP.
  Future<void> indexUPnPDevice(DiscoveredDevice device) =>
      upnpIndexer.indexDevice(device);

  /// Probe manuel d'un hôte pour y trouver un device UPnP (port 49152 par défaut).
  Future<DiscoveredDevice?> probeDevice(String host, {int port = 49152}) =>
      discoveryManager.probeHost(host, port: port);

  // ---------------------------------------------------------------------------
  // Nettoyage bibliothèque
  // ---------------------------------------------------------------------------

  /// Supprime toutes les pistes/albums/artistes locaux de la DB.
  Future<void> clearLibrary() async {
    await db.customUpdate(
      "DELETE FROM tracks WHERE source = 'local'",
      updates: {db.tracks},
    );
    await _removeOrphanAlbums();
    await _removeOrphanArtists();
    await ArtworkManager.instance.clearCache();
  }

  /// Supprime les albums et artistes sans pistes associées.
  Future<void> cleanupOrphans() async {
    await _removeOrphanAlbums();
    await _removeOrphanArtists();
  }

  Future<void> _removeOrphanAlbums() async {
    await db.customUpdate(
      'DELETE FROM albums WHERE id NOT IN (SELECT DISTINCT album_id FROM tracks WHERE album_id IS NOT NULL)',
      updates: {db.albums},
    );
  }

  Future<void> _removeOrphanArtists() async {
    await db.customUpdate(
      'DELETE FROM artists WHERE id NOT IN '
      '(SELECT DISTINCT artist_id FROM tracks WHERE artist_id IS NOT NULL) '
      'AND id NOT IN '
      '(SELECT DISTINCT artist_id FROM albums WHERE artist_id IS NOT NULL)',
      updates: {db.artists},
    );
  }

  // ---------------------------------------------------------------------------
  // Apple Music (iOS seulement)
  // ---------------------------------------------------------------------------

  Future<bool> _shouldIncludeAppleMusic() async {
    try {
      final lib = AppleMusicLibrary();
      final status = await lib.authorizationStatus();
      return status == 'authorized';
    } catch (_) {
      return false;
    }
  }

  Future<void> _indexAppleMusicLibrary() async {
    try {
      final lib = AppleMusicLibrary();
      int added = 0;
      await for (final meta in lib.allTracks()) {
        // Upsert dans la DB — délégué au scanner
        await libraryScanner.scan([]); // Trigger interne
        added++;
      }
    } catch (_) {}
  }

  // ---------------------------------------------------------------------------
  // URL helpers (pour les outputs)
  // ---------------------------------------------------------------------------

  /// Construit l'URL locale du streamer pour un filePath.
  /// Utilise 127.0.0.1 si l'IP LAN n'est pas encore disponible.
  String trackStreamUrl(String filePath) {
    final ip = _localIp ?? '127.0.0.1';
    return httpStreamer.trackUrl(ip, filePath);
  }

  String coverStreamUrl(String coverPath) {
    final ip = _localIp ?? '127.0.0.1';
    return httpStreamer.coverUrl(ip, coverPath);
  }
}
