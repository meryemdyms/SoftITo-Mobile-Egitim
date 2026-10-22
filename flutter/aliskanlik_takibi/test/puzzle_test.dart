import 'package:flutter_test/flutter_test.dart';
import 'package:ritmo/core/services/storage_service.dart';
import 'package:ritmo/features/collection/models/collection_models.dart';
import 'package:ritmo/features/collection/repositories/collection_repository.dart';
import 'package:ritmo/features/habits/controllers/habit_controller.dart';
import 'package:ritmo/features/habits/models/habit_models.dart';
import 'package:ritmo/features/habits/repositories/habit_repository.dart';
import 'package:ritmo/features/puzzle/models/puzzle_models.dart';
import 'package:ritmo/features/puzzle/repositories/artwork_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late StorageService storage;
  late HabitRepository habitRepo;
  late CollectionRepository collectionRepo;
  late HabitController controller;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    storage = await StorageService.getInstance();
    habitRepo = HabitRepository(storage: storage);
    collectionRepo = CollectionRepository(storage: storage);
    controller = HabitController(
      repository: habitRepo,
      collectionRepository: collectionRepo,
      artworkRepository: ArtworkRepository(),
    );
    await controller.loadAll();
  });

  group('Gizli Yapboz Sistemi Testleri', () {
    test('Her alışkanlık başlangıçta gizli bir esere ve karıştırılmış sıraya sahiptir', () async {
      final habit = await controller.addHabit(
        userId: 'u1',
        name: 'Meditasyon',
        category: 'Farkındalık',
        icon: 'meditate',
        colorValue: 0xFF344E41,
        measurementType: MeasurementType.boolean,
        unit: 'kez',
        frequency: FrequencyType.everyday,
        selectedDays: [1, 2, 3, 4, 5, 6, 7],
        targetValue: 1,
        startDate: DateTime(2026, 1, 1),
        endDate: DateTime(2026, 1, 21), // 21 parça
      );

      final process = controller.getActiveProcess(habit.id)!;
      final puzzle = controller.getPuzzleForProcess(process.id)!;

      expect(puzzle.totalPieces, 21);
      expect(puzzle.unlockedPieces, 0);
      expect(puzzle.status, PuzzleStatus.inProgress);
      expect(puzzle.revealOrder.length, 21);
      expect(puzzle.artworkId.isNotEmpty, true);

      final pieces = controller.getPiecesForPuzzle(puzzle.id);
      expect(pieces.length, 21);
      expect(pieces.every((p) => !p.isUnlocked), true);
    });

    test('Tüm parçalar açıldığında yapboz tamamlanır ve başarı koleksiyonuna eklenir', () async {
      // 3 günlük kısa bir süreç
      final habit = await controller.addHabit(
        userId: 'u1',
        name: 'Nefes Egzersizi',
        category: 'Sağlık',
        icon: 'meditate',
        colorValue: 0xFF344E41,
        measurementType: MeasurementType.boolean,
        unit: 'kez',
        frequency: FrequencyType.everyday,
        selectedDays: [1, 2, 3, 4, 5, 6, 7],
        targetValue: 1,
        startDate: DateTime(2026, 1, 1),
        endDate: DateTime(2026, 1, 3), // 3 gün = 3 parça
      );

      final process = controller.getActiveProcess(habit.id)!;

      // Gün 1
      await controller.recordProgress(habitId: habit.id, actualValue: 1, dateStr: '2026-01-01');
      var puz = controller.getPuzzleForProcess(process.id)!;
      expect(puz.unlockedPieces, 1);
      expect(puz.status, PuzzleStatus.inProgress);

      // Gün 2
      await controller.recordProgress(habitId: habit.id, actualValue: 1, dateStr: '2026-01-02');
      puz = controller.getPuzzleForProcess(process.id)!;
      expect(puz.unlockedPieces, 2);

      // Gün 3 (Son Parça!)
      await controller.recordProgress(habitId: habit.id, actualValue: 1, dateStr: '2026-01-03');
      puz = controller.getPuzzleForProcess(process.id)!;
      expect(puz.unlockedPieces, 3);
      expect(puz.isFullyCompleted, true);
      expect(puz.status, PuzzleStatus.completed);

      // Başarı Koleksiyonunda Tamamlanan Eser olarak yer almalı
      final completedArtworks = collectionRepo.getCompletedArtworks();
      expect(completedArtworks.length, 1);
      expect(completedArtworks.first.processId, process.id);
      expect(completedArtworks.first.category, CollectionCategory.completedArtwork);
      expect(completedArtworks.first.completionRate, 1.0);
    });
  });
}
