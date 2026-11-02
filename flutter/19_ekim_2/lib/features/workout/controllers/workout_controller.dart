import 'package:flutter/foundation.dart';
import '../models/workout_model.dart';

/// Egzersiz ve kalori verilerini yöneten ValueNotifier tabanlı kontrolcü.
/// Harici kütüphane gerektirmeden reaktif durum yönetimi sağlar.
class WorkoutController {
  final ValueNotifier<WorkoutModel> state =
      ValueNotifier<WorkoutModel>(WorkoutModel.initial());

  WorkoutModel get current => state.value;

  /// Yeni bir egzersiz seansı ekler.
  /// Kayıt en başa eklenir; toplam yakılan kalori ve aktif dakika güncellenir.
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

  /// Belirtilen kimliğe (id) sahip egzersizi listeden kaldırır.
  /// Toplam kalori ve süreyi düşürür, `clamp` ile değerlerin sıfırın altına inmesini önler.
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

  /// Günlük egzersiz, kalori ve süre verilerini sıfırlar.
  void resetDay() {
    state.value = current.copyWith(
      burnedCalories: 0,
      activeMinutes: 0,
      workouts: const [],
    );
  }

  /// Kontrolcü yok edildiğinde ValueNotifier dinleyicisini kapatır.
  void dispose() {
    state.dispose();
  }
}
