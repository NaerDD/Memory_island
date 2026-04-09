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
