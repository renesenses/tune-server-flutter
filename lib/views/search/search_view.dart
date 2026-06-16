import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../server/database/database.dart';
import '../../server/server_engine.dart';
import '../../server/streaming/streaming_service.dart';
import '../../state/app_state.dart';
import '../../state/library_state.dart';
import '../../state/settings_state.dart';
import '../../widgets/metadata_chips.dart';
import '../helpers/artwork_view.dart';
import '../helpers/tune_colors.dart';
import '../helpers/tune_fonts.dart';
import '../library/albums_grid_view.dart';
import '../library/artists_list_view.dart';
import '../streaming/streaming_album_detail_view.dart';
import '../streaming/streaming_helpers.dart';
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
            hintText: AppLocalizations.of(context).searchHint,
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
// _SearchResults — résultats groupés : local (tracks/albums/artists)
// puis chaque service streaming séparément
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

    // Group streaming results by service
    final byService = <String, List<StreamingResult>>{};
    for (final r in streaming) {
      (byService[r.item.serviceId] ??= []).add(r);
    }

    final l = AppLocalizations.of(context);
    final hasLocal = tracks.isNotEmpty || albums.isNotEmpty || artists.isNotEmpty;
    final sections = <Widget>[
      // --- Local library results ---
      if (hasLocal) ...[
        _SourceHeader(label: l.homeLibrary, icon: Icons.library_music_rounded,
            color: TuneColors.accent),
        if (artists.isNotEmpty) ...[
          _SectionHeader(label: l.searchSectionArtists, count: artists.length),
          ...artists.map((r) => _ArtistTile(result: r)),
        ],
        if (albums.isNotEmpty) ...[
          _SectionHeader(label: l.searchSectionAlbums, count: albums.length),
          ...albums.map((r) => _AlbumTile(result: r)),
        ],
        if (tracks.isNotEmpty) ...[
          _SectionHeader(label: l.searchSectionTracks, count: tracks.length),
          ...tracks.map((r) => _TrackTile(result: r)),
        ],
      ],
      // --- Streaming service results, one section per service ---
      for (final entry in byService.entries) ...[
        _ServiceSection(serviceId: entry.key, items: entry.value),
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
// Source & Section headers
// ---------------------------------------------------------------------------

/// Top-level source header (e.g. "Library", "Tidal", "Qobuz").
class _SourceHeader extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  const _SourceHeader({required this.label, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: color.withValues(alpha: 0.3), width: 1),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 8),
          Text(label,
              style: TuneFonts.subheadline.copyWith(
                  color: color, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

/// Sub-section header within a source (e.g. "Tracks (5)").
class _SectionHeader extends StatelessWidget {
  final String label;
  final int count;
  const _SectionHeader({required this.label, required this.count});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Row(
        children: [
          Text(label,
              style: TuneFonts.footnote.copyWith(
                  color: TuneColors.textSecondary,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5)),
          const SizedBox(width: 6),
          Text('($count)',
              style: TuneFonts.footnote.copyWith(
                  color: TuneColors.textTertiary)),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _ServiceSection — streaming results grouped by service
// ---------------------------------------------------------------------------

class _ServiceSection extends StatelessWidget {
  final String serviceId;
  final List<StreamingResult> items;
  const _ServiceSection({required this.serviceId, required this.items});

  @override
  Widget build(BuildContext context) {
    final info = serviceInfo(serviceId);

    // Sub-group by type within this service
    final tracks = items.where((r) => r.item.type == 'track').toList();
    final albums = items.where((r) => r.item.type == 'album').toList();
    final artists = items.where((r) => r.item.type == 'artist').toList();
    // Items without a recognized type go into tracks
    final other = items.where((r) =>
        r.item.type != 'track' && r.item.type != 'album' && r.item.type != 'artist').toList();

    final l = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SourceHeader(label: info.name, icon: info.icon, color: info.color),
        if (artists.isNotEmpty) ...[
          _SectionHeader(label: l.searchSectionArtists, count: artists.length),
          ...artists.map((r) => _StreamingTile(result: r)),
        ],
        if (albums.isNotEmpty) ...[
          _SectionHeader(label: l.searchSectionAlbums, count: albums.length),
          ...albums.map((r) => _StreamingTile(result: r)),
        ],
        if (tracks.isNotEmpty || other.isNotEmpty) ...[
          _SectionHeader(label: l.searchSectionTracks,
              count: tracks.length + other.length),
          ...tracks.map((r) => _StreamingTile(result: r)),
          ...other.map((r) => _StreamingTile(result: r)),
        ],
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Tuiles résultats
// ---------------------------------------------------------------------------

class _TrackTile extends StatelessWidget {
  final TrackSearchResult result;
  const _TrackTile({required this.result});

  @override
  Widget build(BuildContext context) {
    final track = result.track;
    final app = context.read<AppState>();
    final metadataFields = context.watch<SettingsState>().metadataDisplayFields;
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
      subtitle: _sub(track, metadataFields),
      trailing: FormatBadge(format: track.format),
    );
  }

  Widget? _sub(Track track, List<String> metadataFields) {
    final parts = <String>[
      if (track.artistName != null) track.artistName!,
      if (track.albumTitle != null) track.albumTitle!,
    ];
    final hasText = parts.isNotEmpty;
    final hasChips = metadataFields.isNotEmpty;
    if (!hasText && !hasChips) return null;
    if (!hasChips) {
      return Text(parts.join(' · '),
          style: TuneFonts.footnote,
          maxLines: 1,
          overflow: TextOverflow.ellipsis);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (hasText)
          Text(parts.join(' · '),
              style: TuneFonts.footnote,
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
        MetadataChips(track: track, selectedFields: metadataFields),
      ],
    );
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

    // Determine action based on type
    VoidCallback onTap;
    Widget? trailing;

    if (item.type == 'album') {
      onTap = () => Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => StreamingAlbumDetailView(track: item),
      ));
      trailing = const Icon(Icons.chevron_right_rounded,
          color: TuneColors.textTertiary);
    } else if (item.type == 'artist') {
      // For artists, navigate to album detail as a placeholder
      onTap = () => Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => StreamingAlbumDetailView(track: item),
      ));
      trailing = const Icon(Icons.chevron_right_rounded,
          color: TuneColors.textTertiary);
    } else {
      // Track — play it
      onTap = () => app.playStreaming(item);
      trailing = item.album != null
          ? IconButton(
              icon: const Icon(Icons.album_rounded,
                  size: 18, color: TuneColors.textTertiary),
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => StreamingAlbumDetailView(track: item),
              )),
            )
          : null;
    }

    // Leading widget: artwork or avatar for artists
    Widget leading;
    if (item.type == 'artist') {
      leading = CircleAvatar(
        radius: 22,
        backgroundColor: serviceInfo(item.serviceId).color.withValues(alpha: 0.15),
        child: Text(
          item.title.isNotEmpty ? item.title[0].toUpperCase() : '?',
          style: TextStyle(
            color: serviceInfo(item.serviceId).color,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    } else {
      leading = ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: ArtworkView(url: item.coverUrl, size: 44),
      );
    }

    return ListTile(
      onTap: onTap,
      leading: leading,
      title: Text(item.title,
          style: TuneFonts.body,
          maxLines: 1,
          overflow: TextOverflow.ellipsis),
      subtitle: _sub(item),
      trailing: trailing,
    );
  }

  Widget? _sub(StreamingSearchResult item) {
    final parts = <String>[
      if (item.artist != null) item.artist!,
      if (item.album != null) item.album!,
    ];
    if (parts.isEmpty) {
      // No text subtitle — show badge alone if streaming
      if (ServiceBadge.isStreaming(item.serviceId)) {
        return ServiceBadge(source: item.serviceId, compact: true);
      }
      return null;
    }
    return Row(
      children: [
        Flexible(
          child: Text(parts.join(' · '),
              style: TuneFonts.footnote,
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
        ),
        if (ServiceBadge.isStreaming(item.serviceId)) ...[
          const SizedBox(width: 6),
          ServiceBadge(source: item.serviceId, compact: true),
        ],
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Placeholder
// ---------------------------------------------------------------------------

class _NoResults extends StatelessWidget {
  const _NoResults();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.search_off_rounded, size: 48, color: TuneColors.textTertiary),
          const SizedBox(height: 12),
          Text(AppLocalizations.of(context).searchNoResults, style: TuneFonts.subheadline),
        ],
      ),
    );
  }
}
