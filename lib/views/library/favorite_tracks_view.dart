import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../server/database/database.dart';
import '../../state/app_state.dart';
import '../../state/library_state.dart';
import '../helpers/artwork_view.dart';
import '../helpers/tune_colors.dart';
import '../helpers/tune_fonts.dart';
import 'albums_grid_view.dart' show LibraryEmptyState;

// ---------------------------------------------------------------------------
// FavoriteTracksView
// Affiche la liste des pistes marquées comme favorites.
// Tap → lecture à partir de la piste. Swipe → retire des favoris.
// ---------------------------------------------------------------------------

class FavoriteTracksView extends StatefulWidget {
  const FavoriteTracksView({super.key});

  @override
  State<FavoriteTracksView> createState() => _FavoriteTracksViewState();
}

class _FavoriteTracksViewState extends State<FavoriteTracksView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppState>().refreshFavoriteTracks();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final favorites = context.watch<LibraryState>().favoriteTracks;
    final app = context.read<AppState>();

    if (favorites.isEmpty) {
      return LibraryEmptyState(
        icon: Icons.favorite_border_rounded,
        message: l.libraryEmptyFavorites,
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: favorites.length,
      separatorBuilder: (_, __) => const Divider(
          height: 1, indent: 72, color: TuneColors.divider),
      itemBuilder: (_, i) {
        final track = favorites[i];
        return Dismissible(
          key: ValueKey('fav_${track.id}'),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            color: TuneColors.error,
            child: const Icon(Icons.heart_broken_rounded, color: Colors.white),
          ),
          onDismissed: (_) => app.toggleTrackFavorite(track.id),
          child: _FavoriteTile(
            track: track,
            onTap: () => app.playTracks(favorites, startIndex: i),
          ),
        );
      },
    );
  }
}

class _FavoriteTile extends StatelessWidget {
  final Track track;
  final VoidCallback onTap;
  const _FavoriteTile({required this.track, required this.onTap});

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
      subtitle: _subtitle,
      trailing: const Icon(Icons.favorite_rounded,
          color: TuneColors.accent, size: 18),
    );
  }

  Widget? get _subtitle {
    final parts = <String>[
      if (track.artistName != null) track.artistName!,
      if (track.albumTitle != null) track.albumTitle!,
    ];
    if (parts.isEmpty) return null;
    return Text(parts.join(' · '),
        style: TuneFonts.footnote,
        maxLines: 1,
        overflow: TextOverflow.ellipsis);
  }
}
