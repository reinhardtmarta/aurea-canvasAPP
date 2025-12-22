import 'source_file.dart';
import 'derived_file.dart';

class Project {
  final String id;
  final SourceFile source;
  final List<DerivedFile> derived;

  Project({
    required this.id,
    required this.source,
    List<DerivedFile>? derived,
  }) : derived = derived ?? [];

  Map<String, dynamic> toJson() => {
        'id': id,
        'source': source.toJson(),
        'derived': derived.map((d) => d.toJson()).toList(),
      };

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'],
      source: SourceFile.fromJson(json['source']),
      derived: (json['derived'] as List)
          .map((e) => DerivedFile.fromJson(e))
          .toList(),
    );
  }
}
