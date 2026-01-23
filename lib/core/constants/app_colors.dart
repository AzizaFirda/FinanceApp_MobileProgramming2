import 'package:flutter/material.dart';

class AppColors {
  // Emerald Green Shades
  static const Color emeraldPrimary = Color(0xFF10B981);
  static const Color emeraldDark = Color(0xFF059669);
  static const Color emeraldLight = Color(0xFF34D399);
  static const Color emeraldVeryLight = Color(0xFFD1FAE5);

  // Brown Shades
  static const Color brownPrimary = Color(0xFF92826D);
  static const Color brownDark = Color(0xFF6B5D4F);
  static const Color brownLight = Color(0xFFC4B5A0);
  static const Color softBrown = Color(0xFFE7DFD5);

  // Grey Shades
  static const Color greyPrimary = Color(0xFF6B7280);
  static const Color greyDark = Color(0xFF4B5563);
  static const Color greyLight = Color(0xFF9CA3AF);
  static const Color greyVeryLight = Color(0xFFF3F4F6);

  // Light Mode
  static const Color backgroundLight = Color(0xFFFAFAFA);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color surfaceLight = Color(0xFFF8F6F3);

  // Dark Mode
  static const Color backgroundDark = Color(0xFF1A1A1A);
  static const Color cardDark = Color(0xFF2D2D2D);
  static const Color surfaceDark = Color(0xFF242424);
  static const Color charcoalBlack = Color(0xFF121212);

  // Text Colors Light
  static const Color textPrimaryLight = Color(0xFF1F2937);
  static const Color textSecondaryLight = Color(0xFF6B7280);
  static const Color textTertiaryLight = Color(0xFF9CA3AF);

  // Text Colors Dark
  static const Color textPrimaryDark = Color(0xFFF9FAFB);
  static const Color textSecondaryDark = Color(0xFFD1D5DB);
  static const Color textTertiaryDark = Color(0xFF9CA3AF);

  // Accent Colors
  static const Color accentEmerald = Color(0xFF059669);
  static const Color accentBrown = Color(0xFF92826D);

  // Semantic Colors
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);

  // Shadow Colors
  static Color shadowLight = Colors.black.withValues(alpha: 0.05);
  static Color shadowMedium = Colors.black.withValues(alpha: 0.1);
  static Color shadowDark = Colors.black.withValues(alpha: 0.3);

  // Gradients Light Mode
  static const LinearGradient emeraldGradientLight = LinearGradient(
    colors: [Color(0xFF10B981), Color(0xFF34D399)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient brownGradientLight = LinearGradient(
    colors: [Color(0xFF92826D), Color(0xFFC4B5A0)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Gradients Dark Mode
  static const LinearGradient emeraldGradientDark = LinearGradient(
    colors: [Color(0xFF059669), Color(0xFF10B981)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient brownGradientDark = LinearGradient(
    colors: [Color(0xFF6B5D4F), Color(0xFF92826D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Border Colors
  static const Color borderLight = Color(0xFFE5E7EB);
  static const Color borderDark = Color(0xFF374151);

  // Divider Colors
  static const Color dividerLight = Color(0xFFE5E7EB);
  static const Color dividerDark = Color(0xFF374151);

  // Original Colors (kept for compatibility)
  static const Color primary = emeraldPrimary;
  static const Color primaryDark = emeraldDark;
  static const Color primaryLight = emeraldLight;
  static const Color textPrimary = textPrimaryLight;
  static const Color textSecondary = textSecondaryLight;
  static const Color textTertiary = textTertiaryLight;
  static const Color textLight = Color(0xFFFFFFFF);
  static const Color border = borderLight;
  static const Color divider = dividerLight;

  // Income/Expense Colors
  static const Color income = Color(0xFF10B981);
  static const Color expense = Color(0xFFEF4444);
  static const Color transfer = Color(0xFF6366F1);

  // Chart Colors
  static const List<Color> chartColors = [
    Color(0xFFEF4444),
    Color(0xFFF59E0B),
    Color(0xFFFBBF24),
    Color(0xFF10B981),
    Color(0xFF06B6D4),
    Color(0xFF3B82F6),
    Color(0xFF6366F1),
    Color(0xFF8B5CF6),
    Color(0xFFEC4899),
    Color(0xFFF43F5E),
  ];

  // Account Type Colors
  static const Color cash = Color(0xFF10B981);
  static const Color bank = Color(0xFF3B82F6);
  static const Color ewallet = Color(0xFF8B5CF6);
  static const Color liability = Color(0xFFEF4444);

  // Category Colors
  static const Map<String, Color> categoryColors = {
    'food': Color(0xFFFF6B6B),
    'transport': Color(0xFF4ECDC4),
    'shopping': Color(0xFFFFBE0B),
    'entertainment': Color(0xFF9B59B6),
    'bills': Color(0xFFE74C3C),
    'health': Color(0xFF2ECC71),
    'education': Color(0xFF3498DB),
    'others': Color(0xFF95A5A6),
  };
}
