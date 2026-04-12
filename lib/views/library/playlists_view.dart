import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../server/database/database.dart';
import '../../models/domain_models.dart';
import '../../state/app_state.dart';
import '../../state/library_state.dart';
import '../helpers/artwork_view.dart';
import '../helpers/tune_colors.dart';
import '../helpers/tune_fonts.dart';
import 'albums_grid_view.dart';

// ---------------------------------------------------------------------------
// PlaylistsView — source icon bar + filtered list
// Matches web client and iOS design
// ---------------------------------------------------------------------------

class PlaylistsView extends StatefulWidget {
  const PlaylistsView({super.key});

  @override
  State<PlaylistsView> createState() => _PlaylistsViewState();
}

class _PlaylistsViewState extends State<PlaylistsView> {
  String _selectedSource = 'local';
  Map<String, List<Map<String, dynamic>>> _streamingPlaylists = {};
  bool _loadingStreaming = false;

  @override
  void initState() {
    super.initState();
    _loadStreamingPlaylists();
  }

  Future<void> _loadStreamingPlaylists() async {
    final app = context.read<AppState>();
    if (!app.isRemoteMode || app.apiClient == null) return;
    setState(() => _loadingStreaming = true);
    try {
      final services = await app.apiClient!.getStreamingServices();
      for (final entry in services.entries) {
        if (entry.value is Map && (entry.value as Map)['authenticated'] == true) {
          try {
            final pls = await app.apiClient!.getStreamingPlaylists(entry.key);
            if (pls.isNotEmpty) {
              _streamingPlaylists[entry.key] = pls.cast<Map<String, dynamic>>();
            }
          } catch (_) {}
        }
      }
    } catch (_) {}
    if (mounted) setState(() => _loadingStreaming = false);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final localPlaylists = context.watch<LibraryState>().playlists;
    final app = context.read<AppState>();

    // Build source list
    final sources = <_SourceInfo>[
      _SourceInfo('local', 'Local', Icons.music_note_rounded, localPlaylists.length),
    ];
    for (final entry in _streamingPlaylists.entries) {
      sources.add(_SourceInfo(
        entry.key,
        _serviceName(entry.key),
        _serviceIcon(entry.key),
        entry.value.length,
      ));
    }

    return Scaffold(
      backgroundColor: TuneColors.background,
      floatingActionButton: _selectedSource == 'local'
          ? FloatingActionButton(
              backgroundColor: TuneColors.accent,
              child: const Icon(Icons.add_rounded),
              onPressed: () => _createPlaylist(context, app),
            )
          : null,
      body: Column(
        children: [
          // Source icons bar
          SizedBox(
            height: 90,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              children: [
                for (final src in sources)
                  _SourceButton(
                    info: src,
                    selected: _selectedSource == src.key,
                    onTap: () => setState(() => _selectedSource = src.key),
                  ),
                if (_loadingStreaming)
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Center(
                      child: SizedBox(width: 20, height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: TuneColors.accent)),
                    ),
                  ),
              ],
            ),
          ),
          const Divider(height: 1, color: TuneColors.divider),

          // Playlist list
          Expanded(
            child: _selectedSource == 'local'
                ? _buildLocalList(localPlaylists, app, l)
                : _buildStreamingList(_streamingPlaylists[_selectedSource] ?? []),
          ),
        ],
      ),
    );
  }

  Widget _buildLocalList(List<Playlist> playlists, AppState app, AppLocalizations l) {
    if (playlists.isEmpty) {
      return LibraryEmptyState(icon: Icons.queue_music_rounded, message: l.libraryEmptyPlaylists);
    }
    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: playlists.length,
      separatorBuilder: (_, __) => const Divider(height: 1, indent: 72, color: TuneColors.divider),
      itemBuilder: (_, i) => Dismissible(
        key: ValueKey(playlists[i].id),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          color: TuneColors.error,
          child: const Icon(Icons.delete_rounded, color: Colors.white),
        ),
        onDismissed: (_) => app.deletePlaylist(playlists[i].id),
        child: _PlaylistTile(playlist: playlists[i]),
      ),
    );
  }

  Widget _buildStreamingList(List<Map<String, dynamic>> playlists) {
    if (playlists.isEmpty) {
      return const Center(child: Text('Aucune playlist', style: TuneFonts.body));
    }
    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: playlists.length,
      separatorBuilder: (_, __) => const Divider(height: 1, indent: 72, color: TuneColors.divider),
      itemBuilder: (_, i) {
        final pl = playlists[i];
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          leading: pl['cover_path'] != null
              ? ArtworkView(filePath: pl['cover_path'] as String, size: 44, cornerRadius: 8)
              : Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(
                    color: TuneColors.accent.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.queue_music_rounded, color: TuneColors.accent, size: 22),
                ),
          title: Text(pl['name'] as String? ?? '', style: TuneFonts.body, maxLines: 1, overflow: TextOverflow.ellipsis),
          subtitle: Text('${pl['track_count'] ?? 0} pistes', style: TuneFonts.footnote),
          trailing: PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded, color: TuneColors.textTertiary, size: 20),
            color: TuneColors.surfaceVariant,
            onSelected: (action) async {
              final app = context.read<AppState>();
              if (action == 'transfer' && app.apiClient != null) {
                final sourceId = pl['source_id'] as String? ?? '';
                final name = pl['name'] as String? ?? '';
                try {
                  await app.apiClient!.transferPlaylist(
                    sourceService: _selectedSource, sourcePlaylistId: sourceId,
                    targetService: 'local', targetName: name,
                  );
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Transféré: $name'), duration: const Duration(seconds: 2)),
                    );
                  }
                } catch (_) {}
              }
            },
            itemBuilder: (_) => [
              const PopupMenuItem(value: 'transfer', child: ListTile(
                leading: Icon(Icons.download_rounded, size: 20),
                title: Text('Transférer en local', style: TextStyle(fontSize: 14)),
                dense: true, contentPadding: EdgeInsets.zero,
              )),
            ],
          ),
          onTap: () {
            final app = context.read<AppState>();
            if (app.apiClient != null) {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => _StreamingPlaylistDetailView(
                  service: _selectedSource,
                  playlist: pl,
                ),
              ));
            }
          },
        );
      },
    );
  }

  Future<void> _createPlaylist(BuildContext context, AppState app) async {
    final name = await _askName(context);
    if (name == null || name.isEmpty) return;
    await app.createPlaylist(name);
  }

  Future<String?> _askName(BuildContext context) => showDialog<String>(
    context: context,
    builder: (_) {
      final l = AppLocalizations.of(context);
      final ctrl = TextEditingController();
      return AlertDialog(
        backgroundColor: TuneColors.surface,
        title: Text(l.playlistNewPlaylist, style: TuneFonts.title3),
        content: TextField(controller: ctrl, autofocus: true, style: TuneFonts.body, decoration: InputDecoration(hintText: l.playlistName)),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(l.btnCancel, style: const TextStyle(color: TuneColors.textSecondary))),
          TextButton(onPressed: () => Navigator.of(context).pop(ctrl.text), child: Text(l.btnCreate, style: const TextStyle(color: TuneColors.accent))),
        ],
      );
    },
  );

  String _serviceName(String s) => switch (s) {
    'tidal' => 'Tidal', 'qobuz' => 'Qobuz', 'youtube' => 'YouTube',
    'spotify' => 'Spotify', 'deezer' => 'Deezer', 'amazon' => 'Amazon',
    _ => s[0].toUpperCase() + s.substring(1),
  };

  IconData _serviceIcon(String s) => switch (s) {
    'tidal' => Icons.waves_rounded,
    'qobuz' => Icons.album_rounded,
    'youtube' => Icons.play_circle_rounded,
    'spotify' => Icons.circle_rounded,
    'deezer' => Icons.equalizer_rounded,
    'amazon' => Icons.shopping_cart_rounded,
    _ => Icons.music_note_rounded,
  };
}

// ---------------------------------------------------------------------------
// Source button
// ---------------------------------------------------------------------------

class _SourceInfo {
  final String key;
  final String name;
  final IconData icon;
  final int count;
  const _SourceInfo(this.key, this.name, this.icon, this.count);
}

class _SourceButton extends StatelessWidget {
  final _SourceInfo info;
  final bool selected;
  final VoidCallback onTap;
  const _SourceButton({required this.info, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: selected ? TuneColors.accent : TuneColors.surfaceVariant,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected ? TuneColors.accent : Colors.transparent,
              width: 2,
            ),
            boxShadow: selected
                ? [BoxShadow(color: TuneColors.accent.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 2))]
                : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(info.icon, size: 24, color: selected ? Colors.white : TuneColors.textSecondary),
              const SizedBox(height: 4),
              Text(info.name, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: selected ? Colors.white : TuneColors.textSecondary)),
              Text('${info.count}', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: selected ? Colors.white70 : TuneColors.textTertiary)),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _PlaylistTile (local)
// ---------------------------------------------------------------------------

class _PlaylistTile extends StatelessWidget {
  final Playlist playlist;
  const _PlaylistTile({required this.playlist});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        width: 44, height: 44,
        decoration: BoxDecoration(
          color: TuneColors.accent.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.queue_music_rounded, color: TuneColors.accent, size: 22),
      ),
      title: Text(playlist.name, style: TuneFonts.body, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text('${playlist.trackCount} piste${playlist.trackCount != 1 ? "s" : ""}', style: TuneFonts.footnote),
      trailing: const Icon(Icons.chevron_right_rounded, color: TuneColors.textTertiary),
      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => PlaylistDetailView(playlist: playlist))),
    );
  }
}

// ---------------------------------------------------------------------------
// PlaylistDetailView
// ---------------------------------------------------------------------------

class PlaylistDetailView extends StatefulWidget {
  final Playlist playlist;
  const PlaylistDetailView({super.key, required this.playlist});

  @override
  State<PlaylistDetailView> createState() => _PlaylistDetailViewState();
}

class _PlaylistDetailViewState extends State<PlaylistDetailView> {
  List<Track>? _tracks;

  @override
  void initState() {
    super.initState();
    _loadTracks();
  }

  Future<void> _loadTracks() async {
    final app = context.read<AppState>();
    final tracks = await app.engine.db.playlistRepo.tracks(widget.playlist.id);
    if (mounted) setState(() => _tracks = tracks);
  }

  @override
  Widget build(BuildContext context) {
    final app = context.read<AppState>();
    final pl = widget.playlist;

    return Scaffold(
      backgroundColor: TuneColors.background,
      appBar: AppBar(
        backgroundColor: TuneColors.surface,
        title: Text(pl.name, style: TuneFonts.title3, maxLines: 1, overflow: TextOverflow.ellipsis),
        actions: [
          if (_tracks != null && _tracks!.isNotEmpty)
            TextButton.icon(
              icon: const Icon(Icons.play_arrow_rounded, color: TuneColors.accent),
              label: Text(AppLocalizations.of(context).libraryPlay, style: const TextStyle(color: TuneColors.accent)),
              onPressed: () => app.playTracks(_tracks!),
            ),
        ],
      ),
      body: _tracks == null
          ? const Center(child: CircularProgressIndicator())
          : _tracks!.isEmpty
              ? LibraryEmptyState(icon: Icons.queue_music_rounded, message: AppLocalizations.of(context).playlistEmpty)
              : ReorderableListView.builder(
                  padding: const EdgeInsets.only(bottom: 80),
                  itemCount: _tracks!.length,
                  onReorder: (from, to) async {
                    final realTo = to > from ? to - 1 : to;
                    setState(() {
                      final t = _tracks!.removeAt(from);
                      _tracks!.insert(realTo, t);
                    });
                    await app.engine.db.playlistRepo.moveTrack(pl.id, from, realTo);
                  },
                  itemBuilder: (_, i) => _PlaylistTrackTile(
                    key: ValueKey(_tracks![i].id),
                    track: _tracks![i],
                    onTap: () => app.playTracks(_tracks!, startIndex: i),
                    onRemove: () async {
                      await app.removeTrackFromPlaylist(_tracks![i].id, pl.id);
                      await _loadTracks();
                    },
                  ),
                ),
    );
  }
}

// ---------------------------------------------------------------------------
// _PlaylistTrackTile
// ---------------------------------------------------------------------------

class _PlaylistTrackTile extends StatelessWidget {
  final Track track;
  final VoidCallback onTap;
  final VoidCallback onRemove;
  const _PlaylistTrackTile({super.key, required this.track, required this.onTap, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey('dismiss_${track.id}'),
      direction: DismissDirection.endToStart,
      background: Container(alignment: Alignment.centerRight, padding: const EdgeInsets.only(right: 20), color: TuneColors.error, child: const Icon(Icons.remove_circle_rounded, color: Colors.white)),
      onDismissed: (_) => onRemove(),
      child: ListTile(
        onTap: onTap,
        leading: const Icon(Icons.drag_handle_rounded, color: TuneColors.textTertiary),
        title: Text(track.title, style: TuneFonts.body, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: _subtitle,
        trailing: FormatBadge(format: track.format),
      ),
    );
  }

  Widget? get _subtitle {
    final parts = <String>[
      if (track.artistName != null) track.artistName!,
      if (track.albumTitle != null) track.albumTitle!,
    ];
    if (parts.isEmpty) return null;
    return Text(parts.join(' · '), style: TuneFonts.footnote, maxLines: 1, overflow: TextOverflow.ellipsis);
  }
}

// ---------------------------------------------------------------------------
// Streaming Playlist Detail (remote mode)
// ---------------------------------------------------------------------------

class _StreamingPlaylistDetailView extends StatefulWidget {
  final String service;
  final Map<String, dynamic> playlist;
  const _StreamingPlaylistDetailView({required this.service, required this.playlist});

  @override
  State<_StreamingPlaylistDetailView> createState() => _StreamingPlaylistDetailViewState();
}

class _StreamingPlaylistDetailViewState extends State<_StreamingPlaylistDetailView> {
  List<Track>? _tracks;

  @override
  void initState() {
    super.initState();
    _loadTracks();
  }

  Future<void> _loadTracks() async {
    final app = context.read<AppState>();
    if (app.apiClient == null) return;
    try {
      final sourceId = widget.playlist['source_id'] as String? ?? '';
      final data = await app.apiClient!.getStreamingPlaylistTracks(widget.service, sourceId);
      final tracks = data.map((t) => trackFromJson(t as Map<String, dynamic>)).toList();
      if (mounted) setState(() => _tracks = tracks);
    } catch (e) {
      debugPrint('Load streaming playlist tracks error: $e');
      if (mounted) setState(() => _tracks = []);
    }
  }

  @override
  Widget build(BuildContext context) {
    final app = context.read<AppState>();
    final name = widget.playlist['name'] as String? ?? '';
    final count = widget.playlist['track_count'] as int? ?? 0;

    return Scaffold(
      backgroundColor: TuneColors.background,
      appBar: AppBar(
        backgroundColor: TuneColors.surface,
        title: Text(name, style: TuneFonts.title3, maxLines: 1, overflow: TextOverflow.ellipsis),
      ),
      body: _tracks == null
          ? const Center(child: CircularProgressIndicator(color: TuneColors.accent))
          : _tracks!.isEmpty
              ? Center(child: Text('$count pistes', style: TuneFonts.body))
              : ListView.separated(
                  padding: const EdgeInsets.only(bottom: 80),
                  itemCount: _tracks!.length,
                  separatorBuilder: (_, __) => const Divider(height: 1, indent: 56, color: TuneColors.divider),
                  itemBuilder: (_, i) {
                    final t = _tracks![i];
                    return ListTile(
                      onTap: () {
                        if (t.sourceId != null) {
                          app.play(track: t);
                        }
                      },
                      leading: Text('${i + 1}', style: TuneFonts.footnote),
                      title: Text(t.title, style: TuneFonts.body, maxLines: 1, overflow: TextOverflow.ellipsis),
                      subtitle: t.artistName != null
                          ? Text(t.artistName!, style: TuneFonts.footnote, maxLines: 1, overflow: TextOverflow.ellipsis)
                          : null,
                      trailing: FormatBadge(format: t.format),
                    );
                  },
                ),
    );
  }
}
