import '../project/source_file.dart';
import '../project/derived_file.dart';
import 'boot_intent.dart';
import 'dart:math';

class BootEngine {
  DerivedFile execute(SourceFile source, BootIntent intent) {
    // Placeholder lógico — IA vem depois
    return DerivedFile(
      id: _generateId(),
      sourceId: source.id,
      format: intent.targetFormat,
      createdAt: DateTime.now(),
      content: "Generated ${intent.targetFormat} content",
      meta: {
        'intent': intent.type.name,
        'generatedBy': 'boot',
      },
    );
  }

  String _generateId() {
    return Random().nextInt(999999999).toString();
  }
}
