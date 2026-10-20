import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../campaigns/domain/services/pricing_calculator.dart';
import '../../../customer_profile/domain/entities/customer_profile.dart';
import '../../../customer_profile/presentation/controllers/customer_profile_controller.dart';
import '../../../search/presentation/controllers/vehicle_search_controller.dart';
import '../../../vehicles/domain/entities/vehicle.dart';
import '../../../vehicles/domain/repositories/vehicle_repository.dart';
import '../controllers/booking_controller.dart';

class BookingCheckoutView extends StatefulWidget {
  final String vehicleId;

  const BookingCheckoutView({super.key, required this.vehicleId});

  @override
  State<BookingCheckoutView> createState() => _BookingCheckoutViewState();
}

class _BookingCheckoutViewState extends State<BookingCheckoutView> {
  Vehicle? _vehicle;
  PriceCalculationResult? _priceResult;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadBookingSummary();
  }

  Future<void> _loadBookingSummary() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final vehicleRepo = context.read<VehicleRepository>();
      final bookingCtrl = context.read<BookingController>();
      final searchCtrl = context.read<VehicleSearchController>();
      final authCtrl = context.read<AuthController>();
      final profileCtrl = context.read<CustomerProfileController>();

      if (authCtrl.currentUser != null) {
        await profileCtrl.loadProfile(authCtrl.currentUser!.id);
      }

      final vehicle = await vehicleRepo.getVehicleById(widget.vehicleId);
      if (vehicle == null) {
        setState(() {
          _error = 'Araç bulunamadı.';
          _isLoading = false;
        });
        return;
      }

      final priceResult = await bookingCtrl.calculatePricePreview(
        vehicle: vehicle,
        startAt: searchCtrl.startDateTime,
        endAt: searchCtrl.endDateTime,
      );

      setState(() {
        _vehicle = vehicle;
        _priceResult = priceResult;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Bilgiler hazırlanırken bir hata oluştu.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: AppLoading(message: 'Rezervasyon detayları hesaplanıyor...'),
      );
    }

    if (_error != null || _vehicle == null || _priceResult == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Rezervasyon')),
        body: AppEmptyState(
          title: 'Hata',
          description: _error,
          actionLabel: 'Geri Dön',
          onAction: () => context.pop(),
        ),
      );
    }

    final vehicle = _vehicle!;
    final price = _priceResult!;
    final searchCtrl = context.watch<VehicleSearchController>();
    final authCtrl = context.watch<AuthController>();
    final profileCtrl = context.watch<CustomerProfileController>();
    final bookingCtrl = context.watch<BookingController>();

    final CustomerProfile? profile = profileCtrl.profile;

    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBar(title: const Text('Rezervasyonu Tamamla')),
      body: SingleChildScrollView(
        padding: AppSpacing.edgeInsetsLg,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Vehicle Snapshot Card
            Container(
              padding: AppSpacing.edgeInsetsMd,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: AppRadius.radiusMd,
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: AppRadius.radiusSm,
                    child: vehicle.images.isNotEmpty
                        ? Image.network(
                            vehicle.images.first,
                            width: 80,
                            height: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                const Icon(Icons.directions_car, size: 40),
                          )
                        : const Icon(Icons.directions_car, size: 40),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          vehicle.fullName,
                          style: AppTypography.titleMedium,
                        ),
                        Text(
                          '${vehicle.year} • ${vehicle.transmission.label} • ${vehicle.fuel.label}',
                          style: AppTypography.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Rental Dates & Locations
            Text('Kiralama Bilgileri', style: AppTypography.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            Container(
              padding: AppSpacing.edgeInsetsMd,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: AppRadius.radiusMd,
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  _buildInfoRow('Alış Yeri:', searchCtrl.pickupLocation),
                  const Divider(color: AppColors.border),
                  _buildInfoRow('İade Yeri:', searchCtrl.returnLocation),
                  const Divider(color: AppColors.border),
                  _buildInfoRow(
                    'Alış Zamanı:',
                    DateFormatter.formatDateTime(searchCtrl.startDateTime),
                  ),
                  const Divider(color: AppColors.border),
                  _buildInfoRow(
                    'İade Zamanı:',
                    DateFormatter.formatDateTime(searchCtrl.endDateTime),
                  ),
                  const Divider(color: AppColors.border),
                  _buildInfoRow('Kiralama Süresi:', '${price.dayCount} Gün'),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Driver Information
            Text('Sürücü Bilgileri', style: AppTypography.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            Container(
              padding: AppSpacing.edgeInsetsMd,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: AppRadius.radiusMd,
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  _buildInfoRow('Ad Soyad:', authCtrl.currentUser?.name ?? '-'),
                  const Divider(color: AppColors.border),
                  _buildInfoRow('E-posta:', authCtrl.currentUser?.email ?? '-'),
                  const Divider(color: AppColors.border),
                  _buildInfoRow('Telefon:', authCtrl.currentUser?.phone ?? '-'),
                  const Divider(color: AppColors.border),
                  _buildInfoRow(
                    'Ehliyet Sınıfı:',
                    profile != null
                        ? '${profile.licenceClass} (${profile.licenceYearsAt(DateTime.now())} Yıl)'
                        : 'Eksik',
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Payment Notice
            Container(
              padding: AppSpacing.edgeInsetsMd,
              decoration: BoxDecoration(
                color: AppColors.infoBg,
                borderRadius: AppRadius.radiusMd,
                border: Border.all(color: AppColors.info.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.payment_rounded,
                    color: AppColors.info,
                    size: 24,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Ödeme Yöntemi', style: AppTypography.labelLarge),
                        Text(
                          AppConstants.paymentTypeLabel,
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.ink,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Price Breakdown
            Text('Ücret Özeti', style: AppTypography.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            Container(
              padding: AppSpacing.edgeInsetsMd,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: AppRadius.radiusMd,
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  _buildInfoRow(
                    'Günlük Ücret:',
                    CurrencyFormatter.formatKurus(vehicle.dailyRate),
                  ),
                  const SizedBox(height: 6),
                  _buildInfoRow(
                    'Ara Toplam (${price.dayCount} gün):',
                    CurrencyFormatter.formatKurus(price.basePrice),
                  ),
                  if (price.appliedCampaign != null) ...[
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'İndirim (${price.appliedCampaign!.title}):',
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.success,
                          ),
                        ),
                        Text(
                          '-${CurrencyFormatter.formatKurus(price.discountAmount)}',
                          style: AppTypography.labelLarge.copyWith(
                            color: AppColors.success,
                          ),
                        ),
                      ],
                    ),
                  ],
                  const Divider(color: AppColors.border),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Toplam Tutar:', style: AppTypography.titleMedium),
                      Text(
                        CurrencyFormatter.formatKurus(price.totalPrice),
                        style: AppTypography.titleLarge.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Confirm Button
            AppButton(
              label: 'Rezervasyonu Onayla',
              icon: Icons.check_circle_outline_rounded,
              isLoading: bookingCtrl.isLoading,
              onPressed: () => _confirmBooking(
                context,
                vehicle,
                searchCtrl,
                authCtrl,
                bookingCtrl,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.bodySmall),
          Text(value, style: AppTypography.labelLarge),
        ],
      ),
    );
  }

  Future<void> _confirmBooking(
    BuildContext context,
    Vehicle vehicle,
    VehicleSearchController searchCtrl,
    AuthController authCtrl,
    BookingController bookingCtrl,
  ) async {
    final customer = authCtrl.currentUser;
    if (customer == null) {
      AppSnackbar.showError(context, 'Lütfen önce giriş yapınız.');
      return;
    }

    final reservation = await bookingCtrl.createReservation(
      customerId: customer.id,
      vehicle: vehicle,
      startAt: searchCtrl.startDateTime,
      endAt: searchCtrl.endDateTime,
      pickupLocation: searchCtrl.pickupLocation,
      returnLocation: searchCtrl.returnLocation,
    );

    if (reservation != null && context.mounted) {
      AppSnackbar.showSuccess(
        context,
        'Rezervasyonunuz başarıyla oluşturuldu!',
      );
      context.go('/my-bookings');
    } else if (bookingCtrl.errorMessage != null && context.mounted) {
      AppSnackbar.showError(context, bookingCtrl.errorMessage!);
    }
  }
}
