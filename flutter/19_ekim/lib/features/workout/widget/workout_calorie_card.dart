import 'package:flutter/material.dart';
import 'package:susadim/core/constants/app_colors.dart';
import 'package:susadim/features/workout/controller/workout_controller.dart';

class WorkoutCalorieCard extends StatelessWidget {
  const WorkoutCalorieCard({required this.controller, super.key});

  final WorkoutController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final percent = (controller.calorieProgressRatio * 100).toInt();

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _CalorieGauge(controller: controller, percent: percent),
            const SizedBox(height: 16),
            _CalorieGoalSummary(controller: controller, theme: theme),
          ],
        ),
      ),
    );
  }
}

class _CalorieGauge extends StatelessWidget {
  const _CalorieGauge({required this.controller, required this.percent});

  final WorkoutController controller;
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
              value: controller.calorieProgressRatio,
              strokeWidth: 12,
              backgroundColor: AppColors.obsidianBorder,
              color: AppColors.neonLime,
              strokeCap: StrokeCap.round,
            ),
          ),
          _GaugeCenterInfo(percent: percent),
        ],
      ),
    );
  }
}

class _GaugeCenterInfo extends StatelessWidget {
  const _GaugeCenterInfo({required this.percent});

  final int percent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.local_fire_department, color: AppColors.neonLime, size: 30),
        const SizedBox(height: 4),
        Text(
          '%$percent',
          style: theme.textTheme.headlineMedium?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w800,
          ),
        ),
        Text('yakıldı', style: theme.textTheme.bodyMedium),
      ],
    );
  }
}

class _CalorieGoalSummary extends StatelessWidget {
  const _CalorieGoalSummary({required this.controller, required this.theme});

  final WorkoutController controller;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '${controller.totalCaloriesBurned}',
          style: theme.textTheme.titleLarge?.copyWith(
            color: AppColors.neonLime,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          ' / ${controller.dailyCalorieGoal} kcal',
          style: theme.textTheme.titleMedium,
        ),
      ],
    );
  }
}
