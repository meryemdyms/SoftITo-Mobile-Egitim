import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kirmizi_cagri/core/theme/theme_controller.dart';

void main() {
  group('ThemeController Tests', () {
    test('Initial theme mode is correctly set', () {
      final controller = ThemeController(initialMode: ThemeMode.light);
      expect(controller.themeMode.value, ThemeMode.light);
      controller.dispose();
    });

    test('toggleTheme switches between dark and light modes', () {
      final controller = ThemeController(initialMode: ThemeMode.light);
      controller.toggleTheme();
      expect(controller.themeMode.value, ThemeMode.dark);

      controller.toggleTheme();
      expect(controller.themeMode.value, ThemeMode.light);
      controller.dispose();
    });

    test('setTheme sets explicitly requested theme mode', () {
      final controller = ThemeController(initialMode: ThemeMode.light);
      controller.setTheme(ThemeMode.dark);
      expect(controller.themeMode.value, ThemeMode.dark);
      controller.dispose();
    });
  });
}
