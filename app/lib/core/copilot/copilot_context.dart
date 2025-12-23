import '../project/source_file.dart';
import '../project/derived_file.dart';
import '../geometry/geometry_shape.dart';

class CopilotContext {
  final SourceFile source;
  final List<DerivedFile> derived;
  final List<GeometryShape> shapes;

  CopilotContext({
    required this.source,
    required this.derived,
    required this.shapes,
  });
}
