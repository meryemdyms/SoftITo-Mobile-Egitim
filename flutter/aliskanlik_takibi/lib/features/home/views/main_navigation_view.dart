import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../collection/views/collection_view.dart';
import '../../habits/views/create_habit_view.dart';
import '../../habits/views/habits_list_view.dart';
import '../../profile/views/profile_view.dart';
import '../../progress/views/progress_view.dart';
import 'home_view.dart';

/// Ritmo Ana Gezinme Kabuğu (Main Navigation View).
///
/// `project.md` 4. Navigasyon kurallarına göre 5 ana sekmeyi barındırır:
/// 1. Ana Sayfa ([HomeView])
/// 2. Alışkanlıklar ([HabitsListView])
/// 3. Gelişim ([ProgressView])
/// 4. Başarılar ([CollectionView])
/// 5. Profil ([ProfileView])
///
/// Ekran durumlarını korumak için [IndexedStack] kullanır ve sekmeye göre
/// dinamik yüzen işlem butonu (FloatingActionButton) sunar.
class MainNavigationView extends StatefulWidget {
  final int initialIndex;

  const MainNavigationView({super.key, this.initialIndex = 0});

  @override
  State<MainNavigationView> createState() => _MainNavigationViewState();
}

class _MainNavigationViewState extends State<MainNavigationView> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    // 5 temel sekme ekranı
    final screens = [
      const HomeView(),
      const HabitsListView(),
      const ProgressView(),
      const CollectionView(),
      const ProfileView(),
    ];

    return Scaffold(
      // Sayfalar arası geçişlerde scroll pozisyonunu ve state'i koruyan IndexedStack
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),

      // Alt Gezinme Çubuğu (BottomNavigationBar)
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) => setState(() => _currentIndex = index),
              backgroundColor: Colors.transparent,
              elevation: 0,
              items: const [
                // 1. Sekme: Ana Sayfa
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  activeIcon: Icon(Icons.home_rounded),
                  label: 'Ana Sayfa',
                ),
                // 2. Sekme: Alışkanlıklar
                BottomNavigationBarItem(
                  icon: Icon(Icons.fact_check_outlined),
                  activeIcon: Icon(Icons.fact_check_rounded),
                  label: 'Alışkanlıklar',
                ),
                // 3. Sekme: Gelişim ve Analiz
                BottomNavigationBarItem(
                  icon: Icon(Icons.insights_outlined),
                  activeIcon: Icon(Icons.insights_rounded),
                  label: 'Gelişim',
                ),
                // 4. Sekme: Başarı Koleksiyonu
                BottomNavigationBarItem(
                  icon: Icon(Icons.photo_library_outlined),
                  activeIcon: Icon(Icons.photo_library_rounded),
                  label: 'Başarılar',
                ),
                // 5. Sekme: Kullanıcı Profili
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline_rounded),
                  activeIcon: Icon(Icons.person_rounded),
                  label: 'Profil',
                ),
              ],
            ),
          ),
        ),
      ),

      // Yalnızca 'Alışkanlıklar' sekmesindeyken görünen hızlı alışkanlık ekleme butonu
      floatingActionButton: _currentIndex == 1
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const CreateHabitView()),
                );
              },
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.textOnPrimary,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Yeni Alışkanlık'),
            )
          : null,
    );
  }
}
