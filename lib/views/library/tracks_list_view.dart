import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../server/database/database.dart';
import '../../state/app_state.dart';
import '../../state/library_state.dart';
import '../helpers/artwork_view.dart';
import '../helpers/tune_colors.dart';
import '../helpers/tune_fonts.dart';
import 'add_to_playlist_sheet.dart';
import 'albums_grid_view.dart';
import 'edit_track_sheet.dart';

// ---------------------------------------------------------------------------
// T12.4 — TracksListView
// Liste complète des pistes avec badge format audio (FLAC, MP3, AAC…).
// Chargement lazy à l'affichage via AppState.refreshTracks().
// Miroir de TracksView.swift (iOS)
// ---------------------------------------------------------------------------

class TracksListView extends StatefulWidget {
  const TracksListView({super.key});

  @override
  State<TracksListView> createState() => _TracksListViewState();
}

class _TracksListViewState extends State<TracksListView> {
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _ensureLoaded();
  }

  Future<void> _ensureLoaded() async {
    final lib = context.read<LibraryState>();
    if (lib.tracks.isEmpty) {
      await context.read<AppState>().refreshTracks();
    }
    if (mounted) setState(() => _loaded = true);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final tracks = context.watch<LibraryState>().tracks;

    if (!_loaded) {
      return const Center(child: CircularProgressIndicator());
    }
    if (tracks.isEmpty) {
      return LibraryEmptyState(
        icon: Icons.music_note_rounded,
        message: l.libraryEmptyTracks,
      );
    }

    return ListView.separated(
      itemCount: tracks.length,
      separatorBuilder: (_, __) =>
          const Divider(height: 1, indent: 72, color: TuneColors.divider),
      itemBuilder: (_, i) => _TrackTile(
        track: tracks[i],
        onTap: () =>
            context.read<AppState>().playTracks(tracks, startIndex: i),
        onEdit: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: TuneColors.surface,
          builder: (_) => EditTrackSheet(track: tracks[i]),
        ),
        onAddToPlaylist: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: TuneColors.surface,
          builder: (_) => AddToPlaylistSheet(track: tracks[i]),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _TrackTile
// ---------------------------------------------------------------------------

class _TrackTile extends StatelessWidget {
  final Track track;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onAddToPlaylist;

  const _TrackTile({
    required this.track,
    required this.onTap,
    required this.onEdit,
    required this.onAddToPlaylist,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: ArtworkView(
          filePath: track.coverPath, size: 44, cornerRadius: 4),
      title: Text(track.title,
          style: TuneFonts.body,
          maxLines: 1,
          overflow: TextOverflow.ellipsis),
      subtitle: _subtitle,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FormatBadge(format: track.format),
          IconButton(
            icon: const Icon(Icons.more_vert_rounded,
                size: 18, color: TuneColors.textTertiary),
            onPressed: () => _showMenu(context),
          ),
        ],
      ),
    );
  }

  Widget? get _subtitle {
    final parts = <String>[
      if (track.artistName != null) track.artistName!,
      if (track.albumTitle != null) track.albumTitle!,
    ];
    if (parts.isEmpty) return null;
    return Text(
      parts.join(' · '),
      style: TuneFonts.footnote,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  void _showMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: TuneColors.surface,
      builder: (_) => _TrackMenu(
        track: track,
        onEdit: onEdit,
        onAddToPlaylist: onAddToPlaylist,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Menu contextuel
// ---------------------------------------------------------------------------

class _TrackMenu extends StatelessWidget {
  final Track track;
  final VoidCallback onEdit;
  final VoidCallback onAddToPlaylist;

  const _TrackMenu({
    required this.track,
    required this.onEdit,
    required this.onAddToPlaylist,
  });

  @override
  Widget build(BuildContext context) {
    final app = context.read<AppState>();
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          ListTile(
            leading:
                const Icon(Icons.play_arrow_rounded, color: TuneColors.accent),
            title: Text(AppLocalizations.of(context).libraryPlay, style: TuneFonts.body),
            onTap: () {
              Navigator.pop(context);
              app.playTracks([track]);
            },
          ),
          ListTile(
            leading: const Icon(Icons.queue_rounded,
                color: TuneColors.textSecondary),
            title: Text(AppLocalizations.of(context).libraryPlayNext, style: TuneFonts.body),
            onTap: () {
              Navigator.pop(context);
              final zoneId = app.zoneState.currentZoneId;
              if (zoneId != null) {
                final inst = app.engine.zoneManager.zone(zoneId);
                inst?.queue.addNext(track);
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.playlist_add_rounded,
                color: TuneColors.textSecondary),
            title: Text(AppLocalizations.of(context).playlistAddTo, style: TuneFonts.body),
            onTap: () {
              Navigator.pop(context);
              onAddToPlaylist();
            },
          ),
          ListTile(
            leading: const Icon(Icons.edit_rounded,
                color: TuneColors.textSecondary),
            title: Text(AppLocalizations.of(context).libraryEditTrack, style: TuneFonts.body),
            onTap: () {
              Navigator.pop(context);
              onEdit();
            },
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
