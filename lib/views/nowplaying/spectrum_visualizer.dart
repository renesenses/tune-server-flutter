import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/app_state.dart';
import '../helpers/tune_colors.dart';

// ---------------------------------------------------------------------------
// SpectrumVisualizer — FFT bar visualizer for NowPlayingView
// Listens to WebSocket `audio.spectrum` events from the server.
// Payload: {"bins": [0.0..1.0, ...]} — 16-32 float values.
// Renders 16 animated vertical bars with accent gradient.
// ---------------------------------------------------------------------------

class SpectrumVisualizer extends StatefulWidget {
  /// Height of the visualizer area.
  final double height;

  /// Number of bars to render (sampled/interpolated from incoming bins).
  final int barCount;

  const SpectrumVisualizer({
    super.key,
    this.height = 60,
    this.barCount = 16,
  });

  @override
  State<SpectrumVisualizer> createState() => _SpectrumVisualizerState();
}

class _SpectrumVisualizerState extends State<SpectrumVisualizer>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  StreamSubscription<Map<String, dynamic>>? _wsSub;

  /// Current target bar heights (0.0–1.0).
  late List<double> _targets;

  /// Smoothed bar heights rendered each frame.
  late List<double> _current;

  // Smoothing factor: how fast bars move toward the target each tick.
  // Higher = snappier, lower = smoother.
  static const double _rise = 0.35;
  static const double _fall = 0.18;

  @override
  void initState() {
    super.initState();
    _targets = List.filled(widget.barCount, 0.0);
    _current = List.filled(widget.barCount, 0.0);

    // 60 fps ticker drives interpolation between received FFT frames.
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();

    _animController.addListener(_onTick);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _subscribeToWs();
  }

  void _subscribeToWs() {
    _wsSub?.cancel();
    final stream = context.read<AppState>().wsEventStream;
    if (stream == null) return;
    _wsSub = stream.listen(_handleEvent);
  }

  void _handleEvent(Map<String, dynamic> event) {
    final type = event['type'] as String? ?? '';
    if (type != 'audio.spectrum') return;

    final data = event['data'] as Map<String, dynamic>?;
    final bins = (data?['bins'] as List?)?.cast<num>();
    if (bins == null || bins.isEmpty) return;

    // Sample/downsample bins to barCount.
    final n = widget.barCount;
    final srcLen = bins.length;
    final newTargets = List<double>.generate(n, (i) {
      // Map bar index → fractional bin index.
      final srcIdx = (i * srcLen / n).floor().clamp(0, srcLen - 1);
      return (bins[srcIdx].toDouble()).clamp(0.0, 1.0);
    });

    if (!mounted) return;
    setState(() {
      _targets = newTargets;
    });
  }

  void _onTick() {
    if (!mounted) return;
    bool changed = false;
    for (int i = 0; i < widget.barCount; i++) {
      final t = _targets[i];
      final c = _current[i];
      final factor = t > c ? _rise : _fall;
      final next = c + (t - c) * factor;
      if ((next - c).abs() > 0.001) {
        _current[i] = next;
        changed = true;
      }
    }
    if (changed) setState(() {});
  }

  @override
  void dispose() {
    _wsSub?.cancel();
    _animController.removeListener(_onTick);
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Only render in remote mode (WebSocket available).
    final wsStream = context.select<AppState, Stream<Map<String, dynamic>>?>(
      (a) => a.wsEventStream,
    );
    if (wsStream == null) return const SizedBox.shrink();

    return SizedBox(
      height: widget.height,
      child: CustomPaint(
        painter: _SpectrumPainter(bars: _current),
        size: Size.infinite,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _SpectrumPainter — draws the bar chart with accent gradient.
// ---------------------------------------------------------------------------

class _SpectrumPainter extends CustomPainter {
  final List<double> bars;

  _SpectrumPainter({required this.bars});

  @override
  void paint(Canvas canvas, Size size) {
    if (bars.isEmpty) return;

    final n = bars.length;
    const gap = 3.0;
    final barW = (size.width - gap * (n - 1)) / n;

    for (int i = 0; i < n; i++) {
      final h = (bars[i] * size.height).clamp(2.0, size.height);
      final x = i * (barW + gap);
      final rect = Rect.fromLTWH(
        x,
        size.height - h,
        barW,
        h,
      );

      final paint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            TuneColors.accent,
            TuneColors.accentLight,
          ],
        ).createShader(rect);

      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(2)),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_SpectrumPainter old) {
    // Quick length check + value comparison.
    if (old.bars.length != bars.length) return true;
    for (int i = 0; i < bars.length; i++) {
      if ((old.bars[i] - bars[i]).abs() > 0.001) return true;
    }
    return false;
  }
}
