import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../server/database/database.dart';
import '../../state/app_state.dart';
import '../../state/zone_state.dart';
import '../helpers/tune_colors.dart';

// ---------------------------------------------------------------------------
// T11.2 — SeekBarView
// Slider de position avec labels durée gauche/droite.
// Gestion du drag : affiche la position draggée pendant le glissement,
// émet app.seek() au lâcher.
// Miroir de SeekBarView.swift (iOS)
// ---------------------------------------------------------------------------

class SeekBarView extends StatefulWidget {
  const SeekBarView({super.key});

  @override
  State<SeekBarView> createState() => _SeekBarViewState();
}

class _SeekBarViewState extends State<SeekBarView> {
  double? _draggingValue; // null = pas en cours de drag

  @override
  Widget build(BuildContext context) {
    final positionMs =
        context.select<ZoneState, int>((z) => z.positionMs);
    final track =
        context.select<ZoneState, dynamic>((z) => z.currentTrack) as Track?;
    final durationMs = track?.durationMs ?? 0;

    final sliderValue = _draggingValue ??
        (durationMs > 0 ? (positionMs / durationMs).clamp(0.0, 1.0) : 0.0);

    final posLabel = _formatMs(_draggingValue != null
        ? (_draggingValue! * durationMs).round()
        : positionMs);
    final durLabel = _formatMs(durationMs);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackShape: const _ThinTrackShape(),
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
          ),
          child: Slider(
            value: sliderValue,
            onChangeStart: (_) {},
            onChanged: (v) => setState(() => _draggingValue = v),
            onChangeEnd: (v) {
              setState(() => _draggingValue = null);
              if (durationMs > 0) {
                final seekMs = (v * durationMs).round();
                context
                    .read<AppState>()
                    .seek(Duration(milliseconds: seekMs));
              }
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(posLabel, style: _labelStyle),
              Text(durLabel, style: _labelStyle),
            ],
          ),
        ),
      ],
    );
  }

  static String _formatMs(int ms) {
    if (ms <= 0) return '0:00';
    final totalSeconds = ms ~/ 1000;
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  static const _labelStyle = TextStyle(
    fontSize: 12,
    color: TuneColors.textSecondary,
    fontFeatures: [FontFeature.tabularFigures()],
  );
}

// ---------------------------------------------------------------------------
// Track shape fine (3 dp)
// ---------------------------------------------------------------------------

class _ThinTrackShape extends RoundedRectSliderTrackShape {
  const _ThinTrackShape();

  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final trackHeight = sliderTheme.trackHeight ?? 3;
    final trackLeft = offset.dx;
    final trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
