import 'source_file.dart';
import 'derived_file.dart';

class AureaProject {
  final SourceFile source;
  final List<DerivedFile> derived;

  AureaProject({
    required this.source,
    required this.derived,
  });

  AureaProject addDerived(DerivedFile file) {
    return AureaProject(
      source: source,
      derived: [...derived, file],
    );
  }
}
