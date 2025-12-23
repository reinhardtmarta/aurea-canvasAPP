import '../geometry/geometry_shape.dart';

/// Documento bruto criado pelo usuário
class SourceFile {
  final String id;
  final SourceType type;
  final String content;
  final DateTime createdAt;

  SourceFile({
    required this.id,
    required this.type,
    required this.content,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}

enum SourceType {
  sketch,
  text,
  code,
  latex,
  image,
}

/// Documento derivado (tradução, análise, exportação)
class DerivedFile {
  final String id;
  final DerivedFormat format;
  final String content;
  final String sourceId;
  final DateTime createdAt;

  DerivedFile({
    required this.id,
    required this.format,
    required this.content,
    required this.sourceId,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}

enum DerivedFormat {
  latex,
  svg,
  png,
  pdf,
  markdown,
  analysis,
}

/// Contexto cognitivo do Copilot
/// Ele representa o "estado mental" do usuário no canvas
class CopilotContext {
  final List<GeometryShape> shapes; // Canvas não linear
  final List<SourceFile> sources;   // Conteúdo bruto
  final List<DerivedFile> derived;  // Traduções / análises

  CopilotContext({
    required this.shapes,
    required this.sources,
    required this.derived,
  });

  /// Contexto vazio inicial
  factory CopilotContext.empty() {
    return CopilotContext(
      shapes: [],
      sources: [],
      derived: [],
    );
  }

  /// Atualização segura e imutável
  CopilotContext copyWith({
    List<GeometryShape>? shapes,
    List<SourceFile>? sources,
    List<DerivedFile>? derived,
  }) {
    return CopilotContext(
      shapes: shapes ?? this.shapes,
      sources: sources ?? this.sources,
      derived: derived ?? this.derived,
    );
  }

  /// Adiciona fonte sem sobrescrever nada
  CopilotContext addSource(SourceFile source) {
    return copyWith(
      sources: [...sources, source],
    );
  }

  /// Adiciona derivado mantendo o original intacto
  CopilotContext addDerived(DerivedFile file) {
    return copyWith(
      derived: [...derived, file],
    );
  }

  /// Limpa apenas derivados (nunca apaga esboços)
  CopilotContext clearDerived() {
    return copyWith(derived: []);
  }
}
