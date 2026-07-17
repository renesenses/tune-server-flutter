import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../server/streaming/qobuz_service.dart';
import '../../server/streaming/streaming_service.dart';
import '../../services/tune_api_client.dart';
import '../../state/app_state.dart';
import '../helpers/artwork_view.dart';
import '../helpers/tune_colors.dart';
import '../../widgets/favorite_button.dart';
import '../helpers/tune_fonts.dart';
import 'streaming_album_detail_view.dart';
import 'streaming_helpers.dart';
import 'youtube_browse_view.dart';

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
      final app = context.read<AppState>();
      if (app.isRemoteMode && app.apiClient != null) {
        final data = await app.apiClient!.searchStreaming(widget.status.serviceId, query);
        final results = <StreamingSearchResult>[];
        if (data is Map<String, dynamic>) {
          for (final t in (data['tracks'] as List? ?? [])) {
            final m = t as Map<String, dynamic>;
            results.add(StreamingSearchResult(
              id: m['source_id'] as String? ?? '',
              title: m['title'] as String? ?? '',
              artist: m['artist_name'] as String?,
              album: m['album_title'] as String?,
              serviceId: widget.status.serviceId,
              coverUrl: m['cover_path'] as String?,
            ));
          }
        }
        if (mounted) setState(() { _results = results; _lastQuery = query; _loading = false; });
        return;
      }
      final service = app.engine.streamingManager.service(widget.status.serviceId);
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
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_rounded, color: TuneColors.error),
            tooltip: 'Favorites',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => _StreamingFavoritesView(
                  serviceId: widget.status.serviceId,
                ),
              ),
            ),
          ),
          if (widget.status.serviceId == 'youtube')
            IconButton(
              icon: const Icon(Icons.explore_rounded, color: TuneColors.accent),
              tooltip: 'Explorer',
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const YouTubeBrowseView()),
              ),
            ),
        ],
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
      return _CatalogView(serviceId: widget.status.serviceId);
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
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FavoriteButton(
            isFavorite: app.libraryState.isStreamingFavorite(
                result.type, result.serviceId, result.id),
            size: 18,
            onToggle: () => app.toggleStreamingFavorite(result),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert_rounded,
                size: 18, color: TuneColors.textTertiary),
            onPressed: () => _showMenu(context, app),
          ),
        ],
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
// Catalogue — vue par défaut (featured + playlists)
// ---------------------------------------------------------------------------

class _CatalogView extends StatefulWidget {
  final String serviceId;
  const _CatalogView({required this.serviceId});

  @override
  State<_CatalogView> createState() => _CatalogViewState();
}

class _CatalogViewState extends State<_CatalogView> {
  final Map<String, List<StreamingSearchResult>> _sections = {};
  List<StreamingSearchResult> _playlists = [];
  List<dynamic> _favoriteAlbums = [];
  List<dynamic> _favoriteTracks = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadCatalog();
    _loadFavorites();
  }

  Future<void> _loadCatalog() async {
    final app = context.read<AppState>();
    final service = app.engine.streamingManager.service(widget.serviceId);
    if (service == null) return;

    // Chargement des sections featured (Qobuz uniquement pour l'instant)
    if (service is QobuzService) {
      for (final (id, label) in QobuzService.featuredSections) {
        final albums = await service.getFeaturedAlbums(id, limit: 15);
        if (albums.isNotEmpty && mounted) {
          setState(() => _sections[label] = albums);
        }
      }
      final playlists = await service.getUserPlaylists();
      if (mounted) {
        setState(() {
          _playlists = playlists;
          _loading = false;
        });
      }
    } else {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _loadFavorites() async {
    final api = context.read<AppState>().apiClient;
    if (api == null) return;
    try {
      final albums = await api.getStreamingFavorites(widget.serviceId, 'albums');
      final tracks = await api.getStreamingFavorites(widget.serviceId, 'tracks');
      if (mounted) {
        setState(() {
          _favoriteAlbums = albums;
          _favoriteTracks = tracks;
        });
      }
    } catch (_) {
      // Favorites endpoint might not be available for all services
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading && _sections.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: TuneColors.accent),
      );
    }

    if (_sections.isEmpty && _playlists.isEmpty && _favoriteAlbums.isEmpty && _favoriteTracks.isEmpty) {
      return const _SearchPrompt();
    }

    return ListView(
      padding: const EdgeInsets.only(bottom: 80),
      children: [
        // Favorites section
        if (_favoriteAlbums.isNotEmpty || _favoriteTracks.isNotEmpty) ...[
          if (_favoriteAlbums.isNotEmpty) ...[
            Row(
              children: [
                const Expanded(child: _SectionHeader(title: 'Favorite Albums')),
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: TextButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => _StreamingFavoritesView(
                          serviceId: widget.serviceId,
                          initialTab: 0,
                        ),
                      ),
                    ),
                    child: Text('See all',
                        style: TuneFonts.footnote.copyWith(color: TuneColors.accent)),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 180,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _favoriteAlbums.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (_, i) {
                  final fav = _favoriteAlbums[i] as Map<String, dynamic>;
                  return _FavoriteAlbumCard(
                    fav: fav,
                    serviceId: widget.serviceId,
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
          ],
          if (_favoriteTracks.isNotEmpty) ...[
            _SectionHeader(title: 'Favorite Tracks'),
            ..._favoriteTracks.take(5).map((fav) {
              final m = fav as Map<String, dynamic>;
              final trackId = m['source_id']?.toString() ?? m['id']?.toString() ?? '';
              final title = m['title'] as String? ?? m['name'] as String? ?? '-';
              final artist = m['artist'] as String? ?? m['artist_name'] as String? ?? '';
              final cover = m['cover_url'] as String? ?? m['cover_path'] as String?;
              final album = m['album'] as String? ?? m['album_title'] as String?;
              final durationMs = m['duration_ms'] as int?;
              return _FavoriteTrackTile(
                result: StreamingSearchResult(
                  id: trackId,
                  title: title,
                  artist: artist,
                  album: album,
                  durationMs: durationMs,
                  coverUrl: cover,
                  serviceId: widget.serviceId,
                  type: 'track',
                  raw: m,
                ),
              );
            }),
            if (_favoriteTracks.length > 5)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => _StreamingFavoritesView(
                        serviceId: widget.serviceId,
                        initialTab: 1,
                      ),
                    ),
                  ),
                  child: Text(
                    'See all ${_favoriteTracks.length} tracks',
                    style: TuneFonts.footnote.copyWith(color: TuneColors.accent),
                  ),
                ),
              ),
            const SizedBox(height: 12),
          ],
        ],
        // Sections featured
        for (final entry in _sections.entries) ...[
          _SectionHeader(title: entry.key),
          SizedBox(
            height: 180,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: entry.value.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (_, i) => _AlbumCard(
                result: entry.value[i],
                serviceId: widget.serviceId,
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
        // Playlists utilisateur
        if (_playlists.isNotEmpty) ...[
          _SectionHeader(title: 'Mes Playlists'),
          ..._playlists.map((p) => ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: ArtworkView(url: p.coverUrl, size: 48),
                ),
                title: Text(p.title, style: TuneFonts.body,
                    maxLines: 1, overflow: TextOverflow.ellipsis),
                subtitle: p.artist != null
                    ? Text(p.artist!, style: TuneFonts.caption)
                    : null,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => StreamingAlbumDetailView(track: p),
                  ),
                ),
              )),
        ],
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Favorite album card
// ---------------------------------------------------------------------------

class _FavoriteAlbumCard extends StatelessWidget {
  final Map<String, dynamic> fav;
  final String serviceId;
  const _FavoriteAlbumCard({required this.fav, required this.serviceId});

  @override
  Widget build(BuildContext context) {
    final title = fav['title'] as String? ?? fav['name'] as String? ?? '-';
    final artist = fav['artist'] as String? ?? fav['artist_name'] as String?;
    final cover = fav['cover_url'] as String? ?? fav['cover_path'] as String? ?? fav['image'] as String?;
    final albumId = fav['source_id']?.toString() ?? fav['id']?.toString() ?? '';

    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => StreamingAlbumDetailView(
            track: StreamingSearchResult(
              id: albumId,
              title: title,
              artist: artist,
              album: title,
              coverUrl: cover,
              serviceId: serviceId,
              type: 'album',
              raw: {'album_id': albumId, ...fav},
            ),
          ),
        ),
      ),
      child: SizedBox(
        width: 130,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ArtworkView(url: cover, size: 130, cornerRadius: 8),
                const Positioned(
                  top: 4,
                  right: 4,
                  child: Icon(Icons.favorite_rounded,
                      size: 18, color: TuneColors.error),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(title,
                style: TuneFonts.caption,
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
            if (artist != null)
              Text(artist,
                  style:
                      TuneFonts.caption.copyWith(color: TuneColors.textTertiary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _FavoriteTrackTile — single favorite track with play + cover art
// ---------------------------------------------------------------------------

class _FavoriteTrackTile extends StatelessWidget {
  final StreamingSearchResult result;
  const _FavoriteTrackTile({required this.result});

  @override
  Widget build(BuildContext context) {
    final app = context.read<AppState>();
    return ListTile(
      onTap: () => app.playStreaming(result),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: result.coverUrl != null
            ? ArtworkView(url: result.coverUrl, size: 44)
            : Container(
                width: 44,
                height: 44,
                color: TuneColors.surfaceVariant,
                child: const Icon(Icons.music_note_rounded,
                    size: 20, color: TuneColors.textTertiary),
              ),
      ),
      title: Text(result.title,
          style: TuneFonts.body,
          maxLines: 1,
          overflow: TextOverflow.ellipsis),
      subtitle: result.artist != null
          ? Text(result.artist!,
              style: TuneFonts.footnote,
              maxLines: 1,
              overflow: TextOverflow.ellipsis)
          : null,
      trailing: const Icon(Icons.favorite_rounded,
          size: 16, color: TuneColors.error),
    );
  }
}

// ---------------------------------------------------------------------------
// _StreamingFavoritesView — full-screen favorites with tabs
// Albums / Tracks / Artists
// ---------------------------------------------------------------------------

class _StreamingFavoritesView extends StatefulWidget {
  final String serviceId;
  final int initialTab;
  const _StreamingFavoritesView({
    required this.serviceId,
    this.initialTab = 0,
  });

  @override
  State<_StreamingFavoritesView> createState() =>
      _StreamingFavoritesViewState();
}

class _StreamingFavoritesViewState extends State<_StreamingFavoritesView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabCtrl;
  List<dynamic> _albums = [];
  List<dynamic> _tracks = [];
  List<dynamic> _artists = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(
      length: 3,
      vsync: this,
      initialIndex: widget.initialTab,
    );
    _loadAll();
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadAll() async {
    final api = context.read<AppState>().apiClient;
    if (api == null) {
      if (mounted) setState(() { _loading = false; _error = 'No API client'; });
      return;
    }
    try {
      final results = await Future.wait([
        api.getStreamingFavorites(widget.serviceId, 'albums'),
        api.getStreamingFavorites(widget.serviceId, 'tracks'),
        api.getStreamingFavorites(widget.serviceId, 'artists'),
      ]);
      if (mounted) {
        setState(() {
          _albums = results[0];
          _tracks = results[1];
          _artists = results[2];
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() { _loading = false; _error = e.toString(); });
    }
  }

  @override
  Widget build(BuildContext context) {
    final info = serviceInfo(widget.serviceId);

    return Scaffold(
      backgroundColor: TuneColors.background,
      appBar: AppBar(
        backgroundColor: TuneColors.surface,
        title: Row(
          children: [
            const Icon(Icons.favorite_rounded,
                size: 20, color: TuneColors.error),
            const SizedBox(width: 8),
            Text('${info.name} Favorites', style: TuneFonts.title3),
          ],
        ),
        bottom: TabBar(
          controller: _tabCtrl,
          indicatorColor: TuneColors.accent,
          labelColor: TuneColors.accent,
          unselectedLabelColor: TuneColors.textTertiary,
          tabs: [
            Tab(text: 'Albums${_albums.isNotEmpty ? ' (${_albums.length})' : ''}'),
            Tab(text: 'Tracks${_tracks.isNotEmpty ? ' (${_tracks.length})' : ''}'),
            Tab(text: 'Artists${_artists.isNotEmpty ? ' (${_artists.length})' : ''}'),
          ],
        ),
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: TuneColors.accent))
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error_outline_rounded,
                          size: 48, color: TuneColors.error),
                      const SizedBox(height: 12),
                      Text(_error!, style: TuneFonts.subheadline),
                      const SizedBox(height: 16),
                      FilledButton(
                        onPressed: () {
                          setState(() { _loading = true; _error = null; });
                          _loadAll();
                        },
                        style: FilledButton.styleFrom(
                            backgroundColor: TuneColors.accent),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : TabBarView(
                  controller: _tabCtrl,
                  children: [
                    _FavAlbumsTab(
                      albums: _albums,
                      serviceId: widget.serviceId,
                      onRefresh: _loadAll,
                    ),
                    _FavTracksTab(
                      tracks: _tracks,
                      serviceId: widget.serviceId,
                      onRefresh: _loadAll,
                    ),
                    _FavArtistsTab(
                      artists: _artists,
                      serviceId: widget.serviceId,
                      onRefresh: _loadAll,
                    ),
                  ],
                ),
    );
  }
}

// ---------------------------------------------------------------------------
// Favorites tab — Albums
// ---------------------------------------------------------------------------

class _FavAlbumsTab extends StatelessWidget {
  final List<dynamic> albums;
  final String serviceId;
  final Future<void> Function() onRefresh;
  const _FavAlbumsTab({
    required this.albums,
    required this.serviceId,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    if (albums.isEmpty) {
      return const _EmptyFavorites(
        icon: Icons.album_rounded,
        message: 'No favorite albums yet',
      );
    }
    return RefreshIndicator(
      color: TuneColors.accent,
      onRefresh: onRefresh,
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 180,
          mainAxisSpacing: 16,
          crossAxisSpacing: 12,
          childAspectRatio: 0.72,
        ),
        itemCount: albums.length,
        itemBuilder: (_, i) {
          final fav = albums[i] as Map<String, dynamic>;
          return _FavoriteAlbumCard(fav: fav, serviceId: serviceId);
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Favorites tab — Tracks
// ---------------------------------------------------------------------------

class _FavTracksTab extends StatelessWidget {
  final List<dynamic> tracks;
  final String serviceId;
  final Future<void> Function() onRefresh;
  const _FavTracksTab({
    required this.tracks,
    required this.serviceId,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    if (tracks.isEmpty) {
      return const _EmptyFavorites(
        icon: Icons.music_note_rounded,
        message: 'No favorite tracks yet',
      );
    }
    final app = context.read<AppState>();
    return RefreshIndicator(
      color: TuneColors.accent,
      onRefresh: onRefresh,
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 80),
        itemCount: tracks.length + 1, // +1 for "Play All" header
        itemBuilder: (_, i) {
          if (i == 0) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      icon: const Icon(Icons.play_arrow_rounded),
                      label: Text('Play All (${tracks.length})'),
                      style: FilledButton.styleFrom(
                          backgroundColor: TuneColors.accent),
                      onPressed: () {
                        final list = tracks.map((t) {
                          final m = t as Map<String, dynamic>;
                          return _trackFromMap(m, serviceId);
                        }).toList();
                        app.playStreamingList(list);
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilledButton.icon(
                    icon: const Icon(Icons.shuffle_rounded),
                    label: const Text('Shuffle'),
                    style: FilledButton.styleFrom(
                      backgroundColor: TuneColors.surfaceVariant,
                      foregroundColor: TuneColors.textPrimary,
                    ),
                    onPressed: () {
                      final list = tracks.map((t) {
                        final m = t as Map<String, dynamic>;
                        return _trackFromMap(m, serviceId);
                      }).toList()
                        ..shuffle();
                      app.playStreamingList(list);
                    },
                  ),
                ],
              ),
            );
          }
          final idx = i - 1;
          final m = tracks[idx] as Map<String, dynamic>;
          final result = _trackFromMap(m, serviceId);
          return Column(
            children: [
              _FavoriteTrackTile(result: result),
              const Divider(height: 1, indent: 72, color: TuneColors.divider),
            ],
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Favorites tab — Artists
// ---------------------------------------------------------------------------

class _FavArtistsTab extends StatelessWidget {
  final List<dynamic> artists;
  final String serviceId;
  final Future<void> Function() onRefresh;
  const _FavArtistsTab({
    required this.artists,
    required this.serviceId,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    if (artists.isEmpty) {
      return const _EmptyFavorites(
        icon: Icons.person_rounded,
        message: 'No favorite artists yet',
      );
    }
    return RefreshIndicator(
      color: TuneColors.accent,
      onRefresh: onRefresh,
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 80),
        itemCount: artists.length,
        itemBuilder: (_, i) {
          final m = artists[i] as Map<String, dynamic>;
          final name = m['name'] as String? ?? m['title'] as String? ?? '-';
          final image = m['image_path'] as String? ?? m['cover_url'] as String?;
          return ListTile(
            leading: CircleAvatar(
              radius: 22,
              backgroundColor: TuneColors.surfaceVariant,
              child: image != null
                  ? ClipOval(child: ArtworkView(url: image, size: 44))
                  : const Icon(Icons.person_rounded,
                      color: TuneColors.textTertiary),
            ),
            title: Text(name, style: TuneFonts.body),
            trailing: const Icon(Icons.favorite_rounded,
                size: 16, color: TuneColors.error),
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Helper: build StreamingSearchResult from favorite track map
// ---------------------------------------------------------------------------

StreamingSearchResult _trackFromMap(Map<String, dynamic> m, String serviceId) {
  return StreamingSearchResult(
    id: m['source_id']?.toString() ?? m['id']?.toString() ?? '',
    title: m['title'] as String? ?? m['name'] as String? ?? '-',
    artist: m['artist'] as String? ?? m['artist_name'] as String?,
    album: m['album'] as String? ?? m['album_title'] as String?,
    durationMs: m['duration_ms'] as int?,
    coverUrl: m['cover_url'] as String? ?? m['cover_path'] as String?,
    serviceId: serviceId,
    type: 'track',
    raw: m,
  );
}

// ---------------------------------------------------------------------------
// Empty favorites placeholder
// ---------------------------------------------------------------------------

class _EmptyFavorites extends StatelessWidget {
  final IconData icon;
  final String message;
  const _EmptyFavorites({required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 48, color: TuneColors.textTertiary),
          const SizedBox(height: 12),
          Text(message, style: TuneFonts.subheadline),
        ],
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

