import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
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
import '../streaming/streaming_helpers.dart';

// ---------------------------------------------------------------------------
// Global search overlay — shown on top of every screen.
//
// Usage: call showGlobalSearch(context) from any AppBar action.
// Displays a dark overlay with a focused search field + federated results.
// ---------------------------------------------------------------------------

/// Opens the global search overlay on top of the current route.
void showGlobalSearch(BuildContext context) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Search',
    barrierColor: Colors.black.withValues(alpha: 0.72),
    transitionDuration: const Duration(milliseconds: 220),
    transitionBuilder: (ctx, anim, secondaryAnim, child) {
      return FadeTransition(
        opacity: anim,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, -0.06),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOut)),
          child: child,
        ),
      );
    },
    pageBuilder: (ctx, anim1, anim2) => const _GlobalSearchSheet(),
  );
}

// ---------------------------------------------------------------------------
// _GlobalSearchSheet — the search panel shown inside the overlay
// ---------------------------------------------------------------------------

class _GlobalSearchSheet extends StatefulWidget {
  const _GlobalSearchSheet();

  @override
  State<_GlobalSearchSheet> createState() => _GlobalSearchSheetState();
}

class _GlobalSearchSheetState extends State<_GlobalSearchSheet> {
  final _ctrl = TextEditingController();
  final _focusNode = FocusNode();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    // Auto-focus with a tiny delay so the overlay animation starts first.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _focusNode.dispose();
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
    setState(() {});
    _debounce = Timer(
      const Duration(milliseconds: 500),
      () {
        if (mounted) context.read<AppState>().search(q.trim());
      },
    );
  }

  void _close() {
    context.read<AppState>().clearSearch();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final lib = context.watch<LibraryState>();
    final l = AppLocalizations.of(context);
    final isEmpty = _ctrl.text.trim().isEmpty;
    final mediaQuery = MediaQuery.of(context);

    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        // Respect the status bar + a small margin.
        padding: EdgeInsets.only(
          top: mediaQuery.padding.top + 8,
          left: 12,
          right: 12,
          bottom: 0,
        ),
        child: Material(
          color: TuneColors.surface,
          borderRadius: BorderRadius.circular(16),
          clipBehavior: Clip.hardEdge,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: mediaQuery.size.height * 0.82,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // --- Search bar ---
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _ctrl,
                          focusNode: _focusNode,
                          onChanged: _onChanged,
                          style: TuneFonts.body,
                          textInputAction: TextInputAction.search,
                          onSubmitted: (q) {
                            _debounce?.cancel();
                            if (q.trim().isNotEmpty) {
                              context.read<AppState>().search(q.trim());
                            }
                          },
                          decoration: InputDecoration(
                            hintText: l.searchHint,
                            hintStyle: TuneFonts.footnote,
                            prefixIcon: const Icon(
                              Icons.search_rounded,
                              size: 20,
                              color: TuneColors.textSecondary,
                            ),
                            filled: true,
                            fillColor: TuneColors.surfaceVariant,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 8),
                            suffixIcon: lib.isSearching
                                ? const Padding(
                                    padding: EdgeInsets.all(12),
                                    child: SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: TuneColors.accent),
                                    ),
                                  )
                                : _ctrl.text.isNotEmpty
                                    ? IconButton(
                                        icon: const Icon(Icons.clear_rounded,
                                            size: 18),
                                        onPressed: () {
                                          _ctrl.clear();
                                          _onChanged('');
                                        },
                                      )
                                    : null,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      TextButton(
                        onPressed: _close,
                        style: TextButton.styleFrom(
                          foregroundColor: TuneColors.accent,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                        ),
                        child: Text(l.btnCancel,
                            style: const TextStyle(fontSize: 15)),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1, color: TuneColors.divider),
                // --- Results ---
                Flexible(
                  child: isEmpty
                      ? const SizedBox.shrink()
                      : lib.isSearching && lib.searchResults.isEmpty
                          ? const Padding(
                              padding: EdgeInsets.all(40),
                              child: CircularProgressIndicator(
                                  color: TuneColors.accent),
                            )
                          : lib.searchResults.isEmpty
                              ? Padding(
                                  padding: const EdgeInsets.all(40),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.search_off_rounded,
                                          size: 40,
                                          color: TuneColors.textTertiary),
                                      const SizedBox(height: 10),
                                      Text(l.searchNoResults,
                                          style: TuneFonts.subheadline),
                                    ],
                                  ),
                                )
                              : _SearchResults(
                                  results: lib.searchResults,
                                  onDismiss: _close,
                                ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _SearchResults — reuse same grouping logic as SearchView
// ---------------------------------------------------------------------------

class _SearchResults extends StatelessWidget {
  final List<SearchResult> results;
  final VoidCallback onDismiss;

  const _SearchResults({required this.results, required this.onDismiss});

  @override
  Widget build(BuildContext context) {
    final tracks = results.whereType<TrackSearchResult>().toList();
    final albums = results.whereType<AlbumSearchResult>().toList();
    final artists = results.whereType<ArtistSearchResult>().toList();
    final streaming = results.whereType<StreamingResult>().toList();

    final byService = <String, List<StreamingResult>>{};
    for (final r in streaming) {
      (byService[r.item.serviceId] ??= []).add(r);
    }

    final l = AppLocalizations.of(context);
    final hasLocal =
        tracks.isNotEmpty || albums.isNotEmpty || artists.isNotEmpty;

    final sections = <Widget>[
      if (hasLocal) ...[
        _SourceHeader(
            label: l.homeLibrary,
            icon: Icons.library_music_rounded,
            color: TuneColors.accent),
        if (artists.isNotEmpty) ...[
          _SectionHeader(
              label: l.searchSectionArtists, count: artists.length),
          ...artists.map(
              (r) => _ArtistTile(result: r, onDismiss: onDismiss)),
        ],
        if (albums.isNotEmpty) ...[
          _SectionHeader(
              label: l.searchSectionAlbums, count: albums.length),
          ...albums
              .map((r) => _AlbumTile(result: r, onDismiss: onDismiss)),
        ],
        if (tracks.isNotEmpty) ...[
          _SectionHeader(
              label: l.searchSectionTracks, count: tracks.length),
          ...tracks
              .map((r) => _TrackTile(result: r, onDismiss: onDismiss)),
        ],
      ],
      for (final entry in byService.entries)
        _ServiceSection(
            serviceId: entry.key,
            items: entry.value,
            onDismiss: onDismiss),
      const SizedBox(height: 24),
    ];

    return ListView(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      children: sections,
    );
  }
}

// ---------------------------------------------------------------------------
// Headers
// ---------------------------------------------------------------------------

class _SourceHeader extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  const _SourceHeader(
      {required this.label, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
      decoration: BoxDecoration(
        border: Border(
          bottom:
              BorderSide(color: color.withValues(alpha: 0.3), width: 1),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Text(label,
              style: TuneFonts.subheadline.copyWith(
                  color: color, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String label;
  final int count;
  const _SectionHeader({required this.label, required this.count});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
      child: Row(
        children: [
          Text(label,
              style: TuneFonts.footnote.copyWith(
                  color: TuneColors.textSecondary,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5)),
          const SizedBox(width: 6),
          Text('($count)',
              style: TuneFonts.footnote
                  .copyWith(color: TuneColors.textTertiary)),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Service section
// ---------------------------------------------------------------------------

class _ServiceSection extends StatelessWidget {
  final String serviceId;
  final List<StreamingResult> items;
  final VoidCallback onDismiss;

  const _ServiceSection(
      {required this.serviceId,
      required this.items,
      required this.onDismiss});

  @override
  Widget build(BuildContext context) {
    final info = serviceInfo(serviceId);
    final tracks = items.where((r) => r.item.type == 'track').toList();
    final albums = items.where((r) => r.item.type == 'album').toList();
    final artists =
        items.where((r) => r.item.type == 'artist').toList();
    final other = items
        .where((r) =>
            r.item.type != 'track' &&
            r.item.type != 'album' &&
            r.item.type != 'artist')
        .toList();

    final l = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SourceHeader(
            label: info.name, icon: info.icon, color: info.color),
        if (artists.isNotEmpty) ...[
          _SectionHeader(
              label: l.searchSectionArtists, count: artists.length),
          ...artists.map(
              (r) => _StreamingTile(result: r, onDismiss: onDismiss)),
        ],
        if (albums.isNotEmpty) ...[
          _SectionHeader(
              label: l.searchSectionAlbums, count: albums.length),
          ...albums.map(
              (r) => _StreamingTile(result: r, onDismiss: onDismiss)),
        ],
        if (tracks.isNotEmpty || other.isNotEmpty) ...[
          _SectionHeader(
              label: l.searchSectionTracks,
              count: tracks.length + other.length),
          ...tracks.map(
              (r) => _StreamingTile(result: r, onDismiss: onDismiss)),
          ...other.map(
              (r) => _StreamingTile(result: r, onDismiss: onDismiss)),
        ],
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Result tiles
// ---------------------------------------------------------------------------

class _TrackTile extends StatelessWidget {
  final TrackSearchResult result;
  final VoidCallback onDismiss;
  const _TrackTile({required this.result, required this.onDismiss});

  @override
  Widget build(BuildContext context) {
    final track = result.track;
    final app = context.read<AppState>();
    return ListTile(
      onTap: () {
        onDismiss();
        app.playTracks([track]);
      },
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
  final VoidCallback onDismiss;
  const _AlbumTile({required this.result, required this.onDismiss});

  @override
  Widget build(BuildContext context) {
    final album = result.album;
    return ListTile(
      onTap: () {
        onDismiss();
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => AlbumDetailView(album: album),
        ));
      },
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
  final VoidCallback onDismiss;
  const _ArtistTile({required this.result, required this.onDismiss});

  @override
  Widget build(BuildContext context) {
    final artist = result.artist;
    return ListTile(
      onTap: () {
        onDismiss();
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => ArtistDetailView(artist: artist),
        ));
      },
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
  final VoidCallback onDismiss;
  const _StreamingTile({required this.result, required this.onDismiss});

  @override
  Widget build(BuildContext context) {
    final item = result.item;
    final app = context.read<AppState>();

    VoidCallback onTap;
    Widget? trailing;

    if (item.type == 'album' || item.type == 'artist') {
      onTap = () {
        onDismiss();
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => StreamingAlbumDetailView(track: item),
        ));
      };
      trailing = const Icon(Icons.chevron_right_rounded,
          color: TuneColors.textTertiary);
    } else {
      onTap = () {
        onDismiss();
        app.playStreaming(item);
      };
      trailing = item.album != null
          ? IconButton(
              icon: const Icon(Icons.album_rounded,
                  size: 18, color: TuneColors.textTertiary),
              onPressed: () {
                onDismiss();
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => StreamingAlbumDetailView(track: item),
                ));
              },
            )
          : null;
    }

    Widget leading;
    if (item.type == 'artist') {
      leading = CircleAvatar(
        radius: 22,
        backgroundColor:
            serviceInfo(item.serviceId).color.withValues(alpha: 0.15),
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
