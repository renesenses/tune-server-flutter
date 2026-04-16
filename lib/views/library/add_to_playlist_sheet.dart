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
// Présenté depuis le menu contextuel d'une piste dans AlbumDetailView /
// TracksListView.
// Miroir de AddToPlaylistSheet.swift (iOS)
// ---------------------------------------------------------------------------

class AddToPlaylistSheet extends StatefulWidget {
  final Track track;
  const AddToPlaylistSheet({super.key, required this.track});

  @override
  State<AddToPlaylistSheet> createState() => _AddToPlaylistSheetState();
}

class _AddToPlaylistSheetState extends State<AddToPlaylistSheet> {
  bool _adding = false;

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
                  Text(l.playlistAddTo, style: TuneFonts.title3),
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
                            : () async {
                                setState(() => _adding = true);
                                final messenger =
                                    ScaffoldMessenger.of(context);
                                final added = await app.addTrackToPlaylist(
                                    widget.track.id, playlists[i].id);
                                if (!mounted) return;
                                Navigator.of(context).pop();
                                messenger.showSnackBar(
                                  SnackBar(
                                    content: Text(added
                                        ? l.playlistTrackAdded(
                                            playlists[i].name)
                                        : l.playlistTrackAlreadyIn(
                                            playlists[i].name)),
                                    duration:
                                        const Duration(seconds: 2),
                                    backgroundColor: added
                                        ? TuneColors.accent
                                        : TuneColors.warning,
                                  ),
                                );
                              },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _createAndAdd(BuildContext context, AppState app) async {
    final name = await _askPlaylistName(context);
    if (name == null || name.isEmpty) return;
    setState(() => _adding = true);
    await app.createPlaylist(name);
    // Récupère la playlist créée (dernière de la liste)
    final playlists = context.read<LibraryState>().playlists;
    if (playlists.isNotEmpty) {
      final created = playlists.last;
      await app.addTrackToPlaylist(widget.track.id, created.id);
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
