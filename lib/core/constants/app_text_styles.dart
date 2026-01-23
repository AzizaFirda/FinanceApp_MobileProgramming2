import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  // Headings
  static TextStyle h1 = GoogleFonts.inter(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static TextStyle h2 = GoogleFonts.inter(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static TextStyle h3 = GoogleFonts.inter(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static TextStyle h4 = GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static TextStyle h5 = GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static TextStyle h6 = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  // Body Text
  static TextStyle bodyLarge = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );

  static TextStyle bodyMedium = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );

  static TextStyle bodySmall = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );

  // Caption
  static TextStyle caption = GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.normal,
    color: AppColors.textTertiary,
  );

  // Button Text
  static TextStyle button = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textLight,
  );

  static TextStyle buttonSmall = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textLight,
  );

  // Label
  static TextStyle label = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  static TextStyle labelSmall = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  // Amount Text (for displaying money)
  static TextStyle amountLarge = GoogleFonts.inter(
    fontSize: 36,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static TextStyle amountMedium = GoogleFonts.inter(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static TextStyle amountSmall = GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  // Income/Expense Amount
  static TextStyle incomeAmount = GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.income,
  );

  static TextStyle expenseAmount = GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.expense,
  );

  // Card Title
  static TextStyle cardTitle = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static TextStyle cardSubtitle = GoogleFonts.inter(
    fontSize: 13,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );

  // App Bar
  static TextStyle appBarTitle = GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  // Tab Bar
  static TextStyle tabBarLabel = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );

  // Error Text
  static TextStyle error = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.error,
  );

  // Success Text
  static TextStyle success = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.success,
  );

  // Link Text
  static TextStyle link = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.primary,
    decoration: TextDecoration.underline,
  );

  // Input Text
  static TextStyle input = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );

  static TextStyle inputHint = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textTertiary,
  );

  // Methods to create custom styles
  static TextStyle customStyle({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? letterSpacing,
    double? height,
  }) {
    return GoogleFonts.inter(
      fontSize: fontSize ?? 14,
      fontWeight: fontWeight ?? FontWeight.normal,
      color: color ?? AppColors.textPrimary,
      letterSpacing: letterSpacing,
      height: height,
    );
  }
}
