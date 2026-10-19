import 'package:flutter/material.dart';
import 'package:susadim/core/constants/app_colors.dart';
import 'package:susadim/features/water_tracker/controller/water_tracker_controller.dart';

class WaterMetricsRow extends StatelessWidget {
  const WaterMetricsRow({required this.controller, super.key});

  final WaterTrackerController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _MetricItemCard(
            label: 'Kalan',
            value: '${controller.remainingMl} ml',
            icon: Icons.hourglass_bottom_rounded,
            accentColor: AppColors.neonBlue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _MetricItemCard(
            label: 'Hedef',
            value: '${controller.dailyGoalMl} ml',
            icon: Icons.flag_rounded,
            accentColor: AppColors.neonLime,
          ),
        ),
      ],
    );
  }
}

class _MetricItemCard extends StatelessWidget {
  const _MetricItemCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.accentColor,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: accentColor, size: 20),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(label, style: theme.textTheme.bodyMedium),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
