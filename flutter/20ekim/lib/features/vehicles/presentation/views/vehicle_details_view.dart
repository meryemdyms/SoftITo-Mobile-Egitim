import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../bookings/presentation/controllers/booking_controller.dart';
import '../../../campaigns/domain/services/pricing_calculator.dart';
import '../../../companies/domain/entities/company.dart';
import '../../../companies/domain/repositories/company_repository.dart';
import '../../../search/presentation/controllers/vehicle_search_controller.dart';
import '../../domain/entities/vehicle.dart';
import '../../domain/repositories/vehicle_repository.dart';

/// Seçilen aracın teknik özelliklerini, kiralama koşullarını, indirim dökümünü
/// ve kiralama başlatma aksiyonunu gösteren detay ekranı.
class VehicleDetailsView extends StatefulWidget {
  /// Detayı görüntülenecek aracın benzersiz kimliği.
  final String vehicleId;

  const VehicleDetailsView({super.key, required this.vehicleId});

  @override
  State<VehicleDetailsView> createState() => _VehicleDetailsViewState();
}

class _VehicleDetailsViewState extends State<VehicleDetailsView> {
  Vehicle? _vehicle;
  Company? _company;
  bool _isLoading = true;
  String? _error;
  PriceCalculationResult? _priceResult;

  @override
  void initState() {
    super.initState();
    _loadDetails();
  }

  /// Araç, firma ve arama tarihlerine göre anlık fiyat hesaplama önizlemesini yükler.
  Future<void> _loadDetails() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final vehicleRepo = context.read<VehicleRepository>();
      final companyRepo = context.read<CompanyRepository>();
      final bookingCtrl = context.read<BookingController>();
      final searchCtrl = context.read<VehicleSearchController>();

      final vehicle = await vehicleRepo.getVehicleById(widget.vehicleId);
      if (vehicle == null) {
        setState(() {
          _error = 'Araç bulunamadı.';
          _isLoading = false;
        });
        return;
      }

      final company = await companyRepo.getCompanyById(vehicle.companyId);

      // Seçili arama tarihlerine göre indirim ve toplam bedel önizlemesi
      final priceResult = await bookingCtrl.calculatePricePreview(
        vehicle: vehicle,
        startAt: searchCtrl.startDateTime,
        endAt: searchCtrl.endDateTime,
      );

      setState(() {
        _vehicle = vehicle;
        _company = company;
        _priceResult = priceResult;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Detaylar yüklenirken hata oluştu.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: AppLoading(message: 'Araç detayları hazırlanıyor...'),
      );
    }

    if (_error != null || _vehicle == null) {
      return Scaffold(
        appBar: AppBar(),
        body: AppEmptyState(
          title: 'Araç Bulunamadı',
          description: _error,
          actionLabel: 'Geri Dön',
          onAction: () => context.pop(),
        ),
      );
    }

    final vehicle = _vehicle!;
    final searchCtrl = context.watch<VehicleSearchController>();
    final authCtrl = context.watch<AuthController>();

    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: CustomScrollView(
        slivers: [
          // Araç Görseli ve Geri Butonu Barındıran Genişletilebilir Üst Bar
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            leading: CircleAvatar(
              backgroundColor: Colors.white.withOpacity(0.9),
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  color: AppColors.ink,
                ),
                onPressed: () => context.pop(),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  vehicle.images.isNotEmpty
                      ? Image.network(
                          vehicle.images.first,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _buildFallbackImage(),
                        )
                      : _buildFallbackImage(),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.3),
                          Colors.transparent,
                          Colors.black.withOpacity(0.5),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Araç İçerik Bilgileri
          SliverToBoxAdapter(
            child: Padding(
              padding: AppSpacing.edgeInsetsLg,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Araç Adı, Yıl ve Günlük Fiyat Kartı
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              vehicle.fullName,
                              style: AppTypography.displayMedium,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${vehicle.year} Model',
                              style: AppTypography.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: AppRadius.radiusMd,
                        ),
                        child: Text(
                          '${CurrencyFormatter.formatKurus(vehicle.dailyRate)} / gün',
                          style: AppTypography.titleMedium.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Aracı Kiralayan Firma Kartı (Tıklanabilir, vitrine gider)
                  if (_company != null)
                    InkWell(
                      onTap: () => context.push('/companies/${_company!.id}'),
                      borderRadius: AppRadius.radiusMd,
                      child: Container(
                        padding: AppSpacing.edgeInsetsMd,
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: AppRadius.radiusMd,
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          children: [
                            const CircleAvatar(
                              backgroundColor: AppColors.surfaceVariant,
                              child: Icon(
                                Icons.storefront_rounded,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _company!.name,
                                    style: AppTypography.labelLarge,
                                  ),
                                  Text(
                                    'Vitrine ve Diğer Araçlara Git',
                                    style: AppTypography.bodySmall.copyWith(
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.chevron_right_rounded,
                              color: AppColors.muted,
                            ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: AppSpacing.lg),

                  // Teknik Özellikler Grid Izgarası
                  const Text('Özellikler', style: AppTypography.titleMedium),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      Expanded(
                        child: _buildSpecCard(
                          'Vites',
                          vehicle.transmission.label,
                          Icons.settings_suggest_rounded,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: _buildSpecCard(
                          'Yakıt',
                          vehicle.fuel.label,
                          Icons.local_gas_station_rounded,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      Expanded(
                        child: _buildSpecCard(
                          'Kapasite',
                          '${vehicle.seats} Koltuk',
                          Icons.people_outline_rounded,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: _buildSpecCard(
                          'Konum',
                          vehicle.pickupLocation,
                          Icons.location_on_outlined,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  // Kiralama Kuralları ve Sürücü Koşulları
                  const Text(
                    'Kiralama Koşulları',
                    style: AppTypography.titleMedium,
                  ),
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
                        _buildConditionRow(
                          'Minimum Sürücü Yaşı',
                          '${vehicle.minDriverAge} Yaş',
                        ),
                        const Divider(color: AppColors.border),
                        _buildConditionRow(
                          'Minimum Ehliyet Süresi',
                          '${vehicle.minLicenceYears} Yıl',
                        ),
                        const Divider(color: AppColors.border),
                        _buildConditionRow(
                          'Ödeme Türü',
                          'Firmada Ödeme (Teslimatta)',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  // Seçili Tarih Aralığı ve Fiyatlandırma Hesaplama Özeti
                  const Text(
                    'Seçili Kiralama Özeti',
                    style: AppTypography.titleMedium,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Container(
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
                            const Text('Alış:', style: AppTypography.bodySmall),
                            Text(
                              DateFormatter.formatDateTime(
                                searchCtrl.startDateTime,
                              ),
                              style: AppTypography.labelLarge,
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('İade:', style: AppTypography.bodySmall),
                            Text(
                              DateFormatter.formatDateTime(
                                searchCtrl.endDateTime,
                              ),
                              style: AppTypography.labelLarge,
                            ),
                          ],
                        ),
                        const Divider(color: AppColors.border),
                        if (_priceResult != null) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Süre:',
                                style: AppTypography.bodyMedium,
                              ),
                              Text(
                                '${_priceResult!.dayCount} Gün',
                                style: AppTypography.labelLarge,
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Günlük Ücret:',
                                style: AppTypography.bodyMedium,
                              ),
                              Text(
                                CurrencyFormatter.formatKurus(
                                  vehicle.dailyRate,
                                ),
                                style: AppTypography.bodyMedium,
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Ara Toplam:',
                                style: AppTypography.bodyMedium,
                              ),
                              Text(
                                CurrencyFormatter.formatKurus(
                                  _priceResult!.basePrice,
                                ),
                                style: AppTypography.bodyMedium,
                              ),
                            ],
                          ),
                          if (_priceResult!.appliedCampaign != null) ...[
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.local_offer_outlined,
                                      size: 16,
                                      color: AppColors.success,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      _priceResult!.appliedCampaign!.title,
                                      style: AppTypography.bodySmall.copyWith(
                                        color: AppColors.success,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  '-${CurrencyFormatter.formatKurus(_priceResult!.discountAmount)}',
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
                              const Text(
                                'Toplam Ödenecek:',
                                style: AppTypography.titleMedium,
                              ),
                              Text(
                                CurrencyFormatter.formatKurus(
                                  _priceResult!.totalPrice,
                                ),
                                style: AppTypography.titleLarge.copyWith(
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 100), // Alt eylem çubuğu için boşluk
                ],
              ),
            ),
          ),
        ],
      ),
      // Sabit Alt Rezervasyon Eylem Çubuğu
      bottomSheet: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: const Border(top: BorderSide(color: AppColors.border)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Toplam Tutar', style: AppTypography.bodySmall),
                    if (_priceResult != null)
                      Text(
                        CurrencyFormatter.formatKurus(_priceResult!.totalPrice),
                        style: AppTypography.titleLarge.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: AppButton(
                  label: authCtrl.isAuthenticated
                      ? 'Rezervasyon Yap'
                      : 'Giriş Yap & Kirala',
                  icon: Icons.calendar_today_rounded,
                  onPressed: () {
                    if (!authCtrl.isAuthenticated) {
                      // Misafir akışı: Login sayfasına yönlendirilir ve kiralama adımına geri dönülür
                      final returnPath = '/booking/checkout/${vehicle.id}';
                      context.push('/auth/login?returnTo=$returnPath');
                    } else if (authCtrl.isCompany) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Firma hesabı ile müşteri kiralaması yapılamaz.',
                          ),
                        ),
                      );
                    } else {
                      context.push('/booking/checkout/${vehicle.id}');
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Özellik kutucuğunu oluşturan yardımcı widget.
  Widget _buildSpecCard(String title, String value, IconData icon) {
    return Container(
      padding: AppSpacing.edgeInsetsMd,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.radiusMd,
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.bodySmall),
                Text(
                  value,
                  style: AppTypography.labelLarge,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Kiralama koşulu satırı.
  Widget _buildConditionRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppTypography.bodyMedium),
          Text(value, style: AppTypography.labelLarge),
        ],
      ),
    );
  }

  /// Görsel yüklenemediğinde veya boş olduğunda gösterilen yedek araç ikonu.
  Widget _buildFallbackImage() {
    return Container(
      color: AppColors.surfaceVariant,
      child: const Center(
        child: Icon(
          Icons.directions_car_filled_rounded,
          size: 64,
          color: AppColors.muted,
        ),
      ),
    );
  }
}
