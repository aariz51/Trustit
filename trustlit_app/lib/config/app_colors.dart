import 'package:flutter/material.dart';

/// TrustLit App Color Palette
/// Matches the exact colors from UI designs
class AppColors {
  AppColors._();

  // Primary Colors
  static const Color primaryGreen = Color(0xFF4CAF50);
  static const Color primaryGreenLight = Color(0xFF81C784);
  static const Color primaryGreenDark = Color(0xFF388E3C);

  // Background Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF5F5F5);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color lightGray = Color(0xFFF8F8F8);

  // Text Colors
  static const Color textBlack = Color(0xFF000000);
  static const Color textDarkGray = Color(0xFF333333);
  static const Color textGray = Color(0xFF666666);
  static const Color textLightGray = Color(0xFF999999);
  static const Color textMuted = Color(0xFFAAAAAA);

  // Score Colors (based on rating ranges)
  static const Color scoreExcellent = Color(0xFF4CAF50); // 76-100 (Green)
  static const Color scoreGood = Color(0xFFFFA726); // 51-75 (Yellow/Orange)
  static const Color scoreNotGreat = Color(0xFFFF7043); // 26-50 (Orange)
  static const Color scoreBad = Color(0xFFE53935); // 0-25 (Red)

  // Risk Level Colors
  static const Color riskLow = Color(0xFF4CAF50);
  static const Color riskMedium = Color(0xFFFFA726);
  static const Color riskHigh = Color(0xFFE53935);

  // UI Element Colors
  static const Color divider = Color(0xFFE0E0E0);
  static const Color border = Color(0xFFE0E0E0);
  static const Color selectedBorder = Color(0xFF4CAF50);
  static const Color shadow = Color(0x1A000000);

  // Button Colors
  static const Color buttonPrimary = Color(0xFF4CAF50);
  static const Color buttonSecondary = Color(0xFFFFFFFF);
  static const Color buttonDisabled = Color(0xFFBDBDBD);
  static const Color deleteRed = Color(0xFFE53935);
  static const Color retakeOutline = Color(0xFFE53935);

  // Ingredient Card Colors
  static const Color ingredientCardBg = Color(0xFFF5F9F5);
  static const Color ingredientCardBorder = Color(0xFFE8F5E9);

  // Bottom Navigation
  static const Color navActive = Color(0xFF4CAF50);
  static const Color navInactive = Color(0xFF9E9E9E);

  /// Get score color based on score value
  static Color getScoreColor(int score) {
    if (score >= 76) return scoreExcellent;
    if (score >= 51) return scoreGood;
    if (score >= 26) return scoreNotGreat;
    return scoreBad;
  }

  /// Get risk level color
  static Color getRiskColor(String risk) {
    switch (risk.toLowerCase()) {
      case 'low':
        return riskLow;
      case 'medium':
        return riskMedium;
      case 'high':
        return riskHigh;
      default:
        return riskLow;
    }
  }

  /// Get rating label based on score
  static String getRatingLabel(int score) {
    if (score >= 76) return 'Excellent';
    if (score >= 51) return 'Good';
    if (score >= 26) return 'Average';
    return 'Bad';
  }
}
