import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/viewmodels/auth_viewmodel.dart';
import '../../features/auth/views/login_view.dart';
import '../../features/auth/views/register_view.dart';
import '../../features/explore/views/explore_view.dart';
import '../../features/map/views/map_view.dart';
import '../../features/museum_creation/views/museum_creation_view.dart';
import '../../features/museum_detail/views/museum_detail_view.dart';
import '../../features/notifications/views/notifications_view.dart';
import '../../features/profile/views/profile_view.dart';
import '../../features/splash/views/splash_view.dart';
import '../../shared/widgets/museum_empty_state.dart';
import 'main_scaffold.dart';

/// Cep Müzem — Uygulama Navigasyon Yapılandırması (go_router)
///
/// Uygulamanın tüm sayfa geçişlerini, alt navigasyon (IndexedStack) durumlarını,
/// oturum koruyucularını (route guards) ve hata sayfalarını yönetir.
class AppRouter {
  /// Oturum durumuna göre rotaları dinamik olarak yeniden tetiklemek için dinlenen ViewModel
  final AuthViewModel authViewModel;

  AppRouter({required this.authViewModel});

  /// [GoRouter] örneği; sayfa rotalarını, dallanmaları ve yönlendirme mantığını tanımlar.
  late final GoRouter router = GoRouter(
    initialLocation: '/splash',
    // AuthViewModel dinlenerek oturum durumu değiştiğinde redirect mantığı anında tetiklenir
    refreshListenable: authViewModel,
    routes: [
      // 1. Splash Ekranı: Uygulama logosu ve oturum kontrolü
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashView(),
      ),

      // 2. Kimlik Doğrulama Rotaları (Giriş ve Kayıt)
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginView(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterView(),
      ),

      // 3. Alt Navigasyonlu Ana İskelet (Kesin 4 sekme kuralı)
      // StatefulShellRoute ile her sekmenin kendi gezinme geçmişi korunur.
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainScaffold(navigationShell: navigationShell);
        },
        branches: [
          // 1. Sekme: Keşfet (Dijital sergi kataloğu, takip edilenler ve popüler akış)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/explore',
                builder: (context, state) => const ExploreView(),
              ),
            ],
          ),
          // 2. Sekme: Harita (Müze pinleri ve ziyaret keşfi)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/map',
                builder: (context, state) => const MapView(),
              ),
            ],
          ),
          // 3. Sekme: Müzeni Oluştur (Küratör atölyesi, oda şablonları, eser yerleşimi)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/create',
                builder: (context, state) => const MuseumCreationView(),
              ),
            ],
          ),
          // 4. Sekme: Profil (Küratör bilgileri, Müzelerim, Kaydettiklerim, Ayarlar)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfileView(),
              ),
            ],
          ),
        ],
      ),

      // 4. Müze Detay Ekranı: 2D simülasyon, eser inceleme, sesli rehber ve yorumlar
      GoRoute(
        path: '/museum/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return MuseumDetailView(museumId: id);
        },
      ),

      // 5. Bildirimler Ekranı: Sağ üstteki zil simgesinden açılan etkileşim listesi
      GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationsView(),
      ),
    ],

    // Rota Koruyucuları (Route Guards & Redirect Mantığı)
    // Oturum durumuna ve bulunulan rotaya göre güvenli yönlendirme sağlar.
    redirect: (context, state) {
      final isLoggingIn =
          state.matchedLocation == '/login' ||
          state.matchedLocation == '/register';
      final isSplash = state.matchedLocation == '/splash';

      // Splash ekranındayken yönlendirme yapılmaz, splash kendi zamanlamasını yönetir
      if (isSplash) return null;

      final isAuthenticated = authViewModel.isAuthenticated;

      // Kullanıcı oturum açmamışsa ve auth dışındaki korumalı rotalara erişmeye çalışıyorsa
      if (!isAuthenticated && !isLoggingIn) {
        return '/login';
      }

      // Kullanıcı zaten oturum açmışsa login veya register sayfalarında kalması engellenir
      if (isAuthenticated && isLoggingIn) {
        return '/explore';
      }

      // Herhangi bir yönlendirme gerekmiyorsa rota normal seyrinde devam eder
      return null;
    },

    // 404 / Hatalı Sayfa Durumu Yönetimi
    // Geçersiz bir URL veya rota istendiğinde kullanıcı dostu boş durum ekranı sunulur
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Sayfa Bulunamadı')),
      body: MuseumEmptyState(
        title: 'Geçersiz İstek',
        message: 'Aradığınız sergi veya sayfa bulunamadı: ${state.uri}',
        icon: Icons.error_outline,
        actionLabel: 'Ana Sayfaya Dön',
        onAction: () => context.go('/explore'),
      ),
    ),
  );
}

