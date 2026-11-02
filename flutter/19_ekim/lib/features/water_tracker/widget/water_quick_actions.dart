import 'package:flutter/material.dart';
import 'package:susadim/core/constants/app_colors.dart';
import 'package:susadim/features/water_tracker/controller/water_tracker_controller.dart';
import 'package:susadim/features/water_tracker/models/water_log.dart';
import 'package:susadim/features/water_tracker/widget/water_goal_dialog.dart';

/// Kullanıcının sık kullanılan porsiyonlarda (200, 330, 500, 750 ml)
/// tek dokunuşla su eklemesini sağlayan hızlı aksiyon bileşeni.
class WaterQuickActions extends StatelessWidget {
  const WaterQuickActions({required this.controller, super.key});

  final WaterTrackerController controller;

  /// Hızlı ekleme seçenekleri listesi (ml cinsinden standart bardak/şişe hacimleri)
  static const List<int> _amounts = <int>[200, 330, 500, 750];

  /// Belirtilen miktarda su ekleme işlemini gerçekleştirir.
  /// Eğer bu ekleme ile günlük hedefe ulaşılmışsa tebrik diyalogunu açar.
  void _onAddWater(BuildContext context, int ml) {
    final reachedGoal = controller.addWater(ml, type: DrinkType.water);

    // context.mounted kontrolü: Widget ağacında hala aktif olup olmadığını denetler.
    // Asenkron işlemlerde veya olası sayfa geçişlerinde Context hatası (leak/crash)
    // yaşanmasını önleyen modern bir Flutter best-practice kuralıdır.
    if (reachedGoal && context.mounted) {
      WaterGoalDialog.show(
        context,
        totalMl: controller.totalConsumedMl,
        goalMl: controller.dailyGoalMl,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Bölüm başlığı
        const _SectionHeader(title: 'Hızlı Su Ekle'),
        const SizedBox(height: 10),

        // Butonların yan yana eşit genişlikte dizildiği satır
        Row(
          children: _amounts
              .map(
                (ml) => Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: _QuickAddButton(
                      amountMl: ml,
                      onTap: () => _onAddWater(context, ml),
                    ),
                  ),
                ),
              )
              .toList(growable: false),
        ),
      ],
    );
  }
}

/// Bölüm başlığı metnini standartlaştıran yardımcı bileşen
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
    );
  }
}

/// Her bir hızlı su ekleme butonunun (kartının) tasarımı ve dokunma efekti
class _QuickAddButton extends StatelessWidget {
  const _QuickAddButton({required this.amountMl, required this.onTap});

  final int amountMl;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16), // Dokunma (ripple) efektinin sınırları
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.obsidianCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.neonCyan.withValues(alpha: 0.35)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Artı ikonu
            const Icon(Icons.add, color: AppColors.neonCyan, size: 18),
            const SizedBox(height: 4),

            // Mililitre sayısal değeri
            Text(
              '$amountMl',
              style: const TextStyle(
                color: AppColors.neonCyan,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),

            // 'ml' birim etiketi
            const Text(
              'ml',
              style: TextStyle(color: AppColors.textMuted, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}
