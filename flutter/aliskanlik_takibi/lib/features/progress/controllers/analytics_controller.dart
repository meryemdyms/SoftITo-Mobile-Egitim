import 'package:flutter/foundation.dart';
import '../../../core/utils/date_helpers.dart';
import '../../habits/controllers/habit_controller.dart';
import '../../habits/models/habit_models.dart';
import '../models/analysis_models.dart';

class AnalyticsController extends ChangeNotifier {
  final HabitController habitController;

  AnalyticsController({required this.habitController});

  /// Belirli bir alışkanlık için kapsamlı analiz raporu üretir
  AnalysisReportModel generateReportForHabit(String habitId) {
    final habit = habitController.habits.firstWhere(
      (h) => h.id == habitId,
      orElse: () => HabitModel(
        id: '',
        userId: '',
        name: 'Bilinmeyen Alışkanlık',
        category: '',
        icon: '',
        colorValue: 0,
        measurementType: MeasurementType.boolean,
        unit: '',
        createdAt: DateTime.now(),
      ),
    );

    final schedule = habitController.getSchedule(habitId);
    final process = habitController.getActiveProcess(habitId);
    final puzzle = process != null ? habitController.getPuzzleForProcess(process.id) : null;
    final streakInfo = habitController.calculateStreak(habitId);

    final plannedDays = process?.plannedDays ?? 1;
    final successfulDays = streakInfo.successfulDays;
    final missedDays = streakInfo.missedDays;

    final dayCompletionRate = (successfulDays / plannedDays) * 100.0;

    // Toplam hedef ve toplam gerçekleşen miktar hesaplama
    double totalTarget = 0.0;
    double totalActual = 0.0;

    if (process != null && schedule != null) {
      final today = DateHelpers.dateOnly(DateTime.now());
      var iter = DateHelpers.dateOnly(process.startDate);
      final limit = process.endDate != null && process.endDate!.isBefore(today)
          ? DateHelpers.dateOnly(process.endDate!)
          : today;

      while (!iter.isAfter(limit)) {
        if (schedule.isScheduledOn(iter)) {
          totalTarget += schedule.targetValue;
          final prog = habitController.getProgressForDate(
            habitId,
            DateHelpers.toIsoDate(iter),
          );
          if (prog != null) {
            totalActual += prog.actualValue;
          }
        }
        iter = iter.add(const Duration(days: 1));
      }
    }

    final amountCompletionRate = totalTarget > 0
        ? ((totalActual / totalTarget) * 100.0).clamp(0.0, 100.0)
        : 0.0;

    return AnalysisReportModel(
      id: 'rep_${process?.id ?? habitId}_${DateTime.now().millisecondsSinceEpoch}',
      processId: process?.id ?? '',
      habitId: habitId,
      habitName: habit.name,
      plannedDays: plannedDays,
      successfulDays: successfulDays,
      missedDays: missedDays,
      dayCompletionRate: dayCompletionRate.clamp(0.0, 100.0),
      totalTargetProgress: totalTarget,
      totalActualProgress: totalActual,
      amountCompletionRate: amountCompletionRate,
      longestStreak: streakInfo.longestStreak,
      currentStreak: streakInfo.currentStreak,
      unlockedPieces: puzzle?.unlockedPieces ?? 0,
      totalPieces: puzzle?.totalPieces ?? 0,
      generatedAt: DateTime.now(),
    );
  }

  /// Son 7 günün günlük başarı özetini döner (Gelişim grafiği için)
  List<({DateTime date, int completedCount, int totalPlannedCount})> getLast7DaysSummary() {
    final now = DateTime.now();
    final result = <({DateTime date, int completedCount, int totalPlannedCount})>[];

    for (int i = 6; i >= 0; i--) {
      final d = now.subtract(Duration(days: i));
      final dateOnly = DateHelpers.dateOnly(d);
      final iso = DateHelpers.toIsoDate(dateOnly);

      int planned = 0;
      int completed = 0;

      for (final h in habitController.activeHabits) {
        final sched = habitController.getSchedule(h.id);
        if (sched != null && sched.isScheduledOn(dateOnly)) {
          planned++;
          final prog = habitController.getProgressForDate(h.id, iso);
          if (prog != null && prog.isCompleted) {
            completed++;
          }
        }
      }

      result.add((date: dateOnly, completedCount: completed, totalPlannedCount: planned));
    }

    return result;
  }
}
