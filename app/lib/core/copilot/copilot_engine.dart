import 'copilot_context.dart';
import 'copilot_suggestion.dart';
import '../geometry/geometry_shape.dart';

class CopilotEngine {
  List<CopilotSuggestion> analyze(CopilotContext context) {
    final suggestions = <CopilotSuggestion>[];

    // 1. Nenhum derivado ainda
    if (context.derived.isEmpty) {
      suggestions.add(
        CopilotSuggestion(
          type: CopilotSuggestionType.translate,
          message: 'Deseja gerar uma versão formal (LaTeX, SVG ou PDF)?',
        ),
      );
    }

    // 2. Muitas formas livres
    final freeCount = context.shapes
        .where((s) => s.type == ShapeType.free)
        .length;

    if (freeCount > 3) {
      suggestions.add(
        CopilotSuggestion(
          type: CopilotSuggestionType.refine,
          message:
              'Posso tentar reconhecer padrões geométricos nesse esboço.',
        ),
      );
    }

    // 3. Linhas dominantes
    final lines =
        context.shapes.where((s) => s.type == ShapeType.line).length;

    if (lines >= 2) {
      suggestions.add(
        CopilotSuggestion(
          type: CopilotSuggestionType.analyze,
          message:
              'Há estruturas lineares suficientes para gerar um gráfico.',
        ),
      );
    }

    // 4. Export sugerido
    suggestions.add(
      CopilotSuggestion(
        type: CopilotSuggestionType.export,
        message: 'Exportar o estado atual?',
        payload: {
          'formats': ['png', 'pdf', 'svg', 'latex'],
        },
      ),
    );

    return suggestions;
  }
}
