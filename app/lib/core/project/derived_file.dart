import 'dart:convert';

class DerivedFile {
  final String id;
  final String sourceId;
  final String format; // latex, markdown, png, json, code...
  final DateTime createdAt;

  /// Conteúdo traduzido pelo boot
  final dynamic content;

  /// Metadata de rastreabilidade
  final Map<String, dynamic> meta;

  DerivedFile({
    required this.id,
    required this.sourceId,
    required this.format,
    required this.createdAt,
    required this.content,
    required this.meta,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': 'derived',
      'sourceId': sourceId,
      'format': format,
      'createdAt': createdAt.toIso8601String(),
      'content': content,
      'meta': meta,
    };
  }

  factory DerivedFile.fromMap(Map<String, dynamic> map) {
    return DerivedFile(
      id: map['id'],
      sourceId: map['sourceId'],
      format: map['format'],
      createdAt: DateTime.parse(map['createdAt']),
      content: map['content'],
      meta: Map<String, dynamic>.from(map['meta']),
    );
  }

  String toJson() => jsonEncode(toMap());

  factory DerivedFile.fromJson(String source) =>
      DerivedFile.fromMap(jsonDecode(source));
}
