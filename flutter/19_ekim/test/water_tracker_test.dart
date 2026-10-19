import 'package:flutter_test/flutter_test.dart';
import 'package:susadim/features/water_tracker/controller/water_tracker_controller.dart';
import 'package:susadim/features/water_tracker/models/water_log.dart';

void main() {
  group('WaterTrackerController Testleri', () {
    test('Başlangıç durumları doğru atanmalıdır', () {
      final controller = WaterTrackerController(initialGoalMl: 2000);
      expect(controller.dailyGoalMl, 2000);
      expect(controller.totalConsumedMl, 0);
      expect(controller.remainingMl, 2000);
      expect(controller.progressRatio, 0.0);
      expect(controller.isGoalAchieved, isFalse);
      expect(controller.logs.isEmpty, isTrue);
    });

    test('Su eklendiğinde tüketim ve oran güncellenmelidir', () {
      final controller = WaterTrackerController(initialGoalMl: 2000);
      controller.addWater(500, type: DrinkType.water);

      expect(controller.totalConsumedMl, 500);
      expect(controller.remainingMl, 1500);
      expect(controller.progressRatio, 0.25);
      expect(controller.logs.length, 1);
      expect(controller.logs.first.amountMl, 500);
    });

    test('Kayıt silindiğinde tüketim güncellenmelidir', () {
      final controller = WaterTrackerController(initialGoalMl: 2000);
      controller.addWater(300);
      final id = controller.logs.first.id;
      expect(controller.totalConsumedMl, 300);

      controller.removeLog(id);
      expect(controller.totalConsumedMl, 0);
      expect(controller.logs.isEmpty, isTrue);
    });

    test('Sıfırla çağrıldığında tüm kayıtlar silinmelidir', () {
      final controller = WaterTrackerController();
      controller.addWater(200);
      controller.addWater(300);
      expect(controller.logs.length, 2);

      controller.reset();
      expect(controller.logs.isEmpty, isTrue);
      expect(controller.totalConsumedMl, 0);
    });

    test('Hedefe ulaşıldığında addWater true dönmeli, zaten aşılmışsa false dönmelidir', () {
      final controller = WaterTrackerController(initialGoalMl: 1000);
      
      // Henüz ulaşılmadı
      final firstAdd = controller.addWater(600);
      expect(firstAdd, isFalse);
      expect(controller.isGoalAchieved, isFalse);

      // Hedefe tam ulaşıldı
      final secondAdd = controller.addWater(400);
      expect(secondAdd, isTrue);
      expect(controller.isGoalAchieved, isTrue);

      // Zaten ulaşılmışken tekrar ekleme yapıldı
      final thirdAdd = controller.addWater(200);
      expect(thirdAdd, isFalse);
      expect(controller.isGoalAchieved, isTrue);
    });
  });
}
