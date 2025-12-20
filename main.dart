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

// === ELEMENTOS ===
// Moved the definition of DrawingElement and its subclasses here,
// before they are used in _DrawingScreenState.
abstract class DrawingElement {}

class FreePoint extends DrawingElement {
  final Offset pos;
  FreePoint(this.pos);
}

class GeomText extends DrawingElement {
  final Offset pos;
  final String text;
  GeomText(this.pos, this.text);
}

class GeomCircle extends DrawingElement {
  final Offset center;
  final double radius;
  GeomCircle({required this.center, required this.radius});
}

class GeomPolygon extends DrawingElement {
  final Offset center;
  final int sides;
  final double radius;
  final double rotation;
  GeomPolygon({required this.center, required this.sides, required this.radius, this.rotation = 0});
}

class GeomLine extends DrawingElement {
  final Offset start, end;
  GeomLine({required this.start, required this.end});
}

class GeomSpiral extends DrawingElement {
  final Offset center;
  final int revolutions;
  GeomSpiral({required this.center, required this.revolutions});
}

class GeomAngle extends DrawingElement {
  final Offset center;
  final double armLength;
  GeomAngle({required this.center, required this.armLength});
}

class GeomVector extends DrawingElement {
  final Offset start, end;
  GeomVector({required this.start, required this.end});
}
// === END ELEMENTS ===


class _DrawingScreenState extends State<DrawingScreen> {
  List<DrawingElement> elements = [];
  bool isLinearMode = false;
  String selectedTool = 'free';
  String aiResponse = "Desenhe algo e toque em 'Perguntar à IA' para traduzir para versão linear.";

  void _clear() => setState(() => elements.clear());

  void _addElement(Offset position) {
    setState(() {
      switch (selectedTool) {
        case 'free':
          elements.add(FreePoint(position));
          break;
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
          elements.add(GeomLine(start: position - const Offset(75, 0), end: position + const Offset(75, 0)));
          break;
        case 'spiral':
          elements.add(GeomSpiral(center: position, revolutions: 3)); // Reduced revolutions for better visualization
          break;
        case 'angle':
          elements.add(GeomAngle(center: position, armLength: 80));
          break;
        case 'vector':
          elements.add(GeomVector(start: position, end: position + const Offset(120, -70)));
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
""";
    });
  }

  // FIX: Implement the build method for the State class
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aurea Canvas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.lightbulb_outline),
            onPressed: _askAI,
            tooltip: 'Perguntar à IA',
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _clear,
            tooltip: 'Limpar',
          ),
          Switch(
            value: isLinearMode,
            onChanged: (bool value) {
              setState(() {
                isLinearMode = value;
              });
            },
            trackColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
              if (states.contains(WidgetState.selected)) {
                return Colors.deepPurpleAccent;
              }
              return Colors.grey;
            }),
            thumbIcon: WidgetStateProperty.resolveWith<Icon?>((Set<WidgetState> states) {
              if (states.contains(WidgetState.selected)) {
                return const Icon(Icons.straighten, color: Colors.white);
              }
              return const Icon(Icons.gesture, color: Colors.white);
            }),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Text(isLinearMode ? 'Linear' : 'Livre'),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTapUp: (details) => _addElement(details.localPosition),
              child: CustomPaint(
                painter: AureaCanvasPainter(elements: elements, isLinearMode: isLinearMode),
                child: SizedBox.expand(), // Make CustomPaint fill the available space
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.grey[200],
            constraints: const BoxConstraints(minHeight: 100, maxHeight: 150), // Constrain height for AI response
            child: SingleChildScrollView(
              child: Text(aiResponse),
            ),
          ),
          _buildToolSelectionBar(), // Tool selection bar at the bottom
        ],
      ),
    );
  }

  Widget _buildToolSelectionBar() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Row(
        children: [
          _buildToolButton('free', Icons.brush, 'Livre'),
          _buildToolButton('text', Icons.text_fields, 'Texto'),
          _buildToolButton('circle', Icons.circle_outlined, 'Círculo'),
          _buildToolButton('triangle', Icons.change_history, 'Triângulo'), // More accurate icon for triangle
          _buildToolButton('square', Icons.square_outlined, 'Quadrado'),
          _buildToolButton('diamond', Icons.crop_rotate, 'Losango'),
          _buildToolButton('hexagon', Icons.hexagon_outlined, 'Hexágono'),
          _buildToolButton('line', Icons.horizontal_rule, 'Linha'),
          _buildToolButton('spiral', Icons.waves, 'Espiral'),
          _buildToolButton('angle', Icons.architecture, 'Ângulo'),
          _buildToolButton('vector', Icons.arrow_right_alt, 'Vetor'),
        ],
      ),
    );
  }

  Widget _buildToolButton(String toolName, IconData iconData, String label) {
    bool isSelected = selectedTool == toolName;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: OutlinedButton.icon(
        onPressed: () {
          setState(() {
            selectedTool = toolName;
          });
        },
        style: OutlinedButton.styleFrom(
          backgroundColor: isSelected ? Theme.of(context).primaryColor.withAlpha(51) : null, // Fix: Changed .withOpacity(0.2) to .withAlpha(51)
          side: BorderSide(
            color: isSelected ? Theme.of(context).primaryColor : Colors.grey,
            width: isSelected ? 2.0 : 1.0,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        ),
        icon: Icon(iconData, color: isSelected ? Theme.of(context).primaryColor : Colors.black54),
        label: Text(
          label,
          style: TextStyle(
            color: isSelected ? Theme.of(context).primaryColor : Colors.black54,
          ),
        ),
      ),
    );
  }
}

// CustomPainter for drawing the elements on the canvas
class AureaCanvasPainter extends CustomPainter {
  final List<DrawingElement> elements;
  final bool isLinearMode;

  AureaCanvasPainter({required this.elements, required this.isLinearMode});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    for (var element in elements) {
      if (element is FreePoint) {
        canvas.drawCircle(element.pos, 3, paint..style = PaintingStyle.fill);
      } else if (element is GeomText) {
        textPainter.text = TextSpan(
          text: element.text,
          style: const TextStyle(color: Colors.black, fontSize: 16),
        );
        textPainter.layout();
        textPainter.paint(canvas, element.pos);
      } else if (element is GeomCircle) {
        canvas.drawCircle(element.center, element.radius, paint);
      } else if (element is GeomPolygon) {
        final Path path = Path();
        for (int i = 0; i < element.sides; i++) {
          final double angle = (2 * math.pi / element.sides) * i + element.rotation;
          final Offset point = Offset(
            element.center.dx + element.radius * math.cos(angle),
            element.center.dy + element.radius * math.sin(angle),
          );
          if (i == 0) {
            path.moveTo(point.dx, point.dy);
          } else {
            path.lineTo(point.dx, point.dy);
          }
        }
        path.close();
        canvas.drawPath(path, paint);
      } else if (element is GeomLine) {
        canvas.drawLine(element.start, element.end, paint);
      } else if (element is GeomSpiral) {
        final Path path = Path();
        const double initialRadius = 5.0; // Start closer to center
        const double tightness = 3.0; // Controls how tight the spiral is
        const int numSegments = 360 * 5; // More segments for a smoother spiral
        
        path.moveTo(element.center.dx, element.center.dy); // Start at the center

        for (int i = 0; i <= numSegments; i++) {
          final double angle = (i / numSegments) * (2 * math.pi * element.revolutions);
          final double radius = initialRadius + tightness * angle;
          final Offset point = Offset(
            element.center.dx + radius * math.cos(angle),
            element.center.dy + radius * math.sin(angle),
          );
          if (i == 0) {
            path.moveTo(point.dx, point.dy);
          } else {
            path.lineTo(point.dx, point.dy);
          }
        }
        canvas.drawPath(path, paint);
      } else if (element is GeomAngle) {
        // Draw first arm horizontally
        canvas.drawLine(element.center, element.center + Offset(element.armLength, 0), paint);
        // Draw second arm at 45 degrees
        canvas.drawLine(element.center, element.center + Offset(element.armLength * math.cos(math.pi / 4), element.armLength * math.sin(math.pi / 4)), paint);
        // Draw an arc to represent the angle
        canvas.drawArc(
          Rect.fromCircle(center: element.center, radius: element.armLength / 3),
          0, // Start angle
          math.pi / 4, // Sweep angle (45 degrees)
          false, // Don't use center
          paint,
        );
      } else if (element is GeomVector) {
        canvas.drawLine(element.start, element.end, paint);
        // Draw arrowhead
        const double arrowSize = 15.0;
        final double angle = math.atan2(element.end.dy - element.start.dy, element.end.dx - element.start.dx);
        final Path arrowPath = Path();
        arrowPath.moveTo(element.end.dx, element.end.dy);
        arrowPath.lineTo(
          element.end.dx - arrowSize * math.cos(angle - math.pi / 6),
          element.end.dy - arrowSize * math.sin(angle - math.pi / 6),
        );
        arrowPath.moveTo(element.end.dx, element.end.dy); // Move back to end point to draw other side
        arrowPath.lineTo(
          element.end.dx - arrowSize * math.cos(angle + math.pi / 6),
          element.end.dy - arrowSize * math.sin(angle + math.pi / 6),
        );
        canvas.drawPath(arrowPath, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant AureaCanvasPainter oldDelegate) {
    return elements != oldDelegate.elements || isLinearMode != oldDelegate.isLinearMode;
  }
}
