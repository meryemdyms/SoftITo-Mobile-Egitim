import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/extensions/context_extensions.dart';

typedef WorkoutPresetCallback = void Function({
  required String title,
  required int calories,
  required int durationMinutes,
  required String category,
});

/// Hızlı egzersiz ekleme seçenekleri kartı.
class WorkoutQuickPresets extends StatelessWidget {
  final WorkoutPresetCallback onAddWorkout;

  const WorkoutQuickPresets({
    super.key,
    required this.onAddWorkout,
  });

  static const List<_Preset> _presets = [
    _Preset('HIIT Kardiyo', 200, 20, 'Kardiyo', Icons.flash_on_rounded, AppColors.neonAmber),
    _Preset('Ağırlık Antrenmanı', 160, 25, 'Ağırlık', Icons.fitness_center_rounded, AppColors.neonLime),
    _Preset('Koşu / Tempolu', 240, 20, 'Kardiyo', Icons.directions_run_rounded, AppColors.neonCyan),
    _Preset('Esneme & Yoga', 80, 15, 'Esneme', Icons.self_improvement_rounded, AppColors.neonPurple),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hızlı Antrenman Ekle',
          style: context.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 2.2,
          ),
          itemCount: _presets.length,
          itemBuilder: (context, index) => _buildItem(context, _presets[index]),
        ),
      ],
    );
  }

  Widget _buildItem(BuildContext context, _Preset p) {
    final subColor = context.colorScheme.onSurface.withAlpha(160);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onAddWorkout(
          title: p.title,
          calories: p.calories,
          durationMinutes: p.duration,
          category: p.category,
        ),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: context.surfaceColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: context.cardBorderColor),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: p.color.withAlpha(25),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(p.icon, color: p.color, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      p.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    Text(
                      '+${p.calories} kcal • ${p.duration} dk',
                      style: context.textTheme.bodyMedium?.copyWith(
                            fontSize: 11,
                            color: subColor,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Preset {
  final String title;
  final int calories;
  final int duration;
  final String category;
  final IconData icon;
  final Color color;

  const _Preset(this.title, this.calories, this.duration, this.category, this.icon, this.color);
}
