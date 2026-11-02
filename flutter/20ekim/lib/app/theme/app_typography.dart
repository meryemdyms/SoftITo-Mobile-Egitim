import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Uygulamanın merkezi tipografi (yazı tipi stilleri) sınıfı.
///
/// Hiyerarşik başlıklar, gövde metinleri ve etiketler için
/// standart yazı boyutu, ağırlığı ve satır yüksekliği kurallarını belirler.
class AppTypography {
  AppTypography._();

  /// Büyük manşet ve karşılama başlıkları (28px, Kalın).
  static const TextStyle displayLarge = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.ink,
    letterSpacing: -0.5,
    height: 1.2,
  );

  /// Sayfa ana başlıkları ve hero alanları (24px, Kalın).
  static const TextStyle displayMedium = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.ink,
    letterSpacing: -0.3,
    height: 1.25,
  );

  /// Üst çubuk (AppBar) ve modül başlıkları (20px, Yarı Kalın).
  static const TextStyle titleLarge = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.ink,
    letterSpacing: -0.2,
  );

  /// Kart ve bölüm başlıkları (16px, Yarı Kalın).
  static const TextStyle titleMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.ink,
  );

  /// Okunabilirliği yüksek ana gövde metinleri (16px, Normal).
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.ink,
    height: 1.5,
  );

  /// Standart liste elemanı ve açıklama gövdesi (14px, Normal).
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.ink,
    height: 1.4,
  );

  /// Yardımcı metinler, tarihler ve alt notlar (12px, Normal, Soluk).
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.muted,
  );

  /// Buton içi metinler ve vurgulu form etiketleri (14px, Yarı Kalın).
  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.ink,
  );

  /// Rozetler ve alt gezinme sekmesi etiketleri (11px, Orta Kalınlık).
  static const TextStyle labelSmall = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppColors.muted,
    letterSpacing: 0.2,
  );
}
