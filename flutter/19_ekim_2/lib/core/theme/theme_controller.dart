import 'package:flutter/material.dart';

/// Karanlık, Aydınlık ve Sistem tema modunu yöneten ValueNotifier tabanlı kontrolcü.
class ThemeController {
  final ValueNotifier<ThemeMode> themeMode;

  ThemeController([ThemeMode initial = ThemeMode.system])
      : themeMode = ValueNotifier<ThemeMode>(initial);

  bool get isDarkMode => themeMode.value == ThemeMode.dark;

  bool isDark(BuildContext context) {
    if (themeMode.value == ThemeMode.system) {
      return MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    }
    return themeMode.value == ThemeMode.dark;
  }

  /// Temayı karanlık ve aydınlık mod arasında değiştirir
  void toggleTheme([BuildContext? context]) {
    final currentIsDark = context != null
        ? isDark(context)
        : (themeMode.value != ThemeMode.light);

    themeMode.value = currentIsDark ? ThemeMode.light : ThemeMode.dark;
  }

  /// Belirli bir tema modunu ayarlar
  void setThemeMode(ThemeMode mode) {
    themeMode.value = mode;
  }

  void dispose() {
    themeMode.dispose();
  }
}
