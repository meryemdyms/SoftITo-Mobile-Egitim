import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Cep Müzem — Tipografi Sistemi (museum-design-system)
/// Başlıklar: Cormorant Garamond
/// Gövde: Inter
class AppTypography {
  AppTypography._();

  static TextStyle get pageTitle => GoogleFonts.cormorantGaramond(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    color: AppColors.deepWalnut,
    letterSpacing: 0.2,
  );

  static TextStyle get sectionTitle => GoogleFonts.cormorantGaramond(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.deepWalnut,
    letterSpacing: 0.15,
  );

  static TextStyle get cardTitle => GoogleFonts.cormorantGaramond(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.deepWalnut,
  );

  static TextStyle get body => GoogleFonts.inter(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.deepWalnut,
    height: 1.45,
  );

  static TextStyle get bodySecondary => GoogleFonts.inter(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.secondaryText,
    height: 1.4,
  );

  static TextStyle get caption => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.secondaryText,
    letterSpacing: 0.2,
  );

  static TextStyle get buttonText => GoogleFonts.inter(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.museumWhite,
  );

  static TextStyle get museumBadge => GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: AppColors.antiqueBronze,
    letterSpacing: 0.5,
  );
}
