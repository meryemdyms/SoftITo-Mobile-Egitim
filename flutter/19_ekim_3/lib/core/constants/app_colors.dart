import 'package:flutter/material.dart';

/// Proje genelinde kullanılan Karanlık (Dark Obsidian & Neon) ve Aydınlık (Ferah Atletik) renk paleti.
class AppColors {
  const AppColors._();

  // --- Koyu Tema Renkleri (Dark Obsidian) ---
  static const Color darkBackground = Color(0xFF0A0E17);
  static const Color darkSurface = Color(0xFF131B2A);
  static const Color darkSurfaceElevated = Color(0xFF1B263B);
  static const Color darkCardBorder = Color(0xFF22344D);

  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
  static const Color darkTextMuted = Color(0xFF64748B);

  // --- Aydınlık Tema Renkleri (Ferah Atletik Buz & Okyanus) ---
  static const Color lightBackground = Color(0xFFF6F8FC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceElevated = Color(0xFFEDF2F7);
  static const Color lightCardBorder = Color(0xFFE2E8F0);

  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF475569);
  static const Color lightTextMuted = Color(0xFF94A3B8);

  // Geriye dönük referanslar
  static const Color background = darkBackground;
  static const Color surface = darkSurface;
  static const Color surfaceElevated = darkSurfaceElevated;
  static const Color cardBorder = darkCardBorder;
  static const Color textPrimary = darkTextPrimary;
  static const Color textSecondary = darkTextSecondary;
  static const Color textMuted = darkTextMuted;

  // Vurgu Renkleri
  static const Color neonCyan = Color(0xFF00E5FF);     // Koyu mod su vurgusu
  static const Color oceanBlue = Color(0xFF0284C7);    // Açık mod su vurgusu
  static const Color neonLime = Color(0xFF00E676);     // Koyu mod egzersiz vurgusu
  static const Color athleticGreen = Color(0xFF10B981);// Açık mod egzersiz vurgusu
  static const Color neonAmber = Color(0xFFFFAB00);    // Kalori ve seri vurgusu
  static const Color warmAmber = Color(0xFFD97706);    // Açık mod seri vurgusu
  static const Color neonRose = Color(0xFFFF3366);     // Hata ve silme vurgusu
  static const Color neonPurple = Color(0xFF7C4DFF);   // Kategori vurgusu

  // Gradyanlar
  static const LinearGradient waterGradient = LinearGradient(
    colors: [Color(0xFF00B0FF), Color(0xFF00E5FF)],
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
  );

  static const LinearGradient workoutGradient = LinearGradient(
    colors: [Color(0xFF00C853), Color(0xFF69F0AE)],
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
  );
}
