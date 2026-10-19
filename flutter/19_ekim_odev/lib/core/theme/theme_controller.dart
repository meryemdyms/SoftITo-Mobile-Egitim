import 'package:flutter/material.dart';

/// Uygulama temasını yöneten ve ThemeMode durumunu ValueNotifier ile yayınlayan kontrolcü
class ThemeController {
  ThemeController({ThemeMode initialMode = ThemeMode.system})
      : themeMode = ValueNotifier<ThemeMode>(initialMode);

  final ValueNotifier<ThemeMode> themeMode;

  void toggleTheme() {
    if (themeMode.value == ThemeMode.dark) {
      themeMode.value = ThemeMode.light;
    } else {
      themeMode.value = ThemeMode.dark;
    }
  }

  void setTheme(ThemeMode mode) {
    if (themeMode.value != mode) {
      themeMode.value = mode;
    }
  }

  bool isDarkMode(BuildContext context) {
    if (themeMode.value == ThemeMode.system) {
      return MediaQuery.of(context).platformBrightness == Brightness.dark;
    }
    return themeMode.value == ThemeMode.dark;
  }

  void dispose() {
    themeMode.dispose();
  }
}
