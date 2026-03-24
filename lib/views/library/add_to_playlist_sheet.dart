import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
                  const Text('Ajouter à une playlist',
                      style: TuneFonts.title3),
                  TextButton.icon(
                    icon: const Icon(Icons.add_rounded,
                        color: TuneColors.accent),
                    label: const Text('Nouvelle',
                        style: TextStyle(color: TuneColors.accent)),
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
                  ? const Center(
                      child: Text('Aucune playlist',
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
                                await app.addTrackToPlaylist(
                                    widget.track.id, playlists[i].id);
                                if (mounted) Navigator.of(context).pop();
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
    final ctrl = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: TuneColors.surface,
        title: const Text('Nouvelle playlist', style: TuneFonts.title3),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          style: TuneFonts.body,
          decoration: const InputDecoration(hintText: 'Nom de la playlist'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler',
                style: TextStyle(color: TuneColors.textSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(ctrl.text),
            child: const Text('Créer',
                style: TextStyle(color: TuneColors.accent)),
          ),
        ],
      ),
    );
  }
}
