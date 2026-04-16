import 'dart:io';

import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../helpers/tune_colors.dart';
import '../helpers/tune_fonts.dart';
import '../search/search_view.dart';
import 'albums_grid_view.dart';
import 'apple_music_view.dart';
import 'artists_list_view.dart';
import 'favorite_tracks_view.dart';
import 'genres_view.dart';
import '../playlists/playlist_manager_view.dart';
import 'tracks_list_view.dart';

// ---------------------------------------------------------------------------
// T12.1 — LibraryView
// Onglets Albums / Artistes / Pistes / Genres / Playlists (+ Apple Music iOS).
// Miroir de LibraryNavigationView.swift (iOS TabView)
// ---------------------------------------------------------------------------

class LibraryView extends StatefulWidget {
  const LibraryView({super.key});

  @override
  State<LibraryView> createState() => _LibraryViewState();
}

class _LibraryViewState extends State<LibraryView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final bool _showAppleMusic;

  @override
  void initState() {
    super.initState();
    _showAppleMusic = Platform.isIOS;
    _tabController = TabController(
      length: _showAppleMusic ? 6 : 5,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: TuneColors.background,
      appBar: AppBar(
        backgroundColor: TuneColors.surface,
        title: Text(l.libraryTitle, style: TuneFonts.title2),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded,
                color: TuneColors.textSecondary),
            tooltip: l.navSearch,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SearchView()),
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          indicatorColor: TuneColors.accent,
          labelColor: TuneColors.accent,
          unselectedLabelColor: TuneColors.textSecondary,
          dividerColor: TuneColors.divider,
          tabs: [
            Tab(text: l.tabAlbums),
            Tab(text: l.tabArtists),
            Tab(text: l.tabTracks),
            Tab(text: l.tabFavorites),
            Tab(text: l.tabPlaylists),
            if (_showAppleMusic) Tab(text: l.tabAppleMusic),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          const AlbumsGridView(),
          const ArtistsListView(),
          const TracksListView(),
          const FavoriteTracksView(),
          const PlaylistManagerView(),
          if (_showAppleMusic) const AppleMusicView(),
        ],
      ),
    );
  }
}
