import 'package:flutter/material.dart';

/// Skip backward/forward button matching the web client transport bar style:
/// Previous = bar + triangle (|◀), Next = triangle + bar (▶|)
class SkipButton extends StatelessWidget {
  final bool isForward;
  final double size;
  final Color color;
  final VoidCallback? onPressed;

  const SkipButton({
    super.key,
    required this.isForward,
    this.size = 28,
    this.color = Colors.white,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: size * 1.4,
        height: size,
        child: CustomPaint(
          painter: _SkipPainter(isForward: isForward, color: color),
        ),
      ),
    );
  }
}

class _SkipPainter extends CustomPainter {
  final bool isForward;
  final Color color;

  _SkipPainter({required this.isForward, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final w = size.width;
    final h = size.height;
    final barWidth = (w * 0.1).clamp(2.5, 6.0);
    final gap = w * 0.08;
    final vPad = h * 0.05;

    if (!isForward) {
      // |◀ — bar on left, triangle pointing left
      final barRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(0, vPad, barWidth, h - vPad * 2),
        const Radius.circular(1.5),
      );
      canvas.drawRRect(barRect, paint);

      final tri = Path()
        ..moveTo(w, 0)
        ..lineTo(barWidth + gap, h / 2)
        ..lineTo(w, h)
        ..close();
      canvas.drawPath(tri, paint);
    } else {
      // ▶| — triangle pointing right, bar on right
      final tri = Path()
        ..moveTo(0, 0)
        ..lineTo(w - barWidth - gap, h / 2)
        ..lineTo(0, h)
        ..close();
      canvas.drawPath(tri, paint);

      final barRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(w - barWidth, vPad, barWidth, h - vPad * 2),
        const Radius.circular(1.5),
      );
      canvas.drawRRect(barRect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _SkipPainter old) =>
      old.isForward != isForward || old.color != color;
}
