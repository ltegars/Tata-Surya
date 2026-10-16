import 'package:flutter/material.dart';

/// Soft Space UI Color Palette
/// As defined in PRD_DESIGN.md Section 3 & 4
abstract final class AppColors {
  // Base Colors
  static const Color deepSpace = Color(0xFF0E1525);
  static const Color surface = Color(0xFF171F33);
  static const Color surfaceElevated = Color(0xFF222B42);
  static const Color border = Color(0xFF30394F);

  // Accent Colors
  static const Color mutedLavender = Color(0xFFA59BE8);
  static const Color paleLavender = Color(0xFFD8D2F2);
  static const Color warmWhite = Color(0xFFE6E0D4);

  // Text Colors
  static const Color primaryText = Color(0xFFF3F3F7);
  static const Color secondaryText = Color(0xFFAEB5C5);

  // Button text on primary lavender
  static const Color primaryButtonText = Color(0xFF171426);

  // Planet Natural Reference Colors (PRD_DESIGN.md Section 4)
  static const Color planetMercury = Color(0xFFA8A8B2);
  static const Color planetVenus = Color(0xFFE3BB7B);
  static const Color planetEarth = Color(0xFF4A90E2);
  static const Color planetMars = Color(0xFFD96B47);
  static const Color planetJupiter = Color(0xFFC29D78);
  static const Color planetSaturn = Color(0xFFE0C895);
  static const Color planetUranus = Color(0xFF72C8D1);
  static const Color planetNeptune = Color(0xFF4B70DD);
}
