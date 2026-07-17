import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/enums.dart';
import '../../models/domain_models.dart';
import '../../server/database/database.dart';
import '../../state/app_state.dart';
import '../../state/zone_state.dart';
import '../helpers/artwork_view.dart';
import '../helpers/skip_button.dart';
import '../helpers/tune_colors.dart';
import '../helpers/tune_fonts.dart';
import '../nowplaying/now_playing_view.dart';
import '../nowplaying/volume_control_view.dart';
import '../streaming/streaming_helpers.dart';

// ---------------------------------------------------------------------------
// T10.6 — MiniPlayerView
// Barre transport compacte : pochette · titre/artiste · play/pause · next.
// Affichée seulement si une piste est chargée (ou en pause).
// Barre de progression fine en bas.
// Miroir de MiniPlayerView.swift (iOS)
// ---------------------------------------------------------------------------

class MiniPlayerView extends StatefulWidget {
  const MiniPlayerView({super.key});

  @override
  State<MiniPlayerView> createState() => _MiniPlayerViewState();
}

class _MiniPlayerViewState extends State<MiniPlayerView> {
  bool _expanded = false;

  void _toggle() => setState(() => _expanded = !_expanded);

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
      // Swipe up on the bar to reveal zone + volume + follow-me; swipe down to
      // collapse. The grab handle also toggles on tap.
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onVerticalDragEnd: (details) {
          final v = details.primaryVelocity ?? 0;
          if (v < -80 && !_expanded) {
            setState(() => _expanded = true);
          } else if (v > 80 && _expanded) {
            setState(() => _expanded = false);
          }
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Divider(height: 1),
            _GrabHandle(expanded: _expanded, onTap: _toggle),
            _MiniPlayerContent(),
            AnimatedSize(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOut,
              child: _expanded
                  ? const _ExpandedControls()
                  : const SizedBox(width: double.infinity),
            ),
            _ProgressBar(),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Poignée d'expansion (tap ou swipe)
// ---------------------------------------------------------------------------

class _GrabHandle extends StatelessWidget {
  final bool expanded;
  final VoidCallback onTap;
  const _GrabHandle({required this.expanded, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: double.infinity,
        alignment: Alignment.center,
        padding: const EdgeInsets.only(top: 4, bottom: 2),
        child: Container(
          width: 34,
          height: 4,
          decoration: BoxDecoration(
            color: TuneColors.textTertiary.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Rangée étendue : sélecteur de zone · volume · follow-me
// ---------------------------------------------------------------------------

class _ExpandedControls extends StatelessWidget {
  const _ExpandedControls();

  @override
  Widget build(BuildContext context) {
    final app = context.read<AppState>();
    final zoneState = context.watch<ZoneState>();
    final zones = zoneState.zones;
    final currentId = zoneState.currentZoneId;
    final current = zoneState.currentZone;

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 8, 8),
      child: Row(
        children: [
          // Sélecteur de zone → change la zone contrôlée
          InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () => _pickZone(
              context,
              zones,
              currentId,
              title: 'Changer de zone',
              onPick: (id) => app.selectZone(id),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.speaker_group_rounded,
                      size: 18, color: TuneColors.textSecondary),
                  const SizedBox(width: 4),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 90),
                    child: Text(
                      current?.name ?? 'Zone',
                      style: TuneFonts.footnote,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Icon(Icons.arrow_drop_down_rounded,
                      size: 18, color: TuneColors.textSecondary),
                ],
              ),
            ),
          ),
          const SizedBox(width: 4),
          // Volume de la zone active
          const Expanded(child: VolumeControlView()),
          // Follow me → transfère la lecture vers une zone choisie
          IconButton(
            icon: const Icon(Icons.move_up_rounded),
            iconSize: 20,
            color: TuneColors.textSecondary,
            tooltip: 'Follow me',
            onPressed: () => _pickZone(
              context,
              zones.where((z) => z.id != currentId).toList(),
              null,
              title: 'Amener la lecture vers…',
              onPick: (id) => app.followMeTo(id),
            ),
          ),
        ],
      ),
    );
  }

  void _pickZone(
    BuildContext context,
    List<ZoneWithState> zones,
    int? currentId, {
    required String title,
    required void Function(int) onPick,
  }) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: TuneColors.surface,
      builder: (sheetCtx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(title, style: TuneFonts.body),
              ),
            ),
            if (zones.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text('Aucune autre zone', style: TuneFonts.footnote),
              ),
            for (final z in zones)
              ListTile(
                leading: Icon(
                  z.id == currentId
                      ? Icons.check_circle_rounded
                      : Icons.speaker_rounded,
                  color: z.id == currentId
                      ? TuneColors.accent
                      : TuneColors.textSecondary,
                ),
                title: Text(z.name, style: TuneFonts.body),
                onTap: () {
                  Navigator.pop(sheetCtx);
                  onPick(z.id);
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
// Contenu principal
// ---------------------------------------------------------------------------

class _MiniPlayerContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final app = context.read<AppState>();
    final zoneState = context.watch<ZoneState>();
    final track = zoneState.currentTrack;
    final state = zoneState.playbackState;
    final isPlaying = state == PlaybackState.playing;
    final isBuffering = state == PlaybackState.buffering;

    return Semantics(
      label: 'Now playing',
      child: GestureDetector(
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

            // Titre + artiste + quality badge
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
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            track!.artistName!,
                            style: TuneFonts.miniArtist,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (ServiceBadge.isStreaming(track.source)) ...[
                          const SizedBox(width: 6),
                          ServiceBadge(source: track.source, compact: true),
                        ],
                        if (_hasAudioInfo(track)) ...[
                          const SizedBox(width: 6),
                          _MiniAudioBadge(track: track),
                        ],
                      ],
                    ),
                  ],
                ],
              ),
            ),

            // Bouton coeur
            IconButton(
              icon: const Icon(Icons.favorite_border_rounded),
              iconSize: 20,
              color: TuneColors.textTertiary,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              tooltip: 'Favorite',
              onPressed: () {
                if (track != null && track.source == Source.radio.rawValue) {
                  final radios = app.libraryState.radios;
                  final radio = radios.cast<dynamic>().where(
                    (r) => track.sourceId == r.id.toString(),
                  ).firstOrNull;
                  if (radio != null) {
                    app.saveRadioFavorite(
                      title: track.title, artist: track.artistName, radio: radio,
                    );
                  }
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Ajouté aux favoris'), duration: Duration(seconds: 1)),
                );
              },
            ),

            // Bouton précédent
            SkipButton(
              isForward: false,
              size: 20,
              color: TuneColors.textPrimary,
              onPressed: () => app.previous(),
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
                tooltip: isPlaying ? 'Pause' : 'Play',
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

// ---------------------------------------------------------------------------
// Audio quality badge helpers (shared between MiniPlayer and iPad bar)
// ---------------------------------------------------------------------------

bool _hasAudioInfo(Track? track) {
  if (track == null) return false;
  return (track.format != null && track.format!.isNotEmpty) ||
      (track.sampleRate != null && track.sampleRate! > 0) ||
      (track.bitDepth != null && track.bitDepth! > 0);
}

String _formatShortBadge(Track track) {
  final format = track.format;
  final sampleRate = track.sampleRate;
  final bitDepth = track.bitDepth;

  // Short badge: "FLAC 96/24" or "FLAC" or "96/24"
  final parts = <String>[];
  if (format != null && format.isNotEmpty) {
    parts.add(format.toUpperCase());
  }
  if (sampleRate != null && sampleRate > 0 && bitDepth != null && bitDepth > 0) {
    final kHz = sampleRate / 1000.0;
    final kHzStr = kHz == kHz.truncateToDouble()
        ? '${kHz.toInt()}'
        : kHz.toStringAsFixed(1);
    parts.add('$kHzStr/$bitDepth');
  }
  return parts.join(' ');
}

class _MiniAudioBadge extends StatelessWidget {
  final Track track;
  const _MiniAudioBadge({required this.track});

  @override
  Widget build(BuildContext context) {
    final badge = _formatShortBadge(track);
    if (badge.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
      decoration: BoxDecoration(
        color: TuneColors.accent.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        badge,
        style: const TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w600,
          color: TuneColors.accent,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}
