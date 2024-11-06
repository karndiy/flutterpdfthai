import 'dart:io';  // Ensure this import is included
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
  
  // Method to handle text input and save it as PDF
  void _onTextChanged(String text) async {
    await _pdfModel.createPdfFromText(text);
    setState(() {}); // Update the view after creating the PDF
  }

  // Method to preview the PDF
  void _onPreviewPressed() async {
    if (_pdfModel.pdfPath != null) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PdfViewerPage(pdfPath: _pdfModel.pdfPath!),
        ),
      );
    }
  }

  // Method to print the PDF
  void _onPrintPressed() async {
    if (_pdfModel.pdfPath != null) {
      final file = File(_pdfModel.pdfPath!);
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
      onTextChanged: _onTextChanged,
      onPrintPressed: _onPrintPressed,
      onPreviewPressed: _onPreviewPressed,
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
