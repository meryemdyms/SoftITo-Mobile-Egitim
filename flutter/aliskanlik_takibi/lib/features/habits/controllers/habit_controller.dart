import 'package:flutter/foundation.dart';
import '../../../core/utils/date_helpers.dart';
import '../../collection/models/collection_models.dart';
import '../../collection/repositories/collection_repository.dart';
import '../../puzzle/models/puzzle_models.dart';
import '../../puzzle/repositories/artwork_repository.dart';
import '../models/habit_models.dart';
import '../repositories/habit_repository.dart';

/// Alışkanlık Devamlılık ve Streak Bilgi Modeli.
///
/// `project.md` 8. Bölüm (Streak Sistemi) kurallarına göre hesaplanan verileri tutar.
class HabitStreakInfo {
  /// Mevcut kesintisiz devam eden planlı gün serisi
  final int currentStreak;

  /// Bu alışkanlık sürecinde ulaşılan en yüksek seri rekoru
  final int longestStreak;

  /// Süreç boyunca hedefin başarıyla tamamlandığı gün sayısı
  final int successfulDays;

  /// Planlanmış olmasına rağmen hedefin tamamlanmadığı kaçırılan gün sayısı
  final int missedDays;

  const HabitStreakInfo({
    required this.currentStreak,
    required this.longestStreak,
    required this.successfulDays,
    required this.missedDays,
  });
}

/// Alışkanlık Yönetimi ve Gizli Yapboz Durum Kontrolcüsü (Controller).
///
/// `project.md` 3. Mimari kurallarına göre [ChangeNotifier] kullanarak durum yönetimini yürütür.
/// Tüm iş kuralları (günlük ilerleme kaydı, yapboz parçası açma, seri hesaplamaları ve süreç sonlandırma)
/// bu sınıf içerisinde UI katmanından bağımsız olarak yönetilir.
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

  // Hafızadaki yerel durum listeleri
  List<HabitModel> _habits = [];
  List<HabitScheduleModel> _schedules = [];
  List<HabitProcessModel> _processes = [];
  List<DailyProgressModel> _progressList = [];
  List<PuzzleModel> _puzzles = [];
  bool _isLoading = false;

  /// Tüm alışkanlıkların değiştirilemez listesi
  List<HabitModel> get habits => List.unmodifiable(_habits);

  /// Sadece aktif durumdaki alışkanlıkların listesi
  List<HabitModel> get activeHabits =>
      _habits.where((h) => h.status == HabitStatus.active).toList();

  /// Yükleme durumu
  bool get isLoading => _isLoading;

  /// Yerel depodaki tüm alışkanlık, takvim, süreç ve yapboz verilerini hafızaya yükler.
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

  /// Alışkanlığın takvim planını döner
  HabitScheduleModel? getSchedule(String habitId) {
    final idx = _schedules.indexWhere((s) => s.habitId == habitId);
    return idx != -1 ? _schedules[idx] : null;
  }

  /// Alışkanlığın aktif sürecini döner
  HabitProcessModel? getActiveProcess(String habitId) {
    final idx = _processes.indexWhere(
        (p) => p.habitId == habitId && p.status == ProcessStatus.active);
    return idx != -1 ? _processes[idx] : null;
  }

  /// Belirli bir sürece ait yapbozu döner
  PuzzleModel? getPuzzleForProcess(String processId) {
    final idx = _puzzles.indexWhere((p) => p.processId == processId);
    return idx != -1 ? _puzzles[idx] : null;
  }

  /// Belirli bir yapboza ait parçaları döner
  List<PuzzlePieceModel> getPiecesForPuzzle(String puzzleId) {
    return _repository.getPiecesForPuzzle(puzzleId);
  }

  /// Alışkanlığın bugünkü ilerleme kaydını döner
  DailyProgressModel? getTodayProgress(String habitId) {
    final todayStr = DateHelpers.toIsoDate(DateTime.now());
    final idx = _progressList.indexWhere(
        (p) => p.habitId == habitId && p.date == todayStr);
    return idx != -1 ? _progressList[idx] : null;
  }

  /// Belirli bir tarihteki ('YYYY-MM-DD') ilerleme kaydını döner
  DailyProgressModel? getProgressForDate(String habitId, String isoDate) {
    final idx = _progressList.indexWhere(
        (p) => p.habitId == habitId && p.date == isoDate);
    return idx != -1 ? _progressList[idx] : null;
  }

  /// Bugün yapılması planlanan aktif alışkanlıkları listeler.
  List<HabitModel> getTodayHabits() {
    final now = DateTime.now();
    return activeHabits.where((h) {
      final sched = getSchedule(h.id);
      return sched != null && sched.isScheduledOn(now);
    }).toList();
  }

  /// Yeni alışkanlık ekler ve bağlı sürecini/gizli yapbozunu başlatır.
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

  /// Alışkanlığın durumunu günceller (arşivleme, duraklatma, aktifleştirme).
  Future<void> updateHabitStatus(String habitId, HabitStatus newStatus) async {
    final index = _habits.indexWhere((h) => h.id == habitId);
    if (index == -1) return;

    _habits[index] = _habits[index].copyWith(status: newStatus);
    await _repository.saveHabits(_habits);
    notifyListeners();
  }

  /// Günlük ilerleme kaydetme iş mantığı.
  ///
  /// `project.md` 6. Bölüm (Günlük İlerleme Kuralları) ve 7.2. Bölüm (Parça Açılma Kuralları):
  /// 1. Kısmi ilerleme kaydedilir.
  /// 2. Hedef tamamlandığında ([actualValue] >= target) gün başarılı sayılır.
  /// 3. Her başarılı planlı gün İLK DEFA tamamlandığında yapbozun sıradaki parçasını açar.
  /// 4. Hedefin aşılması ek parça kazandırmaz.
  /// 5. Aynı gün tekrar işlem ek parça üretmez.
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

    // O güne ait mevcut kayıt var mı kontrol et
    final existingIdx = _progressList.indexWhere(
        (p) => p.habitId == habitId && p.date == date);

    // Önceden zaten tamamlanmış mıydı? (Mükerrer parça açılmasını önlemek için)
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

    // KURAL: Eğer hedef İLK DEFA başarıyla tamamlandıysa, gizli yapbozun sıradaki parçası açılır!
    if (isNowCompleted && !wasAlreadyCompleted) {
      await _unlockNextPuzzlePiece(process, date);
    }

    notifyListeners();
    return isNowCompleted;
  }

  /// Sıradaki gizli yapboz parçasını açar.
  ///
  /// `project.md` 7.2: Parçalar önceden belirlenmiş rastgele sırayla açılır ([revealOrder]).
  /// Aynı parça tekrar açılmaz. Tüm parçalar tamamlandığında eser Başarı Koleksiyonuna eklenir.
  Future<void> _unlockNextPuzzlePiece(HabitProcessModel process, String dateStr) async {
    final puzzle = getPuzzleForProcess(process.id);
    if (puzzle == null) return;

    if (puzzle.unlockedPieces >= puzzle.totalPieces) {
      // Tüm parçalar zaten açık
      return;
    }

    // 1. revealOrder içindeki sıradaki açılacak parça indeksini al
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

    // 2. Yapboz durumunu güncelle
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

    // 3. Süreç modelindeki completedDays değerini artır
    final procIdx = _processes.indexWhere((p) => p.id == process.id);
    if (procIdx != -1) {
      _processes[procIdx] = _processes[procIdx].copyWith(
        completedDays: process.completedDays + 1,
        status: isFinished ? ProcessStatus.completed : ProcessStatus.active,
      );
      await _repository.saveProcesses(_processes);
    }

    // 4. KURAL: Eğer yapbozun tüm parçaları tamamlandıysa, başarı koleksiyonuna ekle
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

  /// Süreç sonlandırma (Süreç tamamlandığında veya süresi bittiğinde çağrılır).
  ///
  /// Tam başarıda Tamamlanan Eserler'e, eksik başarıda Yarım Kalan Hikâyeler'e ekler.
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

    // Başarı Koleksiyonuna veya Yarım Kalan Hikâyeler'e kaydet
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

  /// Alışkanlık için streak (seri) ve başarı istatistiklerini hesaplar.
  ///
  /// `project.md` 8. Bölüm (Streak Sistemi Kuralları):
  /// - Başarılı planlı gün streak artırır.
  /// - Kaçırılan planlı gün streak keser (sıfırlar).
  /// - Planlanmamış gün streak bozmaz.
  /// - Bugün henüz bitmediyse dünden gelen seri korunur (bugün kaçırılmış sayılmaz).
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

    // İnceleme üst sınırını belirle
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
          // Bugünün günü ise ve henüz tamamlanmadıysa seriyi kırma (çünkü gün henüz bitmedi)
          // Ancak geçmiş bir gün kaçırıldıysa seri sıfırlanır
          final isToday = DateHelpers.isSameDay(iter, today);
          if (!isToday) {
            missedCount++;
            currentStreak = 0;
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

  /// Bugün tamamlanan alışkanlık oranını döner (0.0 ile 1.0 arasında).
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
