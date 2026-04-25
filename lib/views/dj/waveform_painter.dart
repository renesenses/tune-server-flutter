import 'package:flutter/material.dart';

class WaveformPainter extends CustomPainter {
  final List<double> data;
  final double progress;
  final Color playedColor;
  final Color unplayedColor;

  WaveformPainter({
    required this.data,
    required this.progress,
    this.playedColor = const Color(0xFF6366F1),
    this.unplayedColor = const Color(0x1FFFFFFF),
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;
    final barWidth = size.width / data.length;
    final midY = size.height / 2;

    for (int i = 0; i < data.length; i++) {
      final amp = data[i].clamp(0.0, 1.0);
      final barH = amp * midY * 0.9;
      final x = i * barWidth;
      final played = i / data.length <= progress;
      final paint = Paint()..color = played ? playedColor : unplayedColor;
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset(x + barWidth / 2, midY),
          width: (barWidth - 0.5).clamp(1.0, barWidth),
          height: barH * 2,
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(WaveformPainter old) =>
      old.data != data || old.progress != progress;
}
