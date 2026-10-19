import 'package:flutter/material.dart';
import '../controllers/workout_controller.dart';
import '../models/workout_model.dart';
import '../widgets/workout_history_list.dart';
import '../widgets/workout_quick_presets.dart';
import '../widgets/workout_rings_card.dart';

/// Egzersiz ve kalori takip görünümü (Clean UI ve Reaktif ValueNotifier).
class WorkoutView extends StatelessWidget {
  final WorkoutController controller;

  const WorkoutView({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<WorkoutModel>(
      valueListenable: controller.state,
      builder: (context, model, _) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              WorkoutRingsCard(model: model),
              const SizedBox(height: 24),
              WorkoutQuickPresets(onAddWorkout: controller.addWorkout),
              const SizedBox(height: 24),
              WorkoutHistoryList(
                workouts: model.workouts,
                onRemoveWorkout: controller.removeWorkout,
              ),
            ],
          ),
        );
      },
    );
  }
}
