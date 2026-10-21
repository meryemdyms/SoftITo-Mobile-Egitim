import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';
import 'app_dimensions.dart';
import 'app_typography.dart';

/// Cep Müzem — Yaşayan Müze Merkezi Teması
class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
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
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.ivory,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: AppTypography.pageTitle,
        iconTheme: const IconThemeData(color: AppColors.deepWalnut, size: 24),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      cardTheme: CardThemeData(
        color: AppColors.museumWhite,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppDimensions.cardBorderRadius,
          side: const BorderSide(color: AppColors.museumStone, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
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
