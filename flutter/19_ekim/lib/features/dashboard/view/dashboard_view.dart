import 'package:flutter/material.dart';
import 'package:susadim/core/constants/app_colors.dart';
import 'package:susadim/features/water_tracker/controller/water_tracker_controller.dart';
import 'package:susadim/features/water_tracker/view/water_tracker_view.dart';
import 'package:susadim/features/workout/controller/workout_controller.dart';
import 'package:susadim/features/workout/view/workout_view.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  late final WaterTrackerController _waterController;
  late final WorkoutController _workoutController;
  final ValueNotifier<int> _currentIndex = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    _waterController = WaterTrackerController();
    _workoutController = WorkoutController();
  }

  @override
  void dispose() {
    _waterController.dispose();
    _workoutController.dispose();
    _currentIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: _currentIndex,
      builder: (context, index, _) {
        return Scaffold(
          appBar: _DashboardAppBar(currentIndex: index),
          body: IndexedStack(
            index: index,
            children: [
              WaterTrackerView(controller: _waterController),
              WorkoutView(controller: _workoutController),
            ],
          ),
          bottomNavigationBar: _DashboardNavBar(
            currentIndex: index,
            onDestinationSelected: (idx) => _currentIndex.value = idx,
          ),
        );
      },
    );
  }
}

class _DashboardAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _DashboardAppBar({required this.currentIndex});

  final int currentIndex;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final title = currentIndex == 0 ? '💧 Susadım - Su Takibi' : '⚡ Susadım - Egzersiz';
    final accent = currentIndex == 0 ? AppColors.neonCyan : AppColors.neonLime;

    return AppBar(
      title: Row(
        children: [
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

class _DashboardNavBar extends StatelessWidget {
  const _DashboardNavBar({
    required this.currentIndex,
    required this.onDestinationSelected,
  });

  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onDestinationSelected,
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.water_drop_outlined),
          selectedIcon: Icon(Icons.water_drop, color: AppColors.neonCyan),
          label: 'Su Takibi',
        ),
        NavigationDestination(
          icon: Icon(Icons.fitness_center_outlined),
          selectedIcon: Icon(Icons.fitness_center, color: AppColors.neonLime),
          label: 'Egzersiz & Kalori',
        ),
      ],
    );
  }
}
