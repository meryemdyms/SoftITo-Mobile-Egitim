import 'package:flutter/material.dart';
import 'package:susadim/core/constants/app_colors.dart';

/// Uygulamanın merkezi tema yapılandırma sınıfı.
///
/// Material 3 tasarım prensiplerine uygun olarak oluşturulmuş koyu tema (Dark Theme)
/// kurallarını içerir. Tüm bileşenlerin (Card, Button, NavigationBar, Text) görünümü
/// bu tema üzerinden merkezi olarak yönetilir.
abstract final class AppTheme {
  /// Koyu tema yapılandırmasını döndüren getter özelliği.
  static ThemeData get darkTheme {
    return ThemeData(
      // Material Design 3 bileşen ve tasarım kurallarını etkinleştirir
      useMaterial3: true,
      // Genel parlaklık seviyesini koyu olarak tanımlar
      brightness: Brightness.dark,
      // Scaffold sayfalarının varsayılan arka plan rengi
      scaffoldBackgroundColor: AppColors.obsidianBackground,

      // Material 3 renk şeması (ColorScheme):
      // Sistem bileşenleri (Dialog, SnackBar, Chip vb.) bu renk şemasını referans alır.
      colorScheme: const ColorScheme.dark(
        primary: AppColors.neonCyan,
        onPrimary: AppColors.obsidianBackground,
        secondary: AppColors.neonLime,
        onSecondary: AppColors.obsidianBackground,
        tertiary: AppColors.neonCoral,
        surface: AppColors.obsidianSurface,
        onSurface: AppColors.textPrimary,
        error: AppColors.error,
        onError: Colors.white,
      ),

      // Üst uygulama çubuğu (AppBar) tasarımı
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.obsidianBackground,
        foregroundColor: AppColors.textPrimary,
        elevation: 0, // Düz, gölgesiz modern görünüm
        centerTitle: false, // Başlığı sola yaslar
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 22,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),

      // Kart (Card) bileşenlerinin varsayılan stili
      cardTheme: CardThemeData(
        color: AppColors.obsidianCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // Yumuşak yuvarlatılmış köşeler
          side: const BorderSide(
            color: AppColors.obsidianBorder, // İnce obsidian sınır çizgisi
            width: 1,
          ),
        ),
      ),

      // Alt gezinme çubuğu (NavigationBar) stilleri
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.obsidianSurface,
        // Seçili sekmenin arkasındaki neon cyan kapsül vurgusu (%18 opaklık)
        indicatorColor: AppColors.neonCyan.withValues(alpha: 0.18),
        // Duruma göre dinamik metin stili (Seçili vs Pasif)
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              color: AppColors.neonCyan,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            );
          }
          return const TextStyle(
            color: AppColors.textMuted,
            fontWeight: FontWeight.w500,
            fontSize: 12,
          );
        }),
        // Duruma göre dinamik ikon stili
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.neonCyan, size: 24);
          }
          return const IconThemeData(color: AppColors.textMuted, size: 24);
        }),
      ),

      // Tipografi ve yazı stilleri hiyerarşisi
      textTheme: const TextTheme(
        // Büyük manşetler ve öne çıkan sayaçlar
        headlineLarge: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 32,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
        ),
        // Yüzdelik göstergeler ve modül başlıkları
        headlineMedium: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 24,
          fontWeight: FontWeight.w700,
        ),
        // Kart ve bölüm başlıkları
        titleLarge: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        // İkincil metinler ve sayaç detayları
        titleMedium: TextStyle(
          color: AppColors.textSecondary,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
        // Gövde metinleri ve liste elemanları ana metni
        bodyLarge: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
        // Açıklamalar ve küçük etiketler
        bodyMedium: TextStyle(
          color: AppColors.textSecondary,
          fontSize: 13,
          fontWeight: FontWeight.normal,
        ),
        // Buton içindeki etiketler
        labelLarge: TextStyle(
          color: AppColors.neonCyan,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),

      // Yükseltilmiş / Dolgulu Buton (ElevatedButton) stili
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.neonCyan,
          foregroundColor: AppColors.obsidianBackground,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
      ),

      // Çerçeveli Buton (OutlinedButton) stili
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.neonCyan,
          side: const BorderSide(color: AppColors.neonCyan, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
