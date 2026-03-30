import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Color(0xFF00B4D8);
  static const Color secondary = Color(0xFF0077B6);

  // 🌞 LIGHT
  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primary,
      scaffoldBackgroundColor: const Color(0xFFF5F7FA),

      colorScheme: const ColorScheme.light(
        primary: primary,
        secondary: secondary,
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),

      // ✅ FIX ตรงนี้
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),

      textTheme: const TextTheme(
        bodyMedium: TextStyle(color: Colors.black87),
      ),
    );
  }

  // 🌙 DARK
  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: primary,
      scaffoldBackgroundColor: const Color(0xFF0D1117),

      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: secondary,
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF0D1117),
        foregroundColor: Colors.white,
        elevation: 0,
      ),

      // ✅ FIX ตรงนี้
      cardTheme: CardThemeData(
        color: const Color(0xFF161B22),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),

      textTheme: const TextTheme(
        bodyMedium: TextStyle(color: Colors.white70),
      ),
    );
  }
}
