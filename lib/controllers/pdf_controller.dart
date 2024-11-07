import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:file_picker/file_picker.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../models/pdf_model.dart';
import '../views/pdf_editor_page.dart';

class PdfController extends StatefulWidget {
  @override
  _PdfControllerState createState() => _PdfControllerState();
}

class _PdfControllerState extends State<PdfController> {
  final TextEditingController _textController = TextEditingController();
  final PdfModel _pdfModel = PdfModel();
  String? pdfPath;
  
  // Method to create the PDF and save the path
  Future<void> _createPdf() async {
    final text = _textController.text;
    final path = await _pdfModel.createPdfFromText(text);
    setState(() {
      pdfPath = path;
    });
  }

  // Method to preview the PDF
  void _onPreviewPressed() async {
    await _createPdf();
    if (pdfPath != null) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PdfViewerPage(pdfPath: pdfPath!),
        ),
      );
    }
  }

  // Method to print the PDF
  void _onPrintPressed() async {
    await _createPdf();
    if (pdfPath != null) {
      final file = File(pdfPath!);
      final pdfBytes = await file.readAsBytes();
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdfBytes,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PdfView(
      textController: _textController,
      onTextChanged: (text) {}, // Not calling create PDF on text change
      onPrintPressed: _onPrintPressed,
      onPreviewPressed: _onPreviewPressed,
      pdfPath: pdfPath, // Pass the pdfPath to the PdfView
    );
  }
}

class PdfViewerPage extends StatelessWidget {
  final String pdfPath;

  const PdfViewerPage({Key? key, required this.pdfPath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("PDF Preview")),
      body: SfPdfViewer.file(File(pdfPath)),
    );
  }
}
