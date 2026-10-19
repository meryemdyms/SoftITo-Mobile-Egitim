import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/extensions/context_extensions.dart';
import '../models/water_tracker_model.dart';

/// Sayfa başlığı, uygulama logosu, tema geçiş butonu ve seri sayacını içeren üst banner.
class WaterHeaderCard extends StatelessWidget {
  final WaterTrackerModel model;
  final VoidCallback onReset;
  final VoidCallback onToggleTheme;
  final bool isDarkMode;

  const WaterHeaderCard({
    super.key,
    required this.model,
    required this.onReset,
    required this.onToggleTheme,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildAppBrand(context),
        _buildActionGroup(context),
      ],
    );
  }

  Widget _buildAppBrand(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            'assets/icons/app_logo.png',
            width: 44,
            height: 44,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: context.surfaceColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: context.primaryAccent),
              ),
              child: Icon(Icons.water_drop_rounded, color: context.primaryAccent),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Susadım v1',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
            ),
            Text(
              'Akıllı Hidrasyon',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: context.primaryAccent,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionGroup(BuildContext context) {
    final amberColor = isDarkMode ? AppColors.neonAmber : AppColors.warmAmber;

    return Row(
      children: [
        IconButton(
          onPressed: onToggleTheme,
          tooltip: isDarkMode ? 'Aydınlık Moda Geç' : 'Karanlık Moda Geç',
          icon: Icon(
            isDarkMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
            color: isDarkMode ? AppColors.neonAmber : AppColors.oceanBlue,
            size: 22,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: amberColor.withAlpha(25),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: amberColor.withAlpha(90)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.local_fire_department_rounded, color: amberColor, size: 16),
              const SizedBox(width: 4),
              Text(
                '${model.streakDays} Gün',
                style: TextStyle(
                  color: amberColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () => _confirmReset(context),
          tooltip: 'Günü Sıfırla',
          icon: Icon(Icons.refresh_rounded, color: context.colorScheme.onSurface.withAlpha(140), size: 18),
        ),
      ],
    );
  }

  void _confirmReset(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: context.surfaceColor,
        title: const Text('Günü Sıfırla'),
        content: const Text('Bugünkü su kayıtlarınızı sıfırlamak istediğinize emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              onReset();
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.neonRose),
            child: const Text('Sıfırla', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
