import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/app_state.dart';
import '../../state/zone_state.dart';
import '../helpers/tune_colors.dart';
import '../helpers/tune_fonts.dart';

// ---------------------------------------------------------------------------
// YouTubeBrowseView — Charts and Moods tabs when YouTube is selected
// API: GET /streaming/youtube/home, /charts, /moods
// ---------------------------------------------------------------------------

class YouTubeBrowseView extends StatefulWidget {
  const YouTubeBrowseView({super.key});

  @override
  State<YouTubeBrowseView> createState() => _YouTubeBrowseViewState();
}

class _YouTubeBrowseViewState extends State<YouTubeBrowseView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
        title: const Text('YouTube Music', style: TuneFonts.title3),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: TuneColors.accent,
          labelColor: TuneColors.accent,
          unselectedLabelColor: TuneColors.textSecondary,
          tabs: const [
            Tab(text: 'Accueil'),
            Tab(text: 'Charts'),
            Tab(text: 'Ambiances'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _HomeTab(),
          _ChartsTab(),
          _MoodsTab(),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Home tab
// ---------------------------------------------------------------------------

class _HomeTab extends StatefulWidget {
  const _HomeTab();

  @override
  State<_HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<_HomeTab> {
  Map<String, dynamic>? _data;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final api = context.read<AppState>().apiClient;
    if (api == null) { setState(() => _loading = false); return; }
    try {
      final data = await api.getYoutubeHome();
      if (mounted) setState(() { _data = data; _loading = false; });
    } catch (e) {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator(color: TuneColors.accent));
    if (_data == null) return const Center(child: Text('Aucune donnee', style: TextStyle(color: TuneColors.textSecondary)));

    final sections = _data!['sections'] as List<dynamic>? ?? [];
    if (sections.isEmpty) {
      return const Center(child: Text('Aucun contenu disponible', style: TextStyle(color: TuneColors.textSecondary)));
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: sections.length,
      itemBuilder: (_, i) {
        final section = sections[i] as Map<String, dynamic>;
        return _ContentSection(section: section);
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Charts tab
// ---------------------------------------------------------------------------

class _ChartsTab extends StatefulWidget {
  const _ChartsTab();

  @override
  State<_ChartsTab> createState() => _ChartsTabState();
}

class _ChartsTabState extends State<_ChartsTab> {
  Map<String, dynamic>? _data;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final api = context.read<AppState>().apiClient;
    if (api == null) { setState(() => _loading = false); return; }
    try {
      final data = await api.getYoutubeCharts();
      if (mounted) setState(() { _data = data; _loading = false; });
    } catch (e) {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator(color: TuneColors.accent));
    if (_data == null) return const Center(child: Text('Aucune donnee', style: TextStyle(color: TuneColors.textSecondary)));

    final tracks = _data!['tracks'] as List<dynamic>? ?? [];
    if (tracks.isEmpty) {
      return const Center(child: Text('Aucun chart disponible', style: TextStyle(color: TuneColors.textSecondary)));
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: tracks.length,
      itemBuilder: (_, i) {
        final track = tracks[i] as Map<String, dynamic>;
        return _ChartTrackTile(track: track, position: i + 1);
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Moods tab
// ---------------------------------------------------------------------------

class _MoodsTab extends StatefulWidget {
  const _MoodsTab();

  @override
  State<_MoodsTab> createState() => _MoodsTabState();
}

class _MoodsTabState extends State<_MoodsTab> {
  List<dynamic> _moods = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final api = context.read<AppState>().apiClient;
    if (api == null) { setState(() => _loading = false); return; }
    try {
      final data = await api.getYoutubeMoods();
      if (mounted) setState(() { _moods = data; _loading = false; });
    } catch (e) {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator(color: TuneColors.accent));
    if (_moods.isEmpty) {
      return const Center(child: Text('Aucune ambiance disponible', style: TextStyle(color: TuneColors.textSecondary)));
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 2.2,
      ),
      itemCount: _moods.length,
      itemBuilder: (_, i) {
        final mood = _moods[i] as Map<String, dynamic>;
        return _MoodCard(mood: mood);
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Shared widgets
// ---------------------------------------------------------------------------

class _ContentSection extends StatelessWidget {
  final Map<String, dynamic> section;
  const _ContentSection({required this.section});

  @override
  Widget build(BuildContext context) {
    final title = section['title'] as String? ?? '';
    final items = section['items'] as List<dynamic>? ?? [];
    if (items.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(title,
              style: TuneFonts.body.copyWith(fontWeight: FontWeight.w600, color: TuneColors.textPrimary)),
        ),
        SizedBox(
          height: 160,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: items.length,
            itemBuilder: (_, i) {
              final item = items[i] as Map<String, dynamic>;
              return _ContentCard(item: item);
            },
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

class _ContentCard extends StatelessWidget {
  final Map<String, dynamic> item;
  const _ContentCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final title = item['title'] as String? ?? '';
    final subtitle = item['subtitle'] as String? ?? item['artist'] as String? ?? '';
    final thumbnail = item['thumbnail'] as String?;

    return Container(
      width: 140,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 140, height: 110,
              color: TuneColors.surfaceVariant,
              child: thumbnail != null
                  ? Image.network(thumbnail, fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(Icons.music_note_rounded, color: TuneColors.textTertiary))
                  : const Icon(Icons.music_note_rounded, color: TuneColors.textTertiary),
            ),
          ),
          const SizedBox(height: 6),
          Text(title, style: TuneFonts.caption.copyWith(fontWeight: FontWeight.w500),
              maxLines: 1, overflow: TextOverflow.ellipsis),
          if (subtitle.isNotEmpty)
            Text(subtitle, style: TuneFonts.caption.copyWith(color: TuneColors.textTertiary, fontSize: 11),
                maxLines: 1, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}

class _ChartTrackTile extends StatelessWidget {
  final Map<String, dynamic> track;
  final int position;
  const _ChartTrackTile({required this.track, required this.position});

  @override
  Widget build(BuildContext context) {
    final title = track['title'] as String? ?? '';
    final artist = track['artist'] as String? ?? '';
    final thumbnail = track['thumbnail'] as String?;
    final videoId = track['video_id'] as String? ?? track['id'] as String? ?? '';

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 28,
            child: Text(
              '$position',
              textAlign: TextAlign.center,
              style: TuneFonts.body.copyWith(
                color: position <= 3 ? TuneColors.accent : TuneColors.textTertiary,
                fontWeight: position <= 3 ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          const SizedBox(width: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Container(
              width: 44, height: 44,
              color: TuneColors.surfaceVariant,
              child: thumbnail != null
                  ? Image.network(thumbnail, fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(Icons.music_note_rounded, size: 20, color: TuneColors.textTertiary))
                  : const Icon(Icons.music_note_rounded, size: 20, color: TuneColors.textTertiary),
            ),
          ),
        ],
      ),
      title: Text(title, style: TuneFonts.body, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(artist, style: TuneFonts.caption.copyWith(color: TuneColors.textSecondary),
          maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: IconButton(
        icon: const Icon(Icons.play_circle_outline_rounded, color: TuneColors.accent),
        onPressed: () => _playTrack(context, videoId),
      ),
    );
  }

  void _playTrack(BuildContext context, String videoId) {
    final app = context.read<AppState>();
    final zoneId = context.read<ZoneState>().currentZoneId;
    if (app.apiClient == null || zoneId == null || videoId.isEmpty) return;
    app.apiClient!.play(zoneId, {
      'source': 'youtube',
      'source_id': videoId,
    });
  }
}

class _MoodCard extends StatelessWidget {
  final Map<String, dynamic> mood;
  const _MoodCard({required this.mood});

  @override
  Widget build(BuildContext context) {
    final title = mood['title'] as String? ?? '';
    final color = mood['color'] as String?;
    final bgColor = color != null
        ? Color(int.parse(color.replaceFirst('#', '0xFF')))
        : TuneColors.surfaceVariant;

    return Container(
      decoration: BoxDecoration(
        color: bgColor.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: bgColor.withValues(alpha: 0.5)),
      ),
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TuneFonts.body.copyWith(
          fontWeight: FontWeight.w600,
          color: TuneColors.textPrimary,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
