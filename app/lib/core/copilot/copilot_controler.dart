import 'copilot_engine.dart';
import 'copilot_context.dart';
import 'copilot_suggestion.dart';
import '../ai/ai_adapter.dart';

/// Controller fino.
/// - Orquestra CopilotEngine
/// - Expõe estado para UI
/// - Nunca executa ações
class CopilotController {
  final CopilotEngine _engine;

  CopilotContext _context;

  CopilotController({
    required CopilotContext context,
    AiAdapter? aiAdapter,
  })  : _context = context,
        _engine = CopilotEngine(ai: aiAdapter);

  /// Snapshot imutável do contexto atual
  CopilotContext get context => _context;

  /// Atualiza apenas o estado (ex: novo desenho, novo texto)
  void updateContext(CopilotContext newContext) {
    _context = newContext;
  }

  /// Sugestões locais (rápidas, offline)
  List<CopilotSuggestion> getSuggestions() {
    return _engine.analyze(_context);
  }

  /// Sugestões híbridas (local + IA opcional)
  Future<List<CopilotSuggestion>> getSuggestionsWithAi({
    required String userInput,
  }) async {
    return _engine.analyzeWithAi(
      context: _context,
      userInput: userInput,
    );
  }

  /// Reset lógico (não apaga arquivos)
  void resetDerived() {
    _context = _context.copyWith(
      derived: [],
    );
  }
}
