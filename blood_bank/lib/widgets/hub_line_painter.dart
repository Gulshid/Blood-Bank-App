import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// One animated arrow segment between two nodes on the hub.
class HubLine {
  final Offset start;
  final Offset end;
  final Color color;

  const HubLine({required this.start, required this.end, required this.color});
}

/// Paints staggered, arrow-headed lines radiating from the selected node.
///
/// Each line animates independently using a slice of [progress] (0..1),
/// so lines appear to "fire" out one after another rather than all at once.
class HubLinePainter extends CustomPainter {
  final List<HubLine> lines;
  final double progress;

  HubLinePainter({required this.lines, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    if (lines.isEmpty) return;

    final staggerSlice = lines.length <= 1 ? 1.0 : 1.0 / (lines.length + 1);

    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];
      final segStart = i * staggerSlice * 0.6;
      final segEnd = (segStart + staggerSlice * 2.2).clamp(0.0, 1.0);
      final localT = ((progress - segStart) / (segEnd - segStart)).clamp(0.0, 1.0);
      final eased = Curves.easeOutCubic.transform(localT);

      if (eased <= 0) continue;

      final currentEnd = Offset.lerp(line.start, line.end, eased)!;

      final paint = Paint()
        ..color = line.color.withValues(alpha: 0.9)
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;

      canvas.drawLine(line.start, currentEnd, paint);

      // Arrowhead at the growing tip.
      if (eased > 0.05) {
        final angle = math.atan2(
          currentEnd.dy - line.start.dy,
          currentEnd.dx - line.start.dx,
        );
        const arrowSize = 9.0;
        final p1 = currentEnd -
            Offset(math.cos(angle - 0.5), math.sin(angle - 0.5)) * arrowSize;
        final p2 = currentEnd -
            Offset(math.cos(angle + 0.5), math.sin(angle + 0.5)) * arrowSize;

        final arrowPaint = Paint()
          ..color = line.color.withValues(alpha: 0.9)
          ..style = PaintingStyle.fill;

        final path = Path()
          ..moveTo(currentEnd.dx, currentEnd.dy)
          ..lineTo(p1.dx, p1.dy)
          ..lineTo(p2.dx, p2.dy)
          ..close();
        canvas.drawPath(path, arrowPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant HubLinePainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.lines != lines;
  }
}

/// Colors used for the two relationship types, exposed centrally so the
/// screen and legend stay in sync with the painter.
class HubLineColors {
  static const Color give = AppTheme.statusOptimal; // can give to
  static const Color receive = Color(0xFF58A6FF); // can receive from
}
