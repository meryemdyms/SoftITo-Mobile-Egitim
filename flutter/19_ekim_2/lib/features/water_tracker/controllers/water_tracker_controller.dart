import 'package:flutter/foundation.dart';
import '../models/water_tracker_model.dart';

/// Su takip mantığını yöneten ValueNotifier tabanlı kontrolcü sınıfı.
/// UI katmanı bu kontrolcünün [state] akışını dinleyerek sadece model değiştiğinde güncellenir.
class WaterTrackerController {
  final ValueNotifier<WaterTrackerModel> state =
      ValueNotifier<WaterTrackerModel>(WaterTrackerModel.initial());

  WaterTrackerModel get current => state.value;

  /// Belirtilen miktarda (ml) su ekler.
  /// Yeni kayıt listenin en başına (index 0) eklenir, böylece en son içilen su en üstte görünür.
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

  /// Son eklenen kaydı geri alır.
  /// Toplam su miktarını düşürür ve `clamp` ile değerin negatif olmasını engeller.
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

  /// Günlük sayacı ve geçmiş tüketim loglarını sıfırlar.
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

  /// Controller bellekten temizlendiğinde ValueNotifier dinleyicisini kapatır.
  void dispose() {
    state.dispose();
  }
}
