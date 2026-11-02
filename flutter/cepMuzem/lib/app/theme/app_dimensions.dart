import 'package:flutter/material.dart';

/// Cep Müzem — Kesin Tasarım Ölçüleri (museum-design-system)
///
/// Tasarım Kriterleri:
/// - 20dp ekran yatay boşluğu (horizontal padding)
/// - 16dp kart köşe yuvarlaklığı (card radius)
/// - 12dp buton köşe yuvarlaklığı (button radius)
/// - 24dp modal / alt panel üst köşe yuvarlaklığı (bottom sheet radius)
/// - 44dp minimum dokunma hedefi boyutu (erişilebilirlik standardı)
class AppDimensions {
  AppDimensions._();

  /// Standart ekran yatay iç boşluğu (20dp)
  static const double horizontalPadding = 20.0;

  // Boşluk Ölçekleri (4dp katları ızgara sistemi)
  /// Çok küçük boşluk (4dp)
  static const double space4 = 4.0;

  /// Küçük boşluk (8dp)
  static const double space8 = 8.0;

  /// Orta-küçük boşluk (12dp)
  static const double space12 = 12.0;

  /// Standart ara boşluk (16dp)
  static const double space16 = 16.0;

  /// Standart ekran/bileşen boşluğu (20dp)
  static const double space20 = 20.0;

  /// Geniş bölüm boşluğu (24dp)
  static const double space24 = 24.0;

  /// Çok geniş bölüm/blok boşluğu (32dp)
  static const double space32 = 32.0;

  // Köşe Yuvarlaklıkları (Border Radii)
  /// Kart bileşenleri köşe yarıçapı (16dp)
  static const double cardRadius = 16.0;

  /// Buton bileşenleri köşe yarıçapı (12dp)
  static const double buttonRadius = 12.0;

  /// Alt sayfa / modal paneller üst köşe yarıçapı (24dp)
  static const double bottomSheetRadius = 24.0;

  /// Rozet ve küçük etiketler köşe yarıçapı (8dp)
  static const double badgeRadius = 8.0;

  /// Erişilebilirlik için minimum dokunmatik alan boyutu (44dp)
  static const double minTouchTarget = 44.0;

  /// Kartlar için hazır [BorderRadius] nesnesi
  static const BorderRadius cardBorderRadius = BorderRadius.all(
    Radius.circular(cardRadius),
  );

  /// Butonlar için hazır [BorderRadius] nesnesi
  static const BorderRadius buttonBorderRadius = BorderRadius.all(
    Radius.circular(buttonRadius),
  );

  /// Alt sayfalar (bottom sheet) için sadece üst köşeleri yuvarlatılmış [BorderRadius] nesnesi
  static const BorderRadius bottomSheetBorderRadius = BorderRadius.vertical(
    top: Radius.circular(bottomSheetRadius),
  );
}

