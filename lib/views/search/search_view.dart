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
      const Duration(milliseconds: 300),
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
                  : _SearchResults(
                      results: lib.searchResults,
                      query: lib.lastQuery,
                    ),
    );
  }
}

// ---------------------------------------------------------------------------
// _SearchResults — résultats groupés : local (tracks/albums/artists)
// puis chaque service streaming séparément
// ---------------------------------------------------------------------------

// How many items to show per category before requiring "See all".
const _kPreviewArtists = 3;
const _kPreviewAlbums = 4;
const _kPreviewTracks = 5;
const _kPreviewStreaming = 5;

// ---------------------------------------------------------------------------
// Top result scoring
// ---------------------------------------------------------------------------

/// Score a result against the query. Higher = better match.
/// 30 = exact title match, 20 = title starts-with, 10 = artist match, 0 = other.
int _scoreResult(SearchResult r, String q) {
  final ql = q.toLowerCase();
  String? title;
  String? artist;

  if (r is TrackSearchResult) {
    title = r.track.title;
    artist = r.track.artistName;
  } else if (r is AlbumSearchResult) {
    title = r.album.title;
    artist = r.album.artistName;
  } else if (r is ArtistSearchResult) {
    title = r.artist.name;
  } else if (r is StreamingResult) {
    if (r.item.type != 'track') return 0;
    title = r.item.title;
    artist = r.item.artist;
  }

  final tl = title?.toLowerCase() ?? '';
  if (tl == ql) return 30;
  if (tl.startsWith(ql)) return 20;
  if (artist?.toLowerCase().contains(ql) == true) return 10;
  if (tl.contains(ql)) return 5;
  return 0;
}

/// Pick the best matching result to display as a hero card.
SearchResult? _pickTopResult(List<SearchResult> results, String query) {
  if (query.isEmpty || results.isEmpty) return null;
  // Only consider tracks (local or streaming) and albums — not bare artists.
  final candidates = results.where((r) =>
      r is TrackSearchResult ||
      r is AlbumSearchResult ||
      (r is StreamingResult && r.item.type == 'track'));
  if (candidates.isEmpty) return null;
  final best = candidates.reduce((a, b) =>
      _scoreResult(a, query) >= _scoreResult(b, query) ? a : b);
  // Only show if there's a meaningful match
  if (_scoreResult(best, query) == 0) return null;
  return best;
}

class _SearchResults extends StatelessWidget {
  final List<SearchResult> results;
  final String query;
  const _SearchResults({required this.results, required this.query});

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

    final topResult = _pickTopResult(results, query);

    final l = AppLocalizations.of(context);
    final hasLocal = tracks.isNotEmpty || albums.isNotEmpty || artists.isNotEmpty;
    final sections = <Widget>[
      // --- Top result hero card ---
      if (topResult != null) _TopResultCard(result: topResult),
      // --- Local library results ---
      if (hasLocal) ...[
        _SourceHeader(label: l.homeLibrary, icon: Icons.library_music_rounded,
            color: TuneColors.accent),
        if (artists.isNotEmpty) ...[
          _SectionHeader(
            label: l.searchSectionArtists,
            count: artists.length,
            seeAllPage: artists.length > _kPreviewArtists
                ? _SeeAllPage(title: l.searchSectionArtists,
                    children: artists.map((r) => _ArtistTile(result: r)).toList())
                : null,
          ),
          ...artists.take(_kPreviewArtists).map((r) => _ArtistTile(result: r)),
        ],
        if (albums.isNotEmpty) ...[
          _SectionHeader(
            label: l.searchSectionAlbums,
            count: albums.length,
            seeAllPage: albums.length > _kPreviewAlbums
                ? _SeeAllPage(title: l.searchSectionAlbums,
                    children: albums.map((r) => _AlbumTile(result: r)).toList())
                : null,
          ),
          ...albums.take(_kPreviewAlbums).map((r) => _AlbumTile(result: r)),
        ],
        if (tracks.isNotEmpty) ...[
          _SectionHeader(
            label: l.searchSectionTracks,
            count: tracks.length,
            seeAllPage: tracks.length > _kPreviewTracks
                ? _SeeAllPage(title: l.searchSectionTracks,
                    children: tracks.map((r) => _TrackTile(result: r)).toList())
                : null,
          ),
          ...tracks.take(_kPreviewTracks).map((r) => _TrackTile(result: r)),
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
// _TopResultCard — hero card shown above all sections for best match
// ---------------------------------------------------------------------------

class _TopResultCard extends StatelessWidget {
  final SearchResult result;
  const _TopResultCard({required this.result});

  @override
  Widget build(BuildContext context) {
    final app = context.read<AppState>();
    final l = AppLocalizations.of(context);

    String title = '';
    String? subtitle;
    String? artworkPath;
    String? artworkUrl;
    VoidCallback? onTap;
    Widget? badge;

    if (result is TrackSearchResult) {
      final t = (result as TrackSearchResult).track;
      title = t.title;
      subtitle = [if (t.artistName != null) t.artistName!, if (t.albumTitle != null) t.albumTitle!].join(' · ');
      artworkPath = t.coverPath;
      onTap = () => app.playTracks([t]);
      badge = FormatBadge(format: t.format);
    } else if (result is AlbumSearchResult) {
      final a = (result as AlbumSearchResult).album;
      title = a.title;
      subtitle = a.artistName;
      artworkPath = a.coverPath;
      onTap = () => Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => AlbumDetailView(album: a),
      ));
    } else if (result is StreamingResult) {
      final item = (result as StreamingResult).item;
      title = item.title;
      subtitle = [if (item.artist != null) item.artist!, if (item.album != null) item.album!].join(' · ');
      artworkUrl = item.coverUrl;
      onTap = () => app.playStreaming(item);
      badge = ServiceBadge(source: item.serviceId, compact: true);
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.searchTopResult,
            style: TuneFonts.footnote.copyWith(
              color: TuneColors.textSecondary,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Material(
            color: TuneColors.surface,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: artworkPath != null
                          ? ArtworkView(filePath: artworkPath, size: 64)
                          : ArtworkView(url: artworkUrl, size: 64),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TuneFonts.body.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (subtitle != null && subtitle.isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Text(
                              subtitle,
                              style: TuneFonts.footnote.copyWith(
                                color: TuneColors.textSecondary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                          if (badge != null) ...[
                            const SizedBox(height: 4),
                            badge,
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _SeeAllPage — full-screen list pushed when user taps "See all"
// ---------------------------------------------------------------------------

class _SeeAllPage extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _SeeAllPage({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TuneColors.background,
      appBar: AppBar(
        backgroundColor: TuneColors.surface,
        title: Text(title, style: TuneFonts.subheadline),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 80),
        children: children,
      ),
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
  /// If non-null, a "See all" button is shown that pushes this widget.
  final Widget? seeAllPage;

  const _SectionHeader({
    required this.label,
    required this.count,
    this.seeAllPage,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 8, 4),
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
          const Spacer(),
          if (seeAllPage != null)
            TextButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => seeAllPage!),
              ),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                AppLocalizations.of(context).btnSeeAll,
                style: const TextStyle(color: TuneColors.accent, fontSize: 12),
              ),
            ),
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
    final allTracks = [...tracks, ...other];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SourceHeader(label: info.name, icon: info.icon, color: info.color),
        if (artists.isNotEmpty) ...[
          _SectionHeader(
            label: l.searchSectionArtists,
            count: artists.length,
            seeAllPage: artists.length > _kPreviewArtists
                ? _SeeAllPage(title: '${info.name} · ${l.searchSectionArtists}',
                    children: artists.map((r) => _StreamingTile(result: r)).toList())
                : null,
          ),
          ...artists.take(_kPreviewArtists).map((r) => _StreamingTile(result: r)),
        ],
        if (albums.isNotEmpty) ...[
          _SectionHeader(
            label: l.searchSectionAlbums,
            count: albums.length,
            seeAllPage: albums.length > _kPreviewAlbums
                ? _SeeAllPage(title: '${info.name} · ${l.searchSectionAlbums}',
                    children: albums.map((r) => _StreamingTile(result: r)).toList())
                : null,
          ),
          ...albums.take(_kPreviewAlbums).map((r) => _StreamingTile(result: r)),
        ],
        if (allTracks.isNotEmpty) ...[
          _SectionHeader(
            label: l.searchSectionTracks,
            count: allTracks.length,
            seeAllPage: allTracks.length > _kPreviewStreaming
                ? _SeeAllPage(title: '${info.name} · ${l.searchSectionTracks}',
                    children: allTracks.map((r) => _StreamingTile(result: r)).toList())
                : null,
          ),
          ...allTracks.take(_kPreviewStreaming).map((r) => _StreamingTile(result: r)),
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
