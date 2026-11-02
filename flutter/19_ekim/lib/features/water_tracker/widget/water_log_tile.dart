import 'package:flutter/material.dart';
import 'package:susadim/core/constants/app_colors.dart';
import 'package:susadim/features/water_tracker/models/water_log.dart';

/// Gün içinde eklenen tek bir su tüketim kaydını gösteren satır (tile) bileşeni.
///
/// Bileşen içeriği:
/// - Sıvı simgesi (damla ikonu)
/// - İçecek türü ve saati (örn. "Su", "14:30")
/// - Eklenen miktar (örn. "+250 ml")
/// - Kaydı silme aksiyonu (çarpı ikonu)
class WaterLogTile extends StatelessWidget {
  const WaterLogTile({
    required this.log,
    required this.onDelete,
    super.key,
  });

  /// Görüntülenecek su tüketim kaydı verisi
  final WaterLog log;

  /// Silme butonuna tıklandığında tetiklenecek silme aksiyonu
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Zaman damgasını 'SS:DD' (örn. '09:05') formatına çevirir
    final timeStr = _formatTime(log.timestamp);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.obsidianCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.obsidianBorder),
      ),
      child: Row(
        children: [
          // Sol damla simgesi
          const Icon(Icons.water_drop_outlined, color: AppColors.neonCyan, size: 20),
          const SizedBox(width: 12),

          // İçecek türü ve tüketim saati
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(log.type.displayName, style: theme.textTheme.bodyLarge),
                Text(timeStr, style: theme.textTheme.bodyMedium),
              ],
            ),
          ),

          // Eklenen miktar (örn: +500 ml)
          Text(
            '+${log.amountMl} ml',
            style: const TextStyle(
              color: AppColors.neonCyan,
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

  /// [DateTime] nesnesini iki basamaklı 'SS:DD' formatında dizeye dönüştürür.
  ///
  /// `padLeft(2, '0')` metodu, tek basamaklı saat veya dakikaların önüne '0' ekler
  /// (Örneğin saat 9 ve dakika 5 ise '09:05' üretilir).
  String _formatTime(DateTime dt) {
    final hour = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
