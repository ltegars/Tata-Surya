import 'package:flutter/material.dart';

/// Spacing system as defined in PRD_DESIGN.md Section 24
abstract final class AppSpacing {
  static const double s2 = 2.0;
  static const double s4 = 4.0;
  static const double s8 = 8.0;
  static const double s12 = 12.0;
  static const double s14 = 14.0;
  static const double s16 = 16.0;
  static const double s20 = 20.0;
  static const double s24 = 24.0;
  static const double s32 = 32.0;
  static const double s48 = 48.0;

  // Convenient EdgeInsets
  static const EdgeInsets p4 = EdgeInsets.all(s4);
  static const EdgeInsets p8 = EdgeInsets.all(s8);
  static const EdgeInsets p12 = EdgeInsets.all(s12);
  static const EdgeInsets p16 = EdgeInsets.all(s16);
  static const EdgeInsets p20 = EdgeInsets.all(20.0);
  static const EdgeInsets p24 = EdgeInsets.all(s24);
  static const EdgeInsets p32 = EdgeInsets.all(s32);

  // Horizontal Padding
  static const EdgeInsets ph16 = EdgeInsets.symmetric(horizontal: s16);
  static const EdgeInsets ph20 = EdgeInsets.symmetric(horizontal: 20.0);
  static const EdgeInsets ph24 = EdgeInsets.symmetric(horizontal: s24);

  // Vertical Padding
  static const EdgeInsets pv8 = EdgeInsets.symmetric(vertical: s8);
  static const EdgeInsets pv12 = EdgeInsets.symmetric(vertical: s12);
  static const EdgeInsets pv16 = EdgeInsets.symmetric(vertical: s16);
}
