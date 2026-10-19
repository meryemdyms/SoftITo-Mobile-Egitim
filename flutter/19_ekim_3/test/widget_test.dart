import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:susadim/core/theme/theme_controller.dart';
import 'package:susadim/features/water_tracker/controllers/water_tracker_controller.dart';
import 'package:susadim/features/workout/controllers/workout_controller.dart';
import 'package:susadim/main.dart';

void main() {
  group('ThemeController Testleri', () {
    test('Varsayılan tema modu dark olmalıdır', () {
      final controller = ThemeController(ThemeMode.dark);
      expect(controller.themeMode.value, ThemeMode.dark);
      expect(controller.isDarkMode, true);
      controller.dispose();
    });

    test('toggleTheme temayı dark ve light arasında değiştirmelidir', () {
      final controller = ThemeController(ThemeMode.dark);
      controller.toggleTheme();
      expect(controller.themeMode.value, ThemeMode.light);
      expect(controller.isDarkMode, false);

      controller.toggleTheme();
      expect(controller.themeMode.value, ThemeMode.dark);
      expect(controller.isDarkMode, true);
      controller.dispose();
    });
  });

  group('WaterTrackerController Testleri', () {
    test('İlk başlatma değerleri doğru olmalıdır', () {
      final controller = WaterTrackerController();
      expect(controller.current.currentWaterMl, 1250);
      expect(controller.current.dailyGoalWaterMl, 2500);
      expect(controller.current.streakDays, 4);
      controller.dispose();
    });

    test('addWater çağrıldığında su miktarı ve log eklenmelidir', () {
      final controller = WaterTrackerController();
      final initialAmount = controller.current.currentWaterMl;
      final initialLogsCount = controller.current.logs.length;

      controller.addWater(250);

      expect(controller.current.currentWaterMl, initialAmount + 250);
      expect(controller.current.logs.length, initialLogsCount + 1);
      expect(controller.current.logs.first.amountMl, 250);
      controller.dispose();
    });

    test('undoLastLog son kaydı geri almalıdır', () {
      final controller = WaterTrackerController();
      controller.addWater(500);
      final withAdded = controller.current.currentWaterMl;

      controller.undoLastLog();

      expect(controller.current.currentWaterMl, withAdded - 500);
      controller.dispose();
    });

    test('resetWater sayacı ve logları sıfırlamalıdır', () {
      final controller = WaterTrackerController();
      controller.resetWater();

      expect(controller.current.currentWaterMl, 0);
      expect(controller.current.logs.isEmpty, true);
      controller.dispose();
    });
  });

  group('WorkoutController Testleri', () {
    test('Yeni egzersiz ekleme kalori ve süreyi artırmalıdır', () {
      final controller = WorkoutController();
      final initialCalories = controller.current.burnedCalories;
      final initialMinutes = controller.current.activeMinutes;

      controller.addWorkout(
        title: 'Spinning',
        calories: 300,
        durationMinutes: 30,
        category: 'Kardiyo',
      );

      expect(controller.current.burnedCalories, initialCalories + 300);
      expect(controller.current.activeMinutes, initialMinutes + 30);
      controller.dispose();
    });
  });

  group('SusadimApp Widget Smoke Test', () {
    testWidgets('Uygulama başarıyla render edilmeli ve tema geçişi çalışmalı',
        (WidgetTester tester) async {
      final themeController = ThemeController(ThemeMode.dark);
      await tester.pumpWidget(SusadimApp(themeController: themeController));
      await tester.pump();

      expect(find.text('Susadım v1'), findsOneWidget);
      expect(find.text('Su Takibi'), findsOneWidget);
      expect(find.text('Antrenman & Kalori'), findsOneWidget);

      // Tema butonuna tıklanıp açık moda geçilmesi
      final themeButton = find.byTooltip('Aydınlık Moda Geç');
      expect(themeButton, findsOneWidget);

      await tester.tap(themeButton);
      await tester.pumpAndSettle();

      expect(themeController.isDarkMode, false);
      expect(find.byTooltip('Karanlık Moda Geç'), findsOneWidget);
    });
  });
}
