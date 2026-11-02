import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../companies/domain/entities/company.dart';
import '../../../vehicles/domain/entities/vehicle.dart';

/// Arama sonuçlarında ve firma vitrininde kullanılan zengin araç kartı bileşeni.
///
/// Araç görseli, model yılı, günlük kiralama ücreti rozeti, firma ismi ve teknik rozetleri gösterir.
class VehicleCard extends StatelessWidget {
  /// Kart üzerinde gösterilecek araç varlığı.
  final Vehicle vehicle;

  /// Araca sahip olan kiralama firması (opsiyonel).
  final Company? company;

  /// Karta tıklandığında araç detayına gitmeyi sağlayan fonksiyon.
  final VoidCallback onTap;

  /// Firma adına tıklandığında firma vitrinine gitmeyi sağlayan opsiyonel fonksiyon.
  final VoidCallback? onCompanyTap;

  const VehicleCard({
    super.key,
    required this.vehicle,
    this.company,
    required this.onTap,
    this.onCompanyTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.radiusLg,
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: AppRadius.radiusLg,
        child: InkWell(
          borderRadius: AppRadius.radiusLg,
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Araç Görseli ve Üzerindeki Rozetler (Model Yılı & Günlük Fiyat)
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(AppRadius.lg),
                    ),
                    child: vehicle.images.isNotEmpty
                        ? Image.network(
                            vehicle.images.first,
                            height: 160,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => _buildFallbackImage(),
                          )
                        : _buildFallbackImage(),
                  ),
                  // Sol üst: Model yılı rozeti
                  Positioned(
                    top: AppSpacing.md,
                    left: AppSpacing.md,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.ink.withOpacity(0.85),
                        borderRadius: AppRadius.radiusFull,
                      ),
                      child: Text(
                        '${vehicle.year}',
                        style: AppTypography.labelSmall.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  // Sağ üst: Günlük fiyat rozeti
                  Positioned(
                    top: AppSpacing.md,
                    right: AppSpacing.md,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: AppRadius.radiusFull,
                      ),
                      child: Text(
                        '${CurrencyFormatter.formatKurus(vehicle.dailyRate)} / gün',
                        style: AppTypography.labelSmall.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Araç Başlığı, Firma Bilgisi ve Özellik Rozetleri
              Padding(
                padding: AppSpacing.edgeInsetsMd,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            vehicle.fullName,
                            style: AppTypography.titleMedium,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    // Firma ismi satırı (tıklanabilir)
                    if (company != null)
                      GestureDetector(
                        onTap: onCompanyTap,
                        child: Row(
                          children: [
                            const Icon(
                              Icons.storefront_outlined,
                              size: 14,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: AppSpacing.xs),
                            Expanded(
                              child: Text(
                                company!.name,
                                style: AppTypography.bodySmall.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: AppSpacing.md),
                    // Vites, Yakıt ve Koltuk Kapasitesi Rozetleri
                    Row(
                      children: [
                        _buildSpecBadge(
                          Icons.settings_suggest_rounded,
                          vehicle.transmission.label,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        _buildSpecBadge(
                          Icons.local_gas_station_rounded,
                          vehicle.fuel.label,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        _buildSpecBadge(
                          Icons.people_outline_rounded,
                          '${vehicle.seats} Koltuk',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Teknik özellik rozeti (Icon + Metin).
  Widget _buildSpecBadge(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: AppRadius.radiusSm,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: AppColors.muted),
          const SizedBox(width: 4),
          Text(text, style: AppTypography.bodySmall),
        ],
      ),
    );
  }

  /// Görsel yoksa veya internet/ağ hatası olduğunda gösterilen yedek araç kutusu.
  Widget _buildFallbackImage() {
    return Container(
      height: 160,
      width: double.infinity,
      color: AppColors.surfaceVariant,
      child: const Center(
        child: Icon(
          Icons.directions_car_filled_rounded,
          size: 48,
          color: AppColors.muted,
        ),
      ),
    );
  }
}
