class NotificationPreferenceModel {
  final String id;
  final String habitId;
  final String habitName;
  final bool enabled;
  final String reminderTime; // Örn: '08:30'

  const NotificationPreferenceModel({
    required this.id,
    required this.habitId,
    required this.habitName,
    this.enabled = true,
    required this.reminderTime,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'habitId': habitId,
        'habitName': habitName,
        'enabled': enabled,
        'reminderTime': reminderTime,
      };

  factory NotificationPreferenceModel.fromJson(Map<String, dynamic> json) =>
      NotificationPreferenceModel(
        id: json['id'] as String,
        habitId: json['habitId'] as String,
        habitName: json['habitName'] as String,
        enabled: json['enabled'] as bool? ?? true,
        reminderTime: json['reminderTime'] as String? ?? '09:00',
      );

  NotificationPreferenceModel copyWith({
    String? id,
    String? habitId,
    String? habitName,
    bool? enabled,
    String? reminderTime,
  }) {
    return NotificationPreferenceModel(
      id: id ?? this.id,
      habitId: habitId ?? this.habitId,
      habitName: habitName ?? this.habitName,
      enabled: enabled ?? this.enabled,
      reminderTime: reminderTime ?? this.reminderTime,
    );
  }
}
