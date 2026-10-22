enum MeasurementType {
  boolean,
  quantity,
  duration;

  String get displayName {
    switch (this) {
      case MeasurementType.boolean:
        return 'Evet / Hayır';
      case MeasurementType.quantity:
        return 'Miktar';
      case MeasurementType.duration:
        return 'Süre';
    }
  }
}

enum FrequencyType {
  everyday,
  weekdays,
  customDays;

  String get displayName {
    switch (this) {
      case FrequencyType.everyday:
        return 'Her gün';
      case FrequencyType.weekdays:
        return 'Hafta içi';
      case FrequencyType.customDays:
        return 'Seçilen günler';
    }
  }
}

enum HabitStatus {
  active,
  paused,
  archived,
}

enum ProcessStatus {
  active,
  completed,
  endedIncomplete,
}

class HabitModel {
  final String id;
  final String userId;
  final String name;
  final String category;
  final String icon; // Icon name / key
  final int colorValue; // Color hex integer
  final MeasurementType measurementType;
  final String unit; // Örn: 'sayfa', 'dk', 'bardak', vb.
  final HabitStatus status;
  final DateTime createdAt;

  const HabitModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.category,
    required this.icon,
    required this.colorValue,
    required this.measurementType,
    required this.unit,
    this.status = HabitStatus.active,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'name': name,
        'category': category,
        'icon': icon,
        'colorValue': colorValue,
        'measurementType': measurementType.name,
        'unit': unit,
        'status': status.name,
        'createdAt': createdAt.toIso8601String(),
      };

  factory HabitModel.fromJson(Map<String, dynamic> json) => HabitModel(
        id: json['id'] as String,
        userId: json['userId'] as String,
        name: json['name'] as String,
        category: json['category'] as String,
        icon: json['icon'] as String,
        colorValue: json['colorValue'] as int,
        measurementType: MeasurementType.values.byName(json['measurementType'] as String),
        unit: json['unit'] as String? ?? '',
        status: HabitStatus.values.byName(json['status'] as String? ?? 'active'),
        createdAt: DateTime.parse(json['createdAt'] as String),
      );

  HabitModel copyWith({
    String? id,
    String? userId,
    String? name,
    String? category,
    String? icon,
    int? colorValue,
    MeasurementType? measurementType,
    String? unit,
    HabitStatus? status,
    DateTime? createdAt,
  }) {
    return HabitModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      category: category ?? this.category,
      icon: icon ?? this.icon,
      colorValue: colorValue ?? this.colorValue,
      measurementType: measurementType ?? this.measurementType,
      unit: unit ?? this.unit,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class HabitScheduleModel {
  final String id;
  final String habitId;
  final FrequencyType frequency;
  final List<int> selectedDays; // 1 = Pazartesi, 7 = Pazar
  final double targetValue; // 1.0 (boolean için), 20 (sayfa), 30 (dk)
  final DateTime startDate;
  final DateTime? endDate; // null ise süresiz
  final String? reminderTime; // '08:30'

  const HabitScheduleModel({
    required this.id,
    required this.habitId,
    required this.frequency,
    required this.selectedDays,
    required this.targetValue,
    required this.startDate,
    this.endDate,
    this.reminderTime,
  });

  /// Verilen tarihin bu takvimde planlanmış bir gün olup olmadığını belirler
  bool isScheduledOn(DateTime date) {
    if (date.isBefore(DateTime(startDate.year, startDate.month, startDate.day))) {
      return false;
    }
    if (endDate != null) {
      final end = DateTime(endDate!.year, endDate!.month, endDate!.day, 23, 59, 59);
      if (date.isAfter(end)) return false;
    }

    switch (frequency) {
      case FrequencyType.everyday:
        return true;
      case FrequencyType.weekdays:
        return date.weekday >= 1 && date.weekday <= 5;
      case FrequencyType.customDays:
        return selectedDays.contains(date.weekday);
    }
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'habitId': habitId,
        'frequency': frequency.name,
        'selectedDays': selectedDays,
        'targetValue': targetValue,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate?.toIso8601String(),
        'reminderTime': reminderTime,
      };

  factory HabitScheduleModel.fromJson(Map<String, dynamic> json) =>
      HabitScheduleModel(
        id: json['id'] as String,
        habitId: json['habitId'] as String,
        frequency: FrequencyType.values.byName(json['frequency'] as String),
        selectedDays: (json['selectedDays'] as List<dynamic>?)
                ?.map((e) => e as int)
                .toList() ??
            [1, 2, 3, 4, 5, 6, 7],
        targetValue: (json['targetValue'] as num).toDouble(),
        startDate: DateTime.parse(json['startDate'] as String),
        endDate: json['endDate'] != null
            ? DateTime.parse(json['endDate'] as String)
            : null,
        reminderTime: json['reminderTime'] as String?,
      );
}

class HabitProcessModel {
  final String id;
  final String habitId;
  final DateTime startDate;
  final DateTime? endDate;
  final int plannedDays; // Toplam planlanan başarılı gün sayısı (yapboz parça sayısına denk)
  final int completedDays; // Başarıyla tamamlanan gün sayısı
  final ProcessStatus status;

  const HabitProcessModel({
    required this.id,
    required this.habitId,
    required this.startDate,
    this.endDate,
    required this.plannedDays,
    this.completedDays = 0,
    this.status = ProcessStatus.active,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'habitId': habitId,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate?.toIso8601String(),
        'plannedDays': plannedDays,
        'completedDays': completedDays,
        'status': status.name,
      };

  factory HabitProcessModel.fromJson(Map<String, dynamic> json) =>
      HabitProcessModel(
        id: json['id'] as String,
        habitId: json['habitId'] as String,
        startDate: DateTime.parse(json['startDate'] as String),
        endDate: json['endDate'] != null
            ? DateTime.parse(json['endDate'] as String)
            : null,
        plannedDays: json['plannedDays'] as int,
        completedDays: json['completedDays'] as int? ?? 0,
        status: ProcessStatus.values.byName(json['status'] as String? ?? 'active'),
      );

  HabitProcessModel copyWith({
    String? id,
    String? habitId,
    DateTime? startDate,
    DateTime? endDate,
    int? plannedDays,
    int? completedDays,
    ProcessStatus? status,
  }) {
    return HabitProcessModel(
      id: id ?? this.id,
      habitId: habitId ?? this.habitId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      plannedDays: plannedDays ?? this.plannedDays,
      completedDays: completedDays ?? this.completedDays,
      status: status ?? this.status,
    );
  }
}

class DailyProgressModel {
  final String id;
  final String processId;
  final String habitId;
  final String date; // YYYY-MM-DD
  final double targetValue;
  final double actualValue;
  final bool isCompleted;
  final DateTime? completedAt;

  const DailyProgressModel({
    required this.id,
    required this.processId,
    required this.habitId,
    required this.date,
    required this.targetValue,
    required this.actualValue,
    required this.isCompleted,
    this.completedAt,
  });

  double get progressRatio {
    if (targetValue <= 0) return 0.0;
    return (actualValue / targetValue).clamp(0.0, 1.0);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'processId': processId,
        'habitId': habitId,
        'date': date,
        'targetValue': targetValue,
        'actualValue': actualValue,
        'isCompleted': isCompleted,
        'completedAt': completedAt?.toIso8601String(),
      };

  factory DailyProgressModel.fromJson(Map<String, dynamic> json) =>
      DailyProgressModel(
        id: json['id'] as String,
        processId: json['processId'] as String,
        habitId: json['habitId'] as String? ?? '',
        date: json['date'] as String,
        targetValue: (json['targetValue'] as num).toDouble(),
        actualValue: (json['actualValue'] as num).toDouble(),
        isCompleted: json['isCompleted'] as bool,
        completedAt: json['completedAt'] != null
            ? DateTime.parse(json['completedAt'] as String)
            : null,
      );

  DailyProgressModel copyWith({
    String? id,
    String? processId,
    String? habitId,
    String? date,
    double? targetValue,
    double? actualValue,
    bool? isCompleted,
    DateTime? completedAt,
  }) {
    return DailyProgressModel(
      id: id ?? this.id,
      processId: processId ?? this.processId,
      habitId: habitId ?? this.habitId,
      date: date ?? this.date,
      targetValue: targetValue ?? this.targetValue,
      actualValue: actualValue ?? this.actualValue,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}
