import 'dart:ui' as ui;
import 'dart:typed_data';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/rendering.dart';

class PngExporter {
  Future<File> export(
    GlobalKey repaintKey,
    String fileName,
  ) async {
    final boundary = repaintKey.currentContext!
        .findRenderObject() as RenderRepaintBoundary;

    final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    final byteData =
        await image.toByteData(format: ui.ImageByteFormat.png);

    final pngBytes = byteData!.buffer.asUint8List();

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$fileName.png');

    return file.writeAsBytes(pngBytes);
  }
}
