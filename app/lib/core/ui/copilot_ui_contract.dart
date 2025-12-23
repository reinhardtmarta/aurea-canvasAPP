import '../copilot/copilot_context.dart';
import '../copilot/copilot_suggestion.dart';
import '../boot/boot_orchestrator.dart';
import '../export/export_pipeline.dart';

/// Contrato único entre UI e Core
/// A UI nunca acessa engines diretamente
abstract class CopilotUIContract {
  /// Estado atual (imutável)
  CopilotContext get context;

  /// Atualização de canvas (desenho não linear)
  void updateShapes(List<dynamic> rawShapes);

  /// Entrada linear do usuário (texto)
  void submitLinearInput(String text);

  /// Sugestões do copilot (bot nativo)
  List<CopilotSuggestion> getSuggestions();

  /// Exportação explícita
  ExportResult export(ExportFormat format);

  /// Limpa apenas derivados
  void clearDerived();
}
