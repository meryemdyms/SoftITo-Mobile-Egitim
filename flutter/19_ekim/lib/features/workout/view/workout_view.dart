import 'package:flutter/material.dart';
import 'package:susadim/core/constants/app_colors.dart';
import 'package:susadim/features/workout/controller/workout_controller.dart';
import 'package:susadim/features/workout/widget/workout_add_modal.dart';
import 'package:susadim/features/workout/widget/workout_calorie_card.dart';
import 'package:susadim/features/workout/widget/workout_item_tile.dart';
import 'package:susadim/features/workout/widget/workout_metrics_row.dart';

/// Egzersiz ve kalori takibi ekranının ana görünüm (View) bileşeni.
///
/// Bu ekran, yakılan kalori göstergesini, aktif süre ve kalan kalori metriklerini,
/// yeni egzersiz ekleme aksiyonunu ve gün içerisindeki antrenman listesini barındırır.
class WorkoutView extends StatelessWidget {
  const WorkoutView({required this.controller, super.key});

  /// Egzersiz durumunu yöneten denetleyici
  final WorkoutController controller;

  /// Yeni egzersiz ekleme alt sayfasını (Bottom Sheet) ekranda açar.
  void _showAddModal(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true, // Klavyenin alt sayfayı yukarı itebilmesi için tam yükseklik kontrolü sağlar
      backgroundColor: Colors.transparent, // Modalın yuvarlatılmış köşelerinin görünmesi için şeffaf zemin
      builder: (ctx) => WorkoutAddModal(
        onAdd: ({
          required title,
          required durationMinutes,
          required caloriesBurned,
          required intensity,
        }) {
          // Modal içerisinden gelen veriler controller'a iletilerek yeni kayıt eklenir
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
    // ListenableBuilder, controller'da notifyListeners() çağrıldığında
    // bu bloğu otomatik olarak yeniden çizer.
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          children: [
            // Dairesel kalori yakım göstergesi kartı
            WorkoutCalorieCard(controller: controller),
            const SizedBox(height: 14),

            // Aktif süre ve Kalan kalori metrik kartları satırı
            WorkoutMetricsRow(controller: controller),
            const SizedBox(height: 20),

            // Yeni egzersiz ekleme modalını açan ana buton
            _AddWorkoutButton(onTap: () => _showAddModal(context)),
            const SizedBox(height: 20),

            // "Bugünkü Antrenmanlar" başlığı ve "Sıfırla" aksiyonu
            _WorkoutSectionHeader(onReset: controller.reset),
            const SizedBox(height: 8),

            // Eklenen antrenman kayıtlarının listesi
            _WorkoutList(controller: controller),
          ],
        );
      },
    );
  }
}

/// Yeni egzersiz ekleme aksiyonunu başlatan belirgin neon yeşil buton
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

/// Nesne üzerinde zincirleme (chaining) işlem yapmayı sağlayan Kotlin benzeri yardımcı extension fonksiyonu
extension _LetExt<T> on T {
  R let<R>(R Function(T) op) => op(this);
}

/// Egzersiz kayıtları bölüm başlığı ve sıfırlama butonu
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

/// Antrenman kayıtlarını listeleyen veya boş durum metnini gösteren bileşen
class _WorkoutList extends StatelessWidget {
  const _WorkoutList({required this.controller});

  final WorkoutController controller;

  @override
  Widget build(BuildContext context) {
    // Kayıt listesi boşsa kullanıcıya gösterilecek bilgilendirme metni
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

    // Eklenen antrenman kayıtları tek tek WorkoutItemTile olarak render edilir
    return Column(
      children: controller.workouts.map((entry) {
        return WorkoutItemTile(
          // Liste elemanlarının stabilitesi ve performans için benzersiz anahtar (Key)
          key: ValueKey(entry.id),
          entry: entry,
          onDelete: () => controller.removeWorkout(entry.id),
        );
      }).toList(growable: false),
    );
  }
}
