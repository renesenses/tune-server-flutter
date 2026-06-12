import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../models/domain_models.dart';
import '../../models/enums.dart';
import '../../server/database/database.dart';
import '../../state/app_state.dart';
import '../../state/library_state.dart';
import '../../state/zone_state.dart';
import '../browse/browse_view.dart';
import '../helpers/artwork_view.dart';
import '../helpers/tune_colors.dart';
import '../helpers/tune_fonts.dart';
import '../library/artists_list_view.dart';
import 'history_view.dart';
import 'package:tune_server/services/tune_api_client.dart';

// ---------------------------------------------------------------------------
// T15.2 — HomeView
// Affiché dans SearchView quand aucune requête n'est active.
// Récents, statistiques, accès rapide.
// Miroir de HomeView.swift (iOS)
// ---------------------------------------------------------------------------

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<dynamic>? _topTracks;
  List<dynamic>? _topArtists;
  List<dynamic>? _recommendations;
  List<dynamic>? _continueListening;

  @override
  void initState() {
    super.initState();
    _loadTopContent();
    _loadRecommendations();
    _loadContinueListening();
  }

  Future<void> _loadTopContent() async {
    final app = context.read<AppState>();
    if (app.apiClient == null) return;
    try {
      final tracks = await app.apiClient!.getTopTracks(limit: 20);
      if (mounted) setState(() => _topTracks = tracks);
    } catch (_) {}
    try {
      final artists = await app.apiClient!.getTopArtists(limit: 20);
      if (mounted) setState(() => _topArtists = artists);
    } catch (_) {}
  }

  Future<void> _loadContinueListening() async {
    final app = context.read<AppState>();
    if (app.apiClient == null) return;
    try {
      final data = await app.apiClient!.getContinueListening(limit: 20);
      if (mounted) setState(() => _continueListening = data);
    } catch (_) {}
  }

  Future<void> _loadRecommendations() async {
    final app = context.read<AppState>();
    if (app.apiClient == null) return;
    try {
      final data = await app.apiClient!.getRecommendations(limit: 20);
      final items = data['albums'] as List<dynamic>?;
      if (mounted && items != null) setState(() => _recommendations = items);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final lib = context.watch<LibraryState>();
    final zones = context.watch<ZoneState>();

    // Derive "now listening" reactively from ZoneState — updates in real-time
    // when tracks change via WebSocket/polling (mirrors web client behaviour).
    final nowListening = zones.zones
        .where((z) => z.state == PlaybackState.playing && z.currentTrack != null)
        .map((z) {
          final track = z.currentTrack as Track?;
          return <String, dynamic>{
            'zone_id': z.id,
            'zone_name': z.name,
            'track_title': track?.title ?? '',
            'artist_name': track?.artistName ?? '',
            'cover_path': track?.coverPath,
            'album_id': track?.albumId,
          };
        })
        .toList();

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 16),
      children: [
        // ---- En cours d'écoute (reactive from ZoneState) ----
        if (nowListening.isNotEmpty) ...[
          _SectionTitle(title: "En cours d'écoute"),
          _NowListeningList(items: nowListening, zones: zones),
          const SizedBox(height: 16),
        ],

        // ---- Continue Listening (click to play) ----
        if (_continueListening != null && _continueListening!.isNotEmpty) ...[
          _SectionTitle(title: "Continuer l'écoute"),
          _ContinueListeningList(items: _continueListening!),
          const SizedBox(height: 16),
        ],

        // ---- Récents ----
        if (lib.history.isNotEmpty) ...[
          _SectionTitle(
            title: l.homeRecentlyPlayed,
            trailingLabel: l.btnSeeAll,
            onTrailingTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const HistoryView()),
            ),
          ),
          _RecentsList(tracks: lib.history.map((e) => e.track).toList()),
          const SizedBox(height: 16),
        ],

        // ---- Récemment ajouté ----
        if (lib.recentAlbums.isNotEmpty) ...[
          _SectionTitle(title: 'Récemment ajouté'),
          _RecentAlbumsList(albums: lib.recentAlbums),
          const SizedBox(height: 16),
        ],

        // ---- Top Tracks ----
        if (_topTracks != null && _topTracks!.isNotEmpty) ...[
          _SectionTitle(title: 'Top Tracks'),
          _TopTracksList(tracks: _topTracks!),
          const SizedBox(height: 16),
        ],

        // ---- Top Artists ----
        if (_topArtists != null && _topArtists!.isNotEmpty) ...[
          _SectionTitle(title: 'Top Artists'),
          _TopArtistsList(artists: _topArtists!),
          const SizedBox(height: 16),
        ],

        // ---- Recommandations ----
        if (_recommendations != null && _recommendations!.isNotEmpty) ...[
          _SectionTitle(title: 'Recommandations'),
          _RecommendationsList(albums: _recommendations!),
          const SizedBox(height: 16),
        ],

        // ---- Statistiques bibliothèque ----
        if (lib.stats != null || lib.totalTracks > 0) ...[
          _SectionTitle(title: l.homeLibrary),
          _StatsRow(lib: lib),
          const SizedBox(height: 16),
        ],

        // ---- Accès rapide ----
        _SectionTitle(title: l.homeQuickAccess),
        _QuickAccessGrid(
          hasServers: zones.servers.isNotEmpty,
        ),
        const SizedBox(height: 80),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Section title
// ---------------------------------------------------------------------------

class _SectionTitle extends StatelessWidget {
  final String title;
  final String? trailingLabel;
  final VoidCallback? onTrailingTap;

  const _SectionTitle({
    required this.title,
    this.trailingLabel,
    this.onTrailingTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 12, 8),
      child: Row(
        children: [
          Text(title,
              style: TuneFonts.subheadline
                  .copyWith(color: TuneColors.textPrimary)),
          const Spacer(),
          if (trailingLabel != null)
            TextButton(
              onPressed: onTrailingTap,
              style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 4)),
              child: Text(trailingLabel!,
                  style: const TextStyle(
                      color: TuneColors.accent, fontSize: 13)),
            ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Récents — défilement horizontal
// ---------------------------------------------------------------------------

class _RecentsList extends StatelessWidget {
  final List tracks;
  const _RecentsList({required this.tracks});

  @override
  Widget build(BuildContext context) {
    final app = context.read<AppState>();
    final items = tracks.take(12).toList();

    return SizedBox(
      height: 110,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (_, i) {
          final track = items[i];
          return GestureDetector(
            onTap: () => app.playTracks([track]),
            child: Container(
              width: 90,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: ArtworkView(filePath: track.coverPath, size: 80),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    track.title,
                    style: TuneFonts.caption,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Now Listening — horizontal cards
// ---------------------------------------------------------------------------

class _NowListeningList extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  final ZoneState zones;
  const _NowListeningList({required this.items, required this.zones});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 72,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (_, i) {
          final item = items[i];
          final zoneId = item['zone_id'] as int;
          final zoneName = item['zone_name'] as String? ?? 'Zone';
          final trackTitle = item['track_title'] as String? ?? '';
          final artistName = item['artist_name'] as String? ?? '';
          final coverPath = item['cover_path'] as String?;

          return GestureDetector(
            onTap: () {
              // Switch to this zone
              zones.setCurrentZoneId(zoneId);
            },
            child: Container(
              width: 200,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: TuneColors.surface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: TuneColors.divider),
              ),
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: ArtworkView(filePath: coverPath, size: 48),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(zoneName,
                            style: TuneFonts.caption.copyWith(color: TuneColors.accent),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                        Text(trackTitle,
                            style: TuneFonts.footnote,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                        if (artistName.isNotEmpty)
                          Text(artistName,
                              style: TuneFonts.caption.copyWith(color: TuneColors.textTertiary),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                  // Animated EQ bars indicator
                  const Icon(Icons.equalizer_rounded,
                      size: 16, color: TuneColors.accent),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Continue Listening — horizontal cards, tap to play
// ---------------------------------------------------------------------------

class _ContinueListeningList extends StatelessWidget {
  final List<dynamic> items;
  const _ContinueListeningList({required this.items});

  void _playAlbum(AppState app, int? albumId) {
    if (albumId != null && app.apiClient != null) {
      app.apiClient!.getAlbumTracks(albumId).then((data) {
        final tracks = data
            .map((t) => trackFromJson(t as Map<String, dynamic>))
            .toList();
        if (tracks.isNotEmpty) app.playTracks(tracks);
      }).catchError((_) {});
    }
  }

  void _navigateToArtist(BuildContext context, String artistName) {
    final app = context.read<AppState>();
    final artists = app.libraryState.artists;
    final artist = artists.cast<Artist?>().where(
      (a) => a?.name == artistName,
    ).firstOrNull;
    if (artist != null) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => ArtistDetailView(artist: artist),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final app = context.read<AppState>();
    final displayItems = items.take(20).toList();

    return SizedBox(
      height: 210,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        scrollDirection: Axis.horizontal,
        itemCount: displayItems.length,
        itemBuilder: (_, i) {
          final item = displayItems[i] as Map<String, dynamic>;
          final title = item['title'] as String? ?? item['album_title'] as String? ?? '';
          final artist = item['artist_name'] as String? ?? '';
          final coverPath = item['cover_path'] as String?;
          final albumId = item['album_id'] as int? ?? item['id'] as int?;
          final progressPercent = item['progress_percent'] as num?;

          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: SizedBox(
              width: 150,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Cover art with play overlay — tap to play
                  GestureDetector(
                    onTap: () => _playAlbum(app, albumId),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: ArtworkView(filePath: coverPath, size: 150),
                        ),
                        // Play overlay
                        Positioned(
                          right: 8,
                          bottom: 8,
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: TuneColors.accent.withValues(alpha: 0.9),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.play_arrow_rounded,
                                size: 22, color: Colors.white),
                          ),
                        ),
                        // Progress bar overlay at the bottom
                        if (progressPercent != null)
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                  bottom: Radius.circular(10)),
                              child: LinearProgressIndicator(
                                value: (progressPercent / 100).clamp(0.0, 1.0).toDouble(),
                                minHeight: 3,
                                backgroundColor: Colors.black26,
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                    TuneColors.accent),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Title — tap to play
                  GestureDetector(
                    onTap: () => _playAlbum(app, albumId),
                    child: Text(title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 12, color: TuneColors.textPrimary)),
                  ),
                  // Artist — tap to navigate to artist page
                  if (artist.isNotEmpty)
                    GestureDetector(
                      onTap: () => _navigateToArtist(context, artist),
                      child: Text(artist,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 11, color: TuneColors.textSecondary)),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Récemment ajouté — défilement horizontal d'albums
// ---------------------------------------------------------------------------

class _RecentAlbumsList extends StatelessWidget {
  final List<Album> albums;
  const _RecentAlbumsList({required this.albums});

  @override
  Widget build(BuildContext context) {
    final items = albums.take(20).toList();
    return SizedBox(
      height: 160,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, index) {
          final album = items[index];
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: SizedBox(
              width: 120,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ArtworkView(filePath: album.coverPath, size: 120),
                  const SizedBox(height: 4),
                  Text(album.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12, color: TuneColors.textPrimary)),
                  Text(album.artistName ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 11, color: TuneColors.textSecondary)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Top Tracks — défilement horizontal
// ---------------------------------------------------------------------------

class _TopTracksList extends StatelessWidget {
  final List<dynamic> tracks;
  const _TopTracksList({required this.tracks});

  /// Play a top track using track_id (local) or streaming search (tidal/qobuz/etc).
  /// Mirrors web client's playTopTrack logic.
  Future<void> _playTopTrack(AppState app, Map<String, dynamic> item) async {
    final trackId = item['track_id'] as int?;
    final source = item['source'] as String?;
    final title = item['title'] as String? ?? '';
    final artistName = item['artist_name'] as String? ?? '';

    // Local track with track_id — play directly
    if (trackId != null && trackId > 0 && (source == null || source == 'local')) {
      final track = Track(
        id: trackId,
        title: title,
        artistName: artistName,
        coverPath: item['cover_path'] as String?,
        albumTitle: item['album_title'] as String?,
        source: 'local',
        favorite: false,
      );
      await app.playTracks([track]);
      return;
    }

    // Streaming source — search the streaming service
    if (source != null && source != 'local' && app.apiClient != null) {
      try {
        final results = await app.apiClient!.searchStreaming(
          source,
          '$title $artistName',
          limit: 5,
        );
        final searchTracks = (results is Map) ? (results['tracks'] as List? ?? []) : [];
        for (final t in searchTracks) {
          final m = t as Map<String, dynamic>;
          if (m['title'] == title && m['source_id'] != null) {
            final track = Track(
              id: 0,
              title: m['title'] as String? ?? title,
              artistName: m['artist_name'] as String? ?? artistName,
              source: source,
              sourceId: m['source_id'] as String?,
              coverPath: m['cover_path'] as String?,
              favorite: false,
            );
            await app.play(track: track);
            return;
          }
        }
      } catch (_) {}
    }

    // Fallback: search local library
    if (app.apiClient != null) {
      try {
        final results = await app.apiClient!.searchLibrary(
          '$title $artistName',
          limit: 5,
        );
        final searchTracks = (results is Map) ? (results['tracks'] as List? ?? []) : [];
        for (final t in searchTracks) {
          final m = t as Map<String, dynamic>;
          if (m['title'] == title && m['id'] != null) {
            final track = trackFromJson(m);
            await app.playTracks([track]);
            return;
          }
        }
      } catch (_) {}
    }

    // Last resort: build a Track from the available data and try
    if (trackId != null && trackId > 0) {
      final track = trackFromJson(item);
      await app.playTracks([track]);
    }
  }

  /// Navigate to the artist page by matching the artist name in the library.
  void _navigateToArtist(BuildContext context, String artistName) {
    final app = context.read<AppState>();
    final artists = app.libraryState.artists;
    final artist = artists.cast<Artist?>().where(
      (a) => a?.name == artistName,
    ).firstOrNull;
    if (artist != null) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => ArtistDetailView(artist: artist),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final app = context.read<AppState>();
    final items = tracks.take(20).toList();

    return SizedBox(
      height: 130,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (_, i) {
          final item = items[i] as Map<String, dynamic>;
          final title = item['title'] as String? ?? '';
          final artistName = item['artist_name'] as String? ?? '';
          final coverPath = item['cover_path'] as String?;
          return Container(
            width: 90,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            child: Column(
              children: [
                // Cover — tap to play
                GestureDetector(
                  onTap: () => _playTopTrack(app, item),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: ArtworkView(filePath: coverPath, size: 80),
                  ),
                ),
                const SizedBox(height: 4),
                // Title — tap to play
                GestureDetector(
                  onTap: () => _playTopTrack(app, item),
                  child: Text(
                    title,
                    style: TuneFonts.caption,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
                // Artist — tap to navigate to artist page
                if (artistName.isNotEmpty)
                  GestureDetector(
                    onTap: () => _navigateToArtist(context, artistName),
                    child: Text(
                      artistName,
                      style: TuneFonts.caption.copyWith(
                        color: TuneColors.textSecondary,
                        fontSize: 10,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Top Artists — défilement horizontal
// ---------------------------------------------------------------------------

class _TopArtistsList extends StatelessWidget {
  final List<dynamic> artists;
  const _TopArtistsList({required this.artists});

  @override
  Widget build(BuildContext context) {
    final items = artists.take(20).toList();

    return SizedBox(
      height: 110,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (_, i) {
          final item = items[i] as Map<String, dynamic>;
          final name = item['name'] as String? ?? '';
          final imagePath = item['image_path'] as String?;

          return Container(
            width: 90,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            child: Column(
              children: [
                ClipOval(
                  child: ArtworkView(filePath: imagePath, size: 72),
                ),
                const SizedBox(height: 4),
                Text(
                  name,
                  style: TuneFonts.caption,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Recommandations — horizontal scroll with cover + title + reason chip
// ---------------------------------------------------------------------------

class _RecommendationsList extends StatelessWidget {
  final List<dynamic> albums;
  const _RecommendationsList({required this.albums});

  @override
  Widget build(BuildContext context) {
    final app = context.read<AppState>();
    final items = albums.take(20).toList();

    return SizedBox(
      height: 190,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (_, i) {
          final item = items[i] as Map<String, dynamic>;
          final title = item['title'] as String? ?? '';
          final artist = item['artist_name'] as String? ?? '';
          final coverPath = item['cover_path'] as String?;
          final reason = item['reason'] as String?;
          final albumId = item['id'] as int?;

          return GestureDetector(
            onTap: () {
              if (albumId != null && app.apiClient != null) {
                // Play the album
                app.apiClient!.getAlbumTracks(albumId).then((data) {
                  final tracks = data.map((t) => trackFromJson(t as Map<String, dynamic>)).toList();
                  if (tracks.isNotEmpty) app.playTracks(tracks);
                }).catchError((_) {});
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: SizedBox(
                width: 130,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ArtworkView(filePath: coverPath, size: 130, cornerRadius: 8),
                    const SizedBox(height: 4),
                    Text(title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12, color: TuneColors.textPrimary)),
                    Text(artist,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 11, color: TuneColors.textSecondary)),
                    if (reason != null) ...[
                      const SizedBox(height: 2),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                        decoration: BoxDecoration(
                          color: TuneColors.accent.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          reason,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 10, color: TuneColors.accentLight),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Statistiques
// ---------------------------------------------------------------------------

class _StatsRow extends StatelessWidget {
  final LibraryState lib;
  const _StatsRow({required this.lib});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _StatChip(
              icon: Icons.music_note_rounded,
              value: lib.totalTracks,
              label: l.homeStatTracks),
          const SizedBox(width: 8),
          _StatChip(
              icon: Icons.album_rounded,
              value: lib.totalAlbums,
              label: l.homeStatAlbums),
          const SizedBox(width: 8),
          _StatChip(
              icon: Icons.people_rounded,
              value: lib.totalArtists,
              label: l.homeStatArtists),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final int value;
  final String label;

  const _StatChip(
      {required this.icon, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: TuneColors.surface,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 14, color: TuneColors.accent),
            const SizedBox(width: 6),
            Text(
              '$value $label',
              style: TuneFonts.footnote
                  .copyWith(color: TuneColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Accès rapide
// ---------------------------------------------------------------------------

class _QuickAccessGrid extends StatelessWidget {
  final bool hasServers;
  const _QuickAccessGrid({required this.hasServers});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
          _QuickCard(
            icon: Icons.history_rounded,
            label: AppLocalizations.of(context).homeHistory,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const HistoryView()),
            ),
          ),
          if (hasServers)
            _QuickCard(
              icon: Icons.devices_rounded,
              label: AppLocalizations.of(context).homeBrowseDlna,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const BrowseView()),
              ),
            ),
        ],
      ),
    );
  }
}

class _QuickCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickCard(
      {required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 140,
        padding:
            const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: TuneColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: TuneColors.divider),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: TuneColors.accent),
            const SizedBox(width: 8),
            Expanded(
              child: Text(label,
                  style: TuneFonts.footnote
                      .copyWith(color: TuneColors.textPrimary),
                  maxLines: 2),
            ),
          ],
        ),
      ),
    );
  }
}
