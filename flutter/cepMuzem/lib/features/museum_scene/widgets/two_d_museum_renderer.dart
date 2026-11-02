import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_dimensions.dart';
import '../../../app/theme/app_typography.dart';
import '../../../shared/models/museum_item_model.dart';
import '../../../shared/models/museum_scene_model.dart';
import '../../../shared/models/room_template_model.dart';

/// Cep Müzem — 2D Etkileşimli Müze Sahnesi Renderer (TwoDMuseumRenderer)
///
/// museum-scene-2d ve project.md kuralları gereği:
/// - V1'de çalışan 2D simülasyon kullanılır (3D özelliği V1'de gösterilmez).
/// - 3 kesin oda şablonunu (Klasik Galeri 4 yuva, Taş Koridor 6 yuva, Arşiv Salonu 8 yuva) destekler.
/// - Slot pozisyonları 0.0 - 1.0 arasında normalize edilmiştir ve sahne boyutuna orantılı olarak piksele dönüştürülür.
/// - Sıcak taş duvar, ceviz ahşap zemin, spot ışığı ve bronz sergi plaketleri ile tarihi müze atmosferi yaratır.
/// - Eser çerçevelerine dokunulduğunda [onItemTap] geri çağrısını tetikler.
class TwoDMuseumRenderer extends StatelessWidget {
  /// Çizilecek olan müze odası ve eser verileri
  final MuseumRoomModel room;

  /// Varsa o an seçili olan eser (çerçevesi bronz vurguyla aydınlatılır)
  final MuseumItemModel? selectedItem;

  /// Bir esere dokunulduğunda tetiklenen olay
  final ValueChanged<MuseumItemModel> onItemTap;

  const TwoDMuseumRenderer({
    super.key,
    required this.room,
    this.selectedItem,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    // Oda şablon tanımı ID'ye göre getirilir (varsayılan: classicGallery)
    final template = RoomTemplateModel.getById(room.templateId);

    return LayoutBuilder(
      builder: (context, constraints) {
        final sceneWidth = constraints.maxWidth;
        // 16:10 orantılı ferah müze salonu en boy oranı (minimum 320, maksimum 500dp)
        final sceneHeight = constraints.maxHeight.isFinite
            ? constraints.maxHeight
            : (sceneWidth * 0.75).clamp(320.0, 500.0);

        return Container(
          width: sceneWidth,
          height: sceneHeight,
          decoration: BoxDecoration(
            color: const Color(0xFFEAE3D4), // Sıcak taş duvar dokusu rengi
            borderRadius: AppDimensions.cardBorderRadius,
            border: Border.all(color: AppColors.museumStone, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: AppColors.deepWalnut.withValues(alpha: 0.08),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              // 1. Zemin ve Duvar Ayrımı (Müze Perspektif / Mimari Hissi)
              // Alt %32'lik alan ahşap ceviz zemin olarak modellenir
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: sceneHeight * 0.32,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFF3E3630), // Ahşap koyu ceviz zemin
                    border: Border(
                      top: BorderSide(color: AppColors.antiqueBronze, width: 4),
                    ),
                  ),
                ),
              ),

              // 2. Salon Üst Korniş ve Spot Işık Hüzmesi
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                height: 48,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.museumWhite.withValues(alpha: 0.65),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              // 3. Salon Adı ve Şablon Bilgi Etiketi (Sol Üst)
              Positioned(
                left: AppDimensions.space16,
                top: AppDimensions.space12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.museumWhite.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(
                      AppDimensions.badgeRadius,
                    ),
                    border: Border.all(
                      color: AppColors.museumStone.withValues(alpha: 0.7),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.room_outlined,
                        size: 14,
                        color: AppColors.antiqueBronze,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${template.name} • ${room.name}',
                        style: AppTypography.caption.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.deepWalnut,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 4. Şablondaki Yuvalar (Slotlar) ve Eser Çerçeveleri
              for (final slot in template.slotDefinitions) ...[
                _buildSlotAndItem(
                  context: context,
                  slot: slot,
                  sceneWidth: sceneWidth,
                  sceneHeight: sceneHeight,
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  /// Belirli bir eser yuvasını (slot) ve varsa içine atanmış eseri çizer
  Widget _buildSlotAndItem({
    required BuildContext context,
    required SlotDefinition slot,
    required double sceneWidth,
    required double sceneHeight,
  }) {
    // Bu slota atanmış eseri bul
    MuseumItemModel? item;
    try {
      item = room.items.firstWhere((i) => i.slotId == slot.slotId);
    } catch (_) {
      item = null;
    }

    // Pozisyon: Eserin kendi konumu veya slotun varsayılan konumu (0.0 - 1.0)
    final posX = item != null ? item.positionX : slot.defaultX;
    final posY = item != null ? item.positionY : slot.defaultY;

    // Normalize koordinatları sahne genişlik/yükseklik pikseline dönüştür
    final centerX = posX * sceneWidth;
    final centerY = posY * sceneHeight;

    const frameWidth = 68.0;
    const frameHeight = 94.0;

    // Seçili eser olup olmadığını kontrol et
    final isSelected = item != null && selectedItem?.id == item.id;

    return Positioned(
      left: centerX - (frameWidth / 2),
      top: centerY - (frameHeight / 2),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          // Dolu bir esere tıklandığında alt paneli açmak için tetikle
          if (item != null) {
            onItemTap(item);
          }
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // A. Eser Çerçevesi (Klasik Müze Çerçevesi Efekti)
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: frameWidth,
              height: frameHeight,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.museumWhite,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: isSelected
                      ? AppColors.antiqueBronze
                      : (item != null
                            ? AppColors.deepWalnut
                            : AppColors.museumStone),
                  width: isSelected ? 2.5 : 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isSelected
                        ? AppColors.antiqueBronze.withValues(alpha: 0.4)
                        : AppColors.deepWalnut.withValues(alpha: 0.2),
                    blurRadius: isSelected ? 10 : 4,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: item != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          // Eser Önizleme Resmi
                          if (item.imageUrls.isNotEmpty)
                            Image.network(
                              item.imageUrls.first,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                    color: AppColors.parchment,
                                    child: const Icon(
                                      Icons.image_outlined,
                                      size: 24,
                                      color: AppColors.antiqueBronze,
                                    ),
                                  ),
                            )
                          else
                            Container(
                              color: AppColors.parchment,
                              child: const Icon(
                                Icons.image_outlined,
                                size: 24,
                                color: AppColors.antiqueBronze,
                              ),
                            ),
                          // Varsa sesli not simgesi rozeti
                          if (item.audioUrl != null)
                            Positioned(
                              top: 2,
                              right: 2,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: AppColors.deepWalnut.withValues(
                                    alpha: 0.8,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.volume_up,
                                  size: 10,
                                  color: AppColors.museumWhite,
                                ),
                              ),
                            ),
                        ],
                      ),
                    )
                  // Henüz eser atanmamış boş yuva görünümü
                  : Container(
                      color: AppColors.parchment.withValues(alpha: 0.4),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.add,
                        size: 20,
                        color: AppColors.museumStone.withValues(alpha: 0.6),
                      ),
                    ),
            ),
            const SizedBox(height: 6),

            // B. Sergi Etiketi / Eser Plaketi (Bronz / Taş Müze Etiketi)
            Container(
              constraints: const BoxConstraints(maxWidth: 82),
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.antiqueBronze
                    : AppColors.museumWhite,
                borderRadius: BorderRadius.circular(2),
                border: Border.all(
                  color: isSelected
                      ? AppColors.antiqueBronze
                      : AppColors.museumStone,
                  width: 0.8,
                ),
              ),
              child: Text(
                item != null ? item.title : slot.label,
                style: AppTypography.caption.copyWith(
                  fontSize: 9.5,
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? AppColors.museumWhite
                      : AppColors.deepWalnut,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

