import 'package:flutter/material.dart';

class AppColors {
  static const ink = Color(0xFF13364D);
  static const mutedInk = Color(0xFF5E768A);
  static const shell = Color(0xFFF9F3E6);
  static const sand = Color(0xFFF5E5C2);
  static const mist = Color(0xFFDDF3F2);
  static const sea = Color(0xFF43C4CF);
  static const seaDeep = Color(0xFF1C6E89);
  static const coral = Color(0xFFFF8C69);
  static const gold = Color(0xFFFFC96C);
  static const leaf = Color(0xFF87C96C);
}

ThemeData buildAppTheme() {
  const outline = Color(0x33FFFFFF);

  const scheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.seaDeep,
    onPrimary: Colors.white,
    secondary: AppColors.sea,
    onSecondary: Colors.white,
    error: Color(0xFFB93A32),
    onError: Colors.white,
    surface: AppColors.shell,
    onSurface: AppColors.ink,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: AppColors.shell,
    splashFactory: InkSparkle.splashFactory,
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 38,
        fontWeight: FontWeight.w800,
        color: AppColors.ink,
        height: 0.96,
        letterSpacing: -1.2,
      ),
      headlineMedium: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.w800,
        color: AppColors.ink,
        height: 1.0,
        letterSpacing: -0.8,
      ),
      titleLarge: TextStyle(
        fontSize: 21,
        fontWeight: FontWeight.w700,
        color: AppColors.ink,
        height: 1.12,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppColors.ink,
      ),
      bodyLarge: TextStyle(
        fontSize: 15,
        color: AppColors.mutedInk,
        height: 1.62,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: AppColors.mutedInk,
        height: 1.48,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: AppColors.ink,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppColors.mutedInk,
        letterSpacing: 0.2,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white.withValues(alpha: 0.72),
      hintStyle: const TextStyle(
        color: AppColors.mutedInk,
        fontSize: 14,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: const BorderSide(color: AppColors.seaDeep, width: 1.4),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: Colors.white.withValues(alpha: 0.58),
      disabledColor: Colors.white.withValues(alpha: 0.42),
      selectedColor: AppColors.seaDeep,
      secondarySelectedColor: AppColors.seaDeep,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      labelStyle: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.ink,
      ),
      secondaryLabelStyle: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.ink,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.ink,
        side: BorderSide(color: Colors.white.withValues(alpha: 0.78)),
        backgroundColor: Colors.white.withValues(alpha: 0.32),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
      ),
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: AppColors.ink,
      contentTextStyle: TextStyle(color: Colors.white),
      behavior: SnackBarBehavior.floating,
    ),
    dividerColor: outline,
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Colors.transparent,
      showDragHandle: false,
    ),
  );
}
