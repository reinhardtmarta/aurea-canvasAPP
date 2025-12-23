import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import '../geometry/geometry_shape.dart';

class PdfExporter {
  Future<File> export(
    List<GeometryShape> shapes,
    String fileName,
  ) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (context) {
          return pw.CustomPaint(
            painter: (pw.Canvas canvas, pw.Size size) {
              for (final s in shapes) {
                if (s.type == ShapeType.line) {
                  final a = s.data['start'];
                  final b = s.data['end'];
                  canvas.drawLine(
                    pw.Offset(a.dx, a.dy),
                    pw.Offset(b.dx, b.dy),
                    pw.Paint(),
                  );
                }

                if (s.type == ShapeType.circle) {
                  final c = s.data['center'];
                  final r = s.data['radius'];
                  canvas.drawEllipse(
                    pw.Rect.fromCircle(
                      center: pw.Offset(c.dx, c.dy),
                      radius: r,
                    ),
                    pw.Paint(),
                  );
                }
              }
            },
          );
        },
      ),
    );

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$fileName.pdf');
    await file.writeAsBytes(await pdf.save());
    return file;
  }
}
