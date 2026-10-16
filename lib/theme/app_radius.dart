import 'package:flutter/material.dart';

/// Border radius tokens as defined in PRD_DESIGN.md Section 7
abstract final class AppRadius {
  static const double small = 12.0;
  static const double medium = 16.0;
  static const double card = 20.0;
  static const double cardLarge = 24.0;
  static const double button = 14.0;

  // BorderRadius objects
  static const BorderRadius roundedSmall = BorderRadius.all(Radius.circular(small));
  static const BorderRadius roundedMedium = BorderRadius.all(Radius.circular(medium));
  static const BorderRadius roundedCard = BorderRadius.all(Radius.circular(card));
  static const BorderRadius roundedCardLarge = BorderRadius.all(Radius.circular(cardLarge));
  static const BorderRadius roundedButton = BorderRadius.all(Radius.circular(button));
}
