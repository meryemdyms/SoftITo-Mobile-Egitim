import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_dimensions.dart';
import '../../../app/theme/app_typography.dart';
import '../../../shared/models/room_template_model.dart';
import '../../../shared/widgets/archive_button.dart';

class MuseumCreationView extends StatefulWidget {
  const MuseumCreationView({super.key});

  @override
  State<MuseumCreationView> createState() => _MuseumCreationViewState();
}

class _MuseumCreationViewState extends State<MuseumCreationView> {
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
              Text('Küratör Atölyesi', style: AppTypography.sectionTitle),
              const SizedBox(height: 4),
              Text(
                'Anılarınızı, gezilerinizi veya koleksiyonunuzu 2D dijital müze odalarına yerleştirin.',
                style: AppTypography.bodySecondary,
              ),
              const SizedBox(height: AppDimensions.space20),

              Text('V1 Oda Şablonları', style: AppTypography.cardTitle),
              const SizedBox(height: AppDimensions.space12),

              // 3 Kesin Oda Şablonu Kartları
              for (final template in RoomTemplateModel.allTemplates) ...[
                _buildTemplateCard(template),
                const SizedBox(height: AppDimensions.space12),
              ],

              const SizedBox(height: AppDimensions.space20),

              // Bilgi Kutusu
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
