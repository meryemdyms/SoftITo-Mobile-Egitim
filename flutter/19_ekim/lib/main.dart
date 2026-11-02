import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:susadim/core/constants/app_colors.dart';
import 'package:susadim/core/theme/app_theme.dart';
import 'package:susadim/features/dashboard/view/dashboard_view.dart';

/// Uygulamanın başlangıç noktası (Entry Point).
/// Dart runtime ilk olarak [main] fonksiyonunu çalıştırır.
void main() {
  // Flutter widget ağacı ve motoru arasındaki iletişimin (binding)
  // native platform servisleri (SystemChrome vb.) çağrılmadan önce
  // hazır olmasını garanti eder.
  WidgetsFlutterBinding.ensureInitialized();

  // Cihazın durum çubuğu (Status Bar) ve alt sistem navigasyon çubuğunun
  // (Navigation Bar) renk ve ikon parlaklığı ayarları.
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Şeffaf durum çubuğu
      statusBarIconBrightness: Brightness.light, // Açık renkli (beyaz) durum simgeleri
      systemNavigationBarColor: AppColors.obsidianSurface, // Koyu obsidyen zemin
      systemNavigationBarIconBrightness: Brightness.light, // Açık renkli alt navigasyon simgeleri
    ),
  );

  // Uygulamanın kök widget'ını ayağa kaldırır
  runApp(const SusadimApp());
}

/// Uygulamanın kök widget'ı (Root Widget).
/// Tüm tema, genel başlık ve navigasyon yapılandırması burada tanımlanır.
class SusadimApp extends StatelessWidget {
  const SusadimApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Susadım',
      // Geliştirme aşamasındaki sağ üstteki 'DEBUG' bandını gizler
      debugShowCheckedModeBanner: false,
      // Uygulamanın Dark Obsidian & Neon temasını uygular
      theme: AppTheme.darkTheme,
      // Uygulama açılışında gösterilecek ana kontrol paneli ekranı
      home: const DashboardView(),
    );
  }
}
