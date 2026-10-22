import 'package:flutter_test/flutter_test.dart';
import 'package:ritmo/core/services/storage_service.dart';
import 'package:ritmo/features/collection/repositories/collection_repository.dart';
import 'package:ritmo/features/habits/controllers/habit_controller.dart';
import 'package:ritmo/features/habits/models/habit_models.dart';
import 'package:ritmo/features/habits/repositories/habit_repository.dart';
import 'package:ritmo/features/puzzle/repositories/artwork_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late StorageService storage;
  late HabitRepository repository;
  late CollectionRepository collectionRepo;
  late HabitController controller;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    storage = await StorageService.getInstance();
    repository = HabitRepository(storage: storage);
    collectionRepo = CollectionRepository(storage: storage);
    controller = HabitController(
      repository: repository,
      collectionRepository: collectionRepo,
      artworkRepository: ArtworkRepository(),
    );
    await controller.loadAll();
  });

  group('Alışkanlık ve Süreç Testleri', () {
    test('Yeni alışkanlık oluşturulduğunda planlı gün sayısı kadar yapboz parçası üretilir', () async {
      final habit = await controller.addHabit(
        userId: 'test_user',
        name: 'Kitap Okumak',
        category: 'Kişisel Gelişim',
        icon: 'book',
        colorValue: 0xFF344E41,
        measurementType: MeasurementType.quantity,
        unit: 'sayfa',
        frequency: FrequencyType.everyday,
        selectedDays: [1, 2, 3, 4, 5, 6, 7],
        targetValue: 20,
        startDate: DateTime(2026, 1, 1),
        endDate: DateTime(2026, 1, 30), // 30 gün
      );

      final process = controller.getActiveProcess(habit.id);
      expect(process, isNotNull);
      expect(process!.plannedDays, 30);

      final puzzle = controller.getPuzzleForProcess(process.id);
      expect(puzzle, isNotNull);
      expect(puzzle!.totalPieces, 30);
      expect(puzzle.unlockedPieces, 0);
      expect(puzzle.revealOrder.length, 30);
      // Rastgele sıranın tüm 0..29 indeksleri içerdiğini kontrol et
      expect(puzzle.revealOrder.toSet().length, 30);
    });

    test('Kısmi ilerleme parça kazandırmaz, tam hedef 1 parça kazandırır', () async {
      final habit = await controller.addHabit(
        userId: 'test_user',
        name: 'Su İçmek',
        category: 'Sağlık',
        icon: 'water',
        colorValue: 0xFF4C7B8B,
        measurementType: MeasurementType.quantity,
        unit: 'ml',
        frequency: FrequencyType.everyday,
        selectedDays: [1, 2, 3, 4, 5, 6, 7],
        targetValue: 2000,
        startDate: DateTime.now(),
        endDate: DateTime.now().add(const Duration(days: 20)),
      );

      final process = controller.getActiveProcess(habit.id)!;

      // 1. Kısmi ilerleme (1000 ml / 2000 ml)
      final isDone1 = await controller.recordProgress(
        habitId: habit.id,
        actualValue: 1000,
      );
      expect(isDone1, false);

      var puzzle = controller.getPuzzleForProcess(process.id)!;
      expect(puzzle.unlockedPieces, 0, reason: 'Kısmi ilerleme yapboz parçası açmamalıdır');

      // 2. Hedefin tamamlanması (2000 ml / 2000 ml)
      final isDone2 = await controller.recordProgress(
        habitId: habit.id,
        actualValue: 2000,
      );
      expect(isDone2, true);

      puzzle = controller.getPuzzleForProcess(process.id)!;
      expect(puzzle.unlockedPieces, 1, reason: 'Hedef tamamlanınca 1 parça açılmalıdır');

      // 3. Hedefin aşılması kuralı: 3000 ml yapıldığında ek parça KAZANILMAZ (project.md Kural 6.4)
      await controller.recordProgress(
        habitId: habit.id,
        actualValue: 3000,
      );
      puzzle = controller.getPuzzleForProcess(process.id)!;
      expect(puzzle.unlockedPieces, 1, reason: 'Hedef aşılsa dahi ek parça verilmez');
    });

    test('Planlanmamış günler seriyi bozmaz (Streak Kuralı)', () async {
      // Sadece hafta içi planlanan bir alışkanlık
      final habit = await controller.addHabit(
        userId: 'test_user',
        name: 'Ders Çalışma',
        category: 'Eğitim',
        icon: 'study',
        colorValue: 0xFF3D6B51,
        measurementType: MeasurementType.duration,
        unit: 'dk',
        frequency: FrequencyType.weekdays,
        selectedDays: [1, 2, 3, 4, 5],
        targetValue: 45,
        startDate: DateTime.now().subtract(const Duration(days: 7)),
      );

      final schedule = controller.getSchedule(habit.id)!;
      expect(schedule.isScheduledOn(DateTime(2026, 10, 24)), false); // Cumartesi
      expect(schedule.isScheduledOn(DateTime(2026, 10, 25)), false); // Pazar
      expect(schedule.isScheduledOn(DateTime(2026, 10, 26)), true); // Pazartesi
    });
  });
}
