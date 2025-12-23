import '../../copilot/copilot_context.dart';
import '../../geometry/geometry_shape.dart';
import '../../geometry/geometry_point.dart';
import '../intent_parser.dart';

class LinearToGeometryTranslator {
  DerivedFile? translate(
    BootIntent intent,
    CopilotContext context,
  ) {
    final text = intent.raw.toLowerCase();

    final shapes = <GeometryShape>[];

    if (text.contains('eixo x')) {
      shapes.add(
        GeometryShape.line(
          points: [
            GeometryPoint(-100, 0),
            GeometryPoint(100, 0),
          ],
          metadata: {'generated': true},
        ),
      );
    }

    if (text.contains('eixo y')) {
      shapes.add(
        GeometryShape.line(
          points: [
            GeometryPoint(0, -100),
            GeometryPoint(0, 100),
          ],
          metadata: {'generated': true},
        ),
      );
    }

    if (text.contains('círculo') || text.contains('circle')) {
      shapes.add(
        GeometryShape.circle(
          center: GeometryPoint(0, 0),
          radius: 50,
          metadata: {'generated': true},
        ),
      );
    }

    if (shapes.isEmpty) return null;

    return DerivedFile(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      format: DerivedFormat.analysis,
      content: 'Generated ${shapes.length} geometric shapes',
      sourceId: 'boot',
    );
  }
}
