import 'package:flutter/material.dart';
import 'core/services/app_scope.dart';
import 'core/services/storage_service.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/services/auth_service.dart';
import 'features/auth/views/splash_view.dart';
import 'features/collection/repositories/collection_repository.dart';
import 'features/habits/controllers/habit_controller.dart';
import 'features/habits/models/habit_models.dart';
import 'features/habits/repositories/habit_repository.dart';
import 'features/progress/controllers/analytics_controller.dart';
import 'features/puzzle/repositories/artwork_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final storageService = await StorageService.getInstance();
  final authService = AuthService(storage: storageService);
  await authService.init();

  final artworkRepository = ArtworkRepository();
  final habitRepository = HabitRepository(
    storage: storageService,
    artworkRepo: artworkRepository,
  );
  final collectionRepository = CollectionRepository(storage: storageService);

  final habitController = HabitController(
    repository: habitRepository,
    collectionRepository: collectionRepository,
    artworkRepository: artworkRepository,
  );

  // Verileri yükle
  await habitController.loadAll();

  // İlk açılışta rehber olması için örnek bir başlangıç alışkanlığı ekle (eğer liste tamamen boşsa)
  if (habitController.habits.isEmpty) {
    await habitController.addHabit(
      userId: authService.currentUser?.id ?? 'demo_user',
      name: 'Günde 20 Sayfa Kitap Oku',
      category: 'Kişisel Gelişim',
      icon: 'book',
      colorValue: 0xFF344E41,
      measurementType: MeasurementType.quantity,
      unit: 'sayfa',
      frequency: FrequencyType.everyday,
      selectedDays: [1, 2, 3, 4, 5, 6, 7],
      targetValue: 20,
      startDate: DateTime.now(),
      endDate: DateTime.now().add(const Duration(days: 29)),
      reminderTime: '21:00',
    );
  }

  final analyticsController = AnalyticsController(
    habitController: habitController,
  );

  runApp(
    AppScope(
      storageService: storageService,
      authService: authService,
      habitRepository: habitRepository,
      collectionRepository: collectionRepository,
      artworkRepository: artworkRepository,
      habitController: habitController,
      analyticsController: analyticsController,
      child: RitmoApp(authService: authService),
    ),
  );
}

class RitmoApp extends StatelessWidget {
  final AuthService authService;

  const RitmoApp({super.key, required this.authService});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ritmo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: SplashView(authService: authService),
    );
  }
}
