import 'package:flutter_test/flutter_test.dart';
import 'package:ritmo/core/services/storage_service.dart';
import 'package:ritmo/features/collection/repositories/collection_repository.dart';
import 'package:ritmo/features/habits/controllers/habit_controller.dart';
import 'package:ritmo/features/habits/models/habit_models.dart';
import 'package:ritmo/features/habits/repositories/habit_repository.dart';
import 'package:ritmo/features/progress/controllers/analytics_controller.dart';
import 'package:ritmo/features/puzzle/repositories/artwork_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late StorageService storage;
  late HabitRepository habitRepo;
  late CollectionRepository collectionRepo;
  late HabitController habitController;
  late AnalyticsController analyticsController;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    storage = await StorageService.getInstance();
    habitRepo = HabitRepository(storage: storage);
    collectionRepo = CollectionRepository(storage: storage);
    habitController = HabitController(
      repository: habitRepo,
      collectionRepository: collectionRepo,
      artworkRepository: ArtworkRepository(),
    );
    analyticsController = AnalyticsController(habitController: habitController);
    await habitController.loadAll();
  });

  group('Gelişim ve Analiz Testleri', () {
    test('Gün başarı oranı ile miktar başarı oranı farklı hesaplanır (Kesin İş Kuralı)', () async {
      // Örnek: 10 günlük hedef, günlük 20 sayfa (toplam 200 sayfa)
      // Kullanıcı 5 gün 40 sayfa okudu.
      // Gün başarı oranı: 5 / 10 = %50
      // Miktar başarı oranı: 200 / 200 = %100
      final habit = await habitController.addHabit(
        userId: 'u1',
        name: 'Hızlı Okuma',
        category: 'Kişisel Gelişim',
        icon: 'book',
        colorValue: 0xFF344E41,
        measurementType: MeasurementType.quantity,
        unit: 'sayfa',
        frequency: FrequencyType.everyday,
        selectedDays: [1, 2, 3, 4, 5, 6, 7],
        targetValue: 20,
        startDate: DateTime(2026, 1, 1),
        endDate: DateTime(2026, 1, 10), // 10 gün
      );

      // 5 gün boyunca günde 40 sayfa kaydet
      for (int i = 1; i <= 5; i++) {
        final dayStr = i < 10 ? '0$i' : '$i';
        await habitController.recordProgress(
          habitId: habit.id,
          actualValue: 40,
          dateStr: '2026-01-$dayStr',
        );
      }

      final report = analyticsController.generateReportForHabit(habit.id);

      expect(report.plannedDays, 10);
      expect(report.successfulDays, 5);
      expect(report.dayCompletionRate, 50.0); // %50 gün başarısı
      expect(report.totalActualProgress, 200.0); // 5 * 40 = 200 sayfa
      expect(report.amountCompletionRate, 100.0); // Toplam hedef karşılandı
      expect(report.dayCompletionRate != report.amountCompletionRate, true);
    });
  });
}
