import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/app_state.dart';
import '../../state/zone_state.dart';
import '../helpers/tune_colors.dart';

// ---------------------------------------------------------------------------
// T11.3 — VolumeControlView
// Slider de volume avec icônes mute/max.
// Lit le volume depuis ZoneState.currentZone, écrit via AppState.setVolume().
// Miroir de VolumeControlView.swift (iOS)
// ---------------------------------------------------------------------------

class VolumeControlView extends StatefulWidget {
  const VolumeControlView({super.key});

  @override
  State<VolumeControlView> createState() => _VolumeControlViewState();
}

class _VolumeControlViewState extends State<VolumeControlView> {
  double? _draggingVolume;

  @override
  Widget build(BuildContext context) {
    final zoneVolume =
        context.select<ZoneState, double>((z) => z.currentZone?.volume ?? 0.5);
    final displayVolume = _draggingVolume ?? zoneVolume;

    return Row(
      children: [
        const Icon(Icons.volume_mute_rounded,
            size: 20, color: TuneColors.textSecondary),
        const SizedBox(width: 4),
        Expanded(
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackShape: const _ThinTrackShape(),
              thumbShape:
                  const RoundSliderThumbShape(enabledThumbRadius: 6),
              overlayShape:
                  const RoundSliderOverlayShape(overlayRadius: 14),
            ),
            child: Slider(
              value: displayVolume.clamp(0.0, 1.0),
              onChanged: (v) => setState(() => _draggingVolume = v),
              onChangeEnd: (v) {
                setState(() => _draggingVolume = null);
                context.read<AppState>().setVolume(v);
              },
            ),
          ),
        ),
        const SizedBox(width: 4),
        const Icon(Icons.volume_up_rounded,
            size: 20, color: TuneColors.textSecondary),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Track shape fine
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
    final trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    return Rect.fromLTWH(
        offset.dx, trackTop, parentBox.size.width, trackHeight);
  }
}
