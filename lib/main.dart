import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() => runApp(const AureaApp());

class AureaApp extends StatelessWidget {
  const AureaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aurea Canvas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: const DrawingScreen(),
    );
  }
}

class DrawingScreen extends StatefulWidget {
  const DrawingScreen({super.key});

  @override
  State<DrawingScreen> createState() => _DrawingScreenState();
}

class _DrawingScreenState extends State<DrawingScreen> {
  List<DrawingElement> elements = [];
  bool isLinearMode = false;
  String selectedTool = 'free';
  String aiResponse = "Desenhe algo e toque em 'Perguntar à IA' para traduzir para versão linear.";

  void _clear() => setState(() => elements.clear());

  void _addElement(Offset position) {
    setState(() {
      switch (selectedTool) {
        case 'text':
          final texts = ['x² + y² = r²', 'E = mc²', 'F = ma', 'π ≈ 3.14159', '∫ f(x) dx', 'φ = (1+√5)/2', 'i² = -1', '42'];
          final text = texts[DateTime.now().millisecond % texts.length];
          elements.add(GeomText(position, text));
          break;
        case 'circle':
          elements.add(GeomCircle(center: position, radius: 60));
          break;
        case 'triangle':
          elements.add(GeomPolygon(center: position, sides: 3, radius: 70));
          break;
        case 'square':
          elements.add(GeomPolygon(center: position, sides: 4, radius: 60));
          break;
        case 'diamond':
          elements.add(GeomPolygon(center: position, sides: 4, radius: 60, rotation: math.pi / 4));
          break;
        case 'hexagon':
          elements.add(GeomPolygon(center: position, sides: 6, radius: 65));
          break;
        case 'line':
          elements.add(GeomLine(start: position - Offset(150, 0), end: position + Offset(150, 0)));
          break;
        case 'spiral':
          elements.add(GeomSpiral(center: position, revolutions: 5));
          break;
        case 'angle':
          elements.add(GeomAngle(center: position, armLength: 80));
          break;
        case 'vector':
          elements.add(GeomVector(start: position, end: position + Offset(120, -70)));
          break;
      }
    });
  }

  void _askAI() {
    setState(() {
      aiResponse = """
### Interpretação do desenho:
- Círculo: órbita ou campo
- Vetor: força F = ma
- Espiral: r = a·e^{bθ}
- Hexágono: estrutura cristalina

### LaTeX:
\\[
F = ma \\quad r = a e^{b\\theta}
\\]

### Código Python:
```python
import matplotlib.pyplot as plt
import numpy as np
theta = np.linspace(0, 10*np.pi, 500)
r = np.exp(0.2*theta)
plt.polar(theta, r)
plt.show()
""";
});
}
@override Widget build(BuildContext context) { return Scaffold( appBar: AppBar( title: const Text('Aurea Canvas - Não Linear'), backgroundColor: Colors.deepPurple[400], actions: [ IconButton(icon: const Icon(Icons.cleaning_services), onPressed: _clear), Padding( padding: const EdgeInsets.only(right: 16), child: Row( children: [ Text(isLinearMode ? 'Linear' : 'Não Linear', style: const TextStyle(color: Colors.white)), Switch(value: isLinearMode, onChanged: (v) => setState(() => isLinearMode = v), activeColor: Colors.white), ], ), ), ], ), body: Column( children: [ // Barra de ferramentas completa Container( height: 90, color: Colors.grey[150], child: SingleChildScrollView( scrollDirection: Axis.horizontal, child: Row(children: [ _tool('free', Icons.gesture, 'Livre'), _tool('text', Icons.text_fields, 'Texto'), _tool('circle', Icons.circle_outlined, 'Círculo'), _tool('triangle', Icons.change_history, 'Triângulo'), _tool('square', Icons.crop_square, 'Quadrado'), _tool('diamond', Icons.diamond, 'Losango'), _tool('hexagon', Icons.hexagon_outlined, 'Hexágono'), _tool('line', Icons.horizontal_rule, 'Reta'), _tool('spiral', Icons.auto_fix_high, 'Espiral'), _tool('angle', Icons.sports_score, 'Ângulo'), _tool('vector', Icons.arrow_forward, 'Vetor'), ]), ), ), // Canvas Expanded( child: GestureDetector( onTapDown: (d) => _addElement(d.localPosition), onPanUpdate: (d) { if (selectedTool == 'free') { setState(() => elements.add(FreePoint(d.localPosition))); } }, child: CustomPaint( painter: CanvasPainter(elements, isLinearMode), size: Size.infinite, ), ), ), // Painel inferior IA Container( height: 200, color: Colors.grey[100], padding: const EdgeInsets.all(12), child: Column( crossAxisAlignment: CrossAxisAlignment.start, children: [ Row( mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [ const Text('Versão Linear (gerada pela IA)', style: TextStyle(fontWeight: FontWeight.bold)), ElevatedButton(onPressed: _askAI, child: const Text('Perguntar à IA')), ], ), const Divider(), Expanded(child: SingleChildScrollView(child: Text(aiResponse))), ], ), ), ], ), ); }
Widget _tool(String tool, IconData icon, String label) { bool sel = selectedTool == tool; return Padding( padding: const EdgeInsets.all(8), child: Column( children: [ IconButton( icon: Icon(icon, color: sel ? Colors.white : Colors.deepPurple, size: 32), onPressed: () => setState(() => selectedTool = tool), style: ButtonStyle(backgroundColor: MaterialStateProperty.all(sel ? Colors.deepPurple : Colors.white)), ), Text(label, style: const TextStyle(fontSize: 10)), ], ), ); } }
// === ELEMENTOS === abstract class DrawingElement {}
class FreePoint extends DrawingElement { final Offset pos; FreePoint(this.pos); }
class GeomText extends DrawingElement { final Offset pos; final String text; GeomText(this.pos, this.text); }
class GeomCircle extends DrawingElement { final Offset center; final double radius; GeomCircle({required this.center, required this.radius}); }
class GeomPolygon extends DrawingElement { final Offset center; final int sides; final double radius; final double rotation; GeomPolygon({required this.center, required this.sides, required this.radius, this.rotation = 0}); }
class GeomLine extends DrawingElement { final Offset start, end; GeomLine({required this.start, required this.end}); }
class GeomSpiral extends DrawingElement { final Offset center; final int revolutions; GeomSpiral({required this.center, required this.revolutions}); }
class GeomAngle extends DrawingElement { final Offset center; final double armLength; GeomAngle({required this.center, required this.armLength}); }
class GeomVector extends DrawingElement { final Offset start, end; GeomVector({required this.start, required this.end}); }
// === PAINTER === class CanvasPainter extends CustomPainter { final List elements; final bool isLinearMode;
CanvasPainter(this.elements, this.isLinearMode);
@override void paint(Canvas canvas, Size size) { final paint = Paint()..strokeWidth = 4..strokeCap = StrokeCap.round;
if (isLinearMode) {
  final lp = Paint()..color = Colors.blue[100]!..strokeWidth = 1;
  for (double y = 0; y < size.height; y += 50) canvas.drawLine(Offset(0, y), Offset(size.width, y), lp);
}

for (var e in elements) {
  if (e is FreePoint) canvas.drawCircle(e.pos, 3, paint..color = Colors.black);
  if (e is GeomText) {
    final tp = TextPainter(text: TextSpan(text: e.text, style: const TextStyle(color: Colors.black, fontSize: 26)), textDirection: TextDirection.ltr);
    tp.layout();
    tp.paint(canvas, e.pos - Offset(tp.width / 2, tp.height / 2));
  }
  if (e is GeomCircle) canvas.drawCircle(e.center, e.radius, paint..color = Colors.blue..style = PaintingStyle.stroke);
  if (e is GeomPolygon) {
    final path = Path();
    for (int i = 0; i < e.sides; i++) {
      double a = e.rotation + 2 * math.pi * i / e.sides;
      Offset pt = e.center + Offset(e.radius * math.cos(a), e.radius * math.sin(a));
      i == 0 ? path.moveTo(pt.dx, pt.dy) : path.lineTo(pt.dx, pt.dy);
    }
    path.close();
    canvas.drawPath(path, paint..color = Colors.green[800]!..style = PaintingStyle.stroke);
  }
  if (e is GeomLine) canvas.drawLine(e.start, e.end, paint..color = Colors.black);
  if (e is GeomSpiral) {
    final path = Path();
    path.moveTo(e.center.dx, e.center.dy);
    for (double t = 0; t < e.revolutions * 2 * math.pi; t += 0.05) {
      double r = 6 + 12 * t;
      path.lineTo(e.center.dx + r * math.cos(t), e.center.dy + r * math.sin(t));
    }
    canvas.drawPath(path, paint..color = Colors.purple[700]!);
  }
  if (e is GeomAngle) {
    canvas.drawLine(e.center, e.center + Offset(e.armLength, 0), paint..color = Colors.orange);
    canvas.drawLine(e.center, e.center + Offset(e.armLength * 0.7, -e.armLength * 0.7), paint..color = Colors.orange);
    canvas.drawArc(Rect.fromCircle(center: e.center, radius: 35), -math.pi / 4, math.pi / 2, false, paint..color = Colors.orange);
  }
  if (e is GeomVector) {
    canvas.drawLine(e.start, e.end, paint..color = Colors.red[700]!..strokeWidth = 5);
    double dir = (e.end - e.start).direction;
    Offset l = e.end + Offset(20 * math.cos(dir + 5*math.pi/6), 20 * math.sin(dir + 5*math.pi/6));
    Offset r = e.end + Offset(20 * math.cos(dir - 5*math.pi/6), 20 * math.sin(dir - 5*math.pi/6));
    canvas.drawLine(e.end, l, paint..color = Colors.red[700]!..strokeWidth = 5);
    canvas.drawLine(e.end, r, paint..color = Colors.red[700]!..strokeWidth = 5);
  }
}
}
@override bool shouldRepaint(covariant CustomPainter old) => true; }
