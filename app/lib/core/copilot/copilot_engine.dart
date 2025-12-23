import 'copilot_context.dart';
import 'copilot_suggestion.dart';
import '../geometry/geometry_shape.dart';
import '../ai/ai_adapter.dart';
import '../ai/ai_request.dart';
import '../ai/ai_response.dart';
import '../ai/null_ai_adapter.dart';

class CopilotEngine {
  final AiAdapter _ai;

  CopilotEngine({AiAdapter? ai}) : _ai = ai ?? NullAiAdapter();

  /// Análise 100% local, determinística
  List<CopilotSuggestion> analyze(CopilotContext context) {
    final suggestions = <CopilotSuggestion>[];

    // 1️⃣ Nenhuma tradução ainda
    if (context.derived.isEmpty) {
      suggestions.add(
        CopilotSuggestion(
          type: CopilotSuggestionType.translate,
          message:
              'Posso gerar uma versão formal (LaTeX, SVG ou PDF) do seu esboço.',
        ),
      );
    }

    // 2️⃣ Muitas formas livres → refinamento
    final freeCount = context.shapes
        .where((s) => s.type == ShapeType.free)
        .length;

    if (freeCount >= 3) {
      suggestions.add(
        CopilotSuggestion(
          type: CopilotSuggestionType.refine,
          message:
              'Há muitos traços livres. Deseja tentar reconhecimento geométrico?',
        ),
      );
    }

    // 3️⃣ Estrutura linear → gráfico
    final lineCount = context.shapes
        .where((s) => s.type == ShapeType.line)
        .length;

    if (lineCount >= 2) {
      suggestions.add(
        CopilotSuggestion(
          type: CopilotSuggestionType.analyze,
          message:
              'Detectei estruturas lineares suficientes para gerar um gráfico.',
        ),
      );
    }

    // 4️⃣ Exportação sempre disponível
    suggestions.add(
      CopilotSuggestion(
        type: CopilotSuggestionType.export,
        message: 'Deseja exportar o estado atual?',
        payload: {
          'formats': ['png', 'pdf', 'svg', 'latex'],
        },
      ),
    );

    return suggestions;
  }

  /// Análise híbrida: local + IA (opcional)
  Future<List<CopilotSuggestion>> analyzeWithAi({
    required CopilotContext context,
    required String userInput,
  }) async {
    final suggestions = analyze(context);

    // Resumo mínimo para IA (nunca estado bruto)
    final aiRequest = AiRequest(
      userInput: userInput,
      context: {
        'shapes_total': context.shapes.length,
        'free_shapes': context.shapes
            .where((s) => s.type == ShapeType.free)
            .length,
        'derived_formats':
            context.derived.map((d) => d.format).toList(),
      },
    );

    try {
      final aiResponse = await _ai.suggest(aiRequest);

      if (aiResponse.message.isNotEmpty) {
        suggestions.add(
          CopilotSuggestion(
            type: CopilotSuggestionType.hint,
            message: aiResponse.message,
            payload: aiResponse.suggestion,
          ),
        );
      }
    } catch (_) {
      // Falha da IA nunca quebra o app
    }

    return suggestions;
  }
}
