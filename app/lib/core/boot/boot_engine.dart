import 'boot_parser.dart';
import 'boot_intent.dart';
import '../project/source_file.dart';
import '../project/derived_file.dart';
import 'dart:math';

class BootEngine {
  final _parser = BootParser();

  BootIntent parseInput(String input) {
    return _parser.parse(input);
  }

  DerivedFile execute(SourceFile source, BootIntent intent) {
    if (intent.type == BootIntentType.unknown) {
      throw Exception('Intent not recognized');
    }

    return DerivedFile(
      id: _generateId(),
      sourceId: source.id,
      format: intent.targetFormat ?? 'unknown',
      createdAt: DateTime.now(),
      content: 'Generated ${intent.targetFormat ?? 'content'}',
      meta: {
        'intent': intent.type.name,
        'raw': true,
      },
    );
  }

  String _generateId() {
    return Random().nextInt(999999999).toString();
  }
}
