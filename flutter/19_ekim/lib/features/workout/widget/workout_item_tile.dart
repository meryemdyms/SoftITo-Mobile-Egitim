import 'package:flutter/material.dart';
import 'package:susadim/core/constants/app_colors.dart';
import 'package:susadim/features/workout/models/workout_entry.dart';

class WorkoutItemTile extends StatelessWidget {
  const WorkoutItemTile({
    required this.entry,
    required this.onDelete,
    super.key,
  });

  final WorkoutEntry entry;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.obsidianCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.obsidianBorder),
      ),
      child: Row(
        children: [
          const Icon(Icons.fitness_center_rounded, color: AppColors.neonLime, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(entry.title, style: theme.textTheme.bodyLarge),
                const SizedBox(height: 2),
                Text(
                  '${entry.durationMinutes} dk • ${entry.intensity.displayName}',
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          Text(
            '-${entry.caloriesBurned} kcal',
            style: const TextStyle(
              color: AppColors.neonLime,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close_rounded, size: 18, color: AppColors.textMuted),
            onPressed: onDelete,
            tooltip: 'Sil',
          ),
        ],
      ),
    );
  }
}
