import 'package:flutter/foundation.dart';
import '../../../core/utils/date_helpers.dart';
import '../../collection/models/collection_models.dart';
import '../../collection/repositories/collection_repository.dart';
import '../../puzzle/models/puzzle_models.dart';
import '../../puzzle/repositories/artwork_repository.dart';
import '../models/habit_models.dart';
import '../repositories/habit_repository.dart';

class HabitStreakInfo {
  final int currentStreak;
  final int longestStreak;
  final int successfulDays;
  final int missedDays;

  const HabitStreakInfo({
    required this.currentStreak,
    required this.longestStreak,
    required this.successfulDays,
    required this.missedDays,
  });
}

class HabitController extends ChangeNotifier {
  final HabitRepository repository;
  final CollectionRepository collectionRepository;
  final ArtworkRepository artworkRepository;

  HabitController({
    required this.repository,
    required this.collectionRepository,
    ArtworkRepository? artworkRepository,
  }) : artworkRepository = artworkRepository ?? ArtworkRepository();

  HabitRepository get _repository => repository;
  CollectionRepository get _collectionRepository => collectionRepository;

  List<HabitModel> _habits = [];
  List<HabitScheduleModel> _schedules = [];
  List<HabitProcessModel> _processes = [];
  List<DailyProgressModel> _progressList = [];
  List<PuzzleModel> _puzzles = [];
  bool _isLoading = false;

  List<HabitModel> get habits => List.unmodifiable(_habits);
  List<HabitModel> get activeHabits =>
      _habits.where((h) => h.status == HabitStatus.active).toList();
  bool get isLoading => _isLoading;

  /// Verileri yerel depodan yükler
  Future<void> loadAll() async {
    _isLoading = true;
    notifyListeners();

    _habits = _repository.getHabits();
    _schedules = _repository.getSchedules();
    _processes = _repository.getProcesses();
    _progressList = _repository.getAllProgress();
    _puzzles = _repository.getPuzzles();

    _isLoading = false;
    notifyListeners();
  }

  HabitScheduleModel? getSchedule(String habitId) {
    final idx = _schedules.indexWhere((s) => s.habitId == habitId);
    return idx != -1 ? _schedules[idx] : null;
  }

  HabitProcessModel? getActiveProcess(String habitId) {
    final idx = _processes.indexWhere(
        (p) => p.habitId == habitId && p.status == ProcessStatus.active);
    return idx != -1 ? _processes[idx] : null;
  }

  PuzzleModel? getPuzzleForProcess(String processId) {
    final idx = _puzzles.indexWhere((p) => p.processId == processId);
    return idx != -1 ? _puzzles[idx] : null;
  }

  List<PuzzlePieceModel> getPiecesForPuzzle(String puzzleId) {
    return _repository.getPiecesForPuzzle(puzzleId);
  }

  DailyProgressModel? getTodayProgress(String habitId) {
    final todayStr = DateHelpers.toIsoDate(DateTime.now());
    final idx = _progressList.indexWhere(
        (p) => p.habitId == habitId && p.date == todayStr);
    return idx != -1 ? _progressList[idx] : null;
  }

  /// Belirli bir tarihteki ilerlemeyi getirir
  DailyProgressModel? getProgressForDate(String habitId, String isoDate) {
    final idx = _progressList.indexWhere(
        (p) => p.habitId == habitId && p.date == isoDate);
    return idx != -1 ? _progressList[idx] : null;
  }

  /// Bugün yapılması planlanan alışkanlıkları listeler
  List<HabitModel> getTodayHabits() {
    final now = DateTime.now();
    return activeHabits.where((h) {
      final sched = getSchedule(h.id);
      return sched != null && sched.isScheduledOn(now);
    }).toList();
  }

  /// Yeni alışkanlık ekleme
  Future<HabitModel> addHabit({
    required String userId,
    required String name,
    required String category,
    required String icon,
    required int colorValue,
    required MeasurementType measurementType,
    required String unit,
    required FrequencyType frequency,
    required List<int> selectedDays,
    required double targetValue,
    required DateTime startDate,
    DateTime? endDate,
    String? reminderTime,
  }) async {
    final habit = await _repository.createHabit(
      userId: userId,
      name: name,
      category: category,
      icon: icon,
      colorValue: colorValue,
      measurementType: measurementType,
      unit: unit,
      frequency: frequency,
      selectedDays: selectedDays,
      targetValue: targetValue,
      startDate: startDate,
      endDate: endDate,
      reminderTime: reminderTime,
    );

    await loadAll();
    return habit;
  }

  /// Alışkanlık durumunu güncelleme (arşivle, duraklat, aktifleştir)
  Future<void> updateHabitStatus(String habitId, HabitStatus newStatus) async {
    final index = _habits.indexWhere((h) => h.id == habitId);
    if (index == -1) return;

    _habits[index] = _habits[index].copyWith(status: newStatus);
    await _repository.saveHabits(_habits);
    notifyListeners();
  }

  /// Günlük ilerleme kaydetme
  /// İş kuralı: Hedef tamamlandığında gün başarılı olur ve yapbozun sıradaki parçası açılır.
  /// Aşılması ek parça vermez. Aynı gün tekrar işlem ek parça üretmez.
  Future<bool> recordProgress({
    required String habitId,
    required double actualValue,
    String? dateStr,
  }) async {
    final schedule = getSchedule(habitId);
    final process = getActiveProcess(habitId);
    if (schedule == null || process == null) return false;

    final date = dateStr ?? DateHelpers.toIsoDate(DateTime.now());
    final target = schedule.targetValue;
    final isNowCompleted = actualValue >= target;

    final existingIdx = _progressList.indexWhere(
        (p) => p.habitId == habitId && p.date == date);

    final wasAlreadyCompleted = existingIdx != -1 && _progressList[existingIdx].isCompleted;

    final progressId = existingIdx != -1
        ? _progressList[existingIdx].id
        : 'prog_${habitId}_${date}_${DateTime.now().millisecondsSinceEpoch}';

    final updatedProgress = DailyProgressModel(
      id: progressId,
      processId: process.id,
      habitId: habitId,
      date: date,
      targetValue: target,
      actualValue: actualValue,
      isCompleted: isNowCompleted,
      completedAt: isNowCompleted ? DateTime.now() : null,
    );

    if (existingIdx != -1) {
      _progressList[existingIdx] = updatedProgress;
    } else {
      _progressList.add(updatedProgress);
    }
    await _repository.saveProgressList(_progressList);

    // Eğer hedef İLK DEFA başarıyla tamamlandıysa, yapboz parçası açılır!
    if (isNowCompleted && !wasAlreadyCompleted) {
      await _unlockNextPuzzlePiece(process, date);
    }

    notifyListeners();
    return isNowCompleted;
  }

  /// Sıradaki gizli yapboz parçasını açar
  Future<void> _unlockNextPuzzlePiece(HabitProcessModel process, String dateStr) async {
    final puzzle = getPuzzleForProcess(process.id);
    if (puzzle == null) return;

    if (puzzle.unlockedPieces >= puzzle.totalPieces) {
      // Tüm parçalar zaten açık
      return;
    }

    // revealOrder içindeki sıradaki indeks
    final nextPieceIndex = puzzle.revealOrder[puzzle.unlockedPieces];
    final allPieces = _repository.getPiecesForPuzzle(puzzle.id);

    final pieceIdx = allPieces.indexWhere((p) => p.pieceIndex == nextPieceIndex);
    if (pieceIdx != -1) {
      allPieces[pieceIdx] = allPieces[pieceIdx].copyWith(
        isUnlocked: true,
        unlockedAt: DateTime.now(),
        progressDate: dateStr,
      );
      await _repository.savePieces(allPieces);
    }

    final newUnlockedCount = puzzle.unlockedPieces + 1;
    final isFinished = newUnlockedCount >= puzzle.totalPieces;

    final updatedPuzzle = puzzle.copyWith(
      unlockedPieces: newUnlockedCount,
      status: isFinished ? PuzzleStatus.completed : PuzzleStatus.inProgress,
    );

    final puzzleListIdx = _puzzles.indexWhere((p) => p.id == puzzle.id);
    if (puzzleListIdx != -1) {
      _puzzles[puzzleListIdx] = updatedPuzzle;
      await _repository.savePuzzles(_puzzles);
    }

    // Süreç completedDays güncelle
    final procIdx = _processes.indexWhere((p) => p.id == process.id);
    if (procIdx != -1) {
      _processes[procIdx] = _processes[procIdx].copyWith(
        completedDays: process.completedDays + 1,
        status: isFinished ? ProcessStatus.completed : ProcessStatus.active,
      );
      await _repository.saveProcesses(_processes);
    }

    // Eğer yapboz tamamlandıysa başarı koleksiyonuna ekle
    if (isFinished) {
      final habit = _habits.firstWhere((h) => h.id == process.habitId);
      final item = CollectionItemModel(
        id: 'col_${process.id}',
        userId: habit.userId,
        puzzleId: puzzle.id,
        processId: process.id,
        artworkId: puzzle.artworkId,
        habitName: habit.name,
        category: CollectionCategory.completedArtwork,
        completionRate: 1.0,
        unlockedPieces: updatedPuzzle.unlockedPieces,
        totalPieces: updatedPuzzle.totalPieces,
        collectedAt: DateTime.now(),
      );
      await _collectionRepository.addItem(item);
    }
  }

  /// Süreç sonlandırma (Süreç tamamlandı veya süresi bittiğinde çağrılır)
  Future<void> completeOrEndProcess(String processId) async {
    final procIdx = _processes.indexWhere((p) => p.id == processId);
    if (procIdx == -1) return;

    final process = _processes[procIdx];
    final puzzle = getPuzzleForProcess(processId);
    if (puzzle == null) return;

    final isFullyCompleted = puzzle.unlockedPieces >= puzzle.totalPieces;
    final newStatus = isFullyCompleted ? ProcessStatus.completed : ProcessStatus.endedIncomplete;

    _processes[procIdx] = process.copyWith(status: newStatus);
    await _repository.saveProcesses(_processes);

    // Koleksiyona ekleme
    final habit = _habits.firstWhere((h) => h.id == process.habitId);
    final collectionItem = CollectionItemModel(
      id: 'col_${process.id}',
      userId: habit.userId,
      puzzleId: puzzle.id,
      processId: process.id,
      artworkId: puzzle.artworkId,
      habitName: habit.name,
      category: isFullyCompleted
          ? CollectionCategory.completedArtwork
          : CollectionCategory.unfinishedStory,
      completionRate: puzzle.completionPercentage,
      unlockedPieces: puzzle.unlockedPieces,
      totalPieces: puzzle.totalPieces,
      collectedAt: DateTime.now(),
    );
    await _collectionRepository.addItem(collectionItem);

    notifyListeners();
  }

  /// Streak ve İstatistik Hesaplama Mantığı
  HabitStreakInfo calculateStreak(String habitId) {
    final schedule = getSchedule(habitId);
    final process = getActiveProcess(habitId);
    if (schedule == null || process == null) {
      return const HabitStreakInfo(
        currentStreak: 0,
        longestStreak: 0,
        successfulDays: 0,
        missedDays: 0,
      );
    }

    final today = DateHelpers.dateOnly(DateTime.now());
    final startDate = DateHelpers.dateOnly(process.startDate);
    final endDate = process.endDate != null
        ? DateHelpers.dateOnly(process.endDate!)
        : today;

    // Süreç başlangıcından bugüne (veya en fazla bitiş tarihine kadar)
    final checkLimit = today.isBefore(endDate) ? today : endDate;

    int currentStreak = 0;
    int longestStreak = 0;
    int successfulCount = 0;
    int missedCount = 0;

    var iter = startDate;
    while (!iter.isAfter(checkLimit)) {
      final isScheduled = schedule.isScheduledOn(iter);
      if (isScheduled) {
        final iso = DateHelpers.toIsoDate(iter);
        final prog = getProgressForDate(habitId, iso);
        final isSuccess = prog != null && prog.isCompleted;

        if (isSuccess) {
          successfulCount++;
          currentStreak++;
          if (currentStreak > longestStreak) {
            longestStreak = currentStreak;
          }
        } else {
          // Eğer gün bugün ise ve henüz tamamlanmadıysa, bugünün henüz bitmediğini kabul ediyoruz,
          // dünden gelen streak'i bozmadan tutabiliriz. Ancak geçmiş bir gün kaçırıldıysa streak kesilir.
          final isToday = DateHelpers.isSameDay(iter, today);
          if (!isToday) {
            missedCount++;
            currentStreak = 0; // Seri kırıldı!
          }
        }
      }
      iter = iter.add(const Duration(days: 1));
    }

    return HabitStreakInfo(
      currentStreak: currentStreak,
      longestStreak: longestStreak,
      successfulDays: successfulCount,
      missedDays: missedCount,
    );
  }

  /// Bugün tamamlanan alışkanlık yüzdesi
  double getTodayCompletionRatio() {
    final todayHabits = getTodayHabits();
    if (todayHabits.isEmpty) return 0.0;

    int completed = 0;
    for (final h in todayHabits) {
      final prog = getTodayProgress(h.id);
      if (prog != null && prog.isCompleted) {
        completed++;
      }
    }
    return (completed / todayHabits.length).clamp(0.0, 1.0);
  }
}
