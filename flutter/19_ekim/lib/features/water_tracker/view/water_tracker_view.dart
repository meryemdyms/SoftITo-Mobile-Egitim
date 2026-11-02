import 'package:flutter/material.dart';
import 'package:susadim/core/constants/app_colors.dart';
import 'package:susadim/features/water_tracker/controller/water_tracker_controller.dart';
import 'package:susadim/features/water_tracker/widget/water_gauge_card.dart';
import 'package:susadim/features/water_tracker/widget/water_log_tile.dart';
import 'package:susadim/features/water_tracker/widget/water_metrics_row.dart';
import 'package:susadim/features/water_tracker/widget/water_quick_actions.dart';

/// Su takip modülünün ana görünüm (View) bileşeni.
///
/// Bu ekran, su göstergesini, günlük metrikleri, hızlı su ekleme butonlarını
/// ve gün içerisindeki su tüketim geçmişini tek bir kaydırılabilir sayfada birleştirir.
class WaterTrackerView extends StatelessWidget {
  const WaterTrackerView({required this.controller, super.key});

  /// Su takip iş mantığını yöneten denetleyici nesnesi
  final WaterTrackerController controller;

  @override
  Widget build(BuildContext context) {
    // ListenableBuilder, controller içerisindeki notifyListeners() çağrısını dinler
    // ve controller durumu her değiştiğinde bu builder bloğunu otomatik yeniden çizer.
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          children: [
            // Dairesel ilerleme göstergesi ve toplam miktar kartı
            WaterGaugeCard(controller: controller),
            const SizedBox(height: 14),

            // Kalan miktar ve Günlük Hedef kartlarını içeren çiftli metrik satırı
            WaterMetricsRow(controller: controller),
            const SizedBox(height: 20),

            // 200ml, 330ml, 500ml, 750ml gibi hazır hızlı su ekleme butonları
            WaterQuickActions(controller: controller),
            const SizedBox(height: 20),

            // "Bugünkü Kayıtlar" başlığı ve "Sıfırla" butonu
            _RecentLogsHeader(onReset: controller.reset),
            const SizedBox(height: 8),

            // Eklenen su kayıtlarının listelendiği alt bileşen
            _LogsList(controller: controller),
          ],
        );
      },
    );
  }
}

/// Kayıtlar bölümünün başlık çubuğunu ve sıfırlama aksiyonunu içeren özel bileşen
class _RecentLogsHeader extends StatelessWidget {
  const _RecentLogsHeader({required this.onReset});

  /// Sıfırla butonuna tıklandığında çalışacak geri çağırım (callback) fonksiyonu
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            'Bugünkü Kayıtlar',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        // Tüm geçmişi temizlemek için sıfırlama butonu
        TextButton(
          onPressed: onReset,
          child: const Text('Sıfırla', style: TextStyle(color: AppColors.textMuted)),
        ),
      ],
    );
  }
}

/// Tüketim loglarını listeleyen veya boş durum (empty state) mesajını gösteren bileşen
class _LogsList extends StatelessWidget {
  const _LogsList({required this.controller});

  final WaterTrackerController controller;

  @override
  Widget build(BuildContext context) {
    // Eğer henüz hiç kayıt eklenmemişse kullanıcıyı bilgilendiren boş durum metni
    if (controller.logs.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: Text(
            'Henüz su kaydı eklenmedi.',
            style: TextStyle(color: AppColors.textMuted),
          ),
        ),
      );
    }

    // Kayıtlar varsa her bir kayıt için bir WaterLogTile kartı oluşturulur
    return Column(
      children: controller.logs.map((log) {
        return WaterLogTile(
          // Flutter'ın liste elemanlarını doğru takip edebilmesi ve animasyon/silme
          // işlemlerinde karışıklık olmaması için her elemana benzersiz ValueKey atanır.
          key: ValueKey(log.id),
          log: log,
          onDelete: () => controller.removeLog(log.id),
        );
      }).toList(growable: false),
    );
  }
}
