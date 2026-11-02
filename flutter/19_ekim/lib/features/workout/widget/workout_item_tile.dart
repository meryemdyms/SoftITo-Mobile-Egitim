import 'package:flutter/material.dart';
import 'package:susadim/core/constants/app_colors.dart';
import 'package:susadim/features/workout/models/workout_entry.dart';

/// Gün içinde kaydedilen tek bir antrenman hareketini listeleyen satır (tile) bileşeni.
///
/// Kart içeriğinde:
/// - Spor simgesi (dambıl ikonu)
/// - Antrenman başlığı (örn: "Sabah Koşusu")
/// - Süre ve zorluk seviyesi (örn: "30 dk • Orta")
/// - Yakılan kalori miktarı (örn: "-250 kcal")
/// - Silme ikonu yer alır.
class WorkoutItemTile extends StatelessWidget {
  const WorkoutItemTile({
    required this.entry,
    required this.onDelete,
    super.key,
  });

  /// Görüntülenecek egzersiz kaydı nesnesi
  final WorkoutEntry entry;

  /// Sil butonuna tıklandığında çalışacak geri çağırım fonksiyonu
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.obsidianCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.obsidianBorder),
      ),
      child: Row(
        children: [
          // Egzersiz simgesi (neon lime renkli dambıl)
          const Icon(Icons.fitness_center_rounded, color: AppColors.neonLime, size: 22),
          const SizedBox(width: 12),

          // Egzersiz başlığı, süre ve yoğunluk bilgisi
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(entry.title, style: theme.textTheme.bodyLarge),
                const SizedBox(height: 2),
                Text(
                  '${entry.durationMinutes} dk • ${entry.intensity.displayName}',
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),

          // Yakılan kalori miktarı (örn: -320 kcal)
          Text(
            '-${entry.caloriesBurned} kcal',
            style: const TextStyle(
              color: AppColors.neonLime,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),

          // Kaydı silme butonu
          IconButton(
            icon: const Icon(Icons.close_rounded, size: 18, color: AppColors.textMuted),
            onPressed: onDelete,
            tooltip: 'Sil',
          ),
        ],
      ),
    );
  }
}
