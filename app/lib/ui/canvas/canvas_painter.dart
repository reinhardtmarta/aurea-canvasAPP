import 'package:flutter/material.dart';
import '../../core/geometry/geometry_shape.dart';
import '../../core/geometry/geometry_point.dart';

class CanvasPainter extends CustomPainter {
  final List<GeometryShape> shapes;
  final List<GeometryPoint> current;

  CanvasPainter({
    required this.shapes,
    required this.current,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..color = Colors.black;

    for (final shape in shapes) {
      _drawPoints(canvas, paint, shape.points);
    }

    _drawPoints(canvas, paint, current);
  }

  void _drawPoints(
    Canvas canvas,
    Paint paint,
    List<GeometryPoint> points,
  ) {
    if (points.length < 2) return;

    final path = Path()..moveTo(points.first.x, points.first.y);

    for (final p in points.skip(1)) {
      path.lineTo(p.x, p.y);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CanvasPainter oldDelegate) => true;
}
