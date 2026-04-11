import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/enums.dart';
import '../../server/database/database.dart';
import '../../state/app_state.dart';
import '../../state/zone_state.dart';
import '../helpers/artwork_view.dart';
import '../helpers/skip_button.dart';
import '../helpers/tune_colors.dart';
import '../helpers/tune_fonts.dart';
import '../nowplaying/now_playing_view.dart';

// ---------------------------------------------------------------------------
// T10.6 — MiniPlayerView
// Barre transport compacte : pochette · titre/artiste · play/pause · next.
// Affichée seulement si une piste est chargée (ou en pause).
// Barre de progression fine en bas.
// Miroir de MiniPlayerView.swift (iOS)
// ---------------------------------------------------------------------------

class MiniPlayerView extends StatelessWidget {
  const MiniPlayerView({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.select<ZoneState, PlaybackState>(
        (z) => z.playbackState);
    final hasTrack = context.select<ZoneState, bool>(
        (z) => z.currentTrack != null);

    if (!hasTrack && state == PlaybackState.stopped) {
      return const SizedBox.shrink();
    }

    return Material(
      color: TuneColors.miniPlayerBg,
      elevation: 8,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Divider(height: 1),
          _MiniPlayerContent(),
          _ProgressBar(),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Contenu principal
// ---------------------------------------------------------------------------

class _MiniPlayerContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final app = context.read<AppState>();
    final zoneState = context.watch<ZoneState>();
    final track = zoneState.currentTrack as Track?;
    final state = zoneState.playbackState;
    final isPlaying = state == PlaybackState.playing;
    final isBuffering = state == PlaybackState.buffering;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => showNowPlaying(context),
      child: SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            // Pochette
            ArtworkView(
              filePath: track?.coverPath,
              size: 44,
              cornerRadius: 6,
            ),
            const SizedBox(width: 12),

            // Titre + artiste
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    track?.title ?? 'Aucune piste',
                    style: TuneFonts.miniTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (track?.artistName != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      track!.artistName!,
                      style: TuneFonts.miniArtist,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),

            // Bouton play/pause
            if (isBuffering)
              const SizedBox(
                width: 40,
                height: 40,
                child: Center(
                  child: SizedBox(
                    width: 22, height: 22,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: TuneColors.accent),
                  ),
                ),
              )
            else
              IconButton(
                icon: Icon(isPlaying
                    ? Icons.pause_rounded
                    : Icons.play_arrow_rounded),
                iconSize: 32,
                color: TuneColors.textPrimary,
                onPressed: isPlaying ? () => app.pause() : () => app.resume(),
              ),

            // Bouton suivant
            SkipButton(
              isForward: true,
              size: 20,
              color: TuneColors.textPrimary,
              onPressed: () => app.next(),
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Barre de progression
// ---------------------------------------------------------------------------

class _ProgressBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final positionMs =
        context.select<ZoneState, int>((z) => z.positionMs);
    final track = context.select<ZoneState, dynamic>((z) => z.currentTrack);
    final durationMs = (track as Track?)?.durationMs ?? 0;
    final progress =
        durationMs > 0 ? (positionMs / durationMs).clamp(0.0, 1.0) : 0.0;

    return LinearProgressIndicator(
      value: progress,
      minHeight: 2,
      backgroundColor: TuneColors.divider,
      valueColor:
          const AlwaysStoppedAnimation<Color>(TuneColors.accent),
    );
  }
}
