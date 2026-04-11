import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart' hide RepeatMode;
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../models/enums.dart';
import '../../server/database/database.dart';
import '../../state/app_state.dart';
import '../../state/zone_state.dart';
import '../helpers/artwork_view.dart';
import '../helpers/skip_button.dart';
import '../helpers/tune_colors.dart';
import '../helpers/tune_fonts.dart';
import 'queue_view.dart';
import 'seek_bar_view.dart';
import 'volume_control_view.dart';
import 'zone_management_view.dart';

// ---------------------------------------------------------------------------
// T11.1 — NowPlayingView
// Vue plein écran : fond artwork flouté, pochette large, contrôles complets.
// Présentée en modal bottom sheet depuis MiniPlayerView ou iPadNowPlayingBar.
// Miroir de NowPlayingView.swift (iOS)
// ---------------------------------------------------------------------------

/// Ouvre NowPlayingView en modal plein écran.
void showNowPlaying(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    useSafeArea: false,
    builder: (_) => const NowPlayingView(),
  );
}

class NowPlayingView extends StatelessWidget {
  const NowPlayingView({super.key});

  @override
  Widget build(BuildContext context) {
    final track =
        context.select<ZoneState, dynamic>((z) => z.currentTrack) as Track?;

    return Stack(
      children: [
        // --- Fond : artwork flouté ---
        Positioned.fill(child: _BlurredBackground(track: track)),

        // --- Contenu ---
        SafeArea(
          child: Column(
            children: [
              _DismissHandle(context),
              Expanded(
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Column(
                      children: [
                        const SizedBox(height: 16),

                        // Pochette large
                        _LargeArtwork(track: track),
                        const SizedBox(height: 28),

                        // Titre + artiste + bouton options
                        _TrackInfo(track: track),
                        const SizedBox(height: 20),

                        // Seek bar
                        const SeekBarView(),
                        const SizedBox(height: 8),

                        // Contrôles transport
                        _TransportControls(),
                        const SizedBox(height: 20),

                        // Ligne secondaire : shuffle, repeat, queue, zones
                        _SecondaryControls(context),
                        const SizedBox(height: 24),

                        // Volume
                        const VolumeControlView(),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static Widget _DismissHandle(BuildContext ctx) => Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 4),
        child: GestureDetector(
          onTap: () => Navigator.of(ctx).pop(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 36, height: 4,
                decoration: BoxDecoration(
                  color: TuneColors.textTertiary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ),
      );

  static Widget _SecondaryControls(BuildContext ctx) {
    return Consumer2<ZoneState, AppState>(
      builder: (_, zone, app, __) {
        final shuffle = zone.shuffleEnabled;
        final repeat = zone.repeatMode;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Shuffle
            IconButton(
              icon: Icon(Icons.shuffle_rounded,
                  color: shuffle
                      ? TuneColors.accent
                      : TuneColors.textTertiary),
              onPressed: () =>
                  app.setShuffle(enabled: !shuffle),
            ),
            // Repeat
            IconButton(
              icon: Icon(
                repeat == RepeatMode.one
                    ? Icons.repeat_one_rounded
                    : Icons.repeat_rounded,
                color: repeat != RepeatMode.off
                    ? TuneColors.accent
                    : TuneColors.textTertiary,
              ),
              onPressed: () => app.cycleRepeat(),
            ),
            // Queue
            IconButton(
              icon: const Icon(Icons.queue_music_rounded,
                  color: TuneColors.textSecondary),
              onPressed: () => showModalBottomSheet(
                context: ctx,
                backgroundColor: TuneColors.surface,
                shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(16)),
                ),
                builder: (_) => const QueueView(),
              ),
            ),
            // Zones
            IconButton(
              icon: const Icon(Icons.speaker_group_rounded,
                  color: TuneColors.textSecondary),
              onPressed: () => showModalBottomSheet(
                context: ctx,
                backgroundColor: TuneColors.surface,
                shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(16)),
                ),
                builder: (_) => const ZoneManagementView(),
              ),
            ),
          ],
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Fond flouté
// ---------------------------------------------------------------------------

class _BlurredBackground extends StatelessWidget {
  final Track? track;

  const _BlurredBackground({required this.track});

  @override
  Widget build(BuildContext context) {
    final coverPath = track?.coverPath;
    final isHttp = coverPath != null && coverPath.startsWith('http');
    return Stack(
      fit: StackFit.expand,
      children: [
        // Couleur de base
        ColoredBox(color: TuneColors.background),
        // Image floue (si disponible)
        if (coverPath != null)
          ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
            child: isHttp
                ? Image.network(coverPath, fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const SizedBox.shrink())
                : Image.file(File(coverPath), fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const SizedBox.shrink()),
          ),
        // Overlay sombre
        ColoredBox(
            color: Colors.black.withValues(alpha: 0.65)),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Pochette large
// ---------------------------------------------------------------------------

class _LargeArtwork extends StatelessWidget {
  final Track? track;

  const _LargeArtwork({required this.track});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context).width - 56;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ArtworkView(
        filePath: track?.coverPath,
        size: size,
        cornerRadius: 12,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Infos piste
// ---------------------------------------------------------------------------

class _TrackInfo extends StatelessWidget {
  final Track? track;

  const _TrackInfo({required this.track});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                track?.title ?? AppLocalizations.of(context).nowPlayingNoTrack,
                style: TuneFonts.title2,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (track?.artistName != null) ...[
                const SizedBox(height: 4),
                Text(
                  track!.artistName!,
                  style: TuneFonts.subheadline,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Contrôles transport
// ---------------------------------------------------------------------------

class _TransportControls extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final app = context.read<AppState>();
    final state = context.select<ZoneState, PlaybackState>(
        (z) => z.playbackState);
    final isPlaying = state == PlaybackState.playing;
    final isBuffering = state == PlaybackState.buffering;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Précédent
        SkipButton(
          isForward: false,
          size: 36,
          color: TuneColors.textPrimary,
          onPressed: () => app.previous(),
        ),

        // Play / Pause
        Container(
          width: 72, height: 72,
          decoration: const BoxDecoration(
            color: TuneColors.textPrimary,
            shape: BoxShape.circle,
          ),
          child: isBuffering
              ? const Padding(
                  padding: EdgeInsets.all(22),
                  child: CircularProgressIndicator(
                      strokeWidth: 2.5, color: TuneColors.background),
                )
              : IconButton(
                  icon: Icon(isPlaying
                      ? Icons.pause_rounded
                      : Icons.play_arrow_rounded),
                  iconSize: 38,
                  color: TuneColors.background,
                  onPressed: isPlaying
                      ? () => app.pause()
                      : () => app.resume(),
                ),
        ),

        // Suivant
        SkipButton(
          isForward: true,
          size: 36,
          color: TuneColors.textPrimary,
          onPressed: () => app.next(),
        ),
      ],
    );
  }
}
