import 'package:flutter/material.dart';
import 'app_shell.dart';
import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';

/// Uygulamanın giriş noktası (Entry Point).
void main() {
  // Flutter motoru (engine) ile widget ağacı arasındaki köprüyü native servisler
  // çağrılmadan önce hazır hale getirir.
  WidgetsFlutterBinding.ensureInitialized();

  // Uygulama genelinde tema yönetimini sağlayacak kontrolcüyü başlatır.
  final themeController = ThemeController();

  // Kök widget'ı başlatır ve tema kontrolcüsünü parametre olarak aktarır.
  runApp(KirmiziCagriApp(themeController: themeController));
}

/// Uygulamanın ana MaterialApp kapsayıcısı.
class KirmiziCagriApp extends StatelessWidget {
  const KirmiziCagriApp({super.key, required this.themeController});

  /// Açık/Koyu tema durumunu yöneten nesne.
  final ThemeController themeController;

  @override
  Widget build(BuildContext context) {
    // Tema modundaki (Açık / Koyu / Sistem) değişiklikleri reaktif olarak dinler
    // ve tüm MaterialApp'in temasını günceller.
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeController.themeMode,
      builder: (context, themeMode, _) {
        return MaterialApp(
          title: AppConstants.appName,
          debugShowCheckedModeBanner: false, // Debug etiketini gizler
          theme: AppTheme.lightTheme, // Aydınlık tema ayarları
          darkTheme: AppTheme.darkTheme, // Karanlık tema ayarları
          themeMode: themeMode, // Aktif tema modu
          home: AppShell(themeController: themeController), // Ana gezinme kabuğu
        );
      },
    );
  }
}

