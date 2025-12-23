import 'copilot_ui_contract.dart';
import '../copilot/copilot_controller.dart';
import '../copilot/copilot_context.dart';
import '../boot/boot_orchestrator.dart';
import '../export/export_pipeline.dart';
import '../geometry/geometry_shape.dart';

class CopilotUIController implements CopilotUIContract {
  final CopilotController _copilot;
  final BootOrchestrator _boot;
  final ExportPipeline _exporter;

  CopilotContext _context;

  CopilotUIController({
    CopilotContext? initialContext,
    BootOrchestrator? boot,
    ExportPipeline? exporter,
  })  : _context = initialContext ?? CopilotContext.empty(),
        _boot = boot ?? BootOrchestrator(),
        _exporter = exporter ?? ExportPipeline(),
        _copilot = CopilotController(
          context: initialContext ?? CopilotContext.empty(),
        );

  @override
  CopilotContext get context => _context;

  @override
  void updateShapes(List<dynamic> rawShapes) {
    // UI converte para GeometryShape
    final shapes = rawShapes.cast<GeometryShape>();

    _context = _context.copyWith(shapes: shapes);
    _copilot.updateContext(_context);
  }

  @override
  void submitLinearInput(String text) {
    // Salva fonte original
    _context = _context.addSource(
      SourceFile(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: SourceType.text,
        content: text,
      ),
    );

    // Boot gera derivados
    final derived =
        _boot.handleLinearInput(text: text, context: _context);

    for (final d in derived) {
      _context = _context.addDerived(d);
    }

    _copilot.updateContext(_context);
  }

  @override
  List<CopilotSuggestion> getSuggestions() {
    return _copilot.getSuggestions();
  }

  @override
  ExportResult export(ExportFormat format) {
    return _exporter.export(
      context: _context,
      format: format,
    );
  }

  @override
  void clearDerived() {
    _context = _context.clearDerived();
    _copilot.updateContext(_context);
  }
}
