import 'dart:ui';

class Stroke {
  final List<Offset> points;
  final double width;

  Stroke({
    required this.points,
    this.width = 2.0,
  });

  Map<String, dynamic> toJson() => {
        'width': width,
        'points': points.map((p) => {'x': p.dx, 'y': p.dy}).toList(),
      };

  factory Stroke.fromJson(Map<String, dynamic> json) {
    return Stroke(
      width: json['width'],
      points: (json['points'] as List)
          .map((p) => Offset(p['x'], p['y']))
          .toList(),
    );
  }
}
