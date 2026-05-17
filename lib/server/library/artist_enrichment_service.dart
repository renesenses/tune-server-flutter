import 'dart:async';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../database/database.dart';
import '../event_bus.dart';
import 'artwork_manager.dart';
import 'community_image_service.dart';
import 'cover_art_fetcher.dart';

// ---------------------------------------------------------------------------
// ArtistEnrichmentService
// Background enrichment for artist images with community cache integration.
//
// Priority chain (mirrors Python MetadataEnricher):
//   1. User-provided image (skip — never overwrite)
//   2. Discogs (not available on Flutter — no token)
//   3. Community cache on mozaiklabs.fr (free, no rate limit)
//   4. iTunes Search API (free, 20 req/min)
//   5. MusicBrainz / Cover Art Archive (free, 1 req/s)
//
// After fetching from iTunes or MusicBrainz, the image URL is shared back
// to the community cache so all Tune users benefit.
// ---------------------------------------------------------------------------

/// Image source priority — higher = more trusted.
/// Matches Python _IMAGE_SOURCE_PRIORITY.
const _imageSourcePriority = <String?, int>{
  null: 0,
  'wikipedia': 1,
  'musicbrainz': 2,
  'itunes': 3,
  'community': 3,
  'discogs': 4,
  'user': 5,
};

int _sourcePriority(String? source) => _imageSourcePriority[source] ?? 0;

class ArtistEnrichmentService {
  final TuneDatabase _db;
  final CommunityImageService _communityService;
  final CoverArtFetcher _coverArtFetcher;
  final ArtworkManager _artworkManager;

  bool _running = false;
  Timer? _periodicTimer;
  StreamSubscription? _scanSub;

  ArtistEnrichmentService(
    this._db, {
    CommunityImageService? communityService,
    CoverArtFetcher? coverArtFetcher,
    ArtworkManager? artworkManager,
  })  : _communityService = communityService ?? CommunityImageService(),
        _coverArtFetcher = coverArtFetcher ?? CoverArtFetcher(),
        _artworkManager = artworkManager ?? ArtworkManager.instance;

  // ---------------------------------------------------------------------------
  // Lifecycle
  // ---------------------------------------------------------------------------

  /// Start the enrichment service.
  /// Listens for scan completion events and runs periodic enrichment.
  void start() {
    if (_running) return;
    _running = true;

    // Run enrichment after each library scan
    _scanSub = EventBus.instance.subscribe<LibraryScanCompletedEvent>((_) {
      // Delay to let the DB settle after scan
      Future.delayed(const Duration(seconds: 5), () {
        if (_running) _enrichArtists();
      });
    });

    // Also run periodically (every 10 minutes) for gradual enrichment
    _periodicTimer = Timer.periodic(
      const Duration(minutes: 10),
      (_) {
        if (_running) _enrichArtists();
      },
    );

    // Initial pass after a short delay
    Future.delayed(const Duration(seconds: 15), () {
      if (_running) _enrichArtists();
    });

    debugPrint('[ArtistEnrichment] Service started');
  }

  void stop() {
    _running = false;
    _scanSub?.cancel();
    _scanSub = null;
    _periodicTimer?.cancel();
    _periodicTimer = null;
    debugPrint('[ArtistEnrichment] Service stopped');
  }

  // ---------------------------------------------------------------------------
  // Enrichment pass
  // ---------------------------------------------------------------------------

  Future<void> _enrichArtists() async {
    try {
      final cacheDir = await _getCacheDir();
      final allArtists = await _db.artistRepo.all();

      // Candidates: artists without image, or with a low-priority source
      final candidates = allArtists.where((a) {
        final source = a.imageSource;
        if (source == 'user' || source == 'discogs') return false;
        if (a.imagePath == null || a.imagePath!.isEmpty) return true;
        // Already has community/itunes/musicbrainz — skip
        if (source == 'community' || source == 'itunes') return false;
        return _sourcePriority(source) < _sourcePriority('community');
      }).toList();

      if (candidates.isEmpty) return;

      debugPrint(
          '[ArtistEnrichment] ${candidates.length} artists to enrich');

      int enriched = 0;
      for (final artist in candidates) {
        if (!_running) break;

        final result = await _enrichSingleArtist(artist, cacheDir);
        if (result) enriched++;

        // Rate limiting: 1.5s between requests
        await Future.delayed(const Duration(milliseconds: 1500));
      }

      if (enriched > 0) {
        debugPrint('[ArtistEnrichment] Enriched $enriched artist images');
      }
    } catch (e) {
      debugPrint('[ArtistEnrichment] Error: $e');
    }
  }

  /// Enriches a single artist. Returns true if an image was found.
  Future<bool> _enrichSingleArtist(Artist artist, String cacheDir) async {
    // Step 1: Try community cache (free, fast, no rate limit)
    final communityPath = await _communityService.fetchArtistImage(
      artistName: artist.name,
      cacheDir: cacheDir,
    );
    if (communityPath != null) {
      await _updateArtistImage(artist.id, communityPath, 'community');
      return true;
    }

    // Step 2: Try iTunes Search API
    final iTunesUrl = await _fetchITunesArtistImage(artist.name);
    if (iTunesUrl != null) {
      final localPath = await _artworkManager.coverPathForUrl(iTunesUrl);
      if (localPath != null) {
        await _updateArtistImage(artist.id, localPath, 'itunes');
        // Share to community cache (fire-and-forget)
        _communityService.shareArtistImage(
          artistName: artist.name,
          imageUrl: iTunesUrl,
          source: 'itunes',
        );
        return true;
      }
    }

    // Step 3: Try MusicBrainz (via CoverArtFetcher — it has MB logic for albums,
    // but we can try fetching artist image through a known album)
    // For now, we skip MB artist images as the Flutter CoverArtFetcher
    // does not have a dedicated artist image endpoint for MusicBrainz.
    // The community cache will progressively fill from Python server lookups.

    return false;
  }

  // ---------------------------------------------------------------------------
  // iTunes artist image (higher quality than the existing fetchArtistImage)
  // ---------------------------------------------------------------------------

  /// Fetches an artist image URL from iTunes Search API.
  /// Returns a high-res image URL or null.
  Future<String?> _fetchITunesArtistImage(String artistName) async {
    try {
      // Use CoverArtFetcher to search for an album by this artist,
      // then extract the artist image URL from the result
      final result = await _coverArtFetcher.fetchForAlbum(
        album: '',
        artist: artistName,
      );
      if (result != null && result.artworkUrl.isNotEmpty) {
        return result.artworkUrl;
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  // ---------------------------------------------------------------------------
  // DB update
  // ---------------------------------------------------------------------------

  Future<void> _updateArtistImage(
    int artistId,
    String imagePath,
    String source,
  ) async {
    try {
      await (_db.update(_db.artists)
            ..where((a) => a.id.equals(artistId)))
          .write(ArtistsCompanion(
        imagePath: Value(imagePath),
        imageSource: Value(source),
      ));
    } catch (e) {
      debugPrint('[ArtistEnrichment] DB update failed: $e');
    }
  }

  // ---------------------------------------------------------------------------
  // Cache directory
  // ---------------------------------------------------------------------------

  String? _cachedDir;

  Future<String> _getCacheDir() async {
    if (_cachedDir != null) return _cachedDir!;
    final support = await getApplicationSupportDirectory();
    _cachedDir = p.join(support.path, 'artwork_cache');
    return _cachedDir!;
  }
}
