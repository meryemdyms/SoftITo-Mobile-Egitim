import 'package:flutter_test/flutter_test.dart';
import 'package:ritmo/core/services/app_scope.dart';
import 'package:ritmo/core/services/storage_service.dart';
import 'package:ritmo/features/auth/services/auth_service.dart';
import 'package:ritmo/features/collection/repositories/collection_repository.dart';
import 'package:ritmo/features/habits/controllers/habit_controller.dart';
import 'package:ritmo/features/habits/repositories/habit_repository.dart';
import 'package:ritmo/features/progress/controllers/analytics_controller.dart';
import 'package:ritmo/features/puzzle/repositories/artwork_repository.dart';
import 'package:ritmo/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('RitmoApp açılış testi: Splash ekranı ve Ritmo başlığı render edilir', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final storage = await StorageService.getInstance();
    final authService = AuthService(storage: storage);
    final artworkRepo = ArtworkRepository();
    final habitRepo = HabitRepository(storage: storage, artworkRepo: artworkRepo);
    final collectionRepo = CollectionRepository(storage: storage);
    final habitController = HabitController(
      repository: habitRepo,
      collectionRepository: collectionRepo,
      artworkRepository: artworkRepo,
    );
    final analyticsController = AnalyticsController(habitController: habitController);

    await tester.pumpWidget(
      AppScope(
        storageService: storage,
        authService: authService,
        habitRepository: habitRepo,
        collectionRepository: collectionRepo,
        artworkRepository: artworkRepo,
        habitController: habitController,
        analyticsController: analyticsController,
        child: RitmoApp(authService: authService),
      ),
    );

    // Splash animasyonu ve yönlendirme timer'ını tamamla
    await tester.pump(const Duration(milliseconds: 500));

    // Splash ekranında RITMO ve sloganı doğrula
    expect(find.text('RITMO'), findsOneWidget);
    expect(find.text('Küçük adımlar, büyük değişimler.'), findsOneWidget);

    await tester.pumpAndSettle(const Duration(seconds: 3));
  });
}
