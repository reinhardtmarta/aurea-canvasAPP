enum BootIntentType {
  geometry,
  unknown,
}

class BootIntent {
  final BootIntentType type;
  final String raw;

  BootIntent({
    required this.type,
    required this.raw,
  });
}

class IntentParser {
  List<BootIntent> parse(String input) {
    final text = input.toLowerCase();

    final intents = <BootIntent>[];

    if (_looksLikeGeometry(text)) {
      intents.add(
        BootIntent(
          type: BootIntentType.geometry,
          raw: input,
        ),
      );
    }

    if (intents.isEmpty) {
      intents.add(
        BootIntent(
          type: BootIntentType.unknown,
          raw: input,
        ),
      );
    }

    return intents;
  }

  bool _looksLikeGeometry(String text) {
    return text.contains('linha') ||
        text.contains('reta') ||
        text.contains('círculo') ||
        text.contains('circle') ||
        text.contains('eixo') ||
        text.contains('axis');
  }
}
