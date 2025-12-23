import 'package:flutter/material.dart';
import 'canvas_painter.dart';
import 'stroke.dart';

class CanvasPage extends StatefulWidget {
  const CanvasPage({super.key});

  @override
  State<CanvasPage> createState() => _CanvasPageState();
}

class _CanvasPageState extends State<CanvasPage> {
  final List<Stroke> _strokes = [];
  Stroke? _currentStroke;

  void _startStroke(Offset pos) {
    _currentStroke = Stroke(points: [pos]);
    setState(() => _strokes.add(_currentStroke!));
  }

  void _updateStroke(Offset pos) {
    setState(() => _currentStroke?.points.add(pos));
  }

  void _endStroke() {
    _currentStroke = null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (d) => _startStroke(d.localPosition),
      onPanUpdate: (d) => _updateStroke(d.localPosition),
      onPanEnd: (_) => _endStroke(),
      child: CustomPaint(
        painter: CanvasPainter(_strokes),
        size: Size.infinite,
        child: Container(color: Colors.white),
      ),
    );
  }
}
