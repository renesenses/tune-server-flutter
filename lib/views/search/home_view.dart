import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../models/domain_models.dart';
import '../../server/database/database.dart';
import '../../state/app_state.dart';
import '../../state/library_state.dart';
import '../../state/zone_state.dart';
import '../browse/browse_view.dart';
import '../helpers/artwork_view.dart';
import '../helpers/tune_colors.dart';
import '../helpers/tune_fonts.dart';
import 'history_view.dart';

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

  @override
  void initState() {
    super.initState();
    _loadTopContent();
    _loadRecommendations();
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

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 16),
      children: [
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

  @override
  Widget build(BuildContext context) {
    final app = context.read<AppState>();
    final items = tracks.take(20).toList();

    return SizedBox(
      height: 110,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (_, i) {
          final item = items[i] as Map<String, dynamic>;
          final title = item['title'] as String? ?? '';
          final coverPath = item['cover_path'] as String?;
          return GestureDetector(
            onTap: () {
              final track = trackFromJson(item);
              app.playTracks([track]);
            },
            child: Container(
              width: 90,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: ArtworkView(filePath: coverPath, size: 80),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    title,
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
