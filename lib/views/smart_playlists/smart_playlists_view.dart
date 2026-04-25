import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/domain_models.dart';
import '../../state/app_state.dart';
import '../helpers/artwork_view.dart';
import '../helpers/tune_colors.dart';
import '../helpers/tune_fonts.dart';

// ---------------------------------------------------------------------------
// SmartPlaylistsView — List of smart playlists with rules, tracks, delete
// ---------------------------------------------------------------------------

class SmartPlaylistsView extends StatefulWidget {
  const SmartPlaylistsView({super.key});

  @override
  State<SmartPlaylistsView> createState() => _SmartPlaylistsViewState();
}

class _SmartPlaylistsViewState extends State<SmartPlaylistsView> {
  List<Map<String, dynamic>> _playlists = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final api = context.read<AppState>().apiClient;
    if (api == null) {
      if (mounted) setState(() => _loading = false);
      return;
    }
    try {
      final data = await api.getSmartPlaylists();
      if (!mounted) return;
      setState(() {
        _playlists = data.cast<Map<String, dynamic>>();
        _loading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading smart playlists: $e')),
        );
      }
    }
  }

  Future<void> _delete(int id, int index) async {
    final api = context.read<AppState>().apiClient;
    if (api == null) return;
    try {
      await api.deleteSmartPlaylist(id);
      if (mounted) {
        setState(() => _playlists.removeAt(index));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Delete error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TuneColors.background,
      appBar: AppBar(
        backgroundColor: TuneColors.surface,
        title: Text('Smart Playlists', style: TuneFonts.title2),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _playlists.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.auto_awesome_rounded,
                          size: 56, color: TuneColors.textTertiary),
                      const SizedBox(height: 12),
                      Text('No smart playlists',
                          style: TuneFonts.subheadline),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: _playlists.length,
                    itemBuilder: (_, i) {
                      final pl = _playlists[i];
                      final id = pl['id'] as int;
                      final name = pl['name'] as String? ?? 'Untitled';
                      final rules = pl['rules'] as List? ?? [];
                      final trackCount = pl['track_count'] as int? ?? 0;

                      return Dismissible(
                        key: ValueKey(id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: TuneColors.error,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: const Icon(Icons.delete_rounded,
                              color: Colors.white),
                        ),
                        confirmDismiss: (_) async {
                          return await showDialog<bool>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              backgroundColor: TuneColors.surface,
                              title: const Text('Delete smart playlist?'),
                              content: Text('Delete "$name"?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx, false),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx, true),
                                  child: const Text('Delete',
                                      style: TextStyle(color: TuneColors.error)),
                                ),
                              ],
                            ),
                          ) ?? false;
                        },
                        onDismissed: (_) => _delete(id, i),
                        child: ListTile(
                          leading: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: TuneColors.accent.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.auto_awesome_rounded,
                                color: TuneColors.accent),
                          ),
                          title: Text(name,
                              style: TuneFonts.body,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis),
                          subtitle: Wrap(
                            spacing: 4,
                            runSpacing: 2,
                            children: [
                              Text('$trackCount tracks',
                                  style: TuneFonts.caption),
                              for (final rule in rules.take(3))
                                Chip(
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  visualDensity: VisualDensity.compact,
                                  label: Text(
                                    _ruleLabel(rule),
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                  backgroundColor:
                                      TuneColors.surfaceVariant,
                                  side: BorderSide.none,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 2),
                                ),
                            ],
                          ),
                          trailing: const Icon(Icons.chevron_right_rounded,
                              color: TuneColors.textTertiary),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => _SmartPlaylistDetailView(
                                playlistId: id,
                                playlistName: name,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }

  String _ruleLabel(dynamic rule) {
    if (rule is Map<String, dynamic>) {
      final field = rule['field'] as String? ?? '';
      final op = rule['operator'] as String? ?? '';
      final value = rule['value']?.toString() ?? '';
      return '$field $op $value';
    }
    return rule.toString();
  }
}

// ---------------------------------------------------------------------------
// Smart Playlist Detail — shows tracks, play all FAB
// ---------------------------------------------------------------------------

class _SmartPlaylistDetailView extends StatefulWidget {
  final int playlistId;
  final String playlistName;

  const _SmartPlaylistDetailView({
    required this.playlistId,
    required this.playlistName,
  });

  @override
  State<_SmartPlaylistDetailView> createState() =>
      _SmartPlaylistDetailViewState();
}

class _SmartPlaylistDetailViewState extends State<_SmartPlaylistDetailView> {
  List<dynamic> _tracks = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadTracks();
  }

  Future<void> _loadTracks() async {
    final api = context.read<AppState>().apiClient;
    if (api == null) {
      if (mounted) setState(() => _loading = false);
      return;
    }
    try {
      final data = await api.getSmartPlaylistTracks(widget.playlistId);
      if (!mounted) return;
      setState(() {
        _tracks = data;
        _loading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading tracks: $e')),
        );
      }
    }
  }

  void _playAll() {
    if (_tracks.isEmpty) return;
    final app = context.read<AppState>();
    final tracks = _tracks
        .map((t) => trackFromJson(t as Map<String, dynamic>))
        .toList();
    app.playTracks(tracks);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TuneColors.background,
      appBar: AppBar(
        backgroundColor: TuneColors.surface,
        title: Text(widget.playlistName,
            style: TuneFonts.title3,
            maxLines: 1,
            overflow: TextOverflow.ellipsis),
      ),
      floatingActionButton: _tracks.isNotEmpty
          ? FloatingActionButton(
              backgroundColor: TuneColors.accent,
              onPressed: _playAll,
              child: const Icon(Icons.play_arrow_rounded),
            )
          : null,
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _tracks.isEmpty
              ? Center(
                  child: Text('No tracks match this playlist',
                      style: TuneFonts.subheadline),
                )
              : ListView.builder(
                  itemCount: _tracks.length,
                  itemBuilder: (_, i) {
                    final t = _tracks[i] as Map<String, dynamic>;
                    final title = t['title'] as String? ?? 'Unknown';
                    final artist = t['artist_name'] as String?;
                    final cover = t['cover_path'] as String?;

                    return ListTile(
                      leading: ArtworkView(
                          filePath: cover, size: 44, cornerRadius: 6),
                      title: Text(title,
                          style: TuneFonts.body,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                      subtitle: artist != null
                          ? Text(artist,
                              style: TuneFonts.footnote,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis)
                          : null,
                      onTap: () {
                        final app = context.read<AppState>();
                        final tracks = _tracks
                            .map((tr) =>
                                trackFromJson(tr as Map<String, dynamic>))
                            .toList();
                        app.playTracks(tracks, startIndex: i);
                      },
                    );
                  },
                ),
    );
  }
}
