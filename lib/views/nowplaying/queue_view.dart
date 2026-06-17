import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../server/database/database.dart';
import '../../state/app_state.dart';
import '../../state/settings_state.dart';
import '../../state/zone_state.dart';
import '../../widgets/metadata_chips.dart';
import '../helpers/artwork_view.dart';
import '../helpers/tune_colors.dart';
import '../helpers/tune_fonts.dart';
import '../library/add_to_playlist_sheet.dart';
import '../streaming/streaming_helpers.dart';
import 'smart_autoplay_sheet.dart';

// ---------------------------------------------------------------------------
// T11.4 — QueueView
// Liste de lecture réordonnable (drag) avec suppression par swipe.
// Piste courante mise en évidence.
// AppState.moveQueueItem / removeQueueItem (ajoutés en T11.4).
// Miroir de QueueView.swift (iOS)
// ---------------------------------------------------------------------------

class QueueView extends StatelessWidget {
  const QueueView({super.key});

  void _showClearConfirm(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppLocalizations.of(context).queueClearTitle),
        content: Text(AppLocalizations.of(context).queueClearBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(AppLocalizations.of(context).btnCancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<AppState>().clearQueue();
            },
            child: Text(AppLocalizations.of(context).btnClear,
                style: const TextStyle(color: TuneColors.error)),
          ),
        ],
      ),
    );
  }

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
              Text(AppLocalizations.of(context).queueTitle, style: TuneFonts.title3),
              const Spacer(),
              // Smart AutoPlay — always visible
              IconButton(
                icon: const Icon(Icons.auto_awesome_rounded,
                    color: TuneColors.textSecondary, size: 22),
                tooltip: 'Smart AutoPlay',
                onPressed: () => showSmartAutoPlaySheet(context),
              ),
              if (tracks.isNotEmpty) ...[
                TextButton(
                  onPressed: () => _showClearConfirm(context),
                  child: Text(AppLocalizations.of(context).btnClear,
                      style: const TextStyle(color: TuneColors.error)),
                ),
                TextButton(
                  onPressed: () => context
                      .read<AppState>()
                      .setShuffle(enabled: true),
                  child: Text(AppLocalizations.of(context).btnShuffle,
                      style: const TextStyle(color: TuneColors.accent)),
                ),
              ],
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
                    final gaplessIndices = context.read<ZoneState>().gaplessIndices;
                    final isGapless = gaplessIndices.contains(i);
                    return _QueueItem(
                      key: ValueKey('q-$i-${track.id}'),
                      track: track,
                      index: i,
                      isCurrent: isCurrent,
                      showGaplessIndicator: isGapless,
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
  final bool showGaplessIndicator;

  const _QueueItem({
    super.key,
    required this.track,
    required this.index,
    required this.isCurrent,
    this.showGaplessIndicator = false,
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            color: isCurrent
                ? TuneColors.accent.withValues(alpha: 0.12)
                : Colors.transparent,
            child: ListTile(
              onTap: isCurrent
                  ? null
                  : () => context
                      .read<AppState>()
                      .jumpToQueuePosition(index),
              onLongPress: track.id != 0
                  ? () => _showQueueItemMenu(context, track)
                  : null,
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
              subtitle: _buildSubtitle(context, track),
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
          // Gapless indicator — chain icon between gapless tracks
          if (showGaplessIndicator)
            Container(
              height: 20,
              alignment: Alignment.center,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(width: 20, height: 1, color: TuneColors.accent.withValues(alpha: 0.4)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Icon(Icons.link_rounded, size: 14, color: TuneColors.accent.withValues(alpha: 0.7)),
                  ),
                  Container(width: 20, height: 1, color: TuneColors.accent.withValues(alpha: 0.4)),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget? _buildSubtitle(BuildContext context, Track track) {
    final metadataFields =
        context.read<SettingsState>().metadataDisplayFields;
    final hasArtist = track.artistName != null;
    final hasBadge = ServiceBadge.isStreaming(track.source);
    final hasChips = metadataFields.isNotEmpty;
    if (!hasArtist && !hasBadge && !hasChips) return null;

    // When chips are disabled, fall back to the simple single-line layout.
    if (!hasChips) {
      if (!hasArtist && !hasBadge) return null;
      return Row(
        children: [
          if (hasArtist)
            Flexible(
              child: Text(
                track.artistName!,
                style: TuneFonts.caption,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          if (hasBadge) ...[
            if (hasArtist) const SizedBox(width: 6),
            ServiceBadge(source: track.source, compact: true),
          ],
        ],
      );
    }

    // Chips enabled: artist + badge on first line, chips on second line.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (hasArtist || hasBadge)
          Row(
            children: [
              if (hasArtist)
                Flexible(
                  child: Text(
                    track.artistName!,
                    style: TuneFonts.caption,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              if (hasBadge) ...[
                if (hasArtist) const SizedBox(width: 6),
                ServiceBadge(source: track.source, compact: true),
              ],
            ],
          ),
        MetadataChips(track: track, selectedFields: metadataFields),
      ],
    );
  }

  void _showQueueItemMenu(BuildContext context, Track track) {
    final l = AppLocalizations.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: TuneColors.surface,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.playlist_add_rounded,
                  color: TuneColors.accent),
              title: Text(l.playlistAddTo, style: TuneFonts.body),
              onTap: () {
                Navigator.pop(ctx);
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: TuneColors.surface,
                  builder: (_) => AddToPlaylistSheet(track: track),
                );
              },
            ),
            const SizedBox(height: 8),
          ],
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.queue_music_rounded,
              size: 40, color: TuneColors.textTertiary),
          const SizedBox(height: 12),
          Text(AppLocalizations.of(context).queueEmpty,
              style: const TextStyle(color: TuneColors.textTertiary)),
        ],
      ),
    );
  }
}
