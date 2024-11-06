import 'dart:io';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter PDF Reader',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PdfEditorPage(),
    );
  }
}

class PdfEditorPage extends StatefulWidget {
  const PdfEditorPage({Key? key}) : super(key: key);

  @override
  State<PdfEditorPage> createState() => _PdfEditorPageState();
}

class _PdfEditorPageState extends State<PdfEditorPage> {
  final TextEditingController _textController = TextEditingController();
  String? _pdfPath;
  String? _lastPdfPath;

  // Method to save the text to a PDF file
  Future<void> _saveTextAsPdf(String text) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/last_saved_pdf.pdf';

    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Text(text, style: pw.TextStyle(fontSize: 24)),
          ); // Center the text on the page
        },
      ),
    );

    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());
    setState(() {
      _pdfPath = filePath;
      _lastPdfPath = filePath;  // Save the last generated PDF path
    });
  }

  // Method to preview the last saved PDF
  Future<void> _previewPdf() async {
    if (_lastPdfPath != null) {
      // Show PDF viewer
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PdfViewerPage(pdfPath: _lastPdfPath!),
        ),
      );
    }
  }

  // Method to print the PDF before preview
  Future<void> _printPdf() async {
    if (_pdfPath != null) {
      final file = File(_pdfPath!);
      final pdfBytes = await file.readAsBytes();  // Read the file as bytes
      
      // Printing the PDF
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdfBytes,
      );

      print("PDF sent to printer");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PDF Editor & Preview"),
        actions: [
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: _printPdf,  // Print the PDF
          ),
          IconButton(
            icon: const Icon(Icons.preview),
            onPressed: _previewPdf,  // Preview the last saved PDF
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _textController,
              maxLines: null,
              decoration: const InputDecoration(
                hintText: 'Enter text to save as PDF...',
                border: OutlineInputBorder(),
              ),
              onChanged: (text) {
                _saveTextAsPdf(text);  // Auto-save text as PDF when changed
              },
            ),
            if (_pdfPath != null)
              Column(
                children: [
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _previewPdf,  // Preview the PDF
                    child: const Text("Preview PDF"),
                  ),
                  ElevatedButton(
                    onPressed: _printPdf,  // Print the PDF
                    child: const Text("Print PDF"),
                  ),
                ],
              ),
          ],
        ),
      ),
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
      body: SfPdfViewer.file(File(pdfPath)),  // Display the PDF file
    );
  }
}
