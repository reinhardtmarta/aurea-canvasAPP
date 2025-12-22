class SourceFile {
  final String id;
  final DateTime createdAt;
  final String type; // drawing, text, image
  final dynamic payload;

  SourceFile({
    required this.id,
    required this.createdAt,
    required this.type,
    required this.payload,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'createdAt': createdAt.toIso8601String(),
        'type': type,
        'payload': payload,
      };

  factory SourceFile.fromJson(Map<String, dynamic> json) {
    return SourceFile(
      id: json['id'],
      createdAt: DateTime.parse(json['createdAt']),
      type: json['type'],
      payload: json['payload'],
    );
  }
}
