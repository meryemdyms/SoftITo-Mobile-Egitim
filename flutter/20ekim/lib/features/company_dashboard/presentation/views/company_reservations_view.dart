import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/enums/reservation_status.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_dialog.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../bookings/domain/entities/reservation.dart';
import '../../../vehicles/domain/entities/vehicle.dart';
import '../controllers/company_dashboard_controller.dart';

class CompanyReservationsView extends StatefulWidget {
  const CompanyReservationsView({super.key});

  @override
  State<CompanyReservationsView> createState() =>
      _CompanyReservationsViewState();
}

class _CompanyReservationsViewState extends State<CompanyReservationsView> {
  ReservationStatus? _filterStatus;

  @override
  Widget build(BuildContext context) {
    final dashboardCtrl = context.watch<CompanyDashboardController>();
    var reservations = dashboardCtrl.reservations;

    if (_filterStatus != null) {
      reservations = reservations
          .where((r) => r.status == _filterStatus)
          .toList();
    }

    final vehiclesMap = {for (var v in dashboardCtrl.vehicles) v.id: v};

    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBar(title: const Text('Rezervasyon Yönetimi')),
      body: Column(
        children: [
          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.sm,
            ),
            child: Row(
              children: [
                _buildFilterChip('Tümü', null),
                const SizedBox(width: AppSpacing.xs),
                _buildFilterChip('Onaylandı', ReservationStatus.confirmed),
                const SizedBox(width: AppSpacing.xs),
                _buildFilterChip('Aktif Teslim', ReservationStatus.active),
                const SizedBox(width: AppSpacing.xs),
                _buildFilterChip('Tamamlandı', ReservationStatus.completed),
                const SizedBox(width: AppSpacing.xs),
                _buildFilterChip('İptal Edildi', ReservationStatus.cancelled),
              ],
            ),
          ),
          const Divider(color: AppColors.border, height: 1),

          // List
          Expanded(
            child: reservations.isEmpty
                ? const AppEmptyState(
                    title: 'Rezervasyon Bulunamadı',
                    description:
                        'Seçili filtreye ait rezervasyon kaydı yoktur.',
                  )
                : ListView.separated(
                    padding: AppSpacing.edgeInsetsLg,
                    itemCount: reservations.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: AppSpacing.md),
                    itemBuilder: (context, index) {
                      final reservation = reservations[index];
                      final vehicle = vehiclesMap[reservation.vehicleId];
                      return _buildCompanyReservationCard(
                        context,
                        reservation,
                        vehicle,
                        dashboardCtrl,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, ReservationStatus? status) {
    final isSelected = _filterStatus == status;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() => _filterStatus = selected ? status : null);
      },
      selectedColor: AppColors.primary,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : AppColors.ink,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
        fontSize: 12,
      ),
    );
  }

  Widget _buildCompanyReservationCard(
    BuildContext context,
    Reservation reservation,
    Vehicle? vehicle,
    CompanyDashboardController controller,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.radiusLg,
        border: Border.all(color: AppColors.border),
      ),
      padding: AppSpacing.edgeInsetsMd,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  vehicle?.fullName ?? 'Araç #${reservation.vehicleId}',
                  style: AppTypography.titleMedium,
                ),
              ),
              _buildStatusBadge(reservation.status),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Müşteri ID: ${reservation.customerId}',
            style: AppTypography.bodySmall.copyWith(color: AppColors.muted),
          ),
          const Divider(color: AppColors.border),
          Row(
            children: [
              const Icon(
                Icons.calendar_today_rounded,
                size: 15,
                color: AppColors.primary,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                '${DateFormatter.formatDate(reservation.startAt)} - ${DateFormatter.formatDate(reservation.endAt)} (${reservation.dayCount} gün)',
                style: AppTypography.bodySmall,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Toplam Tutar:', style: AppTypography.bodySmall),
              Text(
                CurrencyFormatter.formatKurus(reservation.totalPrice),
                style: AppTypography.labelLarge.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Lifecycle transition action buttons
          Row(
            children: [
              if (reservation.status == ReservationStatus.confirmed) ...[
                Expanded(
                  child: AppButton(
                    label: 'Teslim Et',
                    icon: Icons.key_rounded,
                    height: 38,
                    onPressed: () => _updateStatus(
                      context,
                      reservation.id,
                      ReservationStatus.active,
                      controller,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: AppButton(
                    label: 'İptal Et',
                    variant: AppButtonVariant.destructive,
                    height: 38,
                    onPressed: () =>
                        _cancelReservation(context, reservation.id, controller),
                  ),
                ),
              ] else if (reservation.status == ReservationStatus.active) ...[
                Expanded(
                  child: AppButton(
                    label: 'İade Al ve Tamamla',
                    icon: Icons.check_circle_outline_rounded,
                    height: 38,
                    onPressed: () => _updateStatus(
                      context,
                      reservation.id,
                      ReservationStatus.completed,
                      controller,
                    ),
                  ),
                ),
              ] else ...[
                Expanded(
                  child: Text(
                    'İşlem tamamlanmıştır (${reservation.status.label}).',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.muted,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(ReservationStatus status) {
    Color bg;
    Color fg;
    switch (status) {
      case ReservationStatus.confirmed:
        bg = AppColors.infoBg;
        fg = AppColors.primary;
        break;
      case ReservationStatus.active:
        bg = AppColors.warningBg;
        fg = AppColors.warning;
        break;
      case ReservationStatus.completed:
        bg = AppColors.successBg;
        fg = AppColors.success;
        break;
      case ReservationStatus.cancelled:
        bg = AppColors.destructiveBg;
        fg = AppColors.destructive;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: AppRadius.radiusFull),
      child: Text(
        status.label,
        style: AppTypography.labelSmall.copyWith(
          color: fg,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Future<void> _updateStatus(
    BuildContext context,
    String reservationId,
    ReservationStatus status,
    CompanyDashboardController controller,
  ) async {
    final success = await controller.updateReservationStatus(
      reservationId,
      status,
    );
    if (success && mounted) {
      AppSnackbar.showSuccess(
        context,
        'Durum "${status.label}" olarak güncellendi.',
      );
    } else if (mounted && controller.errorMessage != null) {
      AppSnackbar.showError(context, controller.errorMessage!);
    }
  }

  Future<void> _cancelReservation(
    BuildContext context,
    String reservationId,
    CompanyDashboardController controller,
  ) async {
    final confirmed = await AppDialog.showConfirm(
      context,
      title: 'Rezervasyonu İptal Et',
      message: 'Bu onaylı rezervasyonu iptal etmek istediğinize emin misiniz?',
      confirmLabel: 'İptal Et',
      isDestructive: true,
    );

    if (confirmed == true && mounted) {
      await _updateStatus(
        context,
        reservationId,
        ReservationStatus.cancelled,
        controller,
      );
    }
  }
}
