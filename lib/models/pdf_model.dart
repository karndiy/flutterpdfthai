import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart'; // Add this import to use rootBundle

class PdfModel {
  String? _pdfPath;

  Future<String> createPdfFromText(String text) async {
    //final directory = await getApplicationDocumentsDirectory();
    final directory = Directory.current;
    final filePath = '${directory.path}/pdf/saved_pdf.pdf';

    // Define the page size (80mm x 80mm)
   // final pageFormat = pw.PdfPageFormat(80 * PdfPageFormat.mm, 80 * PdfPageFormat.mm);

    // Load custom font (THSarabunNew)
    final fontData = await rootBundle.load('assets/fonts/THSarabunNew.ttf');
    final ttf = pw.Font.ttf(fontData);

    
    print('File will be saved at: $filePath');


    final pdf = pw.Document();

    print(filePath);
    pdf.addPage(
      pw.Page(
        //pageFormat: pageFormat, // Set the custom page size
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Text(text, style: pw.TextStyle(font: ttf,fontSize: 24)),
       
          );
        },
      ),
    );

    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());
    _pdfPath = filePath;

    return filePath;
  }

  String? get pdfPath => _pdfPath;
}
