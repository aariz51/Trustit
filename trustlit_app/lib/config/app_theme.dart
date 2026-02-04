import 'package:flutter/material.dart';
import 'app_colors.dart';

/// TrustLit App Theme Configuration
/// Matches the exact typography and styling from UI designs
class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.primaryGreen,
      scaffoldBackgroundColor: AppColors.white,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryGreen,
        secondary: AppColors.primaryGreenLight,
        surface: AppColors.white,
        error: AppColors.deleteRed,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.textBlack,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: 'Outfit',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.textBlack,
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontFamily: 'Outfit',
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppColors.textBlack,
        ),
        displayMedium: TextStyle(
          fontFamily: 'Outfit',
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: AppColors.textBlack,
        ),
        displaySmall: TextStyle(
          fontFamily: 'Outfit',
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.textBlack,
        ),
        headlineLarge: TextStyle(
          fontFamily: 'Outfit',
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: AppColors.textBlack,
        ),
        headlineMedium: TextStyle(
          fontFamily: 'Outfit',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.textBlack,
        ),
        headlineSmall: TextStyle(
          fontFamily: 'Outfit',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.textBlack,
        ),
        titleLarge: TextStyle(
          fontFamily: 'Outfit',
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.textBlack,
        ),
        titleMedium: TextStyle(
          fontFamily: 'Outfit',
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.textDarkGray,
        ),
        titleSmall: TextStyle(
          fontFamily: 'Outfit',
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.textGray,
        ),
        bodyLarge: TextStyle(
          fontFamily: 'Outfit',
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: AppColors.textDarkGray,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'Outfit',
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: AppColors.textDarkGray,
        ),
        bodySmall: TextStyle(
          fontFamily: 'Outfit',
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: AppColors.textGray,
        ),
        labelLarge: TextStyle(
          fontFamily: 'Outfit',
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.white,
        ),
        labelMedium: TextStyle(
          fontFamily: 'Outfit',
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.textGray,
        ),
        labelSmall: TextStyle(
          fontFamily: 'Outfit',
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: AppColors.textLightGray,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryGreen,
          foregroundColor: AppColors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Outfit',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textDarkGray,
          side: const BorderSide(color: AppColors.border),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Outfit',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      cardTheme: const CardThemeData(
        color: AppColors.cardBackground,
        elevation: 2,
        shadowColor: AppColors.shadow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.lightGray,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.white,
        selectedItemColor: AppColors.navActive,
        unselectedItemColor: AppColors.navInactive,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: 1,
      ),
    );
  }
}
