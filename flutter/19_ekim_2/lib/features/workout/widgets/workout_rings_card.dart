import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/extensions/context_extensions.dart';
import '../models/workout_model.dart';

/// Egzersiz ve yakılan kalori özetini gösteren neon/atletik aktivite kartı.
class WorkoutRingsCard extends StatelessWidget {
  final WorkoutModel model;

  const WorkoutRingsCard({
    super.key,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    final calorieColor = context.isDarkMode ? AppColors.neonAmber : AppColors.warmAmber;
    final minuteColor = context.isDarkMode ? AppColors.neonLime : AppColors.athleticGreen;

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: context.cardBorderColor),
        boxShadow: [
          BoxShadow(
            color: minuteColor.withAlpha(context.isDarkMode ? 20 : 15),
            blurRadius: 24,
            spreadRadius: 0,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildMetricRow(
            context: context,
            title: 'Yakılan Kalori',
            value: '${model.burnedCalories} / ${model.dailyCalorieGoal} kcal',
            progress: model.calorieProgress,
            color: calorieColor,
            icon: Icons.local_fire_department_rounded,
          ),
          const SizedBox(height: 20),
          _buildMetricRow(
            context: context,
            title: 'Aktif Süre',
            value: '${model.activeMinutes} / ${model.dailyMinutesGoal} dk',
            progress: model.minuteProgress,
            color: minuteColor,
            icon: Icons.timer_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildMetricRow({
    required BuildContext context,
    required String title,
    required String value,
    required double progress,
    required Color color,
    required IconData icon,
  }) {
    final percent = (progress * 100).toInt();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: context.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
            Text(
              '$value (%$percent)',
              style: context.textTheme.bodyMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 10,
            backgroundColor: context.surfaceElevatedColor,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}
