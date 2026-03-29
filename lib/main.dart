import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; // 👈 สำคัญมาก

import 'screen/stock/stock_list_screen.dart';
import 'l10n/app_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PocketFlow',

      // 🌍 รองรับภาษา
      supportedLocales: const [
        Locale('th'),
        Locale('en'),
      ],

      localizationsDelegates: const [
        AppLocalizations.delegate,

        // 👇 🔥 ต้องมี 3 ตัวนี้
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      // 🌙 Dark Theme
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0D1117),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF161B22),
        ),
      ),

      home: const StockListScreen(),
    );
  }
}
