import 'package:flutter/material.dart';

class AppColors {
  // Brand Primary - Vibrant rescue emerald & deep forest
  static const Color primary = Color(0xFF10B981); // Emerald 500
  static const Color primaryDark = Color(0xFF047857); // Emerald 700
  static const Color primaryMedium = Color(0xFF34D399); // Emerald 400
  static const Color primaryLight = Color(0xFF0B2922); // Deep emerald night container
  static const Color primaryBorder = Color(0xFF165345); // Emerald border

  // Emergency & Triage Levels (High contrast on dark surfaces)
  static const Color emergency = Color(0xFFEF4444); // Red 500 - Critical SOS
  static const Color emergencyLight = Color(0xFF361517); // Dark red container
  static const Color emergencyBorder = Color(0xFF6B2125); // Red border

  static const Color urgent = Color(0xFFF59E0B); // Amber 500 - High priority
  static const Color urgentLight = Color(0xFF33220E); // Dark amber container
  static const Color urgentBorder = Color(0xFF634217); // Amber border

  static const Color moderate = Color(0xFF38BDF8); // Sky 400 - Medium priority
  static const Color moderateLight = Color(0xFF0E2838); // Dark sky container
  static const Color moderateBorder = Color(0xFF1B4E6B); // Sky border

  // Surfaces - Deep Rescue Forest & Midnight Slate (Not plain white)
  static const Color background = Color(0xFF0C1413); // Deep midnight forest
  static const Color surface = Color(0xFF13201E); // Elevated rescue card
  static const Color surfaceSubtle = Color(0xFF192C28); // Subtle container
  static const Color border = Color(0xFF223B36); // Slate-pine border
  static const Color borderSubtle = Color(0xFF1B302C);

  // Typography - High contrast, legible
  static const Color textPrimary = Color(0xFFF8FAFC); // Crisp off-white
  static const Color textSecondary = Color(0xFF94A3B8); // Soft slate
  static const Color textMuted = Color(0xFF64748B); // Muted slate
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        onPrimary: Colors.black,
        primaryContainer: AppColors.primaryLight,
        onPrimaryContainer: AppColors.primaryMedium,
        secondary: AppColors.primaryMedium,
        surface: AppColors.surface,
        onSurface: AppColors.textPrimary,
        error: AppColors.emergency,
        onError: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.black,
          minimumSize: const Size.fromHeight(50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          minimumSize: const Size.fromHeight(50),
          side: const BorderSide(color: AppColors.border, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: const TextStyle(
          color: AppColors.textMuted,
          fontSize: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.8),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.emergency),
        ),
      ),
    );
  }
}
