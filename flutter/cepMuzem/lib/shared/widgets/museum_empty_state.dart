import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_dimensions.dart';
import '../../app/theme/app_typography.dart';
import 'archive_button.dart';

/// ============================================================================
/// MUSEUM EMPTY STATE & SECTION HEADER
/// ============================================================================
///
/// "Yaşayan Müze" tasarım sistemine uygun olarak oluşturulmuş paylaşımlı
/// durum bilgilendirme ve bölüm başlığı bileşenlerini içerir.
///
/// 1. [MuseumEmptyState]:
///    - Henüz içerik bulunmayan (boş akış, boş arşiv, yorumsuz eser vb.) veya
///      arama/filtreleme sonucu eşleşme bulunamayan durumlarda gösterilir.
///    - Müze estetiğini koruyan dairesel parşömen arkaplanlı ikon, tipografik
///      başlık ve opsiyonel ikincil aksiyon butonu sunar.
///
/// 2. [MuseumSectionHeader]:
///    - Sayfa içi bölümleri (Örn: "Takip Edilen Müzeler", "Popüler Koleksiyonlar")
///      birbirinden ayıran, opsiyonel alt başlık ve sağ aksiyon butonunu
///      destekleyen standart başlık şablonudur.
/// ============================================================================

/// Veri bulunamadığında veya liste boş olduğunda zarif bir bilgilendirme
/// ve opsiyonel yeniden deneme / keşif butonu sunan boş durum bileşeni.
class MuseumEmptyState extends StatelessWidget {
  /// Boş durumun ana başlığı (Örn: "Henüz Müze Bulunmuyor", "Kayıtlı Eser Yok").
  final String title;

  /// Kullanıcıyı bilgilendiren ve yönlendiren açıklama metni.
  final String message;

  /// Durumu temsil eden sembolik ikon (varsayılan: [Icons.museum_outlined]).
  final IconData icon;

  /// Aksiyon butonu metni (Örn: "Müzeleri Keşfet", "Tekrar Dene").
  /// Null verilirse buton gösterilmez.
  final String? actionLabel;

  /// Aksiyon butonuna tıklandığında tetiklenecek geri çağırma fonksiyonu.
  final VoidCallback? onAction;

  /// [MuseumEmptyState] kurucu metodu.
  const MuseumEmptyState({
    super.key,
    required this.title,
    required this.message,
    this.icon = Icons.museum_outlined,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.space24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Dairesel parşömen arka planlı sembolik müze ikonu
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                color: AppColors.parchment,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 32, color: AppColors.antiqueBronze),
            ),
            const SizedBox(height: AppDimensions.space16),

            // Boş durum başlığı (Cormorant Garamond serif tipografi)
            Text(
              title,
              style: AppTypography.sectionTitle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.space8),

            // Açıklama / yönlendirme gövde metni (Inter sans-serif)
            Text(
              message,
              style: AppTypography.bodySecondary,
              textAlign: TextAlign.center,
            ),

            // Opsiyonel ikincil aksiyon butonu (Arşiv stili buton)
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: AppDimensions.space20),
              ArchiveButton(
                label: actionLabel!,
                onPressed: onAction,
                variant: ArchiveButtonVariant.secondary,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Sayfa veya liste içi bölümler için standart başlık, alt bilgi ve
/// opsiyonel sağ eklenti (trailing widget) barındıran başlık bileşeni.
class MuseumSectionHeader extends StatelessWidget {
  /// Bölümün ana başlığı (Örn: "Öne Çıkan Küratörler").
  final String title;

  /// Başlığın altında yer alan opsiyonel açıklayıcı alt metin.
  final String? subtitle;

  /// Başlığın sağ tarafında yer alabilecek opsiyonel bileşen (Örn: "Tümünü Gör" butonu veya sayaç).
  final Widget? trailing;

  /// [MuseumSectionHeader] kurucu metodu.
  const MuseumSectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.space12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Sol taraftaki başlık ve alt başlık sütunu
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.sectionTitle),
                if (subtitle != null) ...[
                  const SizedBox(height: AppDimensions.space4),
                  Text(subtitle!, style: AppTypography.caption),
                ],
              ],
            ),
          ),

          // Sağ tarafa yerleştirilen opsiyonel buton / sayaç / widget
          ?trailing,
        ],
      ),
    );
  }
}

