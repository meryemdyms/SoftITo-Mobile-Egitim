import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/extensions/context_extensions.dart';
import '../models/workout_model.dart';

/// Günlük yapılan antrenmanların listelendiği modüler bileşen.
class WorkoutHistoryList extends StatelessWidget {
  final List<WorkoutItem> workouts;
  final ValueChanged<String> onRemoveWorkout;

  const WorkoutHistoryList({
    super.key,
    required this.workouts,
    required this.onRemoveWorkout,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bugünkü Antrenmanlar',
          style: context.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        if (workouts.isEmpty) _buildEmptyState(context) else _buildList(context),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: context.cardBorderColor),
      ),
      child: Center(
        child: Text(
          'Bugün henüz antrenman kaydedilmedi.',
          style: context.textTheme.bodyMedium,
        ),
      ),
    );
  }

  Widget _buildList(BuildContext context) {
    final limeColor = context.isDarkMode ? AppColors.neonLime : AppColors.athleticGreen;
    final amberColor = context.isDarkMode ? AppColors.neonAmber : AppColors.warmAmber;
    final subColor = context.colorScheme.onSurface.withAlpha(160);

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: workouts.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final item = workouts[index];

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: context.surfaceColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: context.cardBorderColor),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: limeColor.withAlpha(25),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.fitness_center_rounded, color: limeColor, size: 18),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: context.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      Text(
                        '${item.durationMinutes} dakika • ${item.category}',
                        style: context.textTheme.bodyMedium?.copyWith(fontSize: 12, color: subColor),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    '${item.calories} kcal',
                    style: context.textTheme.titleMedium?.copyWith(
                          color: amberColor,
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(width: 4),
                  IconButton(
                    onPressed: () => onRemoveWorkout(item.id),
                    icon: Icon(Icons.delete_outline_rounded, size: 18, color: subColor),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
