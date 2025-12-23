import 'geometry_shape.dart';
import 'geometry_point.dart';

/// Engine determinística de reconhecimento geométrico
/// - Offline
/// - Sem IA
/// - Reprodutível
class GeometryEngine {
  /// Analisa formas livres e tenta promover para formas geométricas
  List<GeometryShape> analyze(List<GeometryShape> input) {
    final List<GeometryShape> result = [];

    for (final shape in input) {
      if (shape.type != ShapeType.free) {
        result.add(shape);
        continue;
      }

      final promoted = _tryPromote(shape);
      result.add(promoted ?? shape);
    }

    return result;
  }

  /// Tentativa de promoção sem destruir o original
  GeometryShape? _tryPromote(GeometryShape shape) {
    if (shape.points.length < 2) return null;

    if (_isLine(shape.points)) {
      return shape.copyAs(
        type: ShapeType.line,
        metadata: {'confidence': 0.9},
      );
    }

    if (_isCircle(shape.points)) {
      return shape.copyAs(
        type: ShapeType.circle,
        metadata: {'confidence': 0.85},
      );
    }

    return null;
  }

  /// Heurística simples para linha
  bool _isLine(List<GeometryPoint> points) {
    if (points.length < 3) return true;

    final p0 = points.first;
    final pN = points.last;

    for (final p in points) {
      final distance = _distanceFromLine(p0, pN, p);
      if (distance > 5.0) return false;
    }
    return true;
  }

  /// Heurística simples para círculo
  bool _isCircle(List<GeometryPoint> points) {
    if (points.length < 6) return false;

    final center = _centroid(points);
    final radii = points
        .map((p) => _distance(center, p))
        .toList();

    final avgRadius =
        radii.reduce((a, b) => a + b) / radii.length;

    for (final r in radii) {
      if ((r - avgRadius).abs() > 6.0) return false;
    }

    return true;
  }

  /// Distância ponto–linha
  double _distanceFromLine(
    GeometryPoint a,
    GeometryPoint b,
    GeometryPoint p,
  ) {
    final num = ((b.y - a.y) * p.x -
            (b.x - a.x) * p.y +
            b.x * a.y -
            b.y * a.x)
        .abs();

    final den =
        ((b.y - a.y) * (b.y - a.y) +
                (b.x - a.x) * (b.x - a.x))
            .sqrt();

    return num / den;
  }

  GeometryPoint _centroid(List<GeometryPoint> points) {
    final x =
        points.map((p) => p.x).reduce((a, b) => a + b) /
            points.length;
    final y =
        points.map((p) => p.y).reduce((a, b) => a + b) /
            points.length;
    return GeometryPoint(x, y);
  }

  double _distance(GeometryPoint a, GeometryPoint b) {
    final dx = a.x - b.x;
    final dy = a.y - b.y;
    return (dx * dx + dy * dy).sqrt();
  }
}
