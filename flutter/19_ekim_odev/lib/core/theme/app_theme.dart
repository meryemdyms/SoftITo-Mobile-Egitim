import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Kırmızı Çağrı uygulaması için Material 3 tabanlı açık (light) ve koyu (dark) tema yapılandırması.
/// Kartlar, AppBar, Butonlar, NavigationBar ve Input alanlarının tasarım kurallarını belirler.
class AppTheme {
  const AppTheme._();

  /// Uygulamanın aydınlık (Light) tema yapılandırmasını oluşturur ve döndürür.
  static ThemeData get lightTheme {
    // Aydınlık tema için Material 3 renk şeması
    final colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primaryCrimson,
      onPrimary: Colors.white,
      primaryContainer: const Color(0xFFFFDAD6),
      onPrimaryContainer: AppColors.primaryCrimsonDark,
      secondary: AppColors.secondaryTeal,
      onSecondary: Colors.white,
      secondaryContainer: const Color(0xFFA7F0DF),
      onSecondaryContainer: const Color(0xFF00201B),
      tertiary: AppColors.tertiaryAmber,
      onTertiary: Colors.white,
      error: AppColors.error,
      onError: Colors.white,
      surface: AppColors.lightSurface,
      onSurface: AppColors.lightTextPrimary,
      surfaceContainerHighest: AppColors.lightBackground,
      outline: AppColors.lightBorder,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.lightBackground,
      // Kart bileşenlerinin açık tema stili: gölgesiz (flat), hafif çerçeveli ve yuvarlatılmış
      cardTheme: CardThemeData(
        color: AppColors.lightCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.lightBorder, width: 1),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      // Üst başlık çubuğu (AppBar) stili
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.lightSurface,
        foregroundColor: AppColors.lightTextPrimary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.lightTextPrimary,
          letterSpacing: -0.5,
        ),
      ),
      // Alt gezinme çubuğu (NavigationBar) stili ve aktif/pasif etiket renkleri
      navigationBarTheme: NavigationBarThemeData(
        elevation: 3,
        backgroundColor: AppColors.lightSurface,
        indicatorColor: AppColors.primaryCrimson.withValues(alpha: 0.15),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryCrimson,
            );
          }
          return const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.lightTextSecondary,
          );
        }),
      ),
      // Birincil butonların (ElevatedButton) geniş ve modern görünümü
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryCrimson,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      // Filtre ve seçim etiketleri (Chip) tasarımı
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: AppColors.lightBorder),
        ),
      ),
      // Metin giriş alanlarının (TextField) dolgulu ve çerçeveli stili
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.lightSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.lightBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.lightBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryCrimson, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  /// Uygulamanın karanlık (Dark) tema yapılandırmasını oluşturur ve döndürür.
  static ThemeData get darkTheme {
    // Karanlık tema için yüksek kontrastlı ve göz dostu renk şeması
    final colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.primaryCrimsonLight,
      onPrimary: AppColors.darkBackground,
      primaryContainer: AppColors.primaryCrimsonDark,
      onPrimaryContainer: const Color(0xFFFFDAD6),
      secondary: const Color(0xFF4DB6AC),
      onSecondary: AppColors.darkBackground,
      secondaryContainer: const Color(0xFF004D40),
      onSecondaryContainer: const Color(0xFFA7F0DF),
      tertiary: const Color(0xFFFFB74D),
      onTertiary: AppColors.darkBackground,
      error: const Color(0xFFEF5350),
      onError: AppColors.darkBackground,
      surface: AppColors.darkSurface,
      onSurface: AppColors.darkTextPrimary,
      surfaceContainerHighest: AppColors.darkBackground,
      outline: AppColors.darkBorder,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.darkBackground,
      // Kart bileşenlerinin koyu tema stili
      cardTheme: CardThemeData(
        color: AppColors.darkCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.darkBorder, width: 1),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      // Koyu tema AppBar tasarımı
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkSurface,
        foregroundColor: AppColors.darkTextPrimary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.darkTextPrimary,
          letterSpacing: -0.5,
        ),
      ),
      // Koyu tema NavigationBar tasarımı
      navigationBarTheme: NavigationBarThemeData(
        elevation: 3,
        backgroundColor: AppColors.darkSurface,
        indicatorColor: AppColors.primaryCrimsonLight.withValues(alpha: 0.2),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryCrimsonLight,
            );
          }
          return const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.darkTextSecondary,
          );
        }),
      ),
      // Koyu tema birincil buton tasarımı
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryCrimsonLight,
          foregroundColor: AppColors.darkBackground,
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      // Koyu tema etiket/çip tasarımı
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: AppColors.darkBorder),
        ),
      ),
      // Koyu tema giriş alanı (TextField) tasarımı
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.darkBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.darkBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryCrimsonLight, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}

