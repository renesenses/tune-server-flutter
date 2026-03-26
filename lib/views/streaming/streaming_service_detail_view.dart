import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../server/streaming/streaming_service.dart';
import '../../state/app_state.dart';
import '../helpers/artwork_view.dart';
import '../helpers/tune_colors.dart';
import '../helpers/tune_fonts.dart';
import 'streaming_album_detail_view.dart';
import 'streaming_helpers.dart';

// ---------------------------------------------------------------------------
// T13.2 — StreamingServiceDetailView
// Recherche dans un service streaming + résultats.
// Tape = lecture, bouton album = StreamingAlbumDetailView.
// Miroir de StreamingServiceDetailView.swift (iOS)
// ---------------------------------------------------------------------------

class StreamingServiceDetailView extends StatefulWidget {
  final StreamingServiceStatus status;
  const StreamingServiceDetailView({super.key, required this.status});

  @override
  State<StreamingServiceDetailView> createState() =>
      _StreamingServiceDetailViewState();
}

class _StreamingServiceDetailViewState
    extends State<StreamingServiceDetailView> {
  final _searchCtrl = TextEditingController();
  List<StreamingSearchResult> _results = [];
  bool _loading = false;
  String? _lastQuery;
  Timer? _debounce;

  @override
  void dispose() {
    _searchCtrl.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String q) {
    _debounce?.cancel();
    if (q.trim().isEmpty) {
      setState(() {
        _results = [];
        _lastQuery = null;
      });
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 500), () => _search(q));
  }

  Future<void> _search(String query) async {
    setState(() => _loading = true);
    try {
      final service =
          context.read<AppState>().engine.streamingManager.service(
                widget.status.serviceId,
              );
      final results = await service?.search(query, limit: 30) ?? [];
      if (mounted) {
        setState(() {
          _results = results;
          _lastQuery = query;
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final info = serviceInfo(widget.status.serviceId);

    return Scaffold(
      backgroundColor: TuneColors.background,
      appBar: AppBar(
        backgroundColor: TuneColors.surface,
        title: Row(
          children: [
            Icon(info.icon, color: info.color, size: 20),
            const SizedBox(width: 8),
            Text(info.name, style: TuneFonts.title3),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
            child: TextField(
              controller: _searchCtrl,
              onChanged: _onSearchChanged,
              style: TuneFonts.body,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context).searchHint,
                hintStyle: TuneFonts.footnote,
                prefixIcon:
                    const Icon(Icons.search_rounded, size: 20),
                filled: true,
                fillColor: TuneColors.surfaceVariant,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 8),
                suffixIcon: _loading
                    ? const Padding(
                        padding: EdgeInsets.all(12),
                        child: SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: TuneColors.accent,
                          ),
                        ),
                      )
                    : _searchCtrl.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded, size: 18),
                            onPressed: () {
                              _searchCtrl.clear();
                              _onSearchChanged('');
                            },
                          )
                        : null,
              ),
            ),
          ),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_lastQuery == null) {
      return const _SearchPrompt();
    }
    if (_results.isEmpty && !_loading) {
      return const _NoResults();
    }
    return _ResultsList(
      results: _results,
      serviceId: widget.status.serviceId,
    );
  }
}

// ---------------------------------------------------------------------------
// _ResultsList
// ---------------------------------------------------------------------------

class _ResultsList extends StatelessWidget {
  final List<StreamingSearchResult> results;
  final String serviceId;
  const _ResultsList(
      {required this.results, required this.serviceId});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    // Sépare par type : tracks, albums, artistes
    final tracks = results.where((r) => r.type == 'track').toList();
    final albums = results.where((r) => r.type == 'album').toList();
    final artists = results.where((r) => r.type == 'artist').toList();

    return ListView(
      padding: const EdgeInsets.only(bottom: 80),
      children: [
        // --- Albums (carousel horizontal) ---
        if (albums.isNotEmpty) ...[
          _SectionHeader(title: l.tabAlbums),
          SizedBox(
            height: 180,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: albums.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (_, i) => _AlbumCard(result: albums[i], serviceId: serviceId),
            ),
          ),
          const SizedBox(height: 16),
        ],
        // --- Artistes ---
        if (artists.isNotEmpty) ...[
          _SectionHeader(title: l.tabArtists),
          ...artists.map((r) => _ArtistTile(result: r)),
          const SizedBox(height: 16),
        ],
        // --- Pistes ---
        if (tracks.isNotEmpty) ...[
          _SectionHeader(title: l.tabTracks),
          ...tracks.map((r) => Column(
            children: [
              _ResultTile(result: r),
              const Divider(height: 1, indent: 72, color: TuneColors.divider),
            ],
          )),
        ],
        // --- Fallback si pas de type (flat list) ---
        if (tracks.isEmpty && albums.isEmpty && artists.isEmpty)
          ...results.map((r) => Column(
            children: [
              _ResultTile(result: r),
              const Divider(height: 1, indent: 72, color: TuneColors.divider),
            ],
          )),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
    child: Text(title, style: TuneFonts.title3),
  );
}

class _AlbumCard extends StatelessWidget {
  final StreamingSearchResult result;
  final String serviceId;
  const _AlbumCard({required this.result, required this.serviceId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => StreamingAlbumDetailView(track: result),
        ),
      ),
      child: SizedBox(
        width: 130,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ArtworkView(url: result.coverUrl, size: 130, cornerRadius: 8),
            const SizedBox(height: 6),
            Text(result.title, style: TuneFonts.caption,
                maxLines: 1, overflow: TextOverflow.ellipsis),
            if (result.artist != null)
              Text(result.artist!, style: TuneFonts.caption.copyWith(
                  color: TuneColors.textTertiary),
                  maxLines: 1, overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }
}

class _ArtistTile extends StatelessWidget {
  final StreamingSearchResult result;
  const _ArtistTile({required this.result});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 22,
        backgroundColor: TuneColors.surfaceVariant,
        child: result.coverUrl != null
            ? ClipOval(child: ArtworkView(url: result.coverUrl, size: 44))
            : const Icon(Icons.person_rounded, color: TuneColors.textTertiary),
      ),
      title: Text(result.title, style: TuneFonts.body),
    );
  }
}

class _ResultTile extends StatelessWidget {
  final StreamingSearchResult result;
  const _ResultTile({required this.result});

  @override
  Widget build(BuildContext context) {
    final app = context.read<AppState>();
    return ListTile(
      onTap: () => app.playStreaming(result),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: ArtworkView(url: result.coverUrl, size: 44),
      ),
      title: Text(result.title,
          style: TuneFonts.body, maxLines: 1,
          overflow: TextOverflow.ellipsis),
      subtitle: _subtitle,
      trailing: IconButton(
        icon: const Icon(Icons.more_vert_rounded,
            size: 18, color: TuneColors.textTertiary),
        onPressed: () => _showMenu(context, app),
      ),
    );
  }

  Widget? get _subtitle {
    final parts = <String>[
      if (result.artist != null) result.artist!,
      if (result.album != null) result.album!,
    ];
    if (parts.isEmpty) return null;
    return Text(parts.join(' · '),
        style: TuneFonts.footnote,
        maxLines: 1,
        overflow: TextOverflow.ellipsis);
  }

  void _showMenu(BuildContext context, AppState app) {
    showModalBottomSheet(
      context: context,
      backgroundColor: TuneColors.surface,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.play_arrow_rounded,
                  color: TuneColors.accent),
              title: const Text('Lire', style: TuneFonts.body),
              onTap: () {
                Navigator.pop(context);
                app.playStreaming(result);
              },
            ),
            if (result.album != null)
              ListTile(
                leading: const Icon(Icons.album_rounded,
                    color: TuneColors.textSecondary),
                title: Text(AppLocalizations.of(context).streamingViewAlbum,
                  style: TuneFonts.body),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) =>
                          StreamingAlbumDetailView(track: result),
                    ),
                  );
                },
              ),
            ListTile(
              leading: const Icon(Icons.queue_rounded,
                  color: TuneColors.textSecondary),
              title: Text(AppLocalizations.of(context).libraryPlayNext,
                  style: TuneFonts.body),
              onTap: () {
                Navigator.pop(context);
                final zoneId = app.zoneState.currentZoneId;
                if (zoneId != null) {
                  // On ne peut pas ajouter directement un StreamingSearchResult
                  // à la queue sans résoudre l'URL : on joue directement.
                  app.playStreaming(result);
                }
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Placeholders
// ---------------------------------------------------------------------------

class _SearchPrompt extends StatelessWidget {
  const _SearchPrompt();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.search_rounded, size: 56, color: TuneColors.textTertiary),
          const SizedBox(height: 12),
          Text(AppLocalizations.of(context).searchHintFull,
              style: TuneFonts.subheadline),
        ],
      ),
    );
  }
}

class _NoResults extends StatelessWidget {
  const _NoResults();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.music_off_rounded,
              size: 48, color: TuneColors.textTertiary),
          const SizedBox(height: 12),
          Text(AppLocalizations.of(context).searchNoResults,
              style: TuneFonts.subheadline),
        ],
      ),
    );
  }
}

