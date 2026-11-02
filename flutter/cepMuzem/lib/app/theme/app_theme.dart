import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';
import 'app_dimensions.dart';
import 'app_typography.dart';

/// Cep Müzem — Yaşayan Müze Merkezi Tema Yapılandırması (Material 3)
///
/// museum-design-system yönergesine uygun olarak:
/// - Fildişi (Ivory) ve Müze Beyazı tabanlı aydınlık arayüz
/// - Koyu Ceviz ve Antik Bronz etkileşim öğeleri
/// - 16dp kart, 12dp buton, 24dp modal radius kuralları
/// - 44dp minimum erişilebilir dokunma hedefleri
class AppTheme {
  AppTheme._();

  /// Uygulamanın merkezi açık tema tanımı
  static ThemeData get lightTheme {
    // Material 3 renk şeması: Belirlenen palet kodlarıyla birebir eşleştirilmiştir
    final colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.deepWalnut,
      onPrimary: AppColors.museumWhite,
      secondary: AppColors.antiqueBronze,
      onSecondary: AppColors.museumWhite,
      tertiary: AppColors.archiveOlive,
      onTertiary: AppColors.museumWhite,
      error: AppColors.terracotta,
      onError: AppColors.museumWhite,
      surface: AppColors.museumWhite,
      onSurface: AppColors.deepWalnut,
      surfaceContainerLowest: AppColors.ivory,
      surfaceContainerLow: AppColors.parchment,
      surfaceContainer: AppColors.museumWhite,
      outline: AppColors.museumStone,
      outlineVariant: AppColors.museumStone.withValues(alpha: 0.5),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.ivory,
      canvasColor: AppColors.ivory,
      cardColor: AppColors.museumWhite,
      dividerColor: AppColors.museumStone,

      // 1. Üst Çubuk (AppBar) Yapılandırması: Gölgesiz, Fildişi zemin ve koyu simgeler
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.ivory,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: AppTypography.pageTitle,
        iconTheme: const IconThemeData(color: AppColors.deepWalnut, size: 24),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),

      // 2. Kart (Card) Yapılandırması: 16dp radius, müze taşı ince çerçeve ve 0 elevation
      cardTheme: CardThemeData(
        color: AppColors.museumWhite,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppDimensions.cardBorderRadius,
          side: const BorderSide(color: AppColors.museumStone, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),

      // 3. Birincil Buton (ElevatedButton) Yapılandırması: Koyu ceviz, 12dp radius, 44dp min touch
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.deepWalnut,
          foregroundColor: AppColors.museumWhite,
          minimumSize: const Size(
            double.infinity,
            AppDimensions.minTouchTarget,
          ),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: AppDimensions.buttonBorderRadius,
          ),
          textStyle: AppTypography.buttonText,
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.space20,
            vertical: AppDimensions.space12,
          ),
        ),
      ),

      // 4. Çerçeveli Buton (OutlinedButton) Yapılandırması
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.deepWalnut,
          side: const BorderSide(color: AppColors.deepWalnut, width: 1),
          minimumSize: const Size(
            double.infinity,
            AppDimensions.minTouchTarget,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: AppDimensions.buttonBorderRadius,
          ),
          textStyle: AppTypography.buttonText.copyWith(
            color: AppColors.deepWalnut,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.space20,
            vertical: AppDimensions.space12,
          ),
        ),
      ),

      // 5. Metin Butonu (TextButton) Yapılandırması: Antik bronz rengi ve 44dp hedef
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.antiqueBronze,
          minimumSize: const Size(
            AppDimensions.minTouchTarget,
            AppDimensions.minTouchTarget,
          ),
          textStyle: AppTypography.caption.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // 6. Giriş Alanları (InputDecoration) Yapılandırması: Beyaz zemin, taş çerçeve, net odak
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.museumWhite,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.space16,
          vertical: AppDimensions.space16,
        ),
        border: OutlineInputBorder(
          borderRadius: AppDimensions.buttonBorderRadius,
          borderSide: const BorderSide(color: AppColors.museumStone),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppDimensions.buttonBorderRadius,
          borderSide: const BorderSide(color: AppColors.museumStone),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppDimensions.buttonBorderRadius,
          borderSide: const BorderSide(color: AppColors.deepWalnut, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppDimensions.buttonBorderRadius,
          borderSide: const BorderSide(color: AppColors.terracotta),
        ),
        labelStyle: AppTypography.bodySecondary,
        hintStyle: AppTypography.bodySecondary.copyWith(
          color: AppColors.secondaryText.withValues(alpha: 0.7),
        ),
      ),

      // 7. Alt Navigasyon Çubuğu (BottomNavigationBar) Yapılandırması: Sabit, beyaz yüzey
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.museumWhite,
        selectedItemColor: AppColors.deepWalnut,
        unselectedItemColor: AppColors.secondaryText,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),

      // 8. Alt Panel (BottomSheet) Yapılandırması: 24dp üst radius, beyaz zemin
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.museumWhite,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: AppDimensions.bottomSheetBorderRadius,
        ),
      ),
    );
  }
}

