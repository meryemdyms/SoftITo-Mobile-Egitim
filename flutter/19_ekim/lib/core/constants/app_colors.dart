import 'package:flutter/material.dart';

/// Dark Obsidian & Neon Gece Spor Salonu Renk Paleti.
///
/// `abstract final class` yapısı Dart 3 ile gelen bir tasarım desenidir:
/// - `abstract`: Sınıfın doğrudan `new AppColors()` veya `AppColors()` şeklinde örneğinin (instance) alınmasını engeller.
/// - `final`: Başka bir sınıf tarafından `extends` ya da `implements` edilmesini önler.
/// Bu sayede yalnızca statik sabitleri (constants) organize eden güvenli bir isim alanı (namespace) görevi görür.
abstract final class AppColors {

  static const Color obsidianBackground = Color(0xFF090D12);

  static const Color obsidianSurface = Color(0xFF111720);


  static const Color obsidianCard = Color(0xFF17202C);


  static const Color obsidianCardHighlight = Color(0xFF1F2B3B);


  static const Color obsidianBorder = Color(0xFF263547);




  static const Color neonCyan = Color(0xFF00F5FF);


  static const Color neonBlue = Color(0xFF0077FE);

 
  static const Color neonLime = Color(0xFFCCFF00);


  static const Color neonCoral = Color(0xFFFF5252);


  static const Color neonOrange = Color(0xFFFF9100);

  static const Color neonPurple = Color(0xFFB388FF);

  static const Color textPrimary = Color(0xFFF1F5F9);

  static const Color textSecondary = Color(0xFF94A3B8);

  static const Color textMuted = Color(0xFF64748B);

  static const Color success = Color(0xFF00E676);

  static const Color error = Color(0xFFFF1744);
}
