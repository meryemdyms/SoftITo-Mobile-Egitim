import 'package:flutter/material.dart';

/// Uygulamanın merkezi boşluk (spacing/padding/margin) sistemi.
///
/// 4-katlı ve 8-katlı ölçek prensibine dayalı olarak sabit boşluk değerleri sunar.
class AppSpacing {
  AppSpacing._();

  /// En küçük mikro boşluk (2px).
  static const double xxs = 2.0;

  /// Küçük mikro boşluk (4px).
  static const double xs = 4.0;

  /// Küçük aralık (8px).
  static const double sm = 8.0;

  /// Orta aralık (12px).
  static const double md = 12.0;

  /// Standart aralık (16px).
  static const double lg = 16.0;

  /// Geniş aralık (20px).
  static const double xl = 20.0;

  /// Bölüm arası geniş boşluk (24px).
  static const double xxl = 24.0;

  /// Sayfa arası geniş ayrım boşluğu (32px).
  static const double xxxl = 32.0;

  /// Çok büyük ayrım boşluğu (48px).
  static const double huge = 48.0;

  // Standart Dört Taraflı EdgeInsets Nesneleri
  /// 4px dört taraflı iç boşluk.
  static const EdgeInsets edgeInsetsXs = EdgeInsets.all(xs);

  /// 8px dört taraflı iç boşluk.
  static const EdgeInsets edgeInsetsSm = EdgeInsets.all(sm);

  /// 12px dört taraflı iç boşluk.
  static const EdgeInsets edgeInsetsMd = EdgeInsets.all(md);

  /// 16px dört taraflı iç boşluk.
  static const EdgeInsets edgeInsetsLg = EdgeInsets.all(lg);

  /// 20px dört taraflı iç boşluk.
  static const EdgeInsets edgeInsetsXl = EdgeInsets.all(xl);

  /// 24px dört taraflı iç boşluk.
  static const EdgeInsets edgeInsetsXxl = EdgeInsets.all(xxl);

  /// Sayfa gövdesi için standart yatay ve dikey iç boşluk (16px).
  static const EdgeInsets screenPadding = EdgeInsets.symmetric(
    horizontal: lg,
    vertical: lg,
  );
}

/// Uygulama genelinde kullanılan köşe yuvarlatma (BorderRadius) yarıçapları.
class AppRadius {
  AppRadius._();

  /// Küçük köşe yuvarlatma (6px).
  static const double sm = 6.0;

  /// Orta köşe yuvarlatma (10px).
  static const double md = 10.0;

  /// Standart kart köşe yuvarlatma (14px).
  static const double lg = 14.0;

  /// Büyük modal köşe yuvarlatma (20px).
  static const double xl = 20.0;

  /// Tam yuvarlak / hap şekli (Pill/Circle) (999px).
  static const double full = 999.0;

  /// Küçük köşe yarıçapı nesnesi.
  static const BorderRadius radiusSm = BorderRadius.all(Radius.circular(sm));

  /// Orta köşe yarıçapı nesnesi.
  static const BorderRadius radiusMd = BorderRadius.all(Radius.circular(md));

  /// Standart kart köşe yarıçapı nesnesi.
  static const BorderRadius radiusLg = BorderRadius.all(Radius.circular(lg));

  /// Büyük modal köşe yarıçapı nesnesi.
  static const BorderRadius radiusXl = BorderRadius.all(Radius.circular(xl));

  /// Tam yuvarlak köşe yarıçapı nesnesi.
  static const BorderRadius radiusFull = BorderRadius.all(
    Radius.circular(full),
  );
}
