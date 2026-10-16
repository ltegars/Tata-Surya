import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Typography system as defined in PRD_DESIGN.md Section 5
abstract final class AppTypography {
  // Base font getter
  static TextStyle get _baseFont => GoogleFonts.plusJakartaSans();

  // Display: 32–36 px, Bold
  static TextStyle get display => _baseFont.copyWith(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: AppColors.primaryText,
        letterSpacing: -0.5,
        height: 1.25,
      );

  // Heading: 24–28 px, SemiBold
  static TextStyle get heading => _baseFont.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: AppColors.primaryText,
        letterSpacing: -0.3,
        height: 1.3,
      );

  // Section: 20–24 px, SemiBold
  static TextStyle get section => _baseFont.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.primaryText,
        letterSpacing: -0.2,
        height: 1.35,
      );

  // Body: 15–17 px, Regular
  static TextStyle get body => _baseFont.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppColors.primaryText,
        height: 1.5,
      );

  // Body Secondary (supporting text)
  static TextStyle get bodySecondary => _baseFont.copyWith(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: AppColors.secondaryText,
        height: 1.5,
      );

  // Caption: 12–14 px, Medium
  static TextStyle get caption => _baseFont.copyWith(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: AppColors.secondaryText,
        letterSpacing: 0.1,
        height: 1.4,
      );

  // Button label
  static TextStyle get buttonLabel => _baseFont.copyWith(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
        height: 1.2,
      );
}
