import '../copilot/copilot_context.dart';
import '../geometry/geometry_shape.dart';

/// Tipos de exportação suportados
enum ExportFormat {
  png,
  svg,
  latex,
  markdown,
}

/// Resultado de exportação (não salva nada)
class ExportResult {
  final ExportFormat format;
  final String content;
  final DateTime createdAt;

  ExportResult({
    required this.format,
    required this.content,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}

/// Pipeline de exportação
/// - Nunca altera o contexto
/// - Nunca apaga dados
/// - Apenas traduz estado → representação
class ExportPipeline {
  ExportResult export({
    required CopilotContext context,
    required ExportFormat format,
  }) {
    switch (format) {
      case ExportFormat.svg:
        return ExportResult(
          format: format,
          content: _toSvg(context),
        );
      case ExportFormat.latex:
        return ExportResult(
          format: format,
          content: _toLatex(context),
        );
      case ExportFormat.markdown:
        return ExportResult(
          format: format,
          content: _toMarkdown(context),
        );
      case ExportFormat.png:
        // PNG real é render → bitmap (UI ou backend)
        return ExportResult(
          format: format,
          content: '[PNG_BINARY_PLACEHOLDER]',
        );
    }
  }

  /// =====================
  /// SVG EXPORT
  /// =====================
  String _toSvg(CopilotContext context) {
    final buffer = StringBuffer();

    buffer.writeln(
        '<svg xmlns="http://www.w3.org/2000/svg" width="800" height="600">');

    for (final shape in context.shapes) {
      switch (shape.type) {
        case ShapeType.line:
          final p0 = shape.points.first;
          final p1 = shape.points.last;
          buffer.writeln(
              '<line x1="${p0.x}" y1="${p0.y}" x2="${p1.x}" y2="${p1.y}" stroke="black" />');
          break;

        case ShapeType.circle:
          final c = shape.centroid!;
          buffer.writeln(
              '<circle cx="${c.x}" cy="${c.y}" r="${shape.radius}" stroke="black" fill="none" />');
          break;

        case ShapeType.free:
          final path = shape.points
              .map((p) => '${p.x},${p.y}')
              .join(' ');
          buffer.writeln(
              '<polyline points="$path" stroke="gray" fill="none" />');
          break;
      }
    }

    buffer.writeln('</svg>');
    return buffer.toString();
  }

  /// =====================
  /// LATEX (TikZ)
  /// =====================
  String _toLatex(CopilotContext context) {
    final buffer = StringBuffer();

    buffer.writeln(r'\begin{tikzpicture}');

    for (final shape in context.shapes) {
      switch (shape.type) {
        case ShapeType.line:
          final p0 = shape.points.first;
          final p1 = shape.points.last;
          buffer.writeln(
              r'\draw (' +
                  '${p0.x},${p0.y}) -- (${p1.x},${p1.y});');
          break;

        case ShapeType.circle:
          final c = shape.centroid!;
          buffer.writeln(
              r'\draw (' +
                  '${c.x},${c.y}) circle (${shape.radius});');
          break;

        case ShapeType.free:
          // Free fica como comentário (não destruímos)
          buffer.writeln(
              r'% free shape omitted intentionally');
          break;
      }
    }

    buffer.writeln(r'\end{tikzpicture}');
    return buffer.toString();
  }

  /// =====================
  /// MARKDOWN (Linear)
  /// =====================
  String _toMarkdown(CopilotContext context) {
    final buffer = StringBuffer();

    buffer.writeln('# Aurea Canvas Export');
    buffer.writeln('');
    buffer.writeln('## Shapes detected');
    buffer.writeln('');

    for (final shape in context.shapes) {
      buffer.writeln('- ${shape.type.name}');
    }

    buffer.writeln('');
    buffer.writeln('## Sources');
    for (final src in context.sources) {
      buffer.writeln('- ${src.type.name}: ${src.id}');
    }

    return buffer.toString();
  }
}
