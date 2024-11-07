import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';

class PdfModel {
  String? _pdfPath;

  Future<String> createPdfFromText(String text) async {
    final directory = Directory.current;
    final pdfDirectory = Directory('${directory.path}/pdf');

    // Ensure the PDF directory exists
    if (!await pdfDirectory.exists()) {
      await pdfDirectory.create(recursive: true);
    }

    final filePath = '${pdfDirectory.path}/saved_pdf.pdf';

    // Load custom font (THSarabunNew)
    final fontData = await rootBundle.load('assets/fonts/THSarabunNew.ttf');
    final ttf = pw.Font.ttf(fontData);

    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Text(text, style: pw.TextStyle(font: ttf, fontSize: 24)),
          );
        },
      ),
    );

    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());
    _pdfPath = filePath;

    print('File saved at: $filePath'); // Debugging output

    return filePath;
  }

  String? get pdfPath => _pdfPath;
}
