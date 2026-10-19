import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'features/water_tracker/controllers/water_tracker_controller.dart';
import 'features/water_tracker/views/water_tracker_view.dart';
import 'features/workout/controllers/workout_controller.dart';
import 'features/workout/views/workout_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SusadimApp());
}

/// "Susadım v1" ana uygulama başlatıcı ve tema yapılandırması.
class SusadimApp extends StatefulWidget {
  final ThemeController? themeController;

  const SusadimApp({super.key, this.themeController});

  @override
  State<SusadimApp> createState() => _SusadimAppState();
}

class _SusadimAppState extends State<SusadimApp> {
  late final ThemeController _themeController;
  bool _isInternal = false;

  @override
  void initState() {
    super.initState();
    if (widget.themeController != null) {
      _themeController = widget.themeController!;
    } else {
      _themeController = ThemeController();
      _isInternal = true;
    }
  }

  @override
  void dispose() {
    if (_isInternal) {
      _themeController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: _themeController.themeMode,
      builder: (context, currentMode, _) {
        return MaterialApp(
          title: 'Susadım v1',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: currentMode,
          home: RootNavigationScreen(themeController: _themeController),
        );
      },
    );
  }
}

/// Sayfalar arası geçişi sağlayan ana navigasyon ekranı.
class RootNavigationScreen extends StatefulWidget {
  final ThemeController themeController;

  const RootNavigationScreen({
    super.key,
    required this.themeController,
  });

  @override
  State<RootNavigationScreen> createState() => _RootNavigationScreenState();
}

class _RootNavigationScreenState extends State<RootNavigationScreen> {
  late final WaterTrackerController _waterController;
  late final WorkoutController _workoutController;
  final ValueNotifier<int> _currentTabIndex = ValueNotifier<int>(0);

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
    _currentTabIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: _currentTabIndex,
      builder: (context, activeIndex, _) {
        return Scaffold(
          body: SafeArea(
            child: IndexedStack(
              index: activeIndex,
              children: [
                WaterTrackerView(
                  controller: _waterController,
                  themeController: widget.themeController,
                ),
                WorkoutView(controller: _workoutController),
              ],
            ),
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: activeIndex,
            onDestinationSelected: (idx) => _currentTabIndex.value = idx,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.water_drop_outlined),
                selectedIcon: Icon(Icons.water_drop_rounded),
                label: 'Su Takibi',
              ),
              NavigationDestination(
                icon: Icon(Icons.fitness_center_outlined),
                selectedIcon: Icon(Icons.fitness_center_rounded),
                label: 'Antrenman & Kalori',
              ),
            ],
          ),
        );
      },
    );
  }
}
