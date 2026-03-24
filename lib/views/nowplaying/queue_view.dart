import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../server/database/database.dart';
import '../../state/app_state.dart';
import '../../state/zone_state.dart';
import '../helpers/artwork_view.dart';
import '../helpers/tune_colors.dart';
import '../helpers/tune_fonts.dart';

// ---------------------------------------------------------------------------
// T11.4 — QueueView
// Liste de lecture réordonnable (drag) avec suppression par swipe.
// Piste courante mise en évidence.
// AppState.moveQueueItem / removeQueueItem (ajoutés en T11.4).
// Miroir de QueueView.swift (iOS)
// ---------------------------------------------------------------------------

class QueueView extends StatelessWidget {
  const QueueView({super.key});

  @override
  Widget build(BuildContext context) {
    final snapshot = context.watch<ZoneState>().queueSnapshot;
    final tracks = (snapshot?.tracks ?? []).cast<Track>();
    final currentPosition = snapshot?.position ?? -1;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Handle
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Container(
            width: 36, height: 4,
            decoration: BoxDecoration(
              color: TuneColors.textTertiary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        // Titre
        Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(
            children: [
              Text('File de lecture', style: TuneFonts.title3),
              const Spacer(),
              if (tracks.isNotEmpty)
                TextButton(
                  onPressed: () => context
                      .read<AppState>()
                      .setShuffle(enabled: true),
                  child: const Text('Mélanger',
                      style: TextStyle(color: TuneColors.accent)),
                ),
            ],
          ),
        ),
        const Divider(height: 1),
        // Liste
        Flexible(
          child: tracks.isEmpty
              ? const _EmptyQueue()
              : ReorderableListView.builder(
                  shrinkWrap: true,
                  itemCount: tracks.length,
                  onReorder: (oldIndex, newIndex) {
                    // ReorderableListView décale l'index si déplacement vers le bas
                    if (newIndex > oldIndex) newIndex--;
                    context
                        .read<AppState>()
                        .moveQueueItem(oldIndex, newIndex);
                  },
                  itemBuilder: (_, i) {
                    final track = tracks[i];
                    final isCurrent = i == currentPosition;
                    return _QueueItem(
                      key: ValueKey('q-$i-${track.id}'),
                      track: track,
                      index: i,
                      isCurrent: isCurrent,
                    );
                  },
                ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Item
// ---------------------------------------------------------------------------

class _QueueItem extends StatelessWidget {
  final Track track;
  final int index;
  final bool isCurrent;

  const _QueueItem({
    super.key,
    required this.track,
    required this.index,
    required this.isCurrent,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: key!,
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        color: TuneColors.error,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete_rounded, color: Colors.white),
      ),
      onDismissed: (_) =>
          context.read<AppState>().removeQueueItem(index),
      child: Container(
        color: isCurrent
            ? TuneColors.accent.withValues(alpha: 0.12)
            : Colors.transparent,
        child: ListTile(
          leading: ArtworkView(
            filePath: track.coverPath,
            size: 42,
            cornerRadius: 4,
          ),
          title: Text(
            track.title,
            style: TextStyle(
              color: isCurrent
                  ? TuneColors.accent
                  : TuneColors.textPrimary,
              fontWeight:
                  isCurrent ? FontWeight.w600 : FontWeight.normal,
              fontSize: 15,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: track.artistName != null
              ? Text(
                  track.artistName!,
                  style: TuneFonts.caption,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )
              : null,
          trailing: isCurrent
              ? const Icon(Icons.equalizer_rounded,
                  color: TuneColors.accent, size: 18)
              : ReorderableDragStartListener(
                  index: index,
                  child: const Icon(Icons.drag_handle_rounded,
                      color: TuneColors.textTertiary),
                ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// File vide
// ---------------------------------------------------------------------------

class _EmptyQueue extends StatelessWidget {
  const _EmptyQueue();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.queue_music_rounded,
              size: 40, color: TuneColors.textTertiary),
          SizedBox(height: 12),
          Text('File vide',
              style: TextStyle(color: TuneColors.textTertiary)),
        ],
      ),
    );
  }
}
