import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:susadim/features/water_tracker/models/water_log.dart';

class WaterTrackerController extends ChangeNotifier {
  WaterTrackerController({int initialGoalMl = 2500})
      : _dailyGoalMl = initialGoalMl;

  int _dailyGoalMl;
  final List<WaterLog> _logs = <WaterLog>[];

  int get dailyGoalMl => _dailyGoalMl;

  UnmodifiableListView<WaterLog> get logs => UnmodifiableListView<WaterLog>(_logs);

  int get totalConsumedMl {
    return _logs.fold<int>(0, (sum, log) => sum + log.amountMl);
  }

  double get progressRatio {
    if (_dailyGoalMl <= 0) return 0.0;
    final ratio = totalConsumedMl / _dailyGoalMl;
    return ratio.clamp(0.0, 1.0);
  }

  int get remainingMl {
    final remaining = _dailyGoalMl - totalConsumedMl;
    return remaining < 0 ? 0 : remaining;
  }

  bool get isGoalAchieved => totalConsumedMl >= _dailyGoalMl;

  bool addWater(int amountMl, {DrinkType type = DrinkType.water}) {
    if (amountMl <= 0) return false;
    final wasAchieved = isGoalAchieved;
    final log = WaterLog(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      amountMl: amountMl,
      timestamp: DateTime.now(),
      type: type,
    );
    _logs.insert(0, log);
    final nowAchieved = isGoalAchieved;
    notifyListeners();
    return !wasAchieved && nowAchieved;
  }

  void removeLog(String id) {
    _logs.removeWhere((log) => log.id == id);
    notifyListeners();
  }

  void updateDailyGoal(int newGoalMl) {
    if (newGoalMl <= 0) return;
    _dailyGoalMl = newGoalMl;
    notifyListeners();
  }

  void reset() {
    _logs.clear();
    notifyListeners();
  }
}
