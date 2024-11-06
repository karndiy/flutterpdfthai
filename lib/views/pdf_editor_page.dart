import 'package:flutter/material.dart';

class PdfView extends StatelessWidget {
  final TextEditingController textController;
  final Function(String) onTextChanged;
  final Function() onPrintPressed;
  final Function() onPreviewPressed;

  const PdfView({
    Key? key,
    required this.textController,
    required this.onTextChanged,
    required this.onPrintPressed,
    required this.onPreviewPressed,
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
            // Title or description (Fixed with titleLarge)
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(
                'Enter the text below to save as a PDF:',
                style: Theme.of(context).textTheme.titleLarge, // Fixed to titleLarge
              ),
            ),
            // Text input field inside a Card for material design
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: textController,
                  maxLines: null, // allows multiple lines
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
            // Buttons for Print and Preview
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: onPrintPressed,
                  icon: const Icon(Icons.print),
                  label: const Text('Print'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(120, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: onPreviewPressed,
                  icon: const Icon(Icons.preview),
                  label: const Text('Preview'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(120, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
