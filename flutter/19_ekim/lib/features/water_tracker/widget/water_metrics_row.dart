import 'package:flutter/material.dart';
import 'package:susadim/core/constants/app_colors.dart';
import 'package:susadim/features/water_tracker/controller/water_tracker_controller.dart';

/// 'Kalan Su' ve 'Günlük Hedef' istatistik kartlarını yan yana dizen satır bileşeni.
///
/// Ekran alanını dengeli kullanmak için `Row` içinde iki adet `Expanded` kart yer alır.
class WaterMetricsRow extends StatelessWidget {
  const WaterMetricsRow({required this.controller, super.key});

  final WaterTrackerController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Sol Kart: Kalan su miktarı (Örn: 1200 ml)
        Expanded(
          child: _MetricItemCard(
            label: 'Kalan',
            value: '${controller.remainingMl} ml',
            icon: Icons.hourglass_bottom_rounded,
            accentColor: AppColors.neonBlue,
          ),
        ),
        const SizedBox(width: 12),

        // Sağ Kart: Günlük hedef su miktarı (Örn: 2500 ml)
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

/// Tek bir istatistik metriğini (ikon, etiket, değer) şık bir kart içinde gösteren bileşen
class _MetricItemCard extends StatelessWidget {
  const _MetricItemCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.accentColor,
  });

  /// Metrik başlığı (Örn: 'Kalan', 'Hedef')
  final String label;

  /// Sayısal değer ve birim metni (Örn: '1500 ml')
  final String value;

  /// Metriğin solunda yer alan simge
  final IconData icon;

  /// İkon kutusunun arka planı ve ikon renginde kullanılan vurgu rengi
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            // İkonu hafif yarı saydam renkli yuvarlatılmış bir kutu içine alır
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: accentColor, size: 20),
            ),
            const SizedBox(width: 10),

            // Etiket ve Değer metin sütunu
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
