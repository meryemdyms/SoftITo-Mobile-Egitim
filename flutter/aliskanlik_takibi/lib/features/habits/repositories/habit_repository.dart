import 'dart:math';
import '../../../core/services/storage_service.dart';
import '../../../core/utils/date_helpers.dart';
import '../../puzzle/models/puzzle_models.dart';
import '../../puzzle/repositories/artwork_repository.dart';
import '../models/habit_models.dart';

/// Alışkanlık, İlerleme ve Süreç Veri Yönetimi Deposu (Repository).
///
/// `project.md` 3. Mimari (Feature-First) ve 7. Gizli Yapboz Sistemi kurallarına göre tasarlanmıştır:
/// Alışkanlıkların, takvimlerin, süreçlerin, günlük kayıtların ve yapboz parçalarının
/// yerel depoya ([StorageService]) kalıcı olarak yazılmasını ve okunmasını sağlar.
class HabitRepository {
  final StorageService storage;
  final ArtworkRepository _artworkRepo;

  HabitRepository({
    required this.storage,
    ArtworkRepository? artworkRepo,
  })  : _artworkRepo = artworkRepo ?? ArtworkRepository();

  StorageService get _storage => storage;

  // Yerel depolama anahtarları
  static const String _keyHabits = 'ritmo_habits';
  static const String _keySchedules = 'ritmo_schedules';
  static const String _keyProcesses = 'ritmo_processes';
  static const String _keyProgress = 'ritmo_progress';
  static const String _keyPuzzles = 'ritmo_puzzles';
  static const String _keyPieces = 'ritmo_pieces';

  // ==========================================
  // ALIŞKANLIKLAR (HABITS)
  // ==========================================

  /// Kayıtlı tüm alışkanlık modellerini listeden okur.
  List<HabitModel> getHabits() {
    final list = _storage.getJsonList(_keyHabits) ?? [];
    return list.map((e) => HabitModel.fromJson(e)).toList();
  }

  /// Alışkanlık listesini yerel depoya kalıcı olarak yazar.
  Future<void> saveHabits(List<HabitModel> habits) async {
    await _storage.setJsonList(_keyHabits, habits.map((e) => e.toJson()).toList());
  }

  // ==========================================
  // TAKVİMLER VE PLANLAR (SCHEDULES)
  // ==========================================

  /// Kayıtlı tüm takvim modellerini döner.
  List<HabitScheduleModel> getSchedules() {
    final list = _storage.getJsonList(_keySchedules) ?? [];
    return list.map((e) => HabitScheduleModel.fromJson(e)).toList();
  }

  /// Belirli bir alışkanlığa ait takvim planını döner (bulunamazsa null).
  HabitScheduleModel? getScheduleForHabit(String habitId) {
    final list = getSchedules();
    final index = list.indexWhere((s) => s.habitId == habitId);
    return index != -1 ? list[index] : null;
  }

  /// Takvim planları listesini kaydeder.
  Future<void> saveSchedules(List<HabitScheduleModel> schedules) async {
    await _storage.setJsonList(_keySchedules, schedules.map((e) => e.toJson()).toList());
  }

  // ==========================================
  // SÜREÇLER VE DÖNEMLER (PROCESSES)
  // ==========================================

  /// Kayıtlı tüm alışkanlık süreçlerini döner.
  List<HabitProcessModel> getProcesses() {
    final list = _storage.getJsonList(_keyProcesses) ?? [];
    return list.map((e) => HabitProcessModel.fromJson(e)).toList();
  }

  /// Belirli bir alışkanlığın şu anda aktif olan sürecini döner.
  HabitProcessModel? getActiveProcessForHabit(String habitId) {
    final list = getProcesses();
    final index = list.indexWhere(
        (p) => p.habitId == habitId && p.status == ProcessStatus.active);
    return index != -1 ? list[index] : null;
  }

  /// Süreç listesini kaydeder.
  Future<void> saveProcesses(List<HabitProcessModel> processes) async {
    await _storage.setJsonList(_keyProcesses, processes.map((e) => e.toJson()).toList());
  }

  // ==========================================
  // GÜNLÜK İLERLEMELER (DAILY PROGRESS)
  // ==========================================

  /// Kayıtlı tüm günlük ilerleme verilerini döner.
  List<DailyProgressModel> getAllProgress() {
    final list = _storage.getJsonList(_keyProgress) ?? [];
    return list.map((e) => DailyProgressModel.fromJson(e)).toList();
  }

  /// Belirli bir alışkanlığın belirli bir gündeki ('YYYY-MM-DD') ilerleme kaydını döner.
  DailyProgressModel? getDailyProgress({
    required String habitId,
    required String date,
  }) {
    final list = getAllProgress();
    final index = list.indexWhere((p) => p.habitId == habitId && p.date == date);
    return index != -1 ? list[index] : null;
  }

  /// Günlük ilerleme kayıtları listesini kaydeder.
  Future<void> saveProgressList(List<DailyProgressModel> progressList) async {
    await _storage.setJsonList(_keyProgress, progressList.map((e) => e.toJson()).toList());
  }

  // ==========================================
  // GİZLİ YAPBOZLAR VE PARÇALAR (PUZZLES & PIECES)
  // ==========================================

  /// Kayıtlı tüm yapboz üst modellerini döner.
  List<PuzzleModel> getPuzzles() {
    final list = _storage.getJsonList(_keyPuzzles) ?? [];
    return list.map((e) => PuzzleModel.fromJson(e)).toList();
  }

  /// Belirli bir sürece ([processId]) ait yapbozu döner.
  PuzzleModel? getPuzzleForProcess(String processId) {
    final list = getPuzzles();
    final index = list.indexWhere((p) => p.processId == processId);
    return index != -1 ? list[index] : null;
  }

  /// Yapboz listesini kaydeder.
  Future<void> savePuzzles(List<PuzzleModel> puzzles) async {
    await _storage.setJsonList(_keyPuzzles, puzzles.map((e) => e.toJson()).toList());
  }

  /// Belirli bir yapboza ([puzzleId]) ait tüm parçaları döner.
  List<PuzzlePieceModel> getPiecesForPuzzle(String puzzleId) {
    final list = _storage.getJsonList(_keyPieces) ?? [];
    return list
        .map((e) => PuzzlePieceModel.fromJson(e))
        .where((p) => p.puzzleId == puzzleId)
        .toList();
  }

  /// Yapboz parçalarını mevcut listeyle birleştirerek günceller ve kaydeder.
  Future<void> savePieces(List<PuzzlePieceModel> pieces) async {
    final allPieces = (_storage.getJsonList(_keyPieces) ?? [])
        .map((e) => PuzzlePieceModel.fromJson(e))
        .toList();

    for (final p in pieces) {
      final idx = allPieces.indexWhere((item) => item.id == p.id);
      if (idx != -1) {
        allPieces[idx] = p;
      } else {
        allPieces.add(p);
      }
    }
    await _storage.setJsonList(_keyPieces, allPieces.map((e) => e.toJson()).toList());
  }

  // ==========================================
  // ALIŞKANLIK VE YAPBOZ OLUŞTURMA MANTIĞI
  // ==========================================

  /// Başlangıç, bitiş tarihi ve sıklık türüne göre planlanan toplam gün sayısını hesaplar.
  ///
  /// `project.md` 7.1. Kuralı: Yapboz parça sayısı, tam olarak planlanan alışkanlık gün sayısına eşittir.
  /// Süresiz alışkanlıklarda varsayılan 30 günlük dönem parçası üretilir.
  int calculatePlannedDays({
    required DateTime startDate,
    DateTime? endDate,
    required FrequencyType frequency,
    required List<int> selectedDays,
    int? indefiniteDefaultDays = 30,
  }) {
    final start = DateHelpers.dateOnly(startDate);
    final end = endDate != null
        ? DateHelpers.dateOnly(endDate)
        : start.add(Duration(days: (indefiniteDefaultDays ?? 30) - 1));

    int count = 0;
    var current = start;
    while (!current.isAfter(end)) {
      bool isMatch = false;
      switch (frequency) {
        case FrequencyType.everyday:
          isMatch = true;
          break;
        case FrequencyType.weekdays:
          isMatch = current.weekday >= 1 && current.weekday <= 5;
          break;
        case FrequencyType.customDays:
          isMatch = selectedDays.contains(current.weekday);
          break;
      }
      if (isMatch) count++;
      current = current.add(const Duration(days: 1));
    }
    return max(count, 1);
  }

  /// Yeni bir alışkanlık ve beraberinde sürecini + gizli yapbozunu oluşturur.
  ///
  /// `project.md` 7. Gizli Yapboz Sistemi gereksinimleri:
  /// 1. Sistem rastgele bir gizli görsel atar.
  /// 2. Planlanan gün sayısı hesaplanır ve yapboz o kadar parçaya ayrılır.
  /// 3. Parçalar için rastgele açılma sırası (Fisher-Yates) oluşturulup kalıcı saklanır.
  /// 4. Kullanıcı görseli ve eser adını süreç tamamlanana kadar bilmez.
  Future<HabitModel> createHabit({
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
    // 1. Alışkanlık modelini oluştur
    final habitId = 'habit_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(999)}';
    final habit = HabitModel(
      id: habitId,
      userId: userId,
      name: name,
      category: category,
      icon: icon,
      colorValue: colorValue,
      measurementType: measurementType,
      unit: unit,
      createdAt: DateTime.now(),
    );

    // 2. Takvim planını oluştur
    final schedule = HabitScheduleModel(
      id: 'sched_$habitId',
      habitId: habitId,
      frequency: frequency,
      selectedDays: selectedDays,
      targetValue: targetValue,
      startDate: startDate,
      endDate: endDate,
      reminderTime: reminderTime,
    );

    // 3. Planlı gün sayısını kesin hesapla
    final plannedDays = calculatePlannedDays(
      startDate: startDate,
      endDate: endDate,
      frequency: frequency,
      selectedDays: selectedDays,
    );

    // 4. Süreç modelini oluştur
    final process = HabitProcessModel(
      id: 'proc_$habitId',
      habitId: habitId,
      startDate: startDate,
      endDate: endDate,
      plannedDays: plannedDays,
      completedDays: 0,
      status: ProcessStatus.active,
    );

    // 5. Gizli Yapboz Hazırlığı: Rastgele küratörlü sanat eseri seçimi
    final artwork = _artworkRepo.getRandomArtwork();
    final puzzleId = 'puz_${process.id}';

    // Parçalar için rastgele karıştırılmış açılma sırası oluştur (Fisher-Yates algoritması)
    final revealOrder = List.generate(plannedDays, (i) => i);
    revealOrder.shuffle(Random());

    final puzzle = PuzzleModel(
      id: puzzleId,
      processId: process.id,
      artworkId: artwork.id,
      totalPieces: plannedDays,
      unlockedPieces: 0,
      revealOrder: revealOrder,
      status: PuzzleStatus.inProgress,
    );

    // Parça modellerini oluştur (başlangıçta hepsi kilitli)
    final pieces = List.generate(
      plannedDays,
      (i) => PuzzlePieceModel(
        id: 'piece_${puzzleId}_$i',
        puzzleId: puzzleId,
        pieceIndex: i,
        isUnlocked: false,
      ),
    );

    // 6. Tüm modelleri yerel depoya kaydet
    final habits = getHabits()..add(habit);
    final schedules = getSchedules()..add(schedule);
    final processes = getProcesses()..add(process);
    final puzzles = getPuzzles()..add(puzzle);

    await saveHabits(habits);
    await saveSchedules(schedules);
    await saveProcesses(processes);
    await savePuzzles(puzzles);
    await savePieces(pieces);

    return habit;
  }
}
