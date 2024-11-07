import 'package:flutter/material.dart';
import 'controllers/pdf_controller.dart';
import 'package:flutter_localizations/flutter_localizations.dart';  // Add this import

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter PDF Reader',
      locale: Locale('th', 'TH'), // Set the locale to Thai (Thailand)
      supportedLocales: [
        Locale('en', 'US'), // English
        Locale('th', 'TH'), // Thai
      ],
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PdfController(),
    );
  }
}
