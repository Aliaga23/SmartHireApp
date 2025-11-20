import 'package:flutter/material.dart';

class AppTheme {
  // Colors - SmartHire Brand Colors
  static const Color primaryColor = Color(0xFF0A1828); // Dark background
  static const Color secondaryColor = Color(0xFF0F2638); // Slightly lighter dark
  static const Color accentColor = Color(0xFF14324A); // Card background
  static const Color highlightColor = Color(0xFF00BCD4); // Cyan accent
  static const Color errorColor = Color(0xFFE94560);
  static const Color successColor = Color(0xFF00BCD4);
  static const Color textPrimaryColor = Color(0xFFFFFFFF);
  static const Color textSecondaryColor = Color(0xFF8B9DAF);
  static const Color cardColor = Color(0xFF14324A);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: primaryColor,
      colorScheme: const ColorScheme.dark(
        primary: highlightColor,
        secondary: accentColor,
        surface: secondaryColor,
        error: errorColor,
      ),
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: accentColor.withOpacity(0.5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: accentColor.withOpacity(0.3), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: highlightColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: errorColor, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: errorColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        hintStyle: TextStyle(color: textSecondaryColor.withOpacity(0.6)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: highlightColor,
          foregroundColor: textPrimaryColor,
          elevation: 8,
          shadowColor: highlightColor.withOpacity(0.5),
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}
