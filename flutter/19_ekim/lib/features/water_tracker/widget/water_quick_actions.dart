import 'package:flutter/material.dart';
import 'package:susadim/core/constants/app_colors.dart';
import 'package:susadim/features/water_tracker/controller/water_tracker_controller.dart';
import 'package:susadim/features/water_tracker/models/water_log.dart';
import 'package:susadim/features/water_tracker/widget/water_goal_dialog.dart';

class WaterQuickActions extends StatelessWidget {
  const WaterQuickActions({required this.controller, super.key});

  final WaterTrackerController controller;

  static const List<int> _amounts = <int>[200, 330, 500, 750];

  void _onAddWater(BuildContext context, int ml) {
    final reachedGoal = controller.addWater(ml, type: DrinkType.water);
    if (reachedGoal && context.mounted) {
      WaterGoalDialog.show(
        context,
        totalMl: controller.totalConsumedMl,
        goalMl: controller.dailyGoalMl,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const _SectionHeader(title: 'Hızlı Su Ekle'),
        const SizedBox(height: 10),
        Row(
          children: _amounts
              .map(
                (ml) => Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: _QuickAddButton(
                      amountMl: ml,
                      onTap: () => _onAddWater(context, ml),
                    ),
                  ),
                ),
              )
              .toList(growable: false),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
    );
  }
}

class _QuickAddButton extends StatelessWidget {
  const _QuickAddButton({required this.amountMl, required this.onTap});

  final int amountMl;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.obsidianCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.neonCyan.withValues(alpha: 0.35)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.add, color: AppColors.neonCyan, size: 18),
            const SizedBox(height: 4),
            Text(
              '$amountMl',
              style: const TextStyle(
                color: AppColors.neonCyan,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
            const Text(
              'ml',
              style: TextStyle(color: AppColors.textMuted, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}
