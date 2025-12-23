import '../geometry/geometry_shape.dart';

class LatexExporter {
  String export(List<GeometryShape> shapes) {
    final buffer = StringBuffer(r'\begin{tikzpicture}');

    for (final s in shapes) {
      if (s.type == ShapeType.line) {
        final a = s.data['start'];
        final b = s.data['end'];
        buffer.writeln(
            r'\draw (' '${a.dx},${a.dy}' ') -- (' '${b.dx},${b.dy}' ');');
      }

      if (s.type == ShapeType.circle) {
        final c = s.data['center'];
        final r = s.data['radius'];
        buffer.writeln(
            r'\draw (' '${c.dx},${c.dy}' ') circle (' '$r' ');');
      }
    }

    buffer.writeln(r'\end{tikzpicture}');
    return buffer.toString();
  }
}
