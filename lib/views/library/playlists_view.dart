import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../server/database/database.dart';
import '../../state/app_state.dart';
import '../../state/library_state.dart';
import '../helpers/tune_colors.dart';
import '../helpers/tune_fonts.dart';
import 'albums_grid_view.dart';

// ---------------------------------------------------------------------------
// T12.8 — PlaylistsView + PlaylistDetailView
// Liste des playlists, création, suppression, détail avec pistes draggables.
// Miroir de PlaylistsView.swift + PlaylistDetailView.swift (iOS)
// ---------------------------------------------------------------------------

class PlaylistsView extends StatelessWidget {
  const PlaylistsView({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final playlists = context.watch<LibraryState>().playlists;
    final app = context.read<AppState>();

    return Scaffold(
      backgroundColor: TuneColors.background,
      floatingActionButton: FloatingActionButton(
        backgroundColor: TuneColors.accent,
        child: const Icon(Icons.add_rounded),
        onPressed: () => _createPlaylist(context, app),
      ),
      body: playlists.isEmpty
          ? LibraryEmptyState(
              icon: Icons.queue_music_rounded,
              message: l.libraryEmptyPlaylists,
            )
          : ListView.separated(
              itemCount: playlists.length,
              separatorBuilder: (_, __) => const Divider(
                  height: 1, indent: 72, color: TuneColors.divider),
              itemBuilder: (_, i) => Dismissible(
                key: ValueKey(playlists[i].id),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  color: TuneColors.error,
                  child: const Icon(Icons.delete_rounded,
                      color: Colors.white),
                ),
                onDismissed: (_) => app.deletePlaylist(playlists[i].id),
                child: _PlaylistTile(playlist: playlists[i]),
              ),
            ),
    );
  }

  Future<void> _createPlaylist(
      BuildContext context, AppState app) async {
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
            content: TextField(
              controller: ctrl,
              autofocus: true,
              style: TuneFonts.body,
              decoration: InputDecoration(hintText: l.playlistName),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(l.btnCancel,
                    style: const TextStyle(color: TuneColors.textSecondary)),
              ),
              TextButton(
                onPressed: () =>
                    Navigator.of(context).pop(ctrl.text),
                child: Text(l.btnCreate,
                    style: const TextStyle(color: TuneColors.accent)),
              ),
            ],
          );
        },
      );
}

// ---------------------------------------------------------------------------
// _PlaylistTile
// ---------------------------------------------------------------------------

class _PlaylistTile extends StatelessWidget {
  final Playlist playlist;
  const _PlaylistTile({required this.playlist});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: TuneColors.accent.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.queue_music_rounded,
            color: TuneColors.accent, size: 22),
      ),
      title: Text(playlist.name,
          style: TuneFonts.body,
          maxLines: 1,
          overflow: TextOverflow.ellipsis),
      subtitle: Text(
        '${playlist.trackCount} piste${playlist.trackCount != 1 ? "s" : ""}',
        style: TuneFonts.footnote,
      ),
      trailing: const Icon(Icons.chevron_right_rounded,
          color: TuneColors.textTertiary),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
            builder: (_) => PlaylistDetailView(playlist: playlist)),
      ),
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
    final tracks = await app.engine.db.playlistRepo
        .tracks(widget.playlist.id);
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
        title: Text(pl.name,
            style: TuneFonts.title3,
            maxLines: 1,
            overflow: TextOverflow.ellipsis),
        actions: [
          if (_tracks != null && _tracks!.isNotEmpty)
            TextButton.icon(
              icon: const Icon(Icons.play_arrow_rounded,
                  color: TuneColors.accent),
              label: Text(AppLocalizations.of(context).libraryPlay,
                  style: const TextStyle(color: TuneColors.accent)),
              onPressed: () => app.playTracks(_tracks!),
            ),
        ],
      ),
      body: _tracks == null
          ? const Center(child: CircularProgressIndicator())
          : _tracks!.isEmpty
              ? const LibraryEmptyState(
                  icon: Icons.queue_music_rounded,
                  message: 'Playlist vide',
                )
              : ReorderableListView.builder(
                  padding: const EdgeInsets.only(bottom: 80),
                  itemCount: _tracks!.length,
                  onReorder: (from, to) async {
                    final realTo = to > from ? to - 1 : to;
                    setState(() {
                      final t = _tracks!.removeAt(from);
                      _tracks!.insert(realTo, t);
                    });
                    await app.engine.db.playlistRepo
                        .moveTrack(pl.id, from, realTo);
                  },
                  itemBuilder: (_, i) => _PlaylistTrackTile(
                    key: ValueKey(_tracks![i].id),
                    track: _tracks![i],
                    onTap: () => app.playTracks(_tracks!, startIndex: i),
                    onRemove: () async {
                      await app.removeTrackFromPlaylist(
                          _tracks![i].id, pl.id);
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

  const _PlaylistTrackTile({
    super.key,
    required this.track,
    required this.onTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey('dismiss_${track.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: TuneColors.error,
        child: const Icon(Icons.remove_circle_rounded,
            color: Colors.white),
      ),
      onDismissed: (_) => onRemove(),
      child: ListTile(
        onTap: onTap,
        leading: const Icon(Icons.drag_handle_rounded,
            color: TuneColors.textTertiary),
        title: Text(track.title,
            style: TuneFonts.body,
            maxLines: 1,
            overflow: TextOverflow.ellipsis),
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
    return Text(parts.join(' · '),
        style: TuneFonts.footnote,
        maxLines: 1,
        overflow: TextOverflow.ellipsis);
  }
}
