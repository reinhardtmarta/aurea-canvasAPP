import 'dart:math';
import '../../ui/canvas/stroke.dart';
import 'geometry_shape.dart';
import 'dart:ui';

class GeometryRecognizer {
  GeometryShape recognize(Stroke stroke) {
    if (stroke.points.length < 2) {
      return GeometryShape(ShapeType.free, {});
    }

    if (_isLine(stroke)) {
      return GeometryShape(
        ShapeType.line,
        {
          'start': stroke.points.first,
          'end': stroke.points.last,
        },
      );
    }

    if (_isCircle(stroke)) {
      return GeometryShape(
        ShapeType.circle,
        {
          'center': _center(stroke.points),
          'radius': _averageRadius(stroke.points),
        },
      );
    }

    return GeometryShape(ShapeType.free, {
      'points': stroke.points,
    });
  }

  bool _isLine(Stroke stroke) {
    final a = stroke.points.first;
    final b = stroke.points.last;

    double distanceSum = 0;
    for (final p in stroke.points) {
      distanceSum += _distanceToLine(p, a, b);
    }

    return (distanceSum / stroke.points.length) < 5;
  }

  bool _isCircle(Stroke stroke) {
    final center = _center(stroke.points);
    final radii = stroke.points
        .map((p) => (p - center).distance)
        .toList();

    final avg = radii.reduce((a, b) => a + b) / radii.length;
    final variance =
        radii.map((r) => pow(r - avg, 2)).reduce((a, b) => a + b) /
            radii.length;

    return variance < 20;
  }

  Offset _center(List<Offset> pts) {
    final sum = pts.reduce((a, b) => a + b);
    return Offset(sum.dx / pts.length, sum.dy / pts.length);
  }

  double _averageRadius(List<Offset> pts) {
    final c = _center(pts);
    return pts.map((p) => (p - c).distance).reduce((a, b) => a + b) /
        pts.length;
  }

  double _distanceToLine(Offset p, Offset a, Offset b) {
    final num = ((b.dy - a.dy) * p.dx -
            (b.dx - a.dx) * p.dy +
            b.dx * a.dy -
            b.dy * a.dx)
        .abs();
    final den = (b - a).distance;
    return num / den;
  }
}
