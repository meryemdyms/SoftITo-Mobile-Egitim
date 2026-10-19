import 'package:flutter/foundation.dart';
import '../models/water_tracker_model.dart';

/// Su takip mantığını yöneten ValueNotifier tabanlı kontrolcü sınıfı.
class WaterTrackerController {
  final ValueNotifier<WaterTrackerModel> state =
      ValueNotifier<WaterTrackerModel>(WaterTrackerModel.initial());

  WaterTrackerModel get current => state.value;

  /// Belirtilen miktarda su ekler
  void addWater(int amountMl) {
    final updatedList = List<WaterLogItem>.from(current.logs)
      ..insert(
        0,
        WaterLogItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          amountMl: amountMl,
          timestamp: DateTime.now(),
        ),
      );

    state.value = current.copyWith(
      currentWaterMl: current.currentWaterMl + amountMl,
      logs: updatedList,
    );
  }

  /// Son eklenen kaydı geri alır
  void undoLastLog() {
    if (current.logs.isEmpty) return;
    final lastLog = current.logs.first;
    final updatedList = List<WaterLogItem>.from(current.logs)..removeAt(0);

    final newTotal = (current.currentWaterMl - lastLog.amountMl).clamp(0, 99999);
    state.value = current.copyWith(
      currentWaterMl: newTotal,
      logs: updatedList,
    );
  }

  /// Günlük sayacı sıfırlar
  void resetWater() {
    state.value = current.copyWith(
      currentWaterMl: 0,
      logs: const [],
    );
  }

  /// Günlük hedefi günceller
  void updateDailyGoal(int newGoalMl) {
    state.value = current.copyWith(
      dailyGoalWaterMl: newGoalMl,
    );
  }

  void dispose() {
    state.dispose();
  }
}
