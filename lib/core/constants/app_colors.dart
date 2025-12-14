// lib/core/constants/app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF1976D2);
  static const Color secondary = Color(0xFF4CAF50);
  static const Color accent = Color(0xFFFF9800);

  // Background Colors
  static const Color background = Color(0xFFF5F5F5);
  static const Color cardBackground = Colors.white;
  static const Color surface = Colors.white;

  // Text Colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textLight = Color(0xFFBDBDBD);

  // Status Colors
  static const Color error = Color(0xFFD32F2F);
  static const Color success = Color(0xFF388E3C);
  static const Color warning = Color(0xFFFFA726);
  static const Color info = Color(0xFF1976D2);

  // Additional Colors
  static const Color divider = Color(0xFFE0E0E0);
  static const Color shadow = Color(0x1F000000);

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [accent, Color(0xFFFF6F00)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Alert Severity Colors
  static const Color alertLow = Color(0xFF4CAF50);
  static const Color alertMedium = Color(0xFFFFA726);
  static const Color alertHigh = Color(0xFFD32F2F);

  // Category Colors (for expenses)
  static const Color foodColor = Color(0xFFFF6B6B);
  static const Color transportColor = Color(0xFF4ECDC4);
  static const Color accommodationColor = Color(0xFF95E1D3);
  static const Color activitiesColor = Color(0xFFFFD93D);
  static const Color shoppingColor = Color(0xFFBB6BD9);
  static const Color otherColor = Color(0xFF95A5A6);
}
