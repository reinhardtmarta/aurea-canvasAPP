import 'package:flutter/material.dart';
import 'canvas_painter.dart';
import '../../core/geometry/geometry_point.dart';
import '../../core/geometry/geometry_shape.dart';

class FreeCanvas extends StatefulWidget {
  final void Function(List<GeometryShape>) onChange;

  const FreeCanvas({super.key, required this.onChange});

  @override
  State<FreeCanvas> createState() => _FreeCanvasState();
}

class _FreeCanvasState extends State<FreeCanvas> {
  final List<GeometryShape> _shapes = [];
  List<GeometryPoint> _currentPoints = [];

  void _startStroke(Offset pos) {
    _currentPoints = [GeometryPoint(pos.dx, pos.dy)];
  }

  void _updateStroke(Offset pos) {
    setState(() {
      _currentPoints.add(GeometryPoint(pos.dx, pos.dy));
    });
  }

  void _endStroke() {
    if (_currentPoints.length < 2) return;

    _shapes.add(
      GeometryShape.free(
        points: List.from(_currentPoints),
      ),
    );

    _currentPoints = [];
    widget.onChange(List.from(_shapes));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (d) => _startStroke(d.localPosition),
      onPanUpdate: (d) => _updateStroke(d.localPosition),
      onPanEnd: (_) => _endStroke(),
      child: CustomPaint(
        painter: CanvasPainter(
          shapes: _shapes,
          current: _currentPoints,
        ),
        size: Size.infinite,
      ),
    );
  }
}
