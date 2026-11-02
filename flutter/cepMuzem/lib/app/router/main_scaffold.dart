import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_colors.dart';

/// Cep Müzem — Ana Uygulama İskeleti (Main Scaffold)
///
/// project.md ve AGENTS.md'de belirtilen kesin 4 ana sekmeyi barındırır:
/// 1. Keşfet
/// 2. Harita
/// 3. Müzeni Oluştur
/// 4. Profil
///
/// StatefulNavigationShell kullanarak sekmeler arası geçişte her sekmenin
/// scroll ve sayfa durumunu korur.
class MainScaffold extends StatelessWidget {
  /// go_router tarafından yönetilen sekmeli navigasyon kabuğu
  final StatefulNavigationShell navigationShell;

  const MainScaffold({super.key, required this.navigationShell});

  /// Alt navigasyon çubuğunda bir sekmeye tıklandığında ilgili dala geçişi sağlar
  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      // Eğer kullanıcı zaten bulunduğu sekmeye tekrar dokunursa en başa (root) dönmesini sağlar
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Aktif sekmenin gövdesi burada görüntülenir
      body: navigationShell,
      bottomNavigationBar: Container(
        // Yaşayan Müze tasarım sistemi: Üst kenarlık Museum Stone renginde ince çizgi
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: AppColors.museumStone, width: 0.8),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: navigationShell.currentIndex,
          onTap: _onTap,
          // Kesin 4 bottom navigation öğesi (Yeni sekme eklenemez veya çıkarılamaz)
          items: const [
            // 1. Keşfet Sekmesi
            BottomNavigationBarItem(
              icon: Icon(Icons.museum_outlined),
              activeIcon: Icon(Icons.museum),
              label: 'Keşfet',
            ),
            // 2. Harita Sekmesi
            BottomNavigationBarItem(
              icon: Icon(Icons.map_outlined),
              activeIcon: Icon(Icons.map),
              label: 'Harita',
            ),
            // 3. Müzeni Oluştur Sekmesi
            BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline),
              activeIcon: Icon(Icons.add_circle),
              label: 'Müzeni Oluştur',
            ),
            // 4. Profil Sekmesi
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}

