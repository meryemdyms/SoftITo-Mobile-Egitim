import 'package:flutter/material.dart';
import 'package:susadim/core/constants/app_colors.dart';
import 'package:susadim/features/workout/controller/workout_controller.dart';
import 'package:susadim/features/workout/widget/workout_add_modal.dart';
import 'package:susadim/features/workout/widget/workout_calorie_card.dart';
import 'package:susadim/features/workout/widget/workout_item_tile.dart';
import 'package:susadim/features/workout/widget/workout_metrics_row.dart';

class WorkoutView extends StatelessWidget {
  const WorkoutView({required this.controller, super.key});

  final WorkoutController controller;

  void _showAddModal(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => WorkoutAddModal(
        onAdd: ({
          required title,
          required durationMinutes,
          required caloriesBurned,
          required intensity,
        }) {
          controller.addWorkout(
            title: title,
            durationMinutes: durationMinutes,
            caloriesBurned: caloriesBurned,
            intensity: intensity,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          children: [
            WorkoutCalorieCard(controller: controller),
            const SizedBox(height: 14),
            WorkoutMetricsRow(controller: controller),
            const SizedBox(height: 20),
            _AddWorkoutButton(onTap: () => _showAddModal(context)),
            const SizedBox(height: 20),
            _WorkoutSectionHeader(onReset: controller.reset),
            const SizedBox(height: 8),
            _WorkoutList(controller: controller),
          ],
        );
      },
    );
  }
}

class _AddWorkoutButton extends StatelessWidget {
  const _AddWorkoutButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.styleFrom(
      backgroundColor: AppColors.neonLime,
      foregroundColor: AppColors.obsidianBackground,
    ).let((_) {
      return ElevatedButton.icon(
        onPressed: onTap,
        icon: const Icon(Icons.add_circle_outline_rounded),
        label: const Text('Egzersiz Kaydet'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.neonLime,
          foregroundColor: AppColors.obsidianBackground,
        ),
      );
    });
  }
}

extension _LetExt<T> on T {
  R let<R>(R Function(T) op) => op(this);
}

class _WorkoutSectionHeader extends StatelessWidget {
  const _WorkoutSectionHeader({required this.onReset});

  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            'Bugünkü Antrenmanlar',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        TextButton(
          onPressed: onReset,
          child: const Text('Sıfırla', style: TextStyle(color: AppColors.textMuted)),
        ),
      ],
    );
  }
}

class _WorkoutList extends StatelessWidget {
  const _WorkoutList({required this.controller});

  final WorkoutController controller;

  @override
  Widget build(BuildContext context) {
    if (controller.workouts.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: Text(
            'Henüz egzersiz kaydı eklenmedi.',
            style: TextStyle(color: AppColors.textMuted),
          ),
        ),
      );
    }

    return Column(
      children: controller.workouts.map((entry) {
        return WorkoutItemTile(
          key: ValueKey(entry.id),
          entry: entry,
          onDelete: () => controller.removeWorkout(entry.id),
        );
      }).toList(growable: false),
    );
  }
}
