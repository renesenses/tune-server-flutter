import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/app_state.dart';
import '../../state/zone_state.dart';
import '../helpers/tune_colors.dart';
import '../helpers/tune_fonts.dart';

// ---------------------------------------------------------------------------
// T11.3 — VolumeControlView
// Slider de volume avec icône dynamique, mute toggle et pourcentage.
// Miroir de VolumeControlView.swift (iOS)
// ---------------------------------------------------------------------------

class VolumeControlView extends StatefulWidget {
  const VolumeControlView({super.key});

  @override
  State<VolumeControlView> createState() => _VolumeControlViewState();
}

class _VolumeControlViewState extends State<VolumeControlView> {
  double? _draggingVolume;
  Timer? _debounce;
  double? _mutedVolume; // volume avant mute

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  IconData _volumeIcon(double volume) {
    if (volume <= 0) return Icons.volume_off_rounded;
    if (volume < 0.33) return Icons.volume_mute_rounded;
    if (volume < 0.66) return Icons.volume_down_rounded;
    return Icons.volume_up_rounded;
  }

  void _onVolumeChanged(double v) {
    setState(() => _draggingVolume = v);
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      context.read<AppState>().setVolume(v);
    });
  }

  void _onVolumeChangeEnd(double v) {
    _debounce?.cancel();
    setState(() => _draggingVolume = null);
    context.read<AppState>().setVolume(v);
  }

  void _toggleMute() {
    final app = context.read<AppState>();
    final zone = context.read<ZoneState>();
    final current = zone.currentZone?.volume ?? 0.5;

    if (current > 0) {
      _mutedVolume = current;
      app.setVolume(0);
    } else {
      app.setVolume(_mutedVolume ?? 0.5);
      _mutedVolume = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final zoneVolume =
        context.select<ZoneState, double>((z) => z.currentZone?.volume ?? 0.5);
    final displayVolume = _draggingVolume ?? zoneVolume;
    final pct = (displayVolume * 100).round();

    return Row(
      children: [
        // Mute toggle
        GestureDetector(
          onTap: _toggleMute,
          child: Icon(_volumeIcon(displayVolume),
              size: 22, color: TuneColors.textSecondary),
        ),
        const SizedBox(width: 6),
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
              onChanged: _onVolumeChanged,
              onChangeEnd: _onVolumeChangeEnd,
            ),
          ),
        ),
        const SizedBox(width: 6),
        // Pourcentage
        SizedBox(
          width: 36,
          child: Text(
            '$pct%',
            style: TuneFonts.caption.copyWith(
              color: TuneColors.textSecondary,
              fontFeatures: [const FontFeature.tabularFigures()],
            ),
            textAlign: TextAlign.right,
          ),
        ),
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
