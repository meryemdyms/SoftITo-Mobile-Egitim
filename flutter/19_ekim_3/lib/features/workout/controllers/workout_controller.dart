import 'package:flutter/foundation.dart';
import '../models/workout_model.dart';

/// Egzersiz ve kalori verilerini yöneten ValueNotifier tabanlı kontrolcü.
class WorkoutController {
  final ValueNotifier<WorkoutModel> state =
      ValueNotifier<WorkoutModel>(WorkoutModel.initial());

  WorkoutModel get current => state.value;

  /// Yeni egzersiz seansı ekler
  void addWorkout({
    required String title,
    required int calories,
    required int durationMinutes,
    required String category,
  }) {
    final newWorkout = WorkoutItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      calories: calories,
      durationMinutes: durationMinutes,
      category: category,
      timestamp: DateTime.now(),
    );

    final updatedWorkouts = List<WorkoutItem>.from(current.workouts)
      ..insert(0, newWorkout);

    state.value = current.copyWith(
      burnedCalories: current.burnedCalories + calories,
      activeMinutes: current.activeMinutes + durationMinutes,
      workouts: updatedWorkouts,
    );
  }

  /// Belirtilen egzersizi kaldırır
  void removeWorkout(String id) {
    final itemIndex = current.workouts.indexWhere((w) => w.id == id);
    if (itemIndex == -1) return;

    final item = current.workouts[itemIndex];
    final updatedList = List<WorkoutItem>.from(current.workouts)..removeAt(itemIndex);

    state.value = current.copyWith(
      burnedCalories: (current.burnedCalories - item.calories).clamp(0, 99999),
      activeMinutes: (current.activeMinutes - item.durationMinutes).clamp(0, 99999),
      workouts: updatedList,
    );
  }

  /// Günlük egzersiz verilerini sıfırlar
  void resetDay() {
    state.value = current.copyWith(
      burnedCalories: 0,
      activeMinutes: 0,
      workouts: const [],
    );
  }

  void dispose() {
    state.dispose();
  }
}
