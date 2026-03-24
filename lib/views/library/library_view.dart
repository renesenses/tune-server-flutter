import 'dart:io';

import 'package:flutter/material.dart';

import '../helpers/tune_colors.dart';
import '../helpers/tune_fonts.dart';
import 'albums_grid_view.dart';
import 'apple_music_view.dart';
import 'artists_list_view.dart';
import 'genres_view.dart';
import 'playlists_view.dart';
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
    return Scaffold(
      backgroundColor: TuneColors.background,
      appBar: AppBar(
        backgroundColor: TuneColors.surface,
        title: const Text('Bibliothèque', style: TuneFonts.title2),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          indicatorColor: TuneColors.accent,
          labelColor: TuneColors.accent,
          unselectedLabelColor: TuneColors.textSecondary,
          dividerColor: TuneColors.divider,
          tabs: [
            const Tab(text: 'Albums'),
            const Tab(text: 'Artistes'),
            const Tab(text: 'Pistes'),
            const Tab(text: 'Genres'),
            const Tab(text: 'Playlists'),
            if (_showAppleMusic) const Tab(text: 'Apple Music'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          const AlbumsGridView(),
          const ArtistsListView(),
          const TracksListView(),
          const GenresView(),
          const PlaylistsView(),
          if (_showAppleMusic) const AppleMusicView(),
        ],
      ),
    );
  }
}
