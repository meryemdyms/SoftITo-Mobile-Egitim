import 'package:flutter/material.dart';
import 'package:susadim/core/constants/app_colors.dart';
import 'package:susadim/features/workout/controller/workout_controller.dart';

/// Günlük kalori yakım hedefini ve tamamlanan ilerlemeyi gösteren dairesel gösterge kartı.
///
/// Kart içerisinde:
/// 1. Dairesel ilerleme çubuğu (CircularProgressIndicator),
/// 2. Ortada alev simgesi ve yakılan kalori yüzdesi,
/// 3. Alt kısımda toplam yakılan kalori / hedef kalori metin özeti yer alır.
class WorkoutCalorieCard extends StatelessWidget {
  const WorkoutCalorieCard({required this.controller, super.key});

  /// Egzersiz verilerini sağlayan denetleyici
  final WorkoutController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // İlerleme oranını (0.0 - 1.0) tam sayı yüzdesine çevirir (örn: %64)
    final percent = (controller.calorieProgressRatio * 100).toInt();

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Dairesel kalori halkası ve merkez göstergesi
            _CalorieGauge(controller: controller, percent: percent),
            const SizedBox(height: 16),

            // Yakılan kalori / Günlük hedef kalori metin satırı
            _CalorieGoalSummary(controller: controller, theme: theme),
          ],
        ),
      ),
    );
  }
}

/// Dairesel göstergeyi ve merkezindeki bilgileri Stack ile üst üste yerleştiren bileşen
class _CalorieGauge extends StatelessWidget {
  const _CalorieGauge({required this.controller, required this.percent});

  final WorkoutController controller;
  final int percent;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 170,
      height: 170,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Dairesel ilerleme çubuğu
          SizedBox(
            width: 170,
            height: 170,
            child: CircularProgressIndicator(
              value: controller.calorieProgressRatio, // Doluluk katsayısı (0.0 - 1.0)
              strokeWidth: 12, // Çizgi kalınlığı
              backgroundColor: AppColors.obsidianBorder, // Boş kısım rengi
              color: AppColors.neonLime, // Neon yeşil vurgu rengi
              strokeCap: StrokeCap.round, // Yuvarlatılmış çizgi uçları
            ),
          ),
          // Halkanın tam merkezindeki alev simgesi ve yüzde değeri
          _GaugeCenterInfo(percent: percent),
        ],
      ),
    );
  }
}

/// Gösterge halkasının merkezindeki alev simgesi, yüzde metni ve etiketi çizen bileşen
class _GaugeCenterInfo extends StatelessWidget {
  const _GaugeCenterInfo({required this.percent});

  final int percent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Kalori ve eforu temsil eden alev simgesi
        const Icon(Icons.local_fire_department, color: AppColors.neonLime, size: 30),
        const SizedBox(height: 4),

        // Yakılan kalori yüzdesi (örn: %80)
        Text(
          '%$percent',
          style: theme.textTheme.headlineMedium?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w800,
          ),
        ),

        // 'yakıldı' alt etiketi
        Text('yakıldı', style: theme.textTheme.bodyMedium),
      ],
    );
  }
}

/// 'Yakılan / Hedef kcal' formatında gösterim sağlayan özet metin bileşeni
class _CalorieGoalSummary extends StatelessWidget {
  const _CalorieGoalSummary({required this.controller, required this.theme});

  final WorkoutController controller;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Toplam yakılan kalori (neon lime renginde vurgulu)
        Text(
          '${controller.totalCaloriesBurned}',
          style: theme.textTheme.titleLarge?.copyWith(
            color: AppColors.neonLime,
            fontWeight: FontWeight.bold,
          ),
        ),
        // Günlük hedef kalori
        Text(
          ' / ${controller.dailyCalorieGoal} kcal',
          style: theme.textTheme.titleMedium,
        ),
      ],
    );
  }
}
