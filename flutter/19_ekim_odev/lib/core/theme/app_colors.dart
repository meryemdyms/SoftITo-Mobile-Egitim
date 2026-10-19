import 'package:flutter/material.dart';

/// Kırmızı Çağrı Teması için renk paleti tanımları
class AppColors {
  const AppColors._();

  // Ana Kırmızı Tonları
  static const Color primaryCrimson = Color(0xFFC62828);
  static const Color primaryCrimsonDark = Color(0xFF8E0000);
  static const Color primaryCrimsonLight = Color(0xFFFF5F52);

  // İkincil Vurgular
  static const Color secondaryTeal = Color(0xFF00796B);
  static const Color tertiaryAmber = Color(0xFFF57C00);

  // Açık Tema Yüzey ve Arka Plan
  static const Color lightBackground = Color(0xFFFBF8F8);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightTextPrimary = Color(0xFF1E1A1A);
  static const Color lightTextSecondary = Color(0xFF534343);
  static const Color lightBorder = Color(0xFFE8D4D4);

  // Koyu Tema Yüzey ve Arka Plan
  static const Color darkBackground = Color(0xFF130E0E);
  static const Color darkSurface = Color(0xFF1C1616);
  static const Color darkCard = Color(0xFF241C1C);
  static const Color darkTextPrimary = Color(0xFFEDE0E0);
  static const Color darkTextSecondary = Color(0xFFB59D9D);
  static const Color darkBorder = Color(0xFF382929);

  // Durum Renkleri
  static const Color success = Color(0xFF2E7D32);
  static const Color warning = Color(0xFFED6C02);
  static const Color error = Color(0xFFD32F2F);
  static const Color info = Color(0xFF0288D1);
}
