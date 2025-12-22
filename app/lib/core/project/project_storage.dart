import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'project.dart';
import 'derived_file.dart';

class ProjectStorage {
  Future<Directory> _baseDir() async {
    final dir = await getApplicationDocumentsDirectory();
    final base = Directory('${dir.path}/projects');
    if (!await base.exists()) {
      await base.create(recursive: true);
    }
    return base;
  }

  Future<void> saveProject(Project project) async {
    final base = await _baseDir();
    final projectDir = Directory('${base.path}/${project.id}');
    if (!await projectDir.exists()) {
      await projectDir.create(recursive: true);
    }

    final file = File('${projectDir.path}/project.json');
    await file.writeAsString(
      jsonEncode(project.toJson()),
    );
  }

  Future<Project> loadProject(String projectId) async {
    final base = await _baseDir();
    final file = File('${base.path}/$projectId/project.json');

    if (!await file.exists()) {
      throw Exception('Project not found');
    }

    final content = await file.readAsString();
    return Project.fromJson(jsonDecode(content));
  }

  Future<void> addDerived(
    String projectId,
    DerivedFile derived,
  ) async {
    final project = await loadProject(projectId);
    project.derived.add(derived);
    await saveProject(project);
  }

  Future<List<String>> listProjects() async {
    final base = await _baseDir();
    final dirs = base.listSync().whereType<Directory>();
    return dirs.map((d) => d.path.split('/').last).toList();
  }
}
