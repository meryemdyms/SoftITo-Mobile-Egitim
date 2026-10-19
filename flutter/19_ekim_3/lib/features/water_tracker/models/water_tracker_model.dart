import 'package:flutter/foundation.dart';

/// Su içme kaydı öğesi.
@immutable
class WaterLogItem {
  final String id;
  final int amountMl;
  final DateTime timestamp;

  const WaterLogItem({
    required this.id,
    required this.amountMl,
    required this.timestamp,
  });

  WaterLogItem copyWith({
    String? id,
    int? amountMl,
    DateTime? timestamp,
  }) {
    return WaterLogItem(
      id: id ?? this.id,
      amountMl: amountMl ?? this.amountMl,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  factory WaterLogItem.fromJson(Map<String, dynamic> json) {
    return WaterLogItem(
      id: json['id'] as String? ?? '',
      amountMl: json['amountMl'] as int? ?? 0,
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amountMl': amountMl,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

/// Su takip verilerini tutan değişmez (immutable) model sınıfı.
@immutable
class WaterTrackerModel {
  final int currentWaterMl;
  final int dailyGoalWaterMl;
  final int streakDays;
  final List<WaterLogItem> logs;

  const WaterTrackerModel({
    required this.currentWaterMl,
    required this.dailyGoalWaterMl,
    required this.streakDays,
    required this.logs,
  });

  double get progress {
    if (dailyGoalWaterMl <= 0) return 0.0;
    final val = currentWaterMl / dailyGoalWaterMl;
    return val > 1.0 ? 1.0 : val;
  }

  int get remainingMl {
    final diff = dailyGoalWaterMl - currentWaterMl;
    return diff > 0 ? diff : 0;
  }

  WaterTrackerModel copyWith({
    int? currentWaterMl,
    int? dailyGoalWaterMl,
    int? streakDays,
    List<WaterLogItem>? logs,
  }) {
    return WaterTrackerModel(
      currentWaterMl: currentWaterMl ?? this.currentWaterMl,
      dailyGoalWaterMl: dailyGoalWaterMl ?? this.dailyGoalWaterMl,
      streakDays: streakDays ?? this.streakDays,
      logs: logs ?? this.logs,
    );
  }

  factory WaterTrackerModel.initial() {
    final now = DateTime.now();
    return WaterTrackerModel(
      currentWaterMl: 1250,
      dailyGoalWaterMl: 2500,
      streakDays: 4,
      logs: [
        WaterLogItem(
          id: '1',
          amountMl: 250,
          timestamp: DateTime(now.year, now.month, now.day, 8, 30),
        ),
        WaterLogItem(
          id: '2',
          amountMl: 500,
          timestamp: DateTime(now.year, now.month, now.day, 11, 15),
        ),
        WaterLogItem(
          id: '3',
          amountMl: 500,
          timestamp: DateTime(now.year, now.month, now.day, 13, 45),
        ),
      ],
    );
  }

  factory WaterTrackerModel.fromJson(Map<String, dynamic> json) {
    return WaterTrackerModel(
      currentWaterMl: json['currentWaterMl'] as int? ?? 0,
      dailyGoalWaterMl: json['dailyGoalWaterMl'] as int? ?? 2500,
      streakDays: json['streakDays'] as int? ?? 0,
      logs: (json['logs'] as List<dynamic>?)
              ?.map((e) => WaterLogItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentWaterMl': currentWaterMl,
      'dailyGoalWaterMl': dailyGoalWaterMl,
      'streakDays': streakDays,
      'logs': logs.map((e) => e.toJson()).toList(),
    };
  }
}
