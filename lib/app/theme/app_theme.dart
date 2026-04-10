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
  static const paper = Color(0xFFFDF8EF);
  static const paperLine = Color(0xFFEFE3D2);
  static const charcoal = Color(0xFF2C3036);
  static const softText = Color(0xFF736F67);
}

ThemeData buildAppTheme() {
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
        color: AppColors.charcoal,
        height: 0.96,
        letterSpacing: -1.2,
      ),
      headlineMedium: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.w800,
        color: AppColors.charcoal,
        height: 1.0,
        letterSpacing: -0.8,
      ),
      titleLarge: TextStyle(
        fontSize: 21,
        fontWeight: FontWeight.w700,
        color: AppColors.charcoal,
        height: 1.12,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppColors.charcoal,
      ),
      bodyLarge: TextStyle(
        fontSize: 15,
        color: AppColors.softText,
        height: 1.62,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: AppColors.softText,
        height: 1.5,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: AppColors.charcoal,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppColors.mutedInk,
        letterSpacing: 0.28,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.paper,
      hintStyle: const TextStyle(
        color: AppColors.softText,
        fontSize: 14,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(22),
        borderSide: const BorderSide(color: AppColors.paperLine),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(22),
        borderSide: const BorderSide(color: AppColors.paperLine),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(22),
        borderSide: const BorderSide(color: AppColors.coral, width: 1.2),
      ),
      prefixIconColor: AppColors.mutedInk,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: Colors.white.withValues(alpha: 0.7),
      disabledColor: Colors.white.withValues(alpha: 0.42),
      selectedColor: AppColors.charcoal,
      secondarySelectedColor: AppColors.charcoal,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      side: const BorderSide(color: AppColors.paperLine),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      labelStyle: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.charcoal,
      ),
      secondaryLabelStyle: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.charcoal,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.charcoal,
        side: const BorderSide(color: AppColors.paperLine),
        backgroundColor: Colors.white.withValues(alpha: 0.4),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
      ),
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: AppColors.charcoal,
      contentTextStyle: TextStyle(color: Colors.white),
      behavior: SnackBarBehavior.floating,
    ),
    dividerColor: AppColors.paperLine,
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Colors.transparent,
      showDragHandle: false,
    ),
  );
}
