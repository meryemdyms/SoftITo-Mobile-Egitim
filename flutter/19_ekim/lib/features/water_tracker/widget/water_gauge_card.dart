import 'package:flutter/material.dart';
import 'package:susadim/core/constants/app_colors.dart';
import 'package:susadim/features/water_tracker/controller/water_tracker_controller.dart';

class WaterGaugeCard extends StatelessWidget {
  const WaterGaugeCard({required this.controller, super.key});

  final WaterTrackerController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final percent = (controller.progressRatio * 100).toInt();

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _GaugeProgress(controller: controller, percent: percent),
            const SizedBox(height: 16),
            _GoalSummaryText(controller: controller, theme: theme),
          ],
        ),
      ),
    );
  }
}

class _GaugeProgress extends StatelessWidget {
  const _GaugeProgress({required this.controller, required this.percent});

  final WaterTrackerController controller;
  final int percent;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 170,
      height: 170,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 170,
            height: 170,
            child: CircularProgressIndicator(
              value: controller.progressRatio,
              strokeWidth: 12,
              backgroundColor: AppColors.obsidianBorder,
              color: AppColors.neonCyan,
              strokeCap: StrokeCap.round,
            ),
          ),
          _GaugeCenterContent(percent: percent),
        ],
      ),
    );
  }
}

class _GaugeCenterContent extends StatelessWidget {
  const _GaugeCenterContent({required this.percent});

  final int percent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.water_drop, color: AppColors.neonCyan, size: 30),
        const SizedBox(height: 4),
        Text(
          '%$percent',
          style: theme.textTheme.headlineMedium?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w800,
          ),
        ),
        Text('tamamlandı', style: theme.textTheme.bodyMedium),
      ],
    );
  }
}

class _GoalSummaryText extends StatelessWidget {
  const _GoalSummaryText({required this.controller, required this.theme});

  final WaterTrackerController controller;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '${controller.totalConsumedMl}',
          style: theme.textTheme.titleLarge?.copyWith(
            color: AppColors.neonCyan,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(' / ${controller.dailyGoalMl} ml', style: theme.textTheme.titleMedium),
      ],
    );
  }
}
