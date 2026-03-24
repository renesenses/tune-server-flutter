import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../server/database/database.dart';
import '../../server/server_engine.dart';
import '../../server/streaming/streaming_service.dart';
import '../../state/app_state.dart';
import '../../state/library_state.dart';
import '../helpers/artwork_view.dart';
import '../helpers/tune_colors.dart';
import '../helpers/tune_fonts.dart';
import '../library/albums_grid_view.dart';
import '../library/artists_list_view.dart';
import '../streaming/streaming_album_detail_view.dart';
import 'home_view.dart';

// ---------------------------------------------------------------------------
// T15.1 — SearchView
// Recherche fédérée : bibliothèque locale + tous services streaming en parallèle.
// Quand la barre est vide : affiche HomeView.
// Miroir de SearchView.swift (iOS)
// ---------------------------------------------------------------------------

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final _ctrl = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _ctrl.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onChanged(String q) {
    _debounce?.cancel();
    if (q.trim().isEmpty) {
      context.read<AppState>().clearSearch();
      setState(() {});
      return;
    }
    setState(() {}); // met à jour suffixIcon
    _debounce = Timer(
      const Duration(milliseconds: 500),
      () {
        if (mounted) context.read<AppState>().search(q.trim());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final lib = context.watch<LibraryState>();
    final isEmpty = _ctrl.text.trim().isEmpty;

    return Scaffold(
      backgroundColor: TuneColors.background,
      appBar: AppBar(
        backgroundColor: TuneColors.surface,
        titleSpacing: 12,
        title: TextField(
          controller: _ctrl,
          onChanged: _onChanged,
          style: TuneFonts.body,
          decoration: InputDecoration(
            hintText: 'Rechercher…',
            hintStyle: TuneFonts.footnote,
            prefixIcon: const Icon(Icons.search_rounded, size: 20),
            filled: true,
            fillColor: TuneColors.surfaceVariant,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 8),
            suffixIcon: lib.isSearching
                ? const Padding(
                    padding: EdgeInsets.all(12),
                    child: SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: TuneColors.accent),
                    ),
                  )
                : _ctrl.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded, size: 18),
                        onPressed: () {
                          _ctrl.clear();
                          _onChanged('');
                        },
                      )
                    : null,
          ),
        ),
      ),
      body: isEmpty
          ? const HomeView()
          : lib.isSearching && lib.searchResults.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : lib.searchResults.isEmpty
                  ? const _NoResults()
                  : _SearchResults(results: lib.searchResults),
    );
  }
}

// ---------------------------------------------------------------------------
// _SearchResults — résultats groupés par type
// ---------------------------------------------------------------------------

class _SearchResults extends StatelessWidget {
  final List<SearchResult> results;
  const _SearchResults({required this.results});

  @override
  Widget build(BuildContext context) {
    final tracks = results.whereType<TrackSearchResult>().toList();
    final albums = results.whereType<AlbumSearchResult>().toList();
    final artists = results.whereType<ArtistSearchResult>().toList();
    final streaming = results.whereType<StreamingResult>().toList();

    final sections = <Widget>[
      if (tracks.isNotEmpty) ...[
        _SectionHeader(label: 'Pistes', count: tracks.length),
        ...tracks.map((r) => _TrackTile(result: r)),
      ],
      if (albums.isNotEmpty) ...[
        _SectionHeader(label: 'Albums', count: albums.length),
        ...albums.map((r) => _AlbumTile(result: r)),
      ],
      if (artists.isNotEmpty) ...[
        _SectionHeader(label: 'Artistes', count: artists.length),
        ...artists.map((r) => _ArtistTile(result: r)),
      ],
      if (streaming.isNotEmpty) ...[
        _SectionHeader(label: 'Streaming', count: streaming.length),
        ...streaming.map((r) => _StreamingTile(result: r)),
      ],
      const SizedBox(height: 80),
    ];

    return ListView(
      padding: EdgeInsets.zero,
      children: sections,
    );
  }
}

// ---------------------------------------------------------------------------
// Tuiles résultats
// ---------------------------------------------------------------------------

class _SectionHeader extends StatelessWidget {
  final String label;
  final int count;
  const _SectionHeader({required this.label, required this.count});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Row(
        children: [
          Text(label,
              style: TuneFonts.subheadline
                  .copyWith(color: TuneColors.textPrimary)),
          const SizedBox(width: 6),
          Text('($count)', style: TuneFonts.footnote),
        ],
      ),
    );
  }
}

class _TrackTile extends StatelessWidget {
  final TrackSearchResult result;
  const _TrackTile({required this.result});

  @override
  Widget build(BuildContext context) {
    final track = result.track;
    final app = context.read<AppState>();
    return ListTile(
      onTap: () => app.playTracks([track]),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: ArtworkView(filePath: track.coverPath, size: 44),
      ),
      title: Text(track.title,
          style: TuneFonts.body,
          maxLines: 1,
          overflow: TextOverflow.ellipsis),
      subtitle: _sub(track),
      trailing: FormatBadge(format: track.format),
    );
  }

  Widget? _sub(Track track) {
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

class _AlbumTile extends StatelessWidget {
  final AlbumSearchResult result;
  const _AlbumTile({required this.result});

  @override
  Widget build(BuildContext context) {
    final album = result.album;
    return ListTile(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => AlbumDetailView(album: album),
      )),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: ArtworkView(filePath: album.coverPath, size: 44),
      ),
      title: Text(album.title,
          style: TuneFonts.body,
          maxLines: 1,
          overflow: TextOverflow.ellipsis),
      subtitle: album.artistName != null
          ? Text(album.artistName!,
              style: TuneFonts.footnote,
              maxLines: 1,
              overflow: TextOverflow.ellipsis)
          : null,
      trailing: const Icon(Icons.chevron_right_rounded,
          color: TuneColors.textTertiary),
    );
  }
}

class _ArtistTile extends StatelessWidget {
  final ArtistSearchResult result;
  const _ArtistTile({required this.result});

  @override
  Widget build(BuildContext context) {
    final artist = result.artist;
    return ListTile(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => ArtistDetailView(artist: artist),
      )),
      leading: CircleAvatar(
        radius: 22,
        backgroundColor: TuneColors.accent.withValues(alpha: 0.15),
        child: Text(
          artist.name.isNotEmpty ? artist.name[0].toUpperCase() : '?',
          style: const TextStyle(
              color: TuneColors.accent, fontWeight: FontWeight.w600),
        ),
      ),
      title: Text(artist.name,
          style: TuneFonts.body,
          maxLines: 1,
          overflow: TextOverflow.ellipsis),
      trailing: const Icon(Icons.chevron_right_rounded,
          color: TuneColors.textTertiary),
    );
  }
}

class _StreamingTile extends StatelessWidget {
  final StreamingResult result;
  const _StreamingTile({required this.result});

  @override
  Widget build(BuildContext context) {
    final item = result.item;
    final app = context.read<AppState>();
    return ListTile(
      onTap: () => app.playStreaming(item),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: ArtworkView(url: item.coverUrl, size: 44),
      ),
      title: Text(item.title,
          style: TuneFonts.body,
          maxLines: 1,
          overflow: TextOverflow.ellipsis),
      subtitle: _sub(item),
      trailing: item.album != null
          ? IconButton(
              icon: const Icon(Icons.album_rounded,
                  size: 18, color: TuneColors.textTertiary),
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => StreamingAlbumDetailView(track: item),
              )),
            )
          : null,
    );
  }

  Widget? _sub(StreamingSearchResult item) {
    final parts = <String>[
      if (item.artist != null) item.artist!,
      if (item.album != null) item.album!,
    ];
    if (parts.isEmpty) return null;
    return Text(parts.join(' · '),
        style: TuneFonts.footnote,
        maxLines: 1,
        overflow: TextOverflow.ellipsis);
  }
}

// ---------------------------------------------------------------------------
// Placeholder
// ---------------------------------------------------------------------------

class _NoResults extends StatelessWidget {
  const _NoResults();
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off_rounded, size: 48, color: TuneColors.textTertiary),
          SizedBox(height: 12),
          Text('Aucun résultat', style: TuneFonts.subheadline),
        ],
      ),
    );
  }
}
