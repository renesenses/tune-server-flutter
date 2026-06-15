import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../server/database/database.dart';
import '../../state/app_state.dart';
import '../../state/library_state.dart';
import '../helpers/tune_colors.dart';
import '../helpers/tune_fonts.dart';

// ---------------------------------------------------------------------------
// T12.8 — AddToPlaylistSheet
// Bottom sheet : liste des playlists existantes (tap = ajout) + créer nouvelle.
// Supports both single track and batch (multiple tracks) mode.
// Presented from track context menu, album view, now playing, queue.
// Miroir de AddToPlaylistSheet.swift (iOS) + AddToPlaylistModal.svelte (Web)
// ---------------------------------------------------------------------------

class AddToPlaylistSheet extends StatefulWidget {
  /// Single track mode — mutually exclusive with [trackIds].
  final Track? track;

  /// Batch mode — list of track IDs to add.
  final List<int>? trackIds;

  const AddToPlaylistSheet({super.key, this.track, this.trackIds})
      : assert(track != null || (trackIds != null && trackIds.length > 0),
            'Provide either track or trackIds');

  /// Convenience constructor for a single track.
  const AddToPlaylistSheet.single({super.key, required this.track})
      : trackIds = null;

  /// Convenience constructor for multiple tracks.
  const AddToPlaylistSheet.batch({super.key, required this.trackIds})
      : track = null;

  @override
  State<AddToPlaylistSheet> createState() => _AddToPlaylistSheetState();
}

class _AddToPlaylistSheetState extends State<AddToPlaylistSheet> {
  bool _adding = false;

  /// Effective list of track IDs to add.
  List<int> get _effectiveTrackIds {
    if (widget.trackIds != null) return widget.trackIds!;
    if (widget.track != null) return [widget.track!.id];
    return [];
  }

  bool get _isBatch => _effectiveTrackIds.length > 1;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final playlists = context.watch<LibraryState>().playlists;
    final app = context.read<AppState>();

    return Padding(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom),
      child: DraggableScrollableSheet(
        initialChildSize: 0.5,
        minChildSize: 0.3,
        maxChildSize: 0.85,
        expand: false,
        builder: (_, scrollCtrl) => Column(
          children: [
            // Handle
            const SizedBox(height: 12),
            Center(
              child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: TuneColors.textTertiary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l.playlistAddTo, style: TuneFonts.title3),
                        if (_isBatch)
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Text(
                              '${_effectiveTrackIds.length} piste${_effectiveTrackIds.length != 1 ? "s" : ""}',
                              style: TuneFonts.caption.copyWith(
                                  color: TuneColors.textSecondary),
                            ),
                          ),
                      ],
                    ),
                  ),
                  TextButton.icon(
                    icon: const Icon(Icons.add_rounded,
                        color: TuneColors.accent),
                    label: Text(l.playlistNewPlaylist,
                        style: const TextStyle(color: TuneColors.accent)),
                    onPressed: _adding
                        ? null
                        : () => _createAndAdd(context, app),
                  ),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: playlists.isEmpty
                  ? Center(
                      child: Text(l.libraryEmptyPlaylists,
                          style: TuneFonts.subheadline),
                    )
                  : ListView.builder(
                      controller: scrollCtrl,
                      itemCount: playlists.length,
                      itemBuilder: (_, i) => ListTile(
                        leading: const Icon(Icons.queue_music_rounded,
                            color: TuneColors.accent),
                        title: Text(playlists[i].name, style: TuneFonts.body),
                        subtitle: Text(
                          '${playlists[i].trackCount} piste${playlists[i].trackCount != 1 ? "s" : ""}',
                          style: TuneFonts.footnote,
                        ),
                        onTap: _adding
                            ? null
                            : () => _addToExisting(
                                context, app, playlists[i]),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addToExisting(
      BuildContext context, AppState app, Playlist playlist) async {
    setState(() => _adding = true);
    final messenger = ScaffoldMessenger.of(context);
    final l = AppLocalizations.of(context);

    if (_isBatch) {
      // Batch mode
      final count =
          await app.addTracksToPlaylist(_effectiveTrackIds, playlist.id);
      if (!mounted) return;
      Navigator.of(context).pop();
      messenger.showSnackBar(
        SnackBar(
          content: Text(l.playlistTracksAdded(count, playlist.name)),
          duration: const Duration(seconds: 2),
          backgroundColor: count > 0 ? TuneColors.accent : TuneColors.warning,
        ),
      );
    } else {
      // Single track mode
      final added =
          await app.addTrackToPlaylist(_effectiveTrackIds.first, playlist.id);
      if (!mounted) return;
      Navigator.of(context).pop();
      messenger.showSnackBar(
        SnackBar(
          content: Text(added
              ? l.playlistTrackAdded(playlist.name)
              : l.playlistTrackAlreadyIn(playlist.name)),
          duration: const Duration(seconds: 2),
          backgroundColor: added ? TuneColors.accent : TuneColors.warning,
        ),
      );
    }
  }

  Future<void> _createAndAdd(BuildContext context, AppState app) async {
    final name = await _askPlaylistName(context);
    if (name == null || name.isEmpty) return;
    setState(() => _adding = true);
    await app.createPlaylist(name);
    // Fetch the newly created playlist (last in the list)
    final playlists = context.read<LibraryState>().playlists;
    if (playlists.isNotEmpty) {
      final created = playlists.last;
      if (_isBatch) {
        await app.addTracksToPlaylist(_effectiveTrackIds, created.id);
      } else {
        await app.addTrackToPlaylist(_effectiveTrackIds.first, created.id);
      }
    }
    if (mounted) Navigator.of(context).pop();
  }

  Future<String?> _askPlaylistName(BuildContext context) async {
    final l = AppLocalizations.of(context);
    final ctrl = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
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
            onPressed: () => Navigator.of(context).pop(ctrl.text),
            child: Text(l.btnCreate,
                style: const TextStyle(color: TuneColors.accent)),
          ),
        ],
      ),
    );
  }
}
