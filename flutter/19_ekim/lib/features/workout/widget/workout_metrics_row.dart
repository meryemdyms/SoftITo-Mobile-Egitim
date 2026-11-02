import 'package:flutter/material.dart';
import 'package:susadim/core/constants/app_colors.dart';
import 'package:susadim/features/workout/controller/workout_controller.dart';

/// 'Aktif Süre' ve 'Kalan Kalori' istatistik kartlarını yatay olarak yan yana dizen satır bileşeni.
///
/// `Row` ve `Expanded` bileşenleri kullanılarak ekran genişliği her iki kart arasında eşit paylaştırılır.
class WorkoutMetricsRow extends StatelessWidget {
  const WorkoutMetricsRow({required this.controller, super.key});

  final WorkoutController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Sol Kart: Toplam aktif antrenman süresi (Örn: 45 dk)
        Expanded(
          child: _WorkoutStatCard(
            label: 'Aktif Süre',
            value: '${controller.totalActiveMinutes} dk',
            icon: Icons.timer_outlined,
            accentColor: AppColors.neonLime,
          ),
        ),
        const SizedBox(width: 12),

        // Sağ Kart: Günlük hedefe ulaşmak için kalan kalori miktarı (Örn: 180 kcal)
        Expanded(
          child: _WorkoutStatCard(
            label: 'Kalan Kalori',
            value: '${controller.remainingCalories} kcal',
            icon: Icons.bolt_rounded,
            accentColor: AppColors.neonCoral,
          ),
        ),
      ],
    );
  }
}

/// Tek bir antrenman istatistiğini (ikon, etiket ve değer) gösteren kart bileşeni
class _WorkoutStatCard extends StatelessWidget {
  const _WorkoutStatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.accentColor,
  });

  /// İstatistik başlığı/etiketi (Örn: 'Aktif Süre', 'Kalan Kalori')
  final String label;

  /// Sayısal değer ve birim metni (Örn: '45 dk', '180 kcal')
  final String value;

  /// Metriğe eşlik eden simge
  final IconData icon;

  /// Kartın ikon kutusunda ve renk şemasında kullanılan neon vurgu rengi
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            // İkonu hafif yarı saydam arka planlı yuvarlatılmış bir kutu içine alır
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: accentColor, size: 20),
            ),
            const SizedBox(width: 10),

            // Etiket ve Değer metinlerinin alt alta yer aldığı sütun
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
