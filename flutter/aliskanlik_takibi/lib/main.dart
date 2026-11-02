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

/// Uygulamanın ana giriş noktası.
///
/// Flutter bağlayıcılarını başlatır, kalıcı depolama ve servisleri ayağa kaldırır,
/// bağımlılık enjeksiyonunu (DI) [AppScope] ile kurar ve başlangıç verilerini hazırlar.
void main() async {
  // Flutter motoru ve widget bağlayıcılarının hazır olduğundan emin olunur
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Kalıcı yerel depolama servisini (SharedPreferences) tekil (singleton) olarak başlat
  final storageService = await StorageService.getInstance();

  // 2. Kimlik doğrulama ve kullanıcı oturum servisini başlat
  final authService = AuthService(storage: storageService);
  await authService.init();

  // 3. Sanat eserleri, yapboz ve koleksiyon depolarını oluştur
  final artworkRepository = ArtworkRepository();
  final habitRepository = HabitRepository(
    storage: storageService,
    artworkRepo: artworkRepository,
  );
  final collectionRepository = CollectionRepository(storage: storageService);

  // 4. Alışkanlık ve yapboz durumlarını yöneten ana kontrolcüyü (Controller) başlat
  final habitController = HabitController(
    repository: habitRepository,
    collectionRepository: collectionRepository,
    artworkRepository: artworkRepository,
  );

  // Kayıtlı tüm alışkanlık, süreç ve yapboz verilerini yerel depodan hafızaya yükle
  await habitController.loadAll();

  // İlk açılışta kullanıcıya rehber olması için örnek bir başlangıç alışkanlığı ekle
  // (Eğer kullanıcının listesi tamamen boşsa)
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

  // 5. İstatistik ve analitik hesaplamaları yürüten kontrolcüyü başlat
  final analyticsController = AnalyticsController(
    habitController: habitController,
  );

  // 6. Uygulama ağacını AppScope ile sarmalayarak tüm alt widget'ların servislere erişmesini sağla
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

/// Ritmo uygulamasının kök widget'ı.
///
/// Uygulama temasını, başlığını ve ilk açılış ekranı olan [SplashView]'ı yapılandırır.
class RitmoApp extends StatelessWidget {
  /// Oturum durumunu dinlemek ve yönlendirme yapmak için kullanılan servis
  final AuthService authService;

  const RitmoApp({super.key, required this.authService});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ritmo',
      debugShowCheckedModeBanner: false,
      // project.md tasarım kurallarına uygun Material 3 teması
      theme: AppTheme.lightTheme,
      // Uygulama başlangıcında açılış animasyonu ve yönlendirme yapan Splash ekranı
      home: SplashView(authService: authService),
    );
  }
}
