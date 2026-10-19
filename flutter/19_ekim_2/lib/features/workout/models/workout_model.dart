import 'package:flutter/foundation.dart';

/// Egzersiz aktivitesi öğesi.
@immutable
class WorkoutItem {
  final String id;
  final String title;
  final int calories;
  final int durationMinutes;
  final String category;
  final DateTime timestamp;

  const WorkoutItem({
    required this.id,
    required this.title,
    required this.calories,
    required this.durationMinutes,
    required this.category,
    required this.timestamp,
  });

  WorkoutItem copyWith({
    String? id,
    String? title,
    int? calories,
    int? durationMinutes,
    String? category,
    DateTime? timestamp,
  }) {
    return WorkoutItem(
      id: id ?? this.id,
      title: title ?? this.title,
      calories: calories ?? this.calories,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      category: category ?? this.category,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  factory WorkoutItem.fromJson(Map<String, dynamic> json) {
    return WorkoutItem(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      calories: json['calories'] as int? ?? 0,
      durationMinutes: json['durationMinutes'] as int? ?? 0,
      category: json['category'] as String? ?? 'Genel',
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'calories': calories,
      'durationMinutes': durationMinutes,
      'category': category,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

/// Egzersiz ve kalori verilerini tutan değişmez model sınıfı.
@immutable
class WorkoutModel {
  final int burnedCalories;
  final int dailyCalorieGoal;
  final int activeMinutes;
  final int dailyMinutesGoal;
  final List<WorkoutItem> workouts;

  const WorkoutModel({
    required this.burnedCalories,
    required this.dailyCalorieGoal,
    required this.activeMinutes,
    required this.dailyMinutesGoal,
    required this.workouts,
  });

  double get calorieProgress {
    if (dailyCalorieGoal <= 0) return 0.0;
    final val = burnedCalories / dailyCalorieGoal;
    return val > 1.0 ? 1.0 : val;
  }

  double get minuteProgress {
    if (dailyMinutesGoal <= 0) return 0.0;
    final val = activeMinutes / dailyMinutesGoal;
    return val > 1.0 ? 1.0 : val;
  }

  WorkoutModel copyWith({
    int? burnedCalories,
    int? dailyCalorieGoal,
    int? activeMinutes,
    int? dailyMinutesGoal,
    List<WorkoutItem>? workouts,
  }) {
    return WorkoutModel(
      burnedCalories: burnedCalories ?? this.burnedCalories,
      dailyCalorieGoal: dailyCalorieGoal ?? this.dailyCalorieGoal,
      activeMinutes: activeMinutes ?? this.activeMinutes,
      dailyMinutesGoal: dailyMinutesGoal ?? this.dailyMinutesGoal,
      workouts: workouts ?? this.workouts,
    );
  }

  factory WorkoutModel.initial() {
    return WorkoutModel(
      burnedCalories: 420,
      dailyCalorieGoal: 650,
      activeMinutes: 45,
      dailyMinutesGoal: 60,
      workouts: [
        WorkoutItem(
          id: 'w1',
          title: 'HIIT Kardiyo & Kondisyon',
          calories: 280,
          durationMinutes: 30,
          category: 'Kardiyo',
          timestamp: DateTime.now().subtract(const Duration(hours: 3)),
        ),
        WorkoutItem(
          id: 'w2',
          title: 'Göğüs & Kol Ağırlık',
          calories: 140,
          durationMinutes: 15,
          category: 'Ağırlık',
          timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        ),
      ],
    );
  }

  factory WorkoutModel.fromJson(Map<String, dynamic> json) {
    return WorkoutModel(
      burnedCalories: json['burnedCalories'] as int? ?? 0,
      dailyCalorieGoal: json['dailyCalorieGoal'] as int? ?? 650,
      activeMinutes: json['activeMinutes'] as int? ?? 0,
      dailyMinutesGoal: json['dailyMinutesGoal'] as int? ?? 60,
      workouts: (json['workouts'] as List<dynamic>?)
              ?.map((e) => WorkoutItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'burnedCalories': burnedCalories,
      'dailyCalorieGoal': dailyCalorieGoal,
      'activeMinutes': activeMinutes,
      'dailyMinutesGoal': dailyMinutesGoal,
      'workouts': workouts.map((e) => e.toJson()).toList(),
    };
  }
}
