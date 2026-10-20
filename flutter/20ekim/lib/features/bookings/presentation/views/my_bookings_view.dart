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
import '../../../../core/widgets/app_loading.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../vehicles/domain/entities/vehicle.dart';
import '../../../vehicles/domain/repositories/vehicle_repository.dart';
import '../../domain/entities/reservation.dart';
import '../controllers/booking_controller.dart';

class MyBookingsView extends StatefulWidget {
  const MyBookingsView({super.key});

  @override
  State<MyBookingsView> createState() => _MyBookingsViewState();
}

class _MyBookingsViewState extends State<MyBookingsView> {
  Map<String, Vehicle> _vehiclesMap = {};
  bool _isLoadingVehicles = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final authCtrl = context.read<AuthController>();
    final bookingCtrl = context.read<BookingController>();
    final vehicleRepo = context.read<VehicleRepository>();

    if (authCtrl.currentUser != null) {
      await bookingCtrl.loadCustomerReservations(authCtrl.currentUser!.id);
      final vehicles = await vehicleRepo.getVehicles(activeOnly: false);
      setState(() {
        _vehiclesMap = {for (var v in vehicles) v.id: v};
        _isLoadingVehicles = false;
      });
    } else {
      setState(() => _isLoadingVehicles = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authCtrl = context.watch<AuthController>();
    final bookingCtrl = context.watch<BookingController>();

    if (!authCtrl.isAuthenticated || !authCtrl.isCustomer) {
      return Scaffold(
        appBar: AppBar(title: const Text('Rezervasyonlarım')),
        body: const AppEmptyState(
          title: 'Giriş Yapmalısınız',
          description:
              'Rezervasyonlarınızı görüntülemek için müşteri girişi yapınız.',
        ),
      );
    }

    if (bookingCtrl.isLoading || _isLoadingVehicles) {
      return Scaffold(
        appBar: AppBar(title: const Text('Rezervasyonlarım')),
        body: const AppLoading(message: 'Rezervasyonlarınız yükleniyor...'),
      );
    }

    final reservations = bookingCtrl.myReservations;

    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBar(title: const Text('Rezervasyonlarım')),
      body: reservations.isEmpty
          ? const AppEmptyState(
              icon: Icons.calendar_month_outlined,
              title: 'Henüz Rezervasyonunuz Yok',
              description: 'Kiralamak istediğiniz aracı keşfedip anında rezervasyon yapabilirsiniz.',
            )
          : RefreshIndicator(
              onRefresh: _loadData,
              child: ListView.separated(
                padding: AppSpacing.edgeInsetsLg,
                itemCount: reservations.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: AppSpacing.md),
                itemBuilder: (context, index) {
                  final reservation = reservations[index];
                  final vehicle = _vehiclesMap[reservation.vehicleId];
                  return _buildReservationCard(
                    context,
                    reservation,
                    vehicle,
                    authCtrl.currentUser!.id,
                  );
                },
              ),
            ),
    );
  }

  Widget _buildReservationCard(
    BuildContext context,
    Reservation reservation,
    Vehicle? vehicle,
    String customerId,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.radiusLg,
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: AppSpacing.edgeInsetsMd,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Vehicle Name + Status Badge
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
          const SizedBox(height: AppSpacing.sm),
          const Divider(color: AppColors.border),
          const SizedBox(height: AppSpacing.xs),

          // Date & Time
          Row(
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                size: 16,
                color: AppColors.primary,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                '${DateFormatter.formatDate(reservation.startAt)} - ${DateFormatter.formatDate(reservation.endAt)} (${reservation.dayCount} gün)',
                style: AppTypography.bodySmall.copyWith(color: AppColors.ink),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 16,
                color: AppColors.muted,
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  '${reservation.pickupLocation} -> ${reservation.returnLocation}',
                  style: AppTypography.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Price & Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Ödenecek Tutar:', style: AppTypography.labelSmall),
                  Text(
                    CurrencyFormatter.formatKurus(reservation.totalPrice),
                    style: AppTypography.titleMedium.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              if (reservation.status == ReservationStatus.confirmed)
                AppButton(
                  label: 'İptal Et',
                  variant: AppButtonVariant.outline,
                  height: 36,
                  width: 100,
                  onPressed: () =>
                      _cancelBooking(context, reservation, customerId),
                ),
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

  Future<void> _cancelBooking(
    BuildContext context,
    Reservation reservation,
    String customerId,
  ) async {
    final confirmed = await AppDialog.showConfirm(
      context,
      title: 'Rezervasyonu İptal Et',
      message: 'Bu rezervasyonu iptal etmek istediğinize emin misiniz? Bu işlem geri alınamaz.',
      confirmLabel: 'Evet, İptal Et',
      isDestructive: true,
    );

    if (confirmed == true && mounted) {
      final bookingCtrl = context.read<BookingController>();
      final success = await bookingCtrl.cancelReservation(
        reservationId: reservation.id,
        customerId: customerId,
      );

      if (success && mounted) {
        AppSnackbar.showSuccess(context, 'Rezervasyonunuz iptal edildi.');
      } else if (mounted && bookingCtrl.errorMessage != null) {
        AppSnackbar.showError(context, bookingCtrl.errorMessage!);
      }
    }
  }
}
