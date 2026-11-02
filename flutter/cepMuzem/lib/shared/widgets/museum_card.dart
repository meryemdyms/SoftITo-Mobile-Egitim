import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_dimensions.dart';
import '../../app/theme/app_typography.dart';
import '../models/museum_model.dart';

/// Cep Müzem — Sergi Kataloğu Müze Kartı Bileşeni (MuseumCard)
///
/// project.md Madde 8 & museum-design-system yönergeleri:
/// - Kapak görseli (16:9 en boy oranı)
/// - Varsa konum etiketi (sol üst rozet)
/// - Yer imi / kaydetme butonu (sağ üst dairesel buton)
/// - Müze adı, kısa açıklama
/// - Küratör avatarı, adı, sakin beğeni ve yorum sayaçları
/// - 16dp kart radius ve 1dp traverten taş kenarlık
class MuseumCard extends StatelessWidget {
  /// Kart üzerinde sergilenen müze verisi
  final MuseumModel museum;

  /// Karta tıklandığında (detaya geçiş için) tetiklenen geri çağrı
  final VoidCallback onTap;

  /// Kartın sağ üstündeki kaydetme simgesine tıklandığında tetiklenen geri çağrı
  final VoidCallback onToggleSave;

  const MuseumCard({
    super.key,
    required this.museum,
    required this.onTap,
    required this.onToggleSave,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.museumWhite,
        borderRadius: AppDimensions.cardBorderRadius,
        border: Border.all(color: AppColors.museumStone, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.deepWalnut.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // 1. Kapak Görseli Alanı (16:9 Aspect Ratio)
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(
                    museum.coverUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: AppColors.parchment,
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.museum_outlined,
                          size: 48,
                          color: AppColors.antiqueBronze,
                        ),
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: AppColors.parchment,
                        alignment: Alignment.center,
                        child: const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.antiqueBronze,
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Konum etiketi (Müzenin konumu tanımlıysa sol üstte gösterilir)
                if (museum.location != null)
                  Positioned(
                    top: AppDimensions.space12,
                    left: AppDimensions.space12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.space8,
                        vertical: AppDimensions.space4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.museumWhite.withValues(alpha: 0.92),
                        borderRadius: BorderRadius.circular(
                          AppDimensions.badgeRadius,
                        ),
                        border: Border.all(
                          color: AppColors.museumStone.withValues(alpha: 0.6),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.place_outlined,
                            size: 13,
                            color: AppColors.antiqueBronze,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            museum.location!,
                            style: AppTypography.caption.copyWith(
                              color: AppColors.deepWalnut,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                // Kaydetme / Yer İmi Butonu (Sağ üst)
                Positioned(
                  top: AppDimensions.space8,
                  right: AppDimensions.space8,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: onToggleSave,
                      borderRadius: BorderRadius.circular(22),
                      child: Container(
                        width: AppDimensions.minTouchTarget,
                        height: AppDimensions.minTouchTarget,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.museumWhite.withValues(alpha: 0.95),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.museumStone.withValues(alpha: 0.7),
                            width: 0.8,
                          ),
                        ),
                        child: Icon(
                          museum.isSavedByCurrentUser
                              ? Icons.bookmark
                              : Icons.bookmark_border,
                          size: 22,
                          color: museum.isSavedByCurrentUser
                              ? AppColors.antiqueBronze
                              : AppColors.deepWalnut,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // 2. Müze Bilgileri ve Künye Bölümü
            Padding(
              padding: const EdgeInsets.all(AppDimensions.space16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sergi Başlığı
                  Text(
                    museum.title,
                    style: AppTypography.cardTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppDimensions.space8),

                  // Kısa Açıklama Metni
                  Text(
                    museum.description,
                    style: AppTypography.bodySecondary,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppDimensions.space12),

                  // Küratör Bilgisi ve Sakin Sosyal Sayaçlar
                  Row(
                    children: [
                      // Küratör Avatarı
                      CircleAvatar(
                        radius: 14,
                        backgroundColor: AppColors.parchment,
                        backgroundImage: museum.ownerPhotoUrl != null
                            ? NetworkImage(museum.ownerPhotoUrl!)
                            : null,
                        child: museum.ownerPhotoUrl == null
                            ? const Icon(
                                Icons.person,
                                size: 14,
                                color: AppColors.deepWalnut,
                              )
                            : null,
                      ),
                      const SizedBox(width: AppDimensions.space8),

                      // Küratör Adı
                      Expanded(
                        child: Text(
                          museum.ownerName ?? 'Küratör',
                          style: AppTypography.caption.copyWith(
                            color: AppColors.deepWalnut,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      // Beğeni Sayacı (Sakin Pinterest seviyesinde sosyal gösterge)
                      Icon(
                        Icons.favorite_border,
                        size: 14,
                        color: AppColors.secondaryText.withValues(alpha: 0.7),
                      ),
                      const SizedBox(width: 4),
                      Text('${museum.likeCount}', style: AppTypography.caption),
                      const SizedBox(width: AppDimensions.space8),

                      // Yorum Sayacı
                      Icon(
                        Icons.chat_bubble_outline,
                        size: 14,
                        color: AppColors.secondaryText.withValues(alpha: 0.7),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${museum.commentCount}',
                        style: AppTypography.caption,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

