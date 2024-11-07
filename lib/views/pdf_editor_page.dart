import 'package:flutter/material.dart';

class PdfView extends StatelessWidget {
  final TextEditingController textController;
  final Function(String) onTextChanged;
  final Function() onPrintPressed;
  final Function() onPreviewPressed;
  final String? pdfPath;

  const PdfView({
    Key? key,
    required this.textController,
    required this.onTextChanged,
    required this.onPrintPressed,
    required this.onPreviewPressed,
    this.pdfPath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PDF Editor & Preview"),
        actions: [
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: onPrintPressed,
            tooltip: 'Print PDF',
          ),
          IconButton(
            icon: const Icon(Icons.preview),
            onPressed: onPreviewPressed,
            tooltip: 'Preview PDF',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(
                'Enter the text below to save as a PDF:',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: textController,
                  maxLines: null,
                  textInputAction: TextInputAction.done,
                  decoration: const InputDecoration(
                    hintText: 'Enter text to save as PDF...',
                    border: InputBorder.none,
                  ),
                  onChanged: onTextChanged,
                  style: const TextStyle(fontSize: 16.0),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Display PDF Path
            if (pdfPath != null) // Only show if pdfPath is available
              Text(
                'PDF saved at: $pdfPath',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: onPrintPressed,
                  icon: const Icon(Icons.print),
                  label: const Text('Print'),
                ),
                ElevatedButton.icon(
                  onPressed: onPreviewPressed,
                  icon: const Icon(Icons.preview),
                  label: const Text('Preview'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
