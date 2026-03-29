import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'screen/stock_list_screen.dart';

void main() {
  runApp(const PocketFlowApp());
}

class PocketFlowApp extends StatelessWidget {
  const PocketFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PocketFlow',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('th'),
        Locale('en'),
      ],
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const StockListScreen(),
    );
  }
}
