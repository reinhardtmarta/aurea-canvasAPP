import '../geometry/geometry_shape.dart';

class SvgExporter {
  String export(List<GeometryShape> shapes) {
    final buffer = StringBuffer('<svg xmlns="http://www.w3.org/2000/svg">');

    for (final s in shapes) {
      if (s.type == ShapeType.line) {
        final a = s.data['start'];
        final b = s.data['end'];
        buffer.writeln(
            '<line x1="${a.dx}" y1="${a.dy}" x2="${b.dx}" y2="${b.dy}" stroke="black"/>');
      }

      if (s.type == ShapeType.circle) {
        final c = s.data['center'];
        final r = s.data['radius'];
        buffer.writeln(
            '<circle cx="${c.dx}" cy="${c.dy}" r="$r" stroke="black" fill="none"/>');
      }
    }

    buffer.writeln('</svg>');
    return buffer.toString();
  }
}
