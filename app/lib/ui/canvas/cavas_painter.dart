import 'package:flutter/material.dart';
import 'stroke.dart';

class CanvasPainter extends CustomPainter {
  final List<Stroke> strokes;

  CanvasPainter(this.strokes);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    for (final stroke in strokes) {
      paint.strokeWidth = stroke.width;

      for (int i = 0; i < stroke.points.length - 1; i++) {
        canvas.drawLine(
          stroke.points[i],
          stroke.points[i + 1],
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CanvasPainter oldDelegate) => true;
}
