import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Cep Müzem — Kesin Tipografi Sistemi (museum-design-system)
///
/// Tipografi Kuralları:
/// - Başlık Fontu: Cormorant Garamond (Klasik, zarif, müze ve sergi atmosferi)
/// - Gövde Fontu: Inter (Modern, yüksek okunabilirlik, arayüz metinleri)
/// - Yazı Boyutları:
///   * Sayfa başlığı: 28sp
///   * Bölüm başlığı: 22sp
///   * Kart başlığı: 18sp
///   * Gövde: 15sp
///   * Yardımcı / Açıklama: 12sp
///   * Rozet / Etiket: 11sp
class AppTypography {
  AppTypography._();

  /// Sayfa ana başlığı (28sp, Cormorant Garamond, semi-bold)
  /// Ekran başlıkları, büyük sergi adları ve karşılama metinlerinde kullanılır.
  static TextStyle get pageTitle => GoogleFonts.cormorantGaramond(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    color: AppColors.deepWalnut,
    letterSpacing: 0.2,
  );

  /// Bölüm ve grup başlığı (22sp, Cormorant Garamond, semi-bold)
  /// Alt başlıklar, sekme başlıkları ve modal başlıklarında kullanılır.
  static TextStyle get sectionTitle => GoogleFonts.cormorantGaramond(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.deepWalnut,
    letterSpacing: 0.15,
  );

  /// Kart ve sergi öğesi başlığı (18sp, Cormorant Garamond, semi-bold)
  /// Müze kartlarında, oda başlıklarında ve eser adlarında kullanılır.
  static TextStyle get cardTitle => GoogleFonts.cormorantGaramond(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.deepWalnut,
  );

  /// Birincil gövde metni (15sp, Inter, normal)
  /// Sergi açıklamaları, eser hikayeleri ve uzun metin bloklarında kullanılır.
  static TextStyle get body => GoogleFonts.inter(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.deepWalnut,
    height: 1.45,
  );

  /// İkincil gövde metni (15sp, Inter, normal, ikincil renk)
  /// Yardımcı açıklamalar, alt bilgiler ve form ipuçlarında kullanılır.
  static TextStyle get bodySecondary => GoogleFonts.inter(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.secondaryText,
    height: 1.4,
  );

  /// Alt yazı ve açıklama metni (12sp, Inter, medium)
  /// Sayaçlar, tarihler, etiketler ve küçük bilgi alanlarında kullanılır.
  static TextStyle get caption => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.secondaryText,
    letterSpacing: 0.2,
  );

  /// Buton içi metin stili (15sp, Inter, semi-bold)
  /// Birincil ve ikincil butonların aksiyon yazılarında kullanılır.
  static TextStyle get buttonText => GoogleFonts.inter(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.museumWhite,
  );

  /// Müze rozeti ve sergi plaketi metni (11sp, Inter, semi-bold, Antique Bronze)
  /// Eser plaketleri, kategori rozetleri ve durum etiketlerinde kullanılır.
  static TextStyle get museumBadge => GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: AppColors.antiqueBronze,
    letterSpacing: 0.5,
  );
}

