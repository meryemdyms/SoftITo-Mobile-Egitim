import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_dimensions.dart';
import '../../../app/theme/app_typography.dart';
import '../../../shared/models/room_template_model.dart';
import '../../../shared/widgets/archive_button.dart';

/// Cep Müzem — Müze Oluşturma ve Küratör Atölyesi Ekranı (MuseumCreationView)
///
/// project.md Madde 10 ve museum-creation skill'i gereksinimleri:
/// - Kullanıcının anılarını, gezilerini veya koleksiyonlarını 2D dijital müze odalarına dönüştürür.
/// - V1'deki 3 kesin oda şablonunu (Klasik Galeri 4 eser, Taş Koridor 6 eser, Arşiv Salonu 8 eser) sunar.
/// - Agent veya sistem bu 3 şablon dışında yeni oda şablonu türetmez.
/// - Seçilen oda şablonu ile taslak akışının başlatılmasını sağlar.
class MuseumCreationView extends StatefulWidget {
  const MuseumCreationView({super.key});

  @override
  State<MuseumCreationView> createState() => _MuseumCreationViewState();
}

class _MuseumCreationViewState extends State<MuseumCreationView> {
  /// Seçili oda şablonunun kimliği (varsayılan: Klasik Galeri)
  String _selectedTemplateId = RoomTemplateModel.classicGalleryId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Müzeni Oluştur', style: AppTypography.pageTitle),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.horizontalPadding,
            vertical: AppDimensions.space16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Küratör Atölyesi Başlık ve Açıklaması
              Text('Küratör Atölyesi', style: AppTypography.sectionTitle),
              const SizedBox(height: 4),
              Text(
                'Anılarınızı, gezilerinizi veya koleksiyonunuzu 2D dijital müze odalarına yerleştirin.',
                style: AppTypography.bodySecondary,
              ),
              const SizedBox(height: AppDimensions.space20),

              // 2. V1 Kesin Oda Şablonları Başlığı
              Text('V1 Oda Şablonları', style: AppTypography.cardTitle),
              const SizedBox(height: AppDimensions.space12),

              // 3 Kesin Oda Şablonu Kartları (Klasik Galeri, Taş Koridor, Arşiv Salonu)
              for (final template in RoomTemplateModel.allTemplates) ...[
                _buildTemplateCard(template),
                const SizedBox(height: AppDimensions.space12),
              ],

              const SizedBox(height: AppDimensions.space20),

              // 3. Bilgilendirme ve Akış Kartı
              Container(
                padding: const EdgeInsets.all(AppDimensions.space16),
                decoration: BoxDecoration(
                  color: AppColors.parchment,
                  borderRadius: AppDimensions.cardBorderRadius,
                  border: Border.all(color: AppColors.museumStone),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: AppColors.antiqueBronze,
                      size: 20,
                    ),
                    const SizedBox(width: AppDimensions.space12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Aşama 3 Müze Oluşturma Akışı',
                            style: AppTypography.caption.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.deepWalnut,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Seçilen şablon ile eser fotoğrafları, ses kayıtları ve yerleşim slotları yapılandırılarak sergi yayınlanacaktır.',
                            style: AppTypography.caption,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppDimensions.space24),

              // 4. Taslak Oluşturma Aksiyon Butonu
              ArchiveButton(
                label: 'Taslak Oluşturmaya Başla',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Aşama 1 tamamlandı. Aşama 3\'te tam yayınlama sihirbazı aktifleşecektir.',
                      ),
                      backgroundColor: AppColors.deepWalnut,
                    ),
                  );
                },
              ),
              const SizedBox(height: AppDimensions.space32),
            ],
          ),
        ),
      ),
    );
  }

  /// Oda şablonu seçim kartı bileşeni
  Widget _buildTemplateCard(RoomTemplateModel template) {
    final isSelected = _selectedTemplateId == template.id;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedTemplateId = template.id;
        });
      },
      borderRadius: AppDimensions.cardBorderRadius,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(AppDimensions.space16),
        decoration: BoxDecoration(
          color: AppColors.museumWhite,
          borderRadius: AppDimensions.cardBorderRadius,
          border: Border.all(
            color: isSelected ? AppColors.antiqueBronze : AppColors.museumStone,
            width: isSelected ? 2.0 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? AppColors.antiqueBronze.withValues(alpha: 0.15)
                  : AppColors.deepWalnut.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // Şablon Simge Kutusu
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.antiqueBronze
                    : AppColors.parchment,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.museum,
                color: isSelected
                    ? AppColors.museumWhite
                    : AppColors.deepWalnut,
                size: 26,
              ),
            ),
            const SizedBox(width: AppDimensions.space16),

            // Şablon Adı ve Yuva Sayısı
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(template.name, style: AppTypography.cardTitle),
                  const SizedBox(height: 2),
                  Text(
                    '${template.slotDefinitions.length} Eser Yuvası • 2D Etkileşimli',
                    style: AppTypography.caption,
                  ),
                ],
              ),
            ),

            // Seçim Radyo Göstergesi
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.antiqueBronze : AppColors.museumStone,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          color: AppColors.antiqueBronze,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

