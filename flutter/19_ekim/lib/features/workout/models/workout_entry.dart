enum WorkoutIntensity {
  low,
  medium,
  high;

  String get displayName {
    switch (this) {
      case WorkoutIntensity.low:
        return 'Hafif';
      case WorkoutIntensity.medium:
        return 'Orta';
      case WorkoutIntensity.high:
        return 'Yoğun';
    }
  }
}

class WorkoutEntry {
  const WorkoutEntry({
    required this.id,
    required this.title,
    required this.durationMinutes,
    required this.caloriesBurned,
    required this.intensity,
    required this.timestamp,
  });

  final String id;
  final String title;
  final int durationMinutes;
  final int caloriesBurned;
  final WorkoutIntensity intensity;
  final DateTime timestamp;
}
