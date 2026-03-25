import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../server/database/database.dart';
import '../../state/app_state.dart';
import '../../state/library_state.dart';
import '../helpers/artwork_view.dart';
import '../helpers/tune_colors.dart';
import '../helpers/tune_fonts.dart';
import 'add_to_playlist_sheet.dart';
import 'edit_album_sheet.dart';

// ---------------------------------------------------------------------------
// T12.2 — AlbumsGridView + AlbumDetailView
// Grille de covers, détail album avec tracklist + bouton lecture.
// Miroir de AlbumsView.swift + AlbumDetailView.swift (iOS)
// ---------------------------------------------------------------------------

class AlbumsGridView extends StatelessWidget {
  const AlbumsGridView({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final albums = context.watch<LibraryState>().albums;
    if (albums.isEmpty) {
      return LibraryEmptyState(
        icon: Icons.album_rounded,
        message: l.libraryEmptyAlbums,
      );
    }
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.72,
      ),
      itemCount: albums.length,
      itemBuilder: (_, i) => _AlbumCard(album: albums[i]),
    );
  }
}

class _AlbumCard extends StatelessWidget {
  final Album album;
  const _AlbumCard({required this.album});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => AlbumDetailView(album: album)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Pochette carrée
          Expanded(
            child: LayoutBuilder(
              builder: (_, c) => ArtworkView(
                filePath: album.coverPath,
                size: c.maxWidth,
                cornerRadius: 8,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(album.title,
              style: TuneFonts.callout,
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
          if (album.artistName != null)
            Text(album.artistName!,
                style: TuneFonts.footnote,
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// AlbumDetailView
// ---------------------------------------------------------------------------

class AlbumDetailView extends StatefulWidget {
  final Album album;
  const AlbumDetailView({super.key, required this.album});

  @override
  State<AlbumDetailView> createState() => _AlbumDetailViewState();
}

class _AlbumDetailViewState extends State<AlbumDetailView> {
  List<Track>? _tracks;

  @override
  void initState() {
    super.initState();
    _loadTracks();
  }

  Future<void> _loadTracks() async {
    final app = context.read<AppState>();
    final tracks =
        await app.engine.db.trackRepo.forAlbum(widget.album.id);
    if (mounted) setState(() => _tracks = tracks);
  }

  @override
  Widget build(BuildContext context) {
    final app = context.read<AppState>();
    final album = widget.album;

    return Scaffold(
      backgroundColor: TuneColors.background,
      appBar: AppBar(
        backgroundColor: TuneColors.surface,
        title: Text(album.title,
            style: TuneFonts.title3,
            maxLines: 1,
            overflow: TextOverflow.ellipsis),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_rounded),
            onPressed: () => showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: TuneColors.surface,
              builder: (_) => EditAlbumSheet(album: album),
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // Header artwork + méta
          SliverToBoxAdapter(child: _AlbumHeader(album: album)),

          // Boutons lecture
          SliverToBoxAdapter(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      icon: const Icon(Icons.play_arrow_rounded),
                      label: Text(AppLocalizations.of(context).libraryPlayAlbum),
                      style: FilledButton.styleFrom(
                          backgroundColor: TuneColors.accent),
                      onPressed: _tracks == null || _tracks!.isEmpty
                          ? null
                          : () => app.playTracks(_tracks!),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilledButton.icon(
                    icon: const Icon(Icons.shuffle_rounded),
                    label: Text(AppLocalizations.of(context).btnShuffle),
                    style: FilledButton.styleFrom(
                      backgroundColor: TuneColors.surfaceVariant,
                      foregroundColor: TuneColors.textPrimary,
                    ),
                    onPressed: _tracks == null || _tracks!.isEmpty
                        ? null
                        : () async {
                            await app.setShuffle(enabled: true);
                            final shuffled = List.of(_tracks!)..shuffle();
                            await app.playTracks(shuffled);
                          },
                  ),
                ],
              ),
            ),
          ),

          // Pistes
          if (_tracks == null)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_tracks!.isEmpty)
            SliverFillRemaining(
              child: LibraryEmptyState(
                  icon: Icons.music_off_rounded,
                  message: AppLocalizations.of(context).playlistEmpty),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, i) => _AlbumTrackTile(
                  track: _tracks![i],
                  onTap: () => app.playTracks(_tracks!, startIndex: i),
                  onAddToPlaylist: () => showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: TuneColors.surface,
                    builder: (_) =>
                        AddToPlaylistSheet(track: _tracks![i]),
                  ),
                ),
                childCount: _tracks!.length,
              ),
            ),

          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Sous-widgets privés
// ---------------------------------------------------------------------------

class _AlbumHeader extends StatelessWidget {
  final Album album;
  const _AlbumHeader({required this.album});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: TuneColors.surface,
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          ArtworkView(filePath: album.coverPath, size: 120, cornerRadius: 10),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(album.title,
                    style: TuneFonts.title3,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
                if (album.artistName != null) ...[
                  const SizedBox(height: 4),
                  Text(album.artistName!,
                      style: TuneFonts.subheadline
                          .copyWith(color: TuneColors.accent),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ],
                if (album.year != null) ...[
                  const SizedBox(height: 2),
                  Text(album.year.toString(), style: TuneFonts.caption),
                ],
                if (album.genre != null) ...[
                  const SizedBox(height: 2),
                  Text(album.genre!, style: TuneFonts.caption),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AlbumTrackTile extends StatelessWidget {
  final Track track;
  final VoidCallback onTap;
  final VoidCallback onAddToPlaylist;

  const _AlbumTrackTile({
    required this.track,
    required this.onTap,
    required this.onAddToPlaylist,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: SizedBox(
        width: 32,
        child: Center(
          child: Text(
            track.trackNumber?.toString() ?? '–',
            style: TuneFonts.footnote,
            textAlign: TextAlign.center,
          ),
        ),
      ),
      title: Text(track.title,
          style: TuneFonts.body,
          maxLines: 1,
          overflow: TextOverflow.ellipsis),
      subtitle: track.artistName != null
          ? Text(track.artistName!,
              style: TuneFonts.footnote,
              maxLines: 1,
              overflow: TextOverflow.ellipsis)
          : null,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FormatBadge(format: track.format),
          IconButton(
            icon: const Icon(Icons.more_vert_rounded,
                size: 18, color: TuneColors.textTertiary),
            onPressed: onAddToPlaylist,
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Widgets partagés (publics — réutilisés par les autres vues bibliothèque)
// ---------------------------------------------------------------------------

/// Badge de format audio (FLAC, MP3, AAC…). Hi-res = couleur accent.
class FormatBadge extends StatelessWidget {
  final String? format;
  const FormatBadge({super.key, this.format});

  @override
  Widget build(BuildContext context) {
    if (format == null) return const SizedBox.shrink();
    final lo = format!.toLowerCase();
    final isHiRes = lo == 'flac' || lo == 'alac';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: isHiRes
            ? TuneColors.accent.withValues(alpha: 0.15)
            : TuneColors.surfaceVariant,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        format!.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color:
              isHiRes ? TuneColors.accentLight : TuneColors.textTertiary,
        ),
      ),
    );
  }
}

/// Empty state générique bibliothèque.
class LibraryEmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  const LibraryEmptyState(
      {super.key, required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 56, color: TuneColors.textTertiary),
          const SizedBox(height: 12),
          Text(message, style: TuneFonts.subheadline),
        ],
      ),
    );
  }
}
