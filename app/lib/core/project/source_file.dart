import 'dart:convert';
import '../project/source_file.dart';
import 'local_storage.dart';

final storage = LocalStorageService();

Future<void> saveSource(SourceFile source) async {
  await storage.saveFile(
    fileName: '${source.id}.source.json',
    content: source.toJson(),
  );
}
class SourceFile {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;

  /// Conteúdo bruto do usuário
  final Map<String, dynamic> payload;

  SourceFile({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.payload,
  });

  SourceFile copyWith({
    DateTime? updatedAt,
    Map<String, dynamic>? payload,
  }) {
    return SourceFile(
      id: id,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      payload: payload ?? this.payload,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': 'source',
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'payload': payload,
    };
  }

  factory SourceFile.fromMap(Map<String, dynamic> map) {
    return SourceFile(
      id: map['id'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      payload: Map<String, dynamic>.from(map['payload']),
    );
  }

  String toJson() => jsonEncode(toMap());

  factory SourceFile.fromJson(String source) =>
      SourceFile.fromMap(jsonDecode(source));
}
