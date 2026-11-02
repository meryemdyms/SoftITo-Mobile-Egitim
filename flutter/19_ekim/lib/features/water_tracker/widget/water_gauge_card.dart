import 'package:flutter/material.dart';
import 'package:susadim/core/constants/app_colors.dart';
import 'package:susadim/features/water_tracker/controller/water_tracker_controller.dart';

/// Günlük su tüketim ilerlemesini dairesel gösterge (gauge) ile görselleştiren kart bileşeni.
///
/// Kart içerisinde:
/// 1. Dairesel ilerleme çubuğu (CircularProgressIndicator),
/// 2. Ortada yüzde oranı ve su damlası simgesi,
/// 3. Alt kısımda toplam tüketilen miktar / hedef miktar özeti yer alır.
class WaterGaugeCard extends StatelessWidget {
  const WaterGaugeCard({required this.controller, super.key});

  /// Su tüketim verilerini sağlayan denetleyici
  final WaterTrackerController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // İlerleme katsayısını (0.0 - 1.0) tam sayı yüzdesine dönüştürür (örn: %65)
    final percent = (controller.progressRatio * 100).toInt();

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Dairesel gösterge ve iç metinler
            _GaugeProgress(controller: controller, percent: percent),
            const SizedBox(height: 16),

            // Toplam tüketilen ml / Hedef ml metin özeti
            _GoalSummaryText(controller: controller, theme: theme),
          ],
        ),
      ),
    );
  }
}

/// Dairesel çubuğu ve merkez içeriğini Stack ile üst üste bindiren bileşen
class _GaugeProgress extends StatelessWidget {
  const _GaugeProgress({required this.controller, required this.percent});

  final WaterTrackerController controller;
  final int percent;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 170,
      height: 170,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Dairesel ilerleme çubuğu (CircularProgressIndicator)
          SizedBox(
            width: 170,
            height: 170,
            child: CircularProgressIndicator(
              value: controller.progressRatio, // 0.0 ile 1.0 arasındaki doluluk oranı
              strokeWidth: 12, // Çizgi kalınlığı
              backgroundColor: AppColors.obsidianBorder, // Boş kısmın koyu rengi
              color: AppColors.neonCyan, // Doldurulan kısmın neon cyan rengi
              strokeCap: StrokeCap.round, // Çizgi uçlarının yuvarlatılmış olması
            ),
          ),
          // Halkanın tam ortasında gösterilen ikon ve yüzde metni
          _GaugeCenterContent(percent: percent),
        ],
      ),
    );
  }
}

/// Gösterge halkasının tam merkezindeki damla ikonu ve yüzde metnini çizen bileşen
class _GaugeCenterContent extends StatelessWidget {
  const _GaugeCenterContent({required this.percent});

  final int percent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Su damlası simgesi
        const Icon(Icons.water_drop, color: AppColors.neonCyan, size: 30),
        const SizedBox(height: 4),

        // Yüzde metni (örn: %75)
        Text(
          '%$percent',
          style: theme.textTheme.headlineMedium?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w800,
          ),
        ),

        // 'tamamlandı' alt etiketi
        Text('tamamlandı', style: theme.textTheme.bodyMedium),
      ],
    );
  }
}

/// 'Tüketilen / Hedef ml' formatında gösterim sağlayan alt metin bileşeni
class _GoalSummaryText extends StatelessWidget {
  const _GoalSummaryText({required this.controller, required this.theme});

  final WaterTrackerController controller;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Tüketilen miktar (vurgulu neon renk)
        Text(
          '${controller.totalConsumedMl}',
          style: theme.textTheme.titleLarge?.copyWith(
            color: AppColors.neonCyan,
            fontWeight: FontWeight.bold,
          ),
        ),
        // Hedef miktar
        Text(' / ${controller.dailyGoalMl} ml', style: theme.textTheme.titleMedium),
      ],
    );
  }
}
