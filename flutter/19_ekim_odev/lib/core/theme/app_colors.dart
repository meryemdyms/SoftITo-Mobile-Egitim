import 'package:flutter/material.dart';

/// Kırmızı Çağrı uygulaması için merkezi renk paleti tanımları.
/// Tutarlı bir görsel tasarım sağlamak için tüm açık, koyu ve durum renklerini barındırır.
class AppColors {
  const AppColors._();

  // --- Ana Kırmızı Tonları (Primary Red) ---
  /// Temel kırmızı renk (kan teması vurgusu)
  static const Color primaryCrimson = Color(0xFFC62828);
  /// Koyu kırmızı vurgu tonu
  static const Color primaryCrimsonDark = Color(0xFF8E0000);
  /// Açık kırmızı / parıltı tonu
  static const Color primaryCrimsonLight = Color(0xFFFF5F52);

  // --- İkincil ve Üçüncül Renkler (Secondary & Tertiary) ---
  /// Tıbbi/güven veren ikincil deniz mavisi/yeşili
  static const Color secondaryTeal = Color(0xFF00796B);
  /// Dikkat çekici üçüncü kehribar/turuncu rengi
  static const Color tertiaryAmber = Color(0xFFF57C00);

  // --- Açık Tema Renkleri (Light Mode) ---
  /// Açık tema genel sayfa arka planı
  static const Color lightBackground = Color(0xFFFBF8F8);
  /// Açık tema yüzey rengi
  static const Color lightSurface = Color(0xFFFFFFFF);
  /// Açık tema kart rengi
  static const Color lightCard = Color(0xFFFFFFFF);
  /// Açık tema birincil metin rengi
  static const Color lightTextPrimary = Color(0xFF1E1A1A);
  /// Açık tema ikincil/açıklama metin rengi
  static const Color lightTextSecondary = Color(0xFF534343);
  /// Açık tema sınır/çerçeve rengi
  static const Color lightBorder = Color(0xFFE8D4D4);

  // --- Koyu Tema Renkleri (Dark Mode) ---
  /// Koyu tema genel sayfa arka planı (gözü yormayan yumuşak siyah)
  static const Color darkBackground = Color(0xFF130E0E);
  /// Koyu tema yüzey rengi
  static const Color darkSurface = Color(0xFF1C1616);
  /// Koyu tema kart arka planı
  static const Color darkCard = Color(0xFF241C1C);
  /// Koyu tema birincil metin rengi
  static const Color darkTextPrimary = Color(0xFFEDE0E0);
  /// Koyu tema ikincil metin rengi
  static const Color darkTextSecondary = Color(0xFFB59D9D);
  /// Koyu tema sınır/çerçeve rengi
  static const Color darkBorder = Color(0xFF382929);

  // --- Durum / Bildirim Renkleri (Status Colors) ---
  /// Başarılı işlem veya onay rengi (Yeşil)
  static const Color success = Color(0xFF2E7D32);
  /// Uyarı veya orta aciliyet rengi (Turuncu)
  static const Color warning = Color(0xFFED6C02);
  /// Hata veya yüksek aciliyet rengi (Kırmızı)
  static const Color error = Color(0xFFD32F2F);
  /// Bilgilendirme rengi (Mavi)
  static const Color info = Color(0xFF0288D1);
}

