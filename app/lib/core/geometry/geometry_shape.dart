enum ShapeType {
  line,
  circle,
  polygon,
  free,
}

class GeometryShape {
  final ShapeType type;
  final Map<String, dynamic> data;

  GeometryShape(this.type, this.data);
}
