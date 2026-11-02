import 'package:flutter/material.dart';

/// Uygulama genelinde açık/koyu tema durumunu yöneten ve
/// [ThemeMode] değişikliklerini [ValueNotifier] ile reaktif olarak yayınlayan kontrolcü sınıfı.
class ThemeController {
  /// Başlangıç tema modunu belirleyerek [themeMode] dinleyicisini ilklendirir.
  /// Varsayılan olarak sistem teması ([ThemeMode.system]) seçilidir.
  ThemeController({ThemeMode initialMode = ThemeMode.system})
      : themeMode = ValueNotifier<ThemeMode>(initialMode);

  /// Tema modunu dışarıya yayınlayan dinlenebilir nesne.
  final ValueNotifier<ThemeMode> themeMode;

  /// Açık ve koyu tema arasında hızlı geçiş yapar (Koyuysa Açık, değilse Koyu yapar).
  void toggleTheme() {
    if (themeMode.value == ThemeMode.dark) {
      themeMode.value = ThemeMode.light;
    } else {
      themeMode.value = ThemeMode.dark;
    }
  }

  /// Belirli bir tema modunu doğrudan atar (örneğin ayarlardan seçim yapıldığında).
  void setTheme(ThemeMode mode) {
    if (themeMode.value != mode) {
      themeMode.value = mode;
    }
  }

  /// Aktif temanın koyu modda olup olmadığını kontrol eder.
  /// Sistem teması seçiliyse cihazın anlık sistem temasını (platformBrightness) sorgular.
  bool isDarkMode(BuildContext context) {
    if (themeMode.value == ThemeMode.system) {
      return MediaQuery.of(context).platformBrightness == Brightness.dark;
    }
    return themeMode.value == ThemeMode.dark;
  }

  /// Kontrolcü yok edildiğinde bellek sızıntısını önlemek için ValueNotifier'ı kapatır.
  void dispose() {
    themeMode.dispose();
  }
}

