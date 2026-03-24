import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../server/database/database.dart';
import '../../state/app_state.dart';
import '../../state/library_state.dart';
import '../helpers/artwork_view.dart';
import '../helpers/tune_colors.dart';
import '../helpers/tune_fonts.dart';
import 'albums_grid_view.dart';

// ---------------------------------------------------------------------------
// T12.3 — ArtistsListView + ArtistDetailView
// Liste des artistes alphabétique ; détail = horizontal scroll albums + pistes.
// Miroir de ArtistsView.swift + ArtistDetailView.swift (iOS)
// ---------------------------------------------------------------------------

class ArtistsListView extends StatelessWidget {
  const ArtistsListView({super.key});

  @override
  Widget build(BuildContext context) {
    final artists = context.watch<LibraryState>().artists;
    if (artists.isEmpty) {
      return const LibraryEmptyState(
        icon: Icons.people_rounded,
        message: 'Aucun artiste dans la bibliothèque',
      );
    }
    return ListView.separated(
      itemCount: artists.length,
      separatorBuilder: (_, __) => const Divider(
          height: 1, indent: 72, color: TuneColors.divider),
      itemBuilder: (_, i) => _ArtistTile(artist: artists[i]),
    );
  }
}

class _ArtistTile extends StatelessWidget {
  final Artist artist;
  const _ArtistTile({required this.artist});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: CircleAvatar(
        radius: 22,
        backgroundColor: TuneColors.surfaceVariant,
        child: artist.imagePath != null
            ? ClipOval(
                child: ArtworkView(
                    filePath: artist.imagePath, size: 44, cornerRadius: 22),
              )
            : const Icon(Icons.person_rounded,
                color: TuneColors.textTertiary),
      ),
      title: Text(artist.name,
          style: TuneFonts.body,
          maxLines: 1,
          overflow: TextOverflow.ellipsis),
      trailing: const Icon(Icons.chevron_right_rounded,
          color: TuneColors.textTertiary),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
            builder: (_) => ArtistDetailView(artist: artist)),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// ArtistDetailView
// ---------------------------------------------------------------------------

class ArtistDetailView extends StatefulWidget {
  final Artist artist;
  const ArtistDetailView({super.key, required this.artist});

  @override
  State<ArtistDetailView> createState() => _ArtistDetailViewState();
}

class _ArtistDetailViewState extends State<ArtistDetailView> {
  List<Album>? _albums;
  List<Track>? _tracks;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final app = context.read<AppState>();
    final results = await Future.wait([
      app.engine.db.albumRepo.forArtist(widget.artist.id),
      app.engine.db.trackRepo.forArtist(widget.artist.id),
    ]);
    if (mounted) {
      setState(() {
        _albums = results[0] as List<Album>;
        _tracks = results[1] as List<Track>;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final artist = widget.artist;

    return Scaffold(
      backgroundColor: TuneColors.background,
      appBar: AppBar(
        backgroundColor: TuneColors.surface,
        title: Text(artist.name,
            style: TuneFonts.title3,
            maxLines: 1,
            overflow: TextOverflow.ellipsis),
      ),
      body: _albums == null
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
                // --- Albums ---
                if (_albums!.isNotEmpty) ...[
                  _sectionHeader('Albums'),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 190,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding:
                            const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _albums!.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(width: 12),
                        itemBuilder: (_, i) =>
                            _AlbumCard(album: _albums![i]),
                      ),
                    ),
                  ),
                ],

                // --- Pistes ---
                if (_tracks != null && _tracks!.isNotEmpty) ...[
                  _sectionHeader(
                      '${_tracks!.length} piste${_tracks!.length > 1 ? "s" : ""}'),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (_, i) => _ArtistTrackTile(
                        track: _tracks![i],
                        onTap: () => context
                            .read<AppState>()
                            .playTracks(_tracks!, startIndex: i),
                      ),
                      childCount: _tracks!.length,
                    ),
                  ),
                ],

                const SliverToBoxAdapter(child: SizedBox(height: 80)),
              ],
            ),
    );
  }

  Widget _sectionHeader(String title) => SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
          child: Text(title, style: TuneFonts.title3),
        ),
      );
}

// ---------------------------------------------------------------------------
// Sous-widgets
// ---------------------------------------------------------------------------

class _AlbumCard extends StatelessWidget {
  final Album album;
  const _AlbumCard({required this.album});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => AlbumDetailView(album: album)),
      ),
      child: SizedBox(
        width: 130,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ArtworkView(
                filePath: album.coverPath, size: 130, cornerRadius: 8),
            const SizedBox(height: 4),
            Text(album.title,
                style: TuneFonts.footnote
                    .copyWith(color: TuneColors.textPrimary),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
            if (album.year != null)
              Text(album.year.toString(), style: TuneFonts.caption),
          ],
        ),
      ),
    );
  }
}

class _ArtistTrackTile extends StatelessWidget {
  final Track track;
  final VoidCallback onTap;
  const _ArtistTrackTile({required this.track, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: ArtworkView(
          filePath: track.coverPath, size: 44, cornerRadius: 4),
      title: Text(track.title,
          style: TuneFonts.body,
          maxLines: 1,
          overflow: TextOverflow.ellipsis),
      subtitle: track.albumTitle != null
          ? Text(track.albumTitle!,
              style: TuneFonts.footnote,
              maxLines: 1,
              overflow: TextOverflow.ellipsis)
          : null,
      trailing: FormatBadge(format: track.format),
    );
  }
}
