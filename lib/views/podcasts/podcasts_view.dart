import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../server/database/database.dart';
import '../../server/podcasts/podcast_service.dart';
import '../../state/app_state.dart';
import '../../state/zone_state.dart';
import '../helpers/tune_colors.dart';
import '../helpers/tune_fonts.dart';
import 'package:tune_server/services/tune_api_client.dart';

// ---------------------------------------------------------------------------
// PodcastsView — parcourir Radio France et recherche iTunes podcasts.
// Miroir de PodcastsView.swift (iOS)
// ---------------------------------------------------------------------------

class PodcastsView extends StatefulWidget {
  const PodcastsView({super.key});

  @override
  State<PodcastsView> createState() => _PodcastsViewState();
}

class _PodcastsViewState extends State<PodcastsView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabCtrl;
  final _service = PodcastService();
  final _searchCtrl = TextEditingController();

  List<PodcastShow> _radioFranceShows = [];
  List<PodcastShow> _searchResults = [];
  PodcastShow? _selectedShow;
  List<PodcastEpisodeItem> _episodes = [];

  // Subscribed podcasts
  List<Map<String, dynamic>> _subscribed = [];
  bool _loadingSubscribed = false;
  bool _refreshingAll = false;

  bool _loadingShows = false;
  bool _loadingEpisodes = false;
  bool _searching = false;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 3, vsync: this);
    _loadRadioFrance();
    _loadSubscribed();
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  // -------------------------------------------------------------------------
  // Build
  // -------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    if (_selectedShow != null) {
      return _buildEpisodeList(l);
    }

    return Scaffold(
      backgroundColor: TuneColors.background,
      appBar: AppBar(
        backgroundColor: TuneColors.surface,
        title: Text(l.podcastsTitle, style: TuneFonts.title3),
        actions: [
          if (_tabCtrl.index == 0)
            IconButton(
              icon: _refreshingAll
                  ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: TuneColors.accent))
                  : const Icon(Icons.refresh_rounded, color: TuneColors.textSecondary),
              tooltip: 'Refresh all',
              onPressed: _refreshingAll ? null : _refreshAllPodcasts,
            ),
        ],
        bottom: TabBar(
          controller: _tabCtrl,
          indicatorColor: TuneColors.accent,
          labelColor: TuneColors.accent,
          unselectedLabelColor: TuneColors.textSecondary,
          onTap: (_) => setState(() {}),
          tabs: [
            const Tab(text: 'Subscribed'),
            Tab(text: l.podcastsTabRadioFrance),
            Tab(text: l.podcastsTabSearch),
          ],
        ),
      ),
      floatingActionButton: _tabCtrl.index == 0
          ? FloatingActionButton(
              backgroundColor: TuneColors.accent,
              onPressed: _showSubscribeDialog,
              child: const Icon(Icons.add),
            )
          : null,
      body: TabBarView(
        controller: _tabCtrl,
        children: [
          _buildSubscribedTab(l),
          _buildShowGrid(_radioFranceShows, l, isLoading: _loadingShows),
          _buildSearchTab(l),
        ],
      ),
    );
  }

  // -------------------------------------------------------------------------
  // Grille d'émissions
  // -------------------------------------------------------------------------

  Widget _buildShowGrid(
    List<PodcastShow> shows,
    AppLocalizations l, {
    bool isLoading = false,
  }) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator(color: TuneColors.accent));
    }

    if (shows.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.podcasts_rounded, size: 56, color: TuneColors.textTertiary),
            const SizedBox(height: 12),
            Text(l.podcastsEmpty, style: TuneFonts.subheadline),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.72,
      ),
      itemCount: shows.length,
      itemBuilder: (_, i) => _PodcastCard(
        show: shows[i],
        onTap: () => _openShow(shows[i]),
      ),
    );
  }

  // -------------------------------------------------------------------------
  // Onglet recherche
  // -------------------------------------------------------------------------

  Widget _buildSearchTab(AppLocalizations l) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            controller: _searchCtrl,
            style: TuneFonts.body,
            autocorrect: false,
            onSubmitted: (_) => _search(),
            onChanged: (v) {
              if (v.length >= 3) _search();
            },
            decoration: InputDecoration(
              hintText: l.podcastsSearchHint,
              hintStyle: TuneFonts.body.copyWith(color: TuneColors.textTertiary),
              prefixIcon: const Icon(Icons.search_rounded, color: TuneColors.textSecondary),
              suffixIcon: _searchCtrl.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear_rounded, color: TuneColors.textSecondary),
                      onPressed: () {
                        _searchCtrl.clear();
                        setState(() => _searchResults = []);
                      },
                    )
                  : null,
              filled: true,
              fillColor: TuneColors.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: TuneColors.divider),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: TuneColors.divider),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: TuneColors.accent),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ),
        Expanded(
          child: _buildShowGrid(_searchResults, l, isLoading: _searching),
        ),
      ],
    );
  }

  // -------------------------------------------------------------------------
  // Liste d'épisodes
  // -------------------------------------------------------------------------

  Widget _buildEpisodeList(AppLocalizations l) {
    final show = _selectedShow!;
    return Scaffold(
      backgroundColor: TuneColors.background,
      appBar: AppBar(
        backgroundColor: TuneColors.surface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => setState(() {
            _selectedShow = null;
            _episodes = [];
          }),
        ),
        title: Text(show.name, style: TuneFonts.title3),
      ),
      body: _loadingEpisodes
          ? const Center(
              child: CircularProgressIndicator(color: TuneColors.accent))
          : _episodes.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.mic_off_rounded,
                          size: 56, color: TuneColors.textTertiary),
                      const SizedBox(height: 12),
                      Text(l.podcastsNoEpisodes, style: TuneFonts.subheadline),
                    ],
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.only(bottom: 80),
                  itemCount: _episodes.length + 1,
                  separatorBuilder: (_, i) => i == 0
                      ? const SizedBox()
                      : const Divider(
                          height: 1, indent: 72, color: TuneColors.divider),
                  itemBuilder: (_, i) {
                    if (i == 0) return _ShowHeader(show: show);
                    return _EpisodeTile(
                      episode: _episodes[i - 1],
                      onPlay: () => _playEpisode(_episodes[i - 1], show),
                    );
                  },
                ),
    );
  }

  // -------------------------------------------------------------------------
  // Subscribed podcasts tab
  // -------------------------------------------------------------------------

  Widget _buildSubscribedTab(AppLocalizations l) {
    if (_loadingSubscribed) {
      return const Center(child: CircularProgressIndicator(color: TuneColors.accent));
    }
    if (_subscribed.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.rss_feed_rounded, size: 56, color: TuneColors.textTertiary),
            const SizedBox(height: 12),
            Text('No subscriptions yet', style: TuneFonts.subheadline),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _showSubscribeDialog,
              icon: const Icon(Icons.add),
              label: const Text('Subscribe to RSS feed'),
              style: FilledButton.styleFrom(backgroundColor: TuneColors.accent),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadSubscribed,
      child: ListView.separated(
        padding: const EdgeInsets.only(bottom: 80),
        itemCount: _subscribed.length,
        separatorBuilder: (_, __) => const Divider(height: 1, indent: 72, color: TuneColors.divider),
        itemBuilder: (_, i) {
          final podcast = _subscribed[i];
          final id = podcast['id']?.toString() ?? '';
          final name = podcast['name'] as String? ?? 'Unknown';
          final coverUrl = podcast['cover_url'] as String? ?? '';
          final episodeCount = podcast['episode_count'] as int? ?? 0;

          return Dismissible(
            key: ValueKey(id),
            direction: DismissDirection.endToStart,
            background: Container(
              color: TuneColors.error,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              child: const Icon(Icons.delete_rounded, color: Colors.white),
            ),
            confirmDismiss: (_) async {
              return await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  backgroundColor: TuneColors.surface,
                  title: const Text('Unsubscribe?'),
                  content: Text('Unsubscribe from "$name"?'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      child: const Text('Unsubscribe', style: TextStyle(color: TuneColors.error)),
                    ),
                  ],
                ),
              ) ?? false;
            },
            onDismissed: (_) => _unsubscribe(id, i),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 50,
                  height: 50,
                  child: coverUrl.isNotEmpty
                      ? Image.network(coverUrl, fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: TuneColors.surface,
                            child: const Icon(Icons.podcasts_rounded, color: TuneColors.textTertiary),
                          ))
                      : Container(
                          color: TuneColors.surface,
                          child: const Icon(Icons.podcasts_rounded, color: TuneColors.textTertiary),
                        ),
                ),
              ),
              title: Text(name, style: TuneFonts.body, maxLines: 2, overflow: TextOverflow.ellipsis),
              subtitle: Text('$episodeCount episodes', style: TuneFonts.caption),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.refresh_rounded, size: 20, color: TuneColors.textSecondary),
                    tooltip: 'Refresh',
                    onPressed: () => _refreshPodcast(id),
                  ),
                  const Icon(Icons.chevron_right_rounded, color: TuneColors.textTertiary),
                ],
              ),
              onTap: () => _openSubscribedPodcast(podcast),
            ),
          );
        },
      ),
    );
  }

  // -------------------------------------------------------------------------
  // Actions
  // -------------------------------------------------------------------------

  Future<void> _loadSubscribed() async {
    final app = context.read<AppState>();
    if (!app.isRemoteMode || app.apiClient == null) {
      if (mounted) setState(() => _loadingSubscribed = false);
      return;
    }
    setState(() => _loadingSubscribed = true);
    try {
      final data = await app.apiClient!.getSubscribedPodcasts();
      if (!mounted) return;
      setState(() {
        _subscribed = data.cast<Map<String, dynamic>>();
        _loadingSubscribed = false;
      });
    } catch (_) {
      if (mounted) setState(() => _loadingSubscribed = false);
    }
  }

  Future<void> _showSubscribeDialog() async {
    final urlCtrl = TextEditingController();
    final result = await showDialog<String?>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: TuneColors.surface,
        title: const Text('Subscribe to podcast', style: TuneFonts.title3),
        content: TextField(
          controller: urlCtrl,
          style: TuneFonts.body,
          keyboardType: TextInputType.url,
          autocorrect: false,
          decoration: InputDecoration(
            hintText: 'https://example.com/feed.xml',
            hintStyle: TuneFonts.body.copyWith(color: TuneColors.textTertiary),
            labelText: 'RSS Feed URL',
            filled: true,
            fillColor: TuneColors.surfaceVariant,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, null), child: const Text('Cancel')),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, urlCtrl.text.trim()),
            style: FilledButton.styleFrom(backgroundColor: TuneColors.accent),
            child: const Text('Subscribe'),
          ),
        ],
      ),
    );
    if (result == null || result.isEmpty || !mounted) return;

    final app = context.read<AppState>();
    if (app.apiClient == null) return;
    try {
      await app.apiClient!.subscribePodcast(result);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Subscribed.')),
      );
      _loadSubscribed();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Subscribe error: $e')),
      );
    }
  }

  Future<void> _unsubscribe(String podcastId, int index) async {
    final app = context.read<AppState>();
    if (app.apiClient == null) return;
    try {
      await app.apiClient!.unsubscribePodcast(podcastId);
      if (mounted) setState(() => _subscribed.removeAt(index));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unsubscribe error: $e')),
        );
      }
    }
  }

  Future<void> _refreshPodcast(String podcastId) async {
    final app = context.read<AppState>();
    if (app.apiClient == null) return;
    try {
      await app.apiClient!.refreshPodcast(podcastId);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Podcast refreshed.')),
      );
      _loadSubscribed();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Refresh error: $e')),
      );
    }
  }

  Future<void> _refreshAllPodcasts() async {
    final app = context.read<AppState>();
    if (app.apiClient == null) return;
    setState(() => _refreshingAll = true);
    try {
      await app.apiClient!.refreshAllPodcasts();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All podcasts refreshed.')),
      );
      _loadSubscribed();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Refresh error: $e')),
      );
    }
    if (mounted) setState(() => _refreshingAll = false);
  }

  Future<void> _openSubscribedPodcast(Map<String, dynamic> podcast) async {
    final app = context.read<AppState>();
    if (app.apiClient == null) return;
    final id = podcast['id']?.toString() ?? '';
    final name = podcast['name'] as String? ?? 'Unknown';
    final feedUrl = podcast['feed_url'] as String? ?? '';

    // Build a PodcastShow from subscribed data
    final show = PodcastShow(
      id: id,
      name: name,
      artist: podcast['artist'] as String? ?? '',
      coverUrl: podcast['cover_url'] as String? ?? '',
      description: podcast['description'] as String? ?? '',
      feedUrl: feedUrl,
    );

    setState(() {
      _selectedShow = show;
      _episodes = [];
      _loadingEpisodes = true;
    });

    try {
      final data = await app.apiClient!.getSubscribedPodcastEpisodes(id);
      final eps = data.map((j) => PodcastEpisodeItem.fromJson(j as Map<String, dynamic>)).toList();
      if (mounted) setState(() { _episodes = eps; _loadingEpisodes = false; });
    } catch (_) {
      // Fallback to regular episodes endpoint
      try {
        final data = await app.apiClient!.getPodcastEpisodes(feedUrl);
        final eps = data.map((j) => PodcastEpisodeItem.fromJson(j as Map<String, dynamic>)).toList();
        if (mounted) setState(() { _episodes = eps; _loadingEpisodes = false; });
      } catch (_) {
        if (mounted) setState(() => _loadingEpisodes = false);
      }
    }
  }

  Future<void> _loadRadioFrance() async {
    setState(() => _loadingShows = true);
    final app = context.read<AppState>();
    if (app.isRemoteMode && app.apiClient != null) {
      try {
        final data = await app.apiClient!.getRadioFrancePodcasts();
        final shows = data.map((j) => PodcastShow.fromJson(j as Map<String, dynamic>)).toList();
        if (mounted) setState(() { _radioFranceShows = shows; _loadingShows = false; });
      } catch (_) {
        if (mounted) setState(() => _loadingShows = false);
      }
      return;
    }
    final shows = await _service.getRadioFrancePodcasts();
    if (mounted) setState(() {
      _radioFranceShows = shows;
      _loadingShows = false;
    });
  }

  Future<void> _search() async {
    final q = _searchCtrl.text.trim();
    if (q.isEmpty) return;
    setState(() => _searching = true);
    final app = context.read<AppState>();
    if (app.isRemoteMode && app.apiClient != null) {
      try {
        final data = await app.apiClient!.searchPodcasts(q);
        final results = data.map((j) => PodcastShow.fromJson(j as Map<String, dynamic>)).toList();
        if (mounted) setState(() { _searchResults = results; _searching = false; });
      } catch (_) {
        if (mounted) setState(() => _searching = false);
      }
      return;
    }
    final results = await _service.searchPodcasts(q);
    if (mounted) setState(() {
      _searchResults = results;
      _searching = false;
    });
  }

  Future<void> _openShow(PodcastShow show) async {
    setState(() {
      _selectedShow = show;
      _episodes = [];
      _loadingEpisodes = true;
    });
    final app = context.read<AppState>();
    if (app.isRemoteMode && app.apiClient != null) {
      try {
        final data = await app.apiClient!.getPodcastEpisodes(show.feedUrl, showUrl: show.showUrl);
        final eps = data.map((j) => PodcastEpisodeItem.fromJson(j as Map<String, dynamic>)).toList();
        if (mounted) setState(() { _episodes = eps; _loadingEpisodes = false; });
      } catch (_) {
        if (mounted) setState(() => _loadingEpisodes = false);
      }
      return;
    }
    final eps = await _service.getPodcastEpisodes(
      feedUrl: show.feedUrl,
      showUrl: show.showUrl ?? '',
    );
    if (mounted) setState(() {
      _episodes = eps;
      _loadingEpisodes = false;
    });
  }

  Future<void> _playEpisode(PodcastEpisodeItem episode, PodcastShow show) async {
    final url = episode.audioUrl;
    if (url.isEmpty) return;

    final app = context.read<AppState>();
    final zoneId = context.read<ZoneState>().currentZoneId;

    final cover = episode.coverUrl.isNotEmpty ? episode.coverUrl : show.coverUrl;

    if (app.isRemoteMode && app.apiClient != null) {
      if (zoneId == null) return;
      await app.apiClient!.playPodcast(zoneId, {
        'file_path': url,
        'title': episode.title,
        'artist_name': show.name,
        'cover_path': cover,
        'duration_ms': episode.durationMs,
      });
      await app.refreshZonesRemote();
      return;
    }

    final instance = app.engine.zoneManager.zone(zoneId ?? -1);
    if (instance == null) return;

    final track = Track(
      id: 0,
      title: episode.title,
      artistName: show.artist,
      albumTitle: show.name,
      filePath: url,
      coverPath: cover,
      source: 'podcast',
      durationMs: episode.durationMs > 0 ? episode.durationMs : null,
      favorite: false,
    );

    instance.queue.load([track], startIndex: 0);
    await instance.player.play();
  }
}

// ---------------------------------------------------------------------------
// _PodcastCard — carte grille
// ---------------------------------------------------------------------------

class _PodcastCard extends StatelessWidget {
  final PodcastShow show;
  final VoidCallback onTap;

  const _PodcastCard({required this.show, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: AspectRatio(
              aspectRatio: 1,
              child: show.coverUrl.isNotEmpty
                  ? Image.network(
                      show.coverUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _coverPlaceholder(),
                    )
                  : _coverPlaceholder(),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            show.name,
            style: TuneFonts.body,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            show.artist,
            style: TuneFonts.caption.copyWith(color: TuneColors.textSecondary),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _coverPlaceholder() => Container(
        color: TuneColors.surface,
        child: const Center(
          child: Icon(Icons.podcasts_rounded,
              size: 40, color: TuneColors.textTertiary),
        ),
      );
}

// ---------------------------------------------------------------------------
// _ShowHeader — entête dans la liste d'épisodes
// ---------------------------------------------------------------------------

class _ShowHeader extends StatelessWidget {
  final PodcastShow show;
  const _ShowHeader({required this.show});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: TuneColors.surface,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: show.coverUrl.isNotEmpty
                ? Image.network(show.coverUrl,
                    width: 80, height: 80, fit: BoxFit.cover)
                : Container(
                    width: 80, height: 80, color: TuneColors.surfaceVariant,
                    child: const Icon(Icons.podcasts_rounded,
                        color: TuneColors.textTertiary)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(show.name,
                    style: TuneFonts.body.copyWith(fontWeight: FontWeight.w600)),
                Text(show.artist,
                    style: TuneFonts.caption
                        .copyWith(color: TuneColors.textSecondary)),
                if (show.episodeCount > 0)
                  Text('${show.episodeCount} épisodes',
                      style: TuneFonts.caption
                          .copyWith(color: TuneColors.textSecondary)),
                if (show.description.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(show.description,
                      style: TuneFonts.caption
                          .copyWith(color: TuneColors.textSecondary),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _EpisodeTile — ligne d'épisode
// ---------------------------------------------------------------------------

class _EpisodeTile extends StatelessWidget {
  final PodcastEpisodeItem episode;
  final VoidCallback onPlay;

  const _EpisodeTile({required this.episode, required this.onPlay});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          width: 50,
          height: 50,
          child: episode.coverUrl.isNotEmpty
              ? Image.network(episode.coverUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: TuneColors.surface,
                    child: const Icon(Icons.mic_rounded,
                        color: TuneColors.textTertiary, size: 20),
                  ))
              : Container(
                  color: TuneColors.surface,
                  child: const Icon(Icons.mic_rounded,
                      color: TuneColors.textTertiary, size: 20),
                ),
        ),
      ),
      title: Text(episode.title,
          style: TuneFonts.body,
          maxLines: 2,
          overflow: TextOverflow.ellipsis),
      subtitle: Row(
        children: [
          if (episode.published.isNotEmpty)
            Text(_formatDate(episode.published),
                style: TuneFonts.caption
                    .copyWith(color: TuneColors.textSecondary)),
          if (episode.durationMs > 0) ...[
            Text(' · ',
                style: TuneFonts.caption
                    .copyWith(color: TuneColors.textSecondary)),
            Text(_formatDuration(episode.durationMs),
                style: TuneFonts.caption
                    .copyWith(color: TuneColors.textSecondary)),
          ],
        ],
      ),
      trailing: IconButton(
        icon: const Icon(Icons.play_circle_fill_rounded,
            size: 36, color: TuneColors.accent),
        onPressed: onPlay,
      ),
    );
  }

  static String _formatDuration(int ms) {
    final secs = ms ~/ 1000;
    final h = secs ~/ 3600;
    final m = (secs % 3600) ~/ 60;
    if (h > 0) return '${h}h${m.toString().padLeft(2, '0')}';
    return '${m} min';
  }

  static String _formatDate(String dateStr) {
    try {
      // Tente ISO 8601
      final dt = DateTime.parse(dateStr).toLocal();
      return _relativeDate(dt);
    } catch (_) {}
    // Tente RFC 2822 simple (ex: "Mon, 01 Jan 2024 12:00:00 +0000")
    try {
      final parts = dateStr.split(' ');
      if (parts.length >= 5) {
        final months = {
          'Jan': 1, 'Feb': 2, 'Mar': 3, 'Apr': 4, 'May': 5, 'Jun': 6,
          'Jul': 7, 'Aug': 8, 'Sep': 9, 'Oct': 10, 'Nov': 11, 'Dec': 12,
        };
        final day = int.parse(parts[1]);
        final month = months[parts[2]] ?? 1;
        final year = int.parse(parts[3]);
        final dt = DateTime(year, month, day).toLocal();
        return _relativeDate(dt);
      }
    } catch (_) {}
    return dateStr.length > 10 ? dateStr.substring(0, 10) : dateStr;
  }

  static String _relativeDate(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inDays == 0) return "Aujourd'hui";
    if (diff.inDays == 1) return 'Hier';
    if (diff.inDays < 7) return 'Il y a ${diff.inDays} j';
    return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
  }
}
