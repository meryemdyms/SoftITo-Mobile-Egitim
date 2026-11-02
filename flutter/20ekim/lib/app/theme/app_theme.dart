import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

/// Uygulamanın Material Design 3 tema yapılandırma sınıfı.
///
/// Renk şeması, tipografi, butonlar, giriş alanları ve gezinme çubuğu gibi
/// tüm UI bileşenlerinin global stil kurallarını belirler.
class AppTheme {
  AppTheme._();

  /// Uygulamanın aydınlık (Light) tema nesnesi.
  static ThemeData get lightTheme {
    // Material 3 ColorScheme haritalaması
    final colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primary,
      onPrimary: Colors.white,
      primaryContainer: AppColors.primaryLight.withOpacity(0.2),
      onPrimaryContainer: AppColors.primaryDark,
      secondary: AppColors.muted,
      onSecondary: Colors.white,
      surface: AppColors.surface,
      onSurface: AppColors.ink,
      surfaceVariant: AppColors.surfaceVariant,
      onSurfaceVariant: AppColors.muted,
      background: AppColors.canvas,
      onBackground: AppColors.ink,
      error: AppColors.destructive,
      onError: Colors.white,
      outline: AppColors.border,
      outlineVariant: AppColors.border.withOpacity(0.5),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.canvas,
      fontFamily: null, // Sistem yazı tipi ve zengin kalınlık ağırlıkları
      // Üst çubuk (AppBar) varsayılan stili
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.ink,
        elevation: 0,
        centerTitle: false,
        scrolledUnderElevation: 1,
        titleTextStyle: AppTypography.titleLarge,
      ),
      // Kartlar için standart dolgu, kenarlık ve köşe yuvarlatma
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.radiusLg,
          side: const BorderSide(color: AppColors.border, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      // Metin giriş alanları (TextField) için tutarlı tema
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: AppRadius.radiusMd,
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.radiusMd,
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.radiusMd,
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.radiusMd,
          borderSide: const BorderSide(color: AppColors.destructive),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppRadius.radiusMd,
          borderSide: const BorderSide(color: AppColors.destructive, width: 2),
        ),
        hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.muted),
        labelStyle: AppTypography.bodyMedium.copyWith(color: AppColors.ink),
      ),
      // Vurgulu (Filled) buton stili (minimum 48px dokunma alanı kuralı)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size(double.infinity, 48),
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.radiusMd),
          textStyle: AppTypography.labelLarge.copyWith(color: Colors.white),
        ),
      ),
      // Çerçeveli (Outlined) buton stili
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary),
          minimumSize: const Size(double.infinity, 48),
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.radiusMd),
          textStyle: AppTypography.labelLarge.copyWith(
            color: AppColors.primary,
          ),
        ),
      ),
      // Alt gezinme çubuğu (Bottom Navigation Bar) stili
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.surface,
        elevation: 3,
        indicatorColor: AppColors.primary.withOpacity(0.12),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppTypography.labelSmall.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            );
          }
          return AppTypography.labelSmall;
        }),
      ),
      // Bilgilendirme bildirimleri (SnackBar) stili
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.ink,
        contentTextStyle: AppTypography.bodyMedium.copyWith(
          color: Colors.white,
        ),
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.radiusMd),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
