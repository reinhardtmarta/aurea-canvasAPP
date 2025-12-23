import '../copilot/copilot_context.dart';
import 'intent_parser.dart';
import 'translators/linear_to_geometry.dart';

class BootOrchestrator {
  final IntentParser _parser;
  final LinearToGeometryTranslator _geometryTranslator;

  BootOrchestrator({
    IntentParser? parser,
    LinearToGeometryTranslator? geometryTranslator,
  })  : _parser = parser ?? IntentParser(),
        _geometryTranslator =
            geometryTranslator ?? LinearToGeometryTranslator();

  /// Entrada única do boot
  /// Nunca altera contexto, apenas produz derivados
  List<DerivedFile> handleLinearInput({
    required String text,
    required CopilotContext context,
  }) {
    final intents = _parser.parse(text);

    final List<DerivedFile> results = [];

    for (final intent in intents) {
      switch (intent.type) {
        case BootIntentType.geometry:
          final derived =
              _geometryTranslator.translate(intent, context);
          if (derived != null) results.add(derived);
          break;

        case BootIntentType.unknown:
          break;
      }
    }

    return results;
  }
}
