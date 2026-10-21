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

class AppRouter {
  final AuthViewModel authViewModel;

  AppRouter({required this.authViewModel});

  late final GoRouter router = GoRouter(
    initialLocation: '/splash',
    refreshListenable: authViewModel,
    routes: [
      // Splash
      GoRoute(path: '/splash', builder: (context, state) => const SplashView()),

      // Auth Routes
      GoRoute(path: '/login', builder: (context, state) => const LoginView()),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterView(),
      ),

      // Bottom Navigation Stateful Branches (Kesin 4 sekme)
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainScaffold(navigationShell: navigationShell);
        },
        branches: [
          // 1. Keşfet
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/explore',
                builder: (context, state) => const ExploreView(),
              ),
            ],
          ),
          // 2. Harita
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/map',
                builder: (context, state) => const MapView(),
              ),
            ],
          ),
          // 3. Müzeni Oluştur
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/create',
                builder: (context, state) => const MuseumCreationView(),
              ),
            ],
          ),
          // 4. Profil
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

      // Müze Detay Ekranı
      GoRoute(
        path: '/museum/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return MuseumDetailView(museumId: id);
        },
      ),

      // Bildirimler Ekranı
      GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationsView(),
      ),
    ],

    // Route Guards & Redirect
    redirect: (context, state) {
      final isLoggingIn =
          state.matchedLocation == '/login' ||
          state.matchedLocation == '/register';
      final isSplash = state.matchedLocation == '/splash';

      if (isSplash) return null;

      final isAuthenticated = authViewModel.isAuthenticated;

      // Oturum yoksa ve korumalı alandaysa
      if (!isAuthenticated && !isLoggingIn) {
        return '/login';
      }

      // Oturum varsa ve login/register sayfalarındaysa Keşfet'e git
      if (isAuthenticated && isLoggingIn) {
        return '/explore';
      }

      return null;
    },

    // 404 / Hatalı Sayfa Durumu
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
