import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../companies/domain/entities/company.dart';
import '../../../companies/domain/repositories/company_repository.dart';
import '../controllers/campaigns_controller.dart';
import '../../domain/entities/campaign.dart';

class CampaignsView extends StatefulWidget {
  const CampaignsView({super.key});

  @override
  State<CampaignsView> createState() => _CampaignsViewState();
}

class _CampaignsViewState extends State<CampaignsView> {
  Map<String, Company> _companiesMap = {};
  bool _isLoadingCompanies = true;

  @override
  void initState() {
    super.initState();
    _loadCompanies();
  }

  Future<void> _loadCompanies() async {
    final companyRepo = context.read<CompanyRepository>();
    final companies = await companyRepo.getAllCompanies();
    setState(() {
      _companiesMap = {for (var c in companies) c.id: c};
      _isLoadingCompanies = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final campaignsCtrl = context.watch<CampaignsController>();

    if (campaignsCtrl.isLoading || _isLoadingCompanies) {
      return const Scaffold(
        body: AppLoading(message: 'Fırsatlar yükleniyor...'),
      );
    }

    final campaigns = campaignsCtrl.activeCampaigns;

    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBar(title: const Text('Fırsatlar ve Kampanyalar')),
      body: campaigns.isEmpty
          ? const AppEmptyState(
              icon: Icons.local_offer_outlined,
              title: 'Aktif Kampanya Yok',
              description: 'Şu anda geçerli kampanya bulunmamaktadır.',
            )
          : RefreshIndicator(
              onRefresh: () async {
                await campaignsCtrl.loadCampaigns();
                await _loadCompanies();
              },
              child: ListView.separated(
                padding: AppSpacing.edgeInsetsLg,
                itemCount: campaigns.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: AppSpacing.lg),
                itemBuilder: (context, index) {
                  final campaign = campaigns[index];
                  final company = _companiesMap[campaign.companyId];
                  return _buildCampaignCard(context, campaign, company);
                },
              ),
            ),
    );
  }

  Widget _buildCampaignCard(
    BuildContext context,
    Campaign campaign,
    Company? company,
  ) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner gradient header
          Container(
            padding: AppSpacing.edgeInsetsLg,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.primaryDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(AppRadius.lg),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    campaign.title,
                    style: AppTypography.titleLarge.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: AppRadius.radiusFull,
                  ),
                  child: Text(
                    '%${campaign.discountPercent} İNDİRİM',
                    style: AppTypography.labelLarge.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content body
          Padding(
            padding: AppSpacing.edgeInsetsLg,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (company != null) ...[
                  Row(
                    children: [
                      const Icon(
                        Icons.storefront_outlined,
                        size: 16,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        company.name,
                        style: AppTypography.labelLarge.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                ],
                Text(campaign.description, style: AppTypography.bodyMedium),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    const Icon(
                      Icons.event_available_rounded,
                      size: 16,
                      color: AppColors.muted,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      'Geçerlilik: ${DateFormatter.formatDate(campaign.validFrom)} - ${DateFormatter.formatDate(campaign.validTo)}',
                      style: AppTypography.bodySmall,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                AppButton(
                  label: 'Araçları İncele',
                  variant: AppButtonVariant.secondary,
                  height: 40,
                  onPressed: () {
                    if (company != null) {
                      context.push('/companies/${company.id}');
                    } else {
                      context.go('/');
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
