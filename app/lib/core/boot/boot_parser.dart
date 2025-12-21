import 'boot_intent.dart';
import 'boot_formats.dart';

class BootParser {
  BootIntent parse(String input) {
    final text = input.toLowerCase().trim();

    if (text.isEmpty) {
      return BootIntent(type: BootIntentType.unknown);
    }

    // 1. Detectar intenção
    final intentType = _detectIntent(text);

    // 2. Detectar formato alvo
    final format = _detectFormat(text);

    return BootIntent(
      type: intentType,
      targetFormat: format,
      needsConfirmation: intentType == BootIntentType.export,
    );
  }

  BootIntentType _detectIntent(String text) {
    if (_containsAny(text, ['traduz', 'transforma', 'converte', 'gera'])) {
      return BootIntentType.translate;
    }

    if (_containsAny(text, ['exporta', 'salva', 'baixar'])) {
      return BootIntentType.export;
    }

    if (_containsAny(text, ['analisa', 'padrão', 'estrutura'])) {
      return BootIntentType.analyze;
    }

    return BootIntentType.unknown;
  }

  String? _detectFormat(String text) {
    for (final entry in supportedFormats.entries) {
      for (final keyword in entry.value) {
        if (text.contains(keyword)) {
          return entry.key;
        }
      }
    }
    return null;
  }

  bool _containsAny(String text, List<String> keywords) {
    return keywords.any(text.contains);
  }
}
