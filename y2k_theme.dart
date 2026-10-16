import 'package:flutter/material.dart';

class Y2kTheme {
  // Bảng màu Y2K Dark Cyber Gothic ma mị
  static const Color background = Color(0xFF0A0C12);
  static const Color surface = Color(0xFF121520);
  static const Color surfaceElevated = Color(0xFF1B1F2E);
  static const Color borderDark = Color(0xFF282D42);

  // Neon Xanh & Tím u buồn
  static const Color neonCyan = Color(0xFF00F0FF);
  static const Color neonPurple = Color(0xFFB026FF);
  static const Color eerieViolet = Color(0xFF7928CA);
  static const Color soulGreen = Color(0xFF00FFA3);
  static const Color warningCrimson = Color(0xFFFF2A6D);
  static const Color textMuted = Color(0xFF8A93AA);
  static const Color textBright = Color(0xFFF1F5F9);

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      primaryColor: neonPurple,
      colorScheme: const ColorScheme.dark(
        primary: neonPurple,
        secondary: neonCyan,
        surface: surface,
        error: warningCrimson,
        onPrimary: Colors.black,
        onSecondary: Colors.black,
        onSurface: textBright,
      ),
      fontFamily: 'monospace',
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: neonCyan,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          letterSpacing: 2.0,
          shadows: [
            Shadow(color: neonCyan, blurRadius: 10),
          ],
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: surfaceElevated,
          foregroundColor: neonCyan,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
            side: const BorderSide(color: neonCyan, width: 1.5),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: borderDark),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: borderDark),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: neonPurple, width: 2),
        ),
        hintStyle: const TextStyle(color: textMuted, fontSize: 13),
        labelStyle: const TextStyle(color: neonCyan),
      ),
    );
  }
}
