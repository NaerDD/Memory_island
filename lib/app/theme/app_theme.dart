import 'package:flutter/material.dart';

ThemeData buildAppTheme() {
  const text = Color(0xFF224158);
  const muted = Color(0xFF6E8798);

  final scheme = ColorScheme.fromSeed(
    seedColor: const Color(0xFF2FC8C2),
    brightness: Brightness.light,
    primary: const Color(0xFF2FC8C2),
    secondary: const Color(0xFF3B8CFF),
    surface: const Color(0xFFFFF8EB),
  );

  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: const Color(0xFFFFF4D8),
    colorScheme: scheme,
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white.withValues(alpha: 0.62),
      hintStyle: const TextStyle(
        color: muted,
        fontSize: 14,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(22),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(22),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(22),
        borderSide: const BorderSide(color: Color(0xFF2FC8C2), width: 1.4),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: const Color(0xFF2FC8C2),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
        ),
      ),
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: Color(0xFF224158),
      contentTextStyle: TextStyle(color: Colors.white),
      behavior: SnackBarBehavior.floating,
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 34,
        fontWeight: FontWeight.w800,
        color: text,
        height: 0.96,
      ),
      headlineMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w800,
        color: text,
        height: 1,
      ),
      titleLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w800,
        color: text,
      ),
      bodyLarge: TextStyle(
        fontSize: 15,
        color: muted,
        height: 1.6,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: muted,
        height: 1.5,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: muted,
      ),
    ),
  );
}
