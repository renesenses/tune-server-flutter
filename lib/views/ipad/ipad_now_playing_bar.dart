import 'package:flutter/material.dart' hide RepeatMode;
import 'package:provider/provider.dart';

import '../../models/enums.dart';
import '../../server/database/database.dart';
import '../../state/app_state.dart';
import '../../state/zone_state.dart';
import '../helpers/artwork_view.dart';
import '../helpers/tune_colors.dart';
import '../helpers/tune_fonts.dart';
import '../nowplaying/now_playing_view.dart';

// ---------------------------------------------------------------------------
// T11.6 — iPadNowPlayingBar
// Barre persistante en bas de la sidebar iPad.
// Affiche pochette · titre/artiste · seek inline · contrôles complets.
// Remplace MiniPlayerView dans iPadContentView.
// Miroir de iPadNowPlayingBar.swift (iOS)
// ---------------------------------------------------------------------------

class iPadNowPlayingBar extends StatelessWidget {
  const iPadNowPlayingBar({super.key});

  @override
  Widget build(BuildContext context) {
    final hasTrack = context.select<ZoneState, bool>(
        (z) => z.currentTrack != null);
    final state = context.select<ZoneState, PlaybackState>(
        (z) => z.playbackState);

    if (!hasTrack && state == PlaybackState.stopped) {
      return const SizedBox.shrink();
    }

    return Material(
      color: TuneColors.surface,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Divider(height: 1),
          _ProgressBar(),
          _TrackRow(),
          _ControlRow(),
          _SeekInline(),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Barre de progression (fine, non interactive — accès via tap)
// ---------------------------------------------------------------------------

class _ProgressBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final positionMs =
        context.select<ZoneState, int>((z) => z.positionMs);
    final track =
        context.select<ZoneState, dynamic>((z) => z.currentTrack) as Track?;
    final durationMs = track?.durationMs ?? 0;
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

// ---------------------------------------------------------------------------
// Ligne pochette + titre — tap pour ouvrir NowPlayingView
// ---------------------------------------------------------------------------

class _TrackRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final track =
        context.select<ZoneState, dynamic>((z) => z.currentTrack) as Track?;

    return GestureDetector(
      onTap: () => showNowPlaying(context),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
        child: Row(
          children: [
            ArtworkView(filePath: track?.coverPath, size: 40, cornerRadius: 6),
            const SizedBox(width: 10),
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
                  if (track?.artistName != null)
                    Text(
                      track!.artistName!,
                      style: TuneFonts.miniArtist,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Ligne de contrôles : prev · play/pause · next · shuffle · repeat
// ---------------------------------------------------------------------------

class _ControlRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final app = context.read<AppState>();
    final state = context.select<ZoneState, PlaybackState>(
        (z) => z.playbackState);
    final shuffle = context.select<ZoneState, bool>(
        (z) => z.shuffleEnabled);
    final repeat = context.select<ZoneState, RepeatMode>(
        (z) => z.repeatMode);
    final isPlaying = state == PlaybackState.playing;
    final isBuffering = state == PlaybackState.buffering;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Shuffle
        IconButton(
          icon: Icon(Icons.shuffle_rounded,
              size: 18,
              color: shuffle
                  ? TuneColors.accent
                  : TuneColors.textTertiary),
          onPressed: () => app.setShuffle(enabled: !shuffle),
        ),
        // Précédent
        IconButton(
          icon: const Icon(Icons.skip_previous_rounded, size: 26),
          color: TuneColors.textPrimary,
          onPressed: () => app.previous(),
        ),
        // Play/Pause
        SizedBox(
          width: 40, height: 40,
          child: isBuffering
              ? const Padding(
                  padding: EdgeInsets.all(10),
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: TuneColors.accent),
                )
              : IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    isPlaying
                        ? Icons.pause_circle_filled_rounded
                        : Icons.play_circle_filled_rounded,
                    size: 38,
                  ),
                  color: TuneColors.textPrimary,
                  onPressed: isPlaying
                      ? () => app.pause()
                      : () => app.resume(),
                ),
        ),
        // Suivant
        IconButton(
          icon: const Icon(Icons.skip_next_rounded, size: 26),
          color: TuneColors.textPrimary,
          onPressed: () => app.next(),
        ),
        // Repeat
        IconButton(
          icon: Icon(
            repeat == RepeatMode.one
                ? Icons.repeat_one_rounded
                : Icons.repeat_rounded,
            size: 18,
            color: repeat != RepeatMode.off
                ? TuneColors.accent
                : TuneColors.textTertiary,
          ),
          onPressed: () => app.cycleRepeat(),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Seek inline (compact)
// ---------------------------------------------------------------------------

class _SeekInline extends StatefulWidget {
  @override
  State<_SeekInline> createState() => _SeekInlineState();
}

class _SeekInlineState extends State<_SeekInline> {
  double? _drag;

  @override
  Widget build(BuildContext context) {
    final posMs = context.select<ZoneState, int>((z) => z.positionMs);
    final track =
        context.select<ZoneState, dynamic>((z) => z.currentTrack) as Track?;
    final durMs = track?.durationMs ?? 0;
    final value =
        _drag ?? (durMs > 0 ? (posMs / durMs).clamp(0.0, 1.0) : 0.0);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: SliderTheme(
        data: SliderTheme.of(context).copyWith(
          trackHeight: 2,
          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5),
          overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
        ),
        child: Slider(
          value: value,
          onChanged: (v) => setState(() => _drag = v),
          onChangeEnd: (v) {
            setState(() => _drag = null);
            if (durMs > 0) {
              context
                  .read<AppState>()
                  .seek(Duration(milliseconds: (v * durMs).round()));
            }
          },
        ),
      ),
    );
  }
}
