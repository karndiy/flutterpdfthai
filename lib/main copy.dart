import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PDF Print & Preview Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PrintPreviewScreen(),
    );
  }
}

class PrintPreviewScreen extends StatefulWidget {
  @override
  _PrintPreviewScreenState createState() => _PrintPreviewScreenState();
}

class _PrintPreviewScreenState extends State<PrintPreviewScreen> {
  final TextEditingController _textController = TextEditingController();
  String xpath = "";

  // Function to create and save the PDF document
  Future<File> createAndSavePdfDocument(String text) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Text(
              text,
              style: pw.TextStyle(fontSize: 40),
            ),
          );
        },
      ),
    );

    // Save PDF to a file in the project's documents directory
    final outputDir = await getApplicationDocumentsDirectory();
    xpath = '${outputDir.path}/GeneratedDocument.pdf';
    print(xpath); // Print file path to console
    final outputFile = File(xpath);
    await outputFile.writeAsBytes(await pdf.save());

    return outputFile;
  }

  // Function to save, then preview the PDF
  void saveAndPreviewPdf(BuildContext context) async {
    final text = _textController.text;

    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter text to print.")),
      );
      return;
    }

    try {
      // Create and save the PDF file
      final savedPdfFile = await createAndSavePdfDocument(text);

      // Show a message indicating the PDF was saved successfully
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("PDF saved successfully!")),
      );

      // Display the preview of the saved PDF file
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => savedPdfFile.readAsBytesSync(),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving PDF: $e")),
      );
    }
  }

  // Function to pick a PDF file and preview it
  Future<void> pickAndPreviewPdf() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);

        // Display the selected PDF file
        await Printing.layoutPdf(
          onLayout: (PdfPageFormat format) async => file.readAsBytesSync(),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("No PDF file selected.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error reading PDF file: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("PDF Print & Preview Example")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                labelText: "Enter text for PDF",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => saveAndPreviewPdf(context),
              child: Text("Save & Preview PDF"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: pickAndPreviewPdf,
              child: Text("Select & Preview Existing PDF"),
            ),
          ],
        ),
      ),
    );
  }
}
