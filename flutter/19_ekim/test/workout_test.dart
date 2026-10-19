import 'package:flutter_test/flutter_test.dart';
import 'package:susadim/features/workout/controller/workout_controller.dart';
import 'package:susadim/features/workout/models/workout_entry.dart';

void main() {
  group('WorkoutController Testleri', () {
    test('Başlangıç değerleri doğru olmalıdır', () {
      final controller = WorkoutController(initialCalorieGoal: 600);
      expect(controller.dailyCalorieGoal, 600);
      expect(controller.totalCaloriesBurned, 0);
      expect(controller.totalActiveMinutes, 0);
      expect(controller.remainingCalories, 600);
      expect(controller.calorieProgressRatio, 0.0);
      expect(controller.workouts.isEmpty, isTrue);
    });

    test('Egzersiz eklendiğinde kalori ve süre güncellenmelidir', () {
      final controller = WorkoutController(initialCalorieGoal: 500);
      controller.addWorkout(
        title: 'Koşu',
        durationMinutes: 30,
        caloriesBurned: 250,
        intensity: WorkoutIntensity.high,
      );

      expect(controller.totalCaloriesBurned, 250);
      expect(controller.totalActiveMinutes, 30);
      expect(controller.remainingCalories, 250);
      expect(controller.calorieProgressRatio, 0.5);
      expect(controller.workouts.length, 1);
    });

    test('Egzersiz silme ve sıfırlama doğru çalışmalıdır', () {
      final controller = WorkoutController();
      controller.addWorkout(
        title: 'Fitness',
        durationMinutes: 45,
        caloriesBurned: 300,
        intensity: WorkoutIntensity.medium,
      );
      final id = controller.workouts.first.id;

      controller.removeWorkout(id);
      expect(controller.workouts.isEmpty, isTrue);
      expect(controller.totalCaloriesBurned, 0);

      controller.addWorkout(
        title: 'Yürüyüş',
        durationMinutes: 20,
        caloriesBurned: 80,
        intensity: WorkoutIntensity.low,
      );
      expect(controller.workouts.length, 1);

      controller.reset();
      expect(controller.workouts.isEmpty, isTrue);
    });
  });
}
