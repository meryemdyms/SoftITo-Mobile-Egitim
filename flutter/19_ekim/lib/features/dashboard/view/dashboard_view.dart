import 'package:flutter/material.dart';
import 'package:susadim/core/constants/app_colors.dart';
import 'package:susadim/features/water_tracker/controller/water_tracker_controller.dart';
import 'package:susadim/features/water_tracker/view/water_tracker_view.dart';
import 'package:susadim/features/workout/controller/workout_controller.dart';
import 'package:susadim/features/workout/view/workout_view.dart';

/// Uygulamanın ana kontrol paneli (Dashboard) ekranı.
///
/// Su takibi ve Egzersiz/Kalori sekmelerini barındırır.
/// Bu ekran [StatefulWidget] olarak tanımlanmıştır çünkü:
/// - Controller nesnelerinin yaşam döngüsü (Lifecycle: init & dispose) burada yönetilir.
/// - Aktif sekme indeksi ([ValueNotifier]) burada saklanır.
class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  /// Su takip modülünün denetleyicisi
  late final WaterTrackerController _waterController;

  /// Egzersiz modülünün denetleyicisi
  late final WorkoutController _workoutController;

  /// Aktif olarak seçili olan alt sekme indeksini tutan reaktif bildirim nesnesi
  /// (0: Su Takibi, 1: Egzersiz)
  final ValueNotifier<int> _currentIndex = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    // Ekran ilk açıldığında controller nesneleri başlatılır (Instantiation)
    _waterController = WaterTrackerController();
    _workoutController = WorkoutController();
  }

  @override
  void dispose() {
    // Bellek sızıntılarını (Memory Leak) önlemek için oluşturulan
    // tüm Controller ve ValueNotifier nesneleri dispose edilmelidir.
    _waterController.dispose();
    _workoutController.dispose();
    _currentIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ValueListenableBuilder, yalnızca _currentIndex değeri değiştiğinde
    // ilgili widget bloğunu tetikler; gereksiz genel sayfa rebuild'lerini engeller.
    return ValueListenableBuilder<int>(
      valueListenable: _currentIndex,
      builder: (context, index, _) {
        return Scaffold(
          // Aktif sekmeye göre başlığı ve rengi değişen özel AppBar
          appBar: _DashboardAppBar(currentIndex: index),

          // IndexedStack: Sekmeler arasında gezinirken her iki sayfanın da
          // durumunu (scroll konumu, girilen veriler vb.) bellekte canlı tutar.
          // Sayfaların yeniden oluşturulmasını önleyerek yüksek performans sağlar.
          body: IndexedStack(
            index: index,
            children: [
              WaterTrackerView(controller: _waterController),
              WorkoutView(controller: _workoutController),
            ],
          ),

          // Alt gezinme çubuğu (Bottom Navigation)
          bottomNavigationBar: _DashboardNavBar(
            currentIndex: index,
            onDestinationSelected: (idx) => _currentIndex.value = idx,
          ),
        );
      },
    );
  }
}

/// Dashboard ekranının üst başlık çubuğu bileşeni.
///
/// Flutter'da bir AppBar'ın Scaffold içinde `appBar:` parametresine verilebilmesi
/// için [PreferredSizeWidget] arayüzünü (interface) uygulaması ve [preferredSize]
/// özelliğini sağlaması zorunludur.
class _DashboardAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _DashboardAppBar({required this.currentIndex});

  final int currentIndex;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    // Seçili sekmeye göre dinamik başlık ve neon durum noktası rengi belirlenir
    final title = currentIndex == 0 ? '💧 Susadım - Su Takibi' : '⚡ Susadım - Egzersiz';
    final accent = currentIndex == 0 ? AppColors.neonCyan : AppColors.neonLime;

    return AppBar(
      title: Row(
        children: [
          // Aktif sekmenin rengini yansıtan küçük dairesel neon durum noktası
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(color: accent, shape: BoxShape.circle),
          ),
          Expanded(
            child: Text(
              title,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

/// Material 3 standartlarında alt gezinme çubuğu (NavigationBar) bileşeni
class _DashboardNavBar extends StatelessWidget {
  const _DashboardNavBar({
    required this.currentIndex,
    required this.onDestinationSelected,
  });

  /// Seçili sekme indeksi
  final int currentIndex;

  /// Kullanıcı farklı bir sekmeye tıkladığında tetiklenen fonksiyon
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onDestinationSelected,
      destinations: const [
        // 1. Sekme: Su Takibi
        NavigationDestination(
          icon: Icon(Icons.water_drop_outlined),
          selectedIcon: Icon(Icons.water_drop, color: AppColors.neonCyan),
          label: 'Su Takibi',
        ),
        // 2. Sekme: Egzersiz & Kalori
        NavigationDestination(
          icon: Icon(Icons.fitness_center_outlined),
          selectedIcon: Icon(Icons.fitness_center, color: AppColors.neonLime),
          label: 'Egzersiz & Kalori',
        ),
      ],
    );
  }
}
