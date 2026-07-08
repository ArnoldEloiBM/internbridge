import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF003D9B);
  static const primaryContainer = Color(0xFF0052CC);
  static const onPrimary = Color(0xFFFFFFFF);
  static const onPrimaryContainer = Color(0xFFC4D2FF);
  static const secondary = Color(0xFFB62500);
  static const secondaryContainer = Color(0xFFFF5630);
  static const surface = Color(0xFFF8F9FB);
  static const surfaceContainer = Color(0xFFEDEEF0);
  static const surfaceContainerLow = Color(0xFFF3F4F6);
  static const surfaceContainerHigh = Color(0xFFE7E8EA);
  static const surfaceContainerHighest = Color(0xFFE1E2E4);
  static const surfaceContainerLowest = Color(0xFFFFFFFF);
  static const onSurface = Color(0xFF191C1E);
  static const onSurfaceVariant = Color(0xFF434654);
  static const outline = Color(0xFF737685);
  static const outlineVariant = Color(0xFFC3C6D6);
  static const tertiary = Color(0xFF003E96);
  static const tertiaryContainer = Color(0xFF2356B5);
  static const error = Color(0xFFBA1A1A);
  static const primaryFixed = Color(0xFFDAE2FF);
  static const inverseOnSurface = Color(0xFFF0F1F3);
  static const inverseSurface = Color(0xFF2E3132);
}

class AppTheme {
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme.light(
          primary: AppColors.primary,
          primaryContainer: AppColors.primaryContainer,
          onPrimary: AppColors.onPrimary,
          onPrimaryContainer: AppColors.onPrimaryContainer,
          secondary: AppColors.secondary,
          secondaryContainer: AppColors.secondaryContainer,
          surface: AppColors.surface,
          onSurface: AppColors.onSurface,
          onSurfaceVariant: AppColors.onSurfaceVariant,
          outline: AppColors.outline,
          outlineVariant: AppColors.outlineVariant,
          tertiary: AppColors.tertiary,
          tertiaryContainer: AppColors.tertiaryContainer,
          error: AppColors.error,
        ),
        fontFamily: 'Inter',
        scaffoldBackgroundColor: AppColors.surface,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.surface,
          foregroundColor: AppColors.primary,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryContainer,
            foregroundColor: AppColors.onPrimary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.surfaceContainerLowest,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.outlineVariant),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.outlineVariant),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
        ),
      );
}
