import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../models/domain_models.dart';
import '../../server/database/database.dart';
import '../../state/library_state.dart';
import '../helpers/artwork_view.dart';
import '../helpers/tune_colors.dart';
import '../helpers/tune_fonts.dart';
import 'albums_grid_view.dart';

// ---------------------------------------------------------------------------
// T12.5 — GenresView
// Liste des genres agrégés depuis les albums, avec compteur.
// Tap → GenreAlbumsView : grille albums filtrés par genre.
// Miroir de GenresView.swift (iOS)
// ---------------------------------------------------------------------------

class GenresView extends StatelessWidget {
  const GenresView({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final albums = context.watch<LibraryState>().albums;
    final genres = _buildGenres(albums);

    if (genres.isEmpty) {
      return LibraryEmptyState(
        icon: Icons.category_rounded,
        message: l.libraryEmptyGenres,
      );
    }

    return ListView.separated(
      itemCount: genres.length,
      separatorBuilder: (_, __) =>
          const Divider(height: 1, indent: 16, color: TuneColors.divider),
      itemBuilder: (_, i) => _GenreTile(genre: genres[i]),
    );
  }

  static List<GenreInfo> _buildGenres(List<Album> albums) {
    final map = <String, int>{};
    for (final album in albums) {
      final g = album.genre?.trim();
      if (g != null && g.isNotEmpty) {
        map[g] = (map[g] ?? 0) + 1;
      }
    }
    return map.entries
        .map((e) => GenreInfo(name: e.key, count: e.value))
        .toList()
      ..sort((a, b) => a.name.compareTo(b.name));
  }
}

// ---------------------------------------------------------------------------
// _GenreTile
// ---------------------------------------------------------------------------

class _GenreTile extends StatelessWidget {
  final GenreInfo genre;
  const _GenreTile({required this.genre});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: TuneColors.accent.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.category_rounded,
            color: TuneColors.accent, size: 22),
      ),
      title: Text(genre.name, style: TuneFonts.body),
      subtitle: Text(
        '${genre.count} album${genre.count > 1 ? "s" : ""}',
        style: TuneFonts.footnote,
      ),
      trailing: const Icon(Icons.chevron_right_rounded,
          color: TuneColors.textTertiary),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
            builder: (_) => GenreAlbumsView(genre: genre.name)),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// GenreAlbumsView — albums filtrés par genre
// ---------------------------------------------------------------------------

class GenreAlbumsView extends StatelessWidget {
  final String genre;
  const GenreAlbumsView({super.key, required this.genre});

  @override
  Widget build(BuildContext context) {
    final allAlbums = context.watch<LibraryState>().albums;
    final albums =
        allAlbums.where((a) => a.genre?.trim() == genre).toList();

    return Scaffold(
      backgroundColor: TuneColors.background,
      appBar: AppBar(
        backgroundColor: TuneColors.surface,
        title: Text(genre,
            style: TuneFonts.title3,
            maxLines: 1,
            overflow: TextOverflow.ellipsis),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(24),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              '${albums.length} album${albums.length > 1 ? "s" : ""}',
              style: TuneFonts.footnote,
            ),
          ),
        ),
      ),
      body: albums.isEmpty
          ? LibraryEmptyState(
              icon: Icons.album_rounded,
              message: AppLocalizations.of(context).libraryEmptyAlbums)
          : GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.72,
              ),
              itemCount: albums.length,
              itemBuilder: (_, i) => _GenreAlbumCard(album: albums[i]),
            ),
    );
  }
}

class _GenreAlbumCard extends StatelessWidget {
  final Album album;
  const _GenreAlbumCard({required this.album});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
            builder: (_) => AlbumDetailView(album: album)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
