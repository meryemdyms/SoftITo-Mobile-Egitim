import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/utils/validation_utils.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../campaigns/domain/entities/campaign.dart';
import '../controllers/company_dashboard_controller.dart';

/// Firmaya ait indirim ve promosyon kampanyalarının listelendiği,
/// yeni kampanya oluşturulup yayınlandığı yönetim ekranı.
class CompanyCampaignsView extends StatelessWidget {
  const CompanyCampaignsView({super.key});

  @override
  Widget build(BuildContext context) {
    final dashboardCtrl = context.watch<CompanyDashboardController>();
    final campaigns = dashboardCtrl.campaigns;

    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBar(title: const Text('Kampanya Yönetimi')),
      // Yeni kampanya oluşturma butonu
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Yeni Kampanya'),
        onPressed: () => _openAddCampaignDialog(context, dashboardCtrl),
      ),
      body: campaigns.isEmpty
          ? AppEmptyState(
              icon: Icons.local_offer_outlined,
              title: 'Henüz Kampanya Yok',
              description: 'Müşterilerinize özel indirimler sunmak için yeni kampanya oluşturun.',
              actionLabel: 'Kampanya Oluştur',
              onAction: () => _openAddCampaignDialog(context, dashboardCtrl),
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.lg,
                80,
              ),
              itemCount: campaigns.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: AppSpacing.md),
              itemBuilder: (context, index) {
                final campaign = campaigns[index];
                return _buildCampaignTile(context, campaign);
              },
            ),
    );
  }

  /// Kampanya bilgilerini özetleyen kart görünümü.
  Widget _buildCampaignTile(BuildContext context, Campaign campaign) {
    return Container(
      padding: AppSpacing.edgeInsetsMd,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.radiusMd,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(campaign.title, style: AppTypography.titleMedium),
              ),
              // İndirim oranı rozeti
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: AppRadius.radiusFull,
                ),
                child: Text(
                  '%${campaign.discountPercent} İndirim',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(campaign.description, style: AppTypography.bodySmall),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Tarih: ${DateFormatter.formatDate(campaign.validFrom)} - ${DateFormatter.formatDate(campaign.validTo)}',
            style: AppTypography.labelSmall.copyWith(color: AppColors.muted),
          ),
        ],
      ),
    );
  }

  /// Yeni kampanya oluşturma modal penceresini (Bottom Sheet) açar.
  void _openAddCampaignDialog(
    BuildContext context,
    CompanyDashboardController controller,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AddCampaignModal(controller: controller),
    );
  }
}

/// Yeni kampanya oluşturma formunu barındıran alt pencere bileşeni.
class _AddCampaignModal extends StatefulWidget {
  final CompanyDashboardController controller;

  const _AddCampaignModal({required this.controller});

  @override
  State<_AddCampaignModal> createState() => _AddCampaignModalState();
}

class _AddCampaignModalState extends State<_AddCampaignModal> {
  final _formKey = GlobalKey<FormState>();

  // Metin alanları için TextEditingController'lar
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _discountPercentCtrl = TextEditingController(text: '15');

  // Kampanyanın varsayılan geçerlilik aralığı: Bugün ile 30 gün sonrası
  DateTime _validFrom = DateTime.now();
  DateTime _validTo = DateTime.now().add(const Duration(days: 30));

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _discountPercentCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        top: AppSpacing.xl,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.xl,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Yeni Kampanya Tanımla',
                    style: AppTypography.titleLarge,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(color: AppColors.border),
              const SizedBox(height: AppSpacing.md),

              // Kampanya Başlığı
              AppTextField(
                label: 'Kampanya Başlığı',
                hint: 'Örn: Erken Rezervasyon Fırsatı %15',
                controller: _titleCtrl,
                validator: (v) =>
                    ValidationUtils.validateMinLength(v, 3, 'Başlık'),
              ),
              const SizedBox(height: AppSpacing.md),

              // Açıklama
              AppTextField(
                label: 'Açıklama',
                hint: 'Kampanya katılım ve kullanım şartları...',
                controller: _descCtrl,
                maxLines: 2,
                validator: (v) =>
                    ValidationUtils.validateMinLength(v, 5, 'Açıklama'),
              ),
              const SizedBox(height: AppSpacing.md),

              // İndirim Yüzdesi (%)
              AppTextField(
                label: 'İndirim Yüzdesi (%)',
                hint: '15',
                controller: _discountPercentCtrl,
                keyboardType: TextInputType.number,
                validator: (v) {
                  final err = ValidationUtils.validatePositiveNumber(
                    v,
                    'İndirim',
                  );
                  if (err != null) return err;
                  final num = int.parse(v!);
                  if (num <= 0 || num > 90) {
                    return 'İndirim 1 ile 90 arasında olmalıdır.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.md),

              // Geçerlilik Tarihleri Seçimi
              Text('Geçerlilik Tarihleri', style: AppTypography.labelLarge),
              const SizedBox(height: AppSpacing.xs),
              InkWell(
                onTap: _pickRange,
                borderRadius: AppRadius.radiusMd,
                child: Container(
                  padding: AppSpacing.edgeInsetsMd,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: AppRadius.radiusMd,
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${DateFormatter.formatDate(_validFrom)} - ${DateFormatter.formatDate(_validTo)}',
                        style: AppTypography.bodyMedium,
                      ),
                      const Icon(
                        Icons.calendar_today_rounded,
                        size: 18,
                        color: AppColors.muted,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Yayınla Butonu
              AppButton(label: 'Kampanyayı Yayınla', onPressed: _saveCampaign),
            ],
          ),
        ),
      ),
    );
  }

  /// Tarih aralığı seçici diyalog penceresini açar.
  Future<void> _pickRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: DateTimeRange(start: _validFrom, end: _validTo),
    );
    if (picked != null) {
      setState(() {
        _validFrom = picked.start;
        _validTo = picked.end;
      });
    }
  }

  /// Kampanyayı doğrulayıp sisteme kaydeden metot.
  Future<void> _saveCampaign() async {
    if (!_formKey.currentState!.validate()) return;
    final company = widget.controller.company;
    if (company == null) return;

    final newCampaign = Campaign(
      id: 'camp_${DateTime.now().millisecondsSinceEpoch}',
      companyId: company.id,
      title: _titleCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      discountPercent: int.parse(_discountPercentCtrl.text.trim()),
      validFrom: _validFrom,
      validTo: _validTo,
      active: true,
    );

    final success = await widget.controller.addCampaign(newCampaign);
    if (success && mounted) {
      Navigator.pop(context);
      AppSnackbar.showSuccess(context, 'Yeni kampanya yayınlandı.');
    }
  }
}
