import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_loading.dart';
import '../controllers/vehicle_search_controller.dart';
import '../widgets/search_filter_modal.dart';
import '../widgets/vehicle_card.dart';

class SearchHomeView extends StatelessWidget {
  const SearchHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final searchController = context.watch<VehicleSearchController>();

    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBar(
        title: const Text('Araç Kirala'),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune_rounded),
            tooltip: 'Filtreler',
            onPressed: () => _openFilters(context, searchController),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // Demo Banner
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.sm,
                AppSpacing.lg,
                0,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: AppColors.infoBg,
                borderRadius: AppRadius.radiusMd,
                border: Border.all(color: AppColors.info.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline_rounded,
                    size: 18,
                    color: AppColors.info,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      AppConstants.demoDisclaimer,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.ink,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Search Form Card
          SliverToBoxAdapter(
            child: Padding(
              padding: AppSpacing.edgeInsetsLg,
              child: Container(
                padding: AppSpacing.edgeInsetsLg,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: AppRadius.radiusLg,
                  border: Border.all(color: AppColors.border),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Location Row
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          color: AppColors.primary,
                          size: 20,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            searchController.pickupLocation,
                            style: AppTypography.titleMedium,
                          ),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                      child: Divider(color: AppColors.border, height: 1),
                    ),

                    // Date & Time Row
                    Row(
                      children: [
                        Expanded(
                          child: _buildDateBox(
                            context,
                            title: 'Alış Tarihi',
                            dateTime: searchController.startDateTime,
                            onTap: () =>
                                _pickDateRange(context, searchController),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                            vertical: AppSpacing.xs,
                          ),
                          margin: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.xs,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceVariant,
                            borderRadius: AppRadius.radiusFull,
                          ),
                          child: Text(
                            '${searchController.dayCount} gün',
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        Expanded(
                          child: _buildDateBox(
                            context,
                            title: 'İade Tarihi',
                            dateTime: searchController.endDateTime,
                            onTap: () =>
                                _pickDateRange(context, searchController),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Filter Quick Action Row
                    Row(
                      children: [
                        Expanded(
                          child: AppButton(
                            label:
                                'Filtrele (${searchController.vehicles.length} Araç)',
                            variant: AppButtonVariant.secondary,
                            icon: Icons.tune_rounded,
                            height: 42,
                            onPressed: () =>
                                _openFilters(context, searchController),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Search Results Title
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.xs,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Uygun Araçlar', style: AppTypography.titleLarge),
                  Text(
                    '${searchController.vehicles.length} sonuç',
                    style: AppTypography.bodySmall,
                  ),
                ],
              ),
            ),
          ),

          // Results List or Loading/Empty
          if (searchController.isLoading)
            const SliverFillRemaining(
              child: AppLoading(message: 'Müsait araçlar listeleniyor...'),
            )
          else if (searchController.vehicles.isEmpty)
            SliverFillRemaining(
              child: AppEmptyState(
                title: 'Araç Bulunamadı',
                description: 'Seçtiğiniz tarihler veya filtrelere uygun araç bulunamadı. Filtreleri sıfırlayabilirsiniz.',
                actionLabel: 'Filtreleri Sıfırla',
                onAction: searchController.resetFilters,
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final vehicle = searchController.vehicles[index];
                  final company =
                      searchController.companiesMap[vehicle.companyId];

                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                    child: VehicleCard(
                      vehicle: vehicle,
                      company: company,
                      onTap: () => context.push('/vehicles/${vehicle.id}'),
                      onCompanyTap: () {
                        if (company != null) {
                          context.push('/companies/${company.id}');
                        }
                      },
                    ),
                  );
                }, childCount: searchController.vehicles.length),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDateBox(
    BuildContext context, {
    required String title,
    required DateTime dateTime,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.radiusMd,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant.withOpacity(0.5),
          borderRadius: AppRadius.radiusMd,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppTypography.labelSmall),
            const SizedBox(height: 2),
            Text(
              DateFormatter.formatShortDateWithMonth(dateTime),
              style: AppTypography.labelLarge,
            ),
            Text(
              DateFormatter.formatTime(dateTime),
              style: AppTypography.bodySmall.copyWith(color: AppColors.muted),
            ),
          ],
        ),
      ),
    );
  }

  void _openFilters(BuildContext context, VehicleSearchController controller) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SearchFilterModal(controller: controller),
    );
  }

  Future<void> _pickDateRange(
    BuildContext context,
    VehicleSearchController controller,
  ) async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: now,
      lastDate: now.add(const Duration(days: 90)),
      initialDateRange: DateTimeRange(
        start: controller.startDateTime,
        end: controller.endDateTime,
      ),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme
                .copyWith(primary: AppColors.primary, onPrimary: Colors.white),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      // Maintain selected hours
      final newStart = DateTime(
        picked.start.year,
        picked.start.month,
        picked.start.day,
        controller.startDateTime.hour,
        controller.startDateTime.minute,
      );
      final newEnd = DateTime(
        picked.end.year,
        picked.end.month,
        picked.end.day,
        controller.endDateTime.hour,
        controller.endDateTime.minute,
      );
      controller.setSearchDates(start: newStart, end: newEnd);
    }
  }
}
