import 'package:flutter/material.dart';
import '../../../core/theme/theme_controller.dart';
import '../controllers/water_tracker_controller.dart';
import '../models/water_tracker_model.dart';
import '../widgets/water_gauge_card.dart';
import '../widgets/water_header_card.dart';
import '../widgets/water_history_tile.dart';
import '../widgets/water_quick_add_buttons.dart';

/// Su takip ana ekran görünümü (Clean UI ve Reaktif ValueNotifier).
class WaterTrackerView extends StatelessWidget {
  final WaterTrackerController controller;
  final ThemeController themeController;

  const WaterTrackerView({
    super.key,
    required this.controller,
    required this.themeController,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<WaterTrackerModel>(
      valueListenable: controller.state,
      builder: (context, model, _) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              WaterHeaderCard(
                model: model,
                onReset: controller.resetWater,
                onToggleTheme: () => themeController.toggleTheme(context),
                isDarkMode: themeController.isDark(context),
              ),
              const SizedBox(height: 20),
              WaterGaugeCard(model: model),
              const SizedBox(height: 24),
              WaterQuickAddButtons(onAddWater: controller.addWater),
              const SizedBox(height: 24),
              WaterHistorySection(
                logs: model.logs,
                onUndo: controller.undoLastLog,
              ),
            ],
          ),
        );
      },
    );
  }
}
