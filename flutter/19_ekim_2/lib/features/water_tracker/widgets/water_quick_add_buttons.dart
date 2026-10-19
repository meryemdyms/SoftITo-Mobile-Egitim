import 'package:flutter/material.dart';
import '../../../core/extensions/context_extensions.dart';

/// Hızlı su ekleme seçeneklerini sunan modüler buton grubu.
class WaterQuickAddButtons extends StatelessWidget {
  final ValueChanged<int> onAddWater;

  const WaterQuickAddButtons({
    super.key,
    required this.onAddWater,
  });

  static const List<_QuickOption> _options = [
    _QuickOption(150, '150 ml', 'Bardak', Icons.local_cafe_rounded),
    _QuickOption(250, '250 ml', 'Kupa', Icons.coffee_rounded),
    _QuickOption(500, '500 ml', 'Şişe', Icons.sports_bar_rounded),
    _QuickOption(750, '750 ml', 'Matara', Icons.fitness_center_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hızlı Su Ekle',
          style: context.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        Row(
          children: _options.map((opt) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: _buildItem(context, opt),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildItem(BuildContext context, _QuickOption opt) {
    final subColor = context.colorScheme.onSurface.withAlpha(160);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onAddWater(opt.amount),
        borderRadius: BorderRadius.circular(18),
        splashColor: context.primaryAccent.withAlpha(30),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: context.surfaceColor,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: context.cardBorderColor),
          ),
          child: Column(
            children: [
              Icon(opt.icon, color: context.primaryAccent, size: 22),
              const SizedBox(height: 6),
              Text(
                opt.label,
                style: context.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 2),
              Text(
                opt.sublabel,
                style: context.textTheme.bodyMedium?.copyWith(
                      fontSize: 11,
                      color: subColor,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickOption {
  final int amount;
  final String label;
  final String sublabel;
  final IconData icon;

  const _QuickOption(this.amount, this.label, this.sublabel, this.icon);
}
