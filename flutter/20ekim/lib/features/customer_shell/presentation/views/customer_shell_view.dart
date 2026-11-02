import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';

/// Misafir ve Müşteri kullanıcıları için durum korumalı alt sekmeleri (Bottom Navigation) barındıran kabuk görünüm.
///
/// Keşfet, Harita, Fırsatlar, Rezervasyon ve Profil sekmeleri arasında durum kaybetmeden geçişi sağlar.
class CustomerShellView extends StatelessWidget {
  /// GoRouter tarafından sağlanan durum korumalı gezinme kabuğu.
  final StatefulNavigationShell navigationShell;

  const CustomerShellView({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) {
          // İlgili sekmeye geçiş yapar, mevcut sekmedeyse ilk sayfaya geri döner
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        destinations: const [
          // 0. Sekme: Araç Arama ve Ana Keşif
          NavigationDestination(
            icon: Icon(Icons.search_rounded),
            selectedIcon: Icon(Icons.search_rounded, color: AppColors.primary),
            label: 'Keşfet',
          ),
          // 1. Sekme: Haritada Firmaları ve Araçları Görme
          NavigationDestination(
            icon: Icon(Icons.map_outlined),
            selectedIcon: Icon(Icons.map_rounded, color: AppColors.primary),
            label: 'Harita',
          ),
          // 2. Sekme: Kampanyalar ve İndirimli Fırsatlar
          NavigationDestination(
            icon: Icon(Icons.local_offer_outlined),
            selectedIcon: Icon(
              Icons.local_offer_rounded,
              color: AppColors.primary,
            ),
            label: 'Fırsatlar',
          ),
          // 3. Sekme: Müşteri Rezervasyonlarım
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(
              Icons.calendar_month_rounded,
              color: AppColors.primary,
            ),
            label: 'Rezervasyon',
          ),
          // 4. Sekme: Kullanıcı Profili ve Oturum
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded, color: AppColors.primary),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
