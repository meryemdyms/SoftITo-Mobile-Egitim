import 'package:flutter/material.dart';

/// Cep Müzem — Kesin Tasarım Ölçüleri (museum-design-system)
class AppDimensions {
  AppDimensions._();

  static const double horizontalPadding = 20.0;

  static const double space4 = 4.0;
  static const double space8 = 8.0;
  static const double space12 = 12.0;
  static const double space16 = 16.0;
  static const double space20 = 20.0;
  static const double space24 = 24.0;
  static const double space32 = 32.0;

  static const double cardRadius = 16.0;
  static const double buttonRadius = 12.0;
  static const double bottomSheetRadius = 24.0;
  static const double badgeRadius = 8.0;

  static const double minTouchTarget = 44.0;

  static const BorderRadius cardBorderRadius = BorderRadius.all(
    Radius.circular(cardRadius),
  );
  static const BorderRadius buttonBorderRadius = BorderRadius.all(
    Radius.circular(buttonRadius),
  );
  static const BorderRadius bottomSheetBorderRadius = BorderRadius.vertical(
    top: Radius.circular(bottomSheetRadius),
  );
}
