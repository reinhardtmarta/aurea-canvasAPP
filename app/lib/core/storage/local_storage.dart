import 'dart:io';
import 'package:path_provider/path_provider.dart';

class LocalStorageService {
  /// Diretório base do app (local, privado)
  Future<Directory> _baseDir() async {
    final dir = await getApplicationDocumentsDirectory();
    final base = Directory('${dir.path}/aurea_canvas');
    if (!await base.exists()) {
      await base.create(recursive: true);
    }
    return base;
  }

  /// Salva qualquer arquivo de texto
  Future<File> saveFile({
    required String fileName,
    required String content,
  }) async {
    final dir = await _baseDir();
    final file = File('${dir.path}/$fileName');
    return file.writeAsString(content);
  }

  /// Lê arquivo existente
  Future<String> readFile(String fileName) async {
    final dir = await _baseDir();
    final file = File('${dir.path}/$fileName');
    return file.readAsString();
  }

  /// Lista arquivos salvos
  Future<List<FileSystemEntity>> listFiles() async {
    final dir = await _baseDir();
    return dir.listSync();
  }
}
