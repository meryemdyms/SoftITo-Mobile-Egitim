import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../campaigns/domain/entities/campaign.dart';
import '../../../campaigns/domain/repositories/campaign_repository.dart';
import '../../../search/presentation/widgets/vehicle_card.dart';
import '../../../vehicles/domain/entities/vehicle.dart';
import '../../../vehicles/domain/repositories/vehicle_repository.dart';
import '../../domain/entities/company.dart';
import '../../domain/repositories/company_repository.dart';

class CompanyStorefrontView extends StatefulWidget {
  final String companyId;

  const CompanyStorefrontView({super.key, required this.companyId});

  @override
  State<CompanyStorefrontView> createState() => _CompanyStorefrontViewState();
}

class _CompanyStorefrontViewState extends State<CompanyStorefrontView> {
  Company? _company;
  List<Vehicle> _vehicles = [];
  List<Campaign> _campaigns = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadStorefront();
  }

  Future<void> _loadStorefront() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final companyRepo = context.read<CompanyRepository>();
      final vehicleRepo = context.read<VehicleRepository>();
      final campaignRepo = context.read<CampaignRepository>();

      final company = await companyRepo.getCompanyById(widget.companyId);
      if (company == null) {
        setState(() {
          _error = 'Firma bulunamadı.';
          _isLoading = false;
        });
        return;
      }

      final vehicles = await vehicleRepo.getCompanyVehicles(widget.companyId);
      final campaigns = await campaignRepo.getCompanyCampaigns(
        widget.companyId,
      );

      setState(() {
        _company = company;
        _vehicles = vehicles.where((v) => v.isActive).toList();
        _campaigns = campaigns.where((c) => c.active).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Firma vitrini yüklenirken bir hata oluştu.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: AppLoading(message: 'Firma vitrini yükleniyor...'),
      );
    }

    if (_error != null || _company == null) {
      return Scaffold(
        appBar: AppBar(),
        body: AppEmptyState(
          title: 'Firma Bulunamadı',
          description: _error,
          actionLabel: 'Geri Dön',
          onAction: () => context.pop(),
        ),
      );
    }

    final company = _company!;

    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBar(title: Text(company.name)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Company Info Header
            Container(
              padding: AppSpacing.edgeInsetsLg,
              color: AppColors.surface,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: AppColors.primary.withOpacity(0.1),
                        child: const Icon(
                          Icons.storefront_rounded,
                          size: 32,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(company.name, style: AppTypography.titleLarge),
                            const SizedBox(height: 4),
                            Text(
                              'Çalışma Saatleri: ${company.openingHours}',
                              style: AppTypography.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    company.description,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.muted,
                    ),
                  ),
                  const Divider(color: AppColors.border, height: 24),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 18,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Expanded(
                        child: Text(
                          company.address,
                          style: AppTypography.bodySmall,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.phone_outlined,
                        size: 18,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(company.phone, style: AppTypography.bodySmall),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Active Campaigns for this company
            if (_campaigns.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Text(
                  'Aktif Kampanyalar',
                  style: AppTypography.titleMedium,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              SizedBox(
                height: 100,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                  ),
                  scrollDirection: Axis.horizontal,
                  itemCount: _campaigns.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(width: AppSpacing.md),
                  itemBuilder: (context, index) {
                    final campaign = _campaigns[index];
                    return Container(
                      width: 260,
                      padding: AppSpacing.edgeInsetsMd,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.primary, AppColors.primaryDark],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: AppRadius.radiusMd,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                campaign.title,
                                style: AppTypography.labelLarge.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: AppRadius.radiusSm,
                                ),
                                child: Text(
                                  '%${campaign.discountPercent}',
                                  style: AppTypography.labelSmall.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            campaign.description,
                            style: AppTypography.bodySmall.copyWith(
                              color: Colors.white70,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
            ],

            // Vehicles of Company
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Firmanın Araçları', style: AppTypography.titleMedium),
                  Text(
                    '${_vehicles.length} Araç',
                    style: AppTypography.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),

            if (_vehicles.isEmpty)
              const Padding(
                padding: EdgeInsets.all(AppSpacing.xl),
                child: Center(
                  child: Text(
                    'Bu firmanın şu anda kiralık aracı bulunmamaktadır.',
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: AppSpacing.edgeInsetsLg,
                itemCount: _vehicles.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: AppSpacing.md),
                itemBuilder: (context, index) {
                  final vehicle = _vehicles[index];
                  return VehicleCard(
                    vehicle: vehicle,
                    company: company,
                    onTap: () => context.push('/vehicles/${vehicle.id}'),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
