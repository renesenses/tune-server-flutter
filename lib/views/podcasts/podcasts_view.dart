import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../server/database/database.dart';
import '../../server/podcasts/podcast_service.dart';
import '../../state/app_state.dart';
import '../../state/zone_state.dart';
import '../helpers/tune_colors.dart';
import '../helpers/tune_fonts.dart';

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

  bool _loadingShows = false;
  bool _loadingEpisodes = false;
  bool _searching = false;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
    _loadRadioFrance();
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
        bottom: TabBar(
          controller: _tabCtrl,
          indicatorColor: TuneColors.accent,
          labelColor: TuneColors.accent,
          unselectedLabelColor: TuneColors.textSecondary,
          tabs: [
            Tab(text: l.podcastsTabRadioFrance),
            Tab(text: l.podcastsTabSearch),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabCtrl,
        children: [
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
  // Actions
  // -------------------------------------------------------------------------

  Future<void> _loadRadioFrance() async {
    setState(() => _loadingShows = true);
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
    final instance = app.engine.zoneManager.zone(zoneId ?? -1);
    if (instance == null) return;

    final cover = episode.coverUrl.isNotEmpty
        ? episode.coverUrl
        : show.coverUrl;

    final track = Track(
      id: 0,
      title: episode.title,
      artistName: show.artist,
      albumTitle: show.name,
      filePath: url,
      coverPath: cover,
      source: 'podcast',
      durationMs: episode.durationMs > 0 ? episode.durationMs : null,
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
