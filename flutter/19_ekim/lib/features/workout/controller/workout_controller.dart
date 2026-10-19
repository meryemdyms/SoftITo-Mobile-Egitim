import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:susadim/features/workout/models/workout_entry.dart';

class WorkoutController extends ChangeNotifier {
  WorkoutController({int initialCalorieGoal = 500})
      : _dailyCalorieGoal = initialCalorieGoal;

  int _dailyCalorieGoal;
  final List<WorkoutEntry> _workouts = <WorkoutEntry>[];

  int get dailyCalorieGoal => _dailyCalorieGoal;

  UnmodifiableListView<WorkoutEntry> get workouts =>
      UnmodifiableListView<WorkoutEntry>(_workouts);

  int get totalCaloriesBurned {
    return _workouts.fold<int>(0, (sum, item) => sum + item.caloriesBurned);
  }

  int get totalActiveMinutes {
    return _workouts.fold<int>(0, (sum, item) => sum + item.durationMinutes);
  }

  double get calorieProgressRatio {
    if (_dailyCalorieGoal <= 0) return 0.0;
    final ratio = totalCaloriesBurned / _dailyCalorieGoal;
    return ratio.clamp(0.0, 1.0);
  }

  int get remainingCalories {
    final remaining = _dailyCalorieGoal - totalCaloriesBurned;
    return remaining < 0 ? 0 : remaining;
  }

  void addWorkout({
    required String title,
    required int durationMinutes,
    required int caloriesBurned,
    required WorkoutIntensity intensity,
  }) {
    if (title.trim().isEmpty || durationMinutes <= 0 || caloriesBurned <= 0) {
      return;
    }
    final entry = WorkoutEntry(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title.trim(),
      durationMinutes: durationMinutes,
      caloriesBurned: caloriesBurned,
      intensity: intensity,
      timestamp: DateTime.now(),
    );
    _workouts.insert(0, entry);
    notifyListeners();
  }

  void removeWorkout(String id) {
    _workouts.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  void updateCalorieGoal(int newGoal) {
    if (newGoal <= 0) return;
    _dailyCalorieGoal = newGoal;
    notifyListeners();
  }

  void reset() {
    _workouts.clear();
    notifyListeners();
  }
}
