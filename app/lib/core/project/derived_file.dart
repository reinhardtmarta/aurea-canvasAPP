class DerivedFile {
  final String id;
  final String sourceId;
  final String format;
  final DateTime createdAt;
  final String content;
  final Map<String, dynamic>? meta;

  DerivedFile({
    required this.id,
    required this.sourceId,
    required this.format,
    required this.createdAt,
    required this.content,
    this.meta,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'sourceId': sourceId,
        'format': format,
        'createdAt': createdAt.toIso8601String(),
        'content': content,
        'meta': meta,
      };

  factory DerivedFile.fromJson(Map<String, dynamic> json) {
    return DerivedFile(
      id: json['id'],
      sourceId: json['sourceId'],
      format: json['format'],
      createdAt: DateTime.parse(json['createdAt']),
      content: json['content'],
      meta: json['meta'],
    );
  }
}
