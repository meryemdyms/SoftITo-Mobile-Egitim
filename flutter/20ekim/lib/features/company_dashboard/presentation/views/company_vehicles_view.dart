import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/enums/fuel_type.dart';
import '../../../../core/enums/transmission_type.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/validation_utils.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../vehicles/domain/entities/vehicle.dart';
import '../controllers/company_dashboard_controller.dart';

class CompanyVehiclesView extends StatelessWidget {
  const CompanyVehiclesView({super.key});

  @override
  Widget build(BuildContext context) {
    final dashboardCtrl = context.watch<CompanyDashboardController>();
    final vehicles = dashboardCtrl.vehicles;

    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBar(title: const Text('Filo Yönetimi')),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Yeni Araç Ekle'),
        onPressed: () => _openAddVehicleDialog(context, dashboardCtrl),
      ),
      body: vehicles.isEmpty
          ? AppEmptyState(
              icon: Icons.directions_car_outlined,
              title: 'Henüz Araç Eklenmedi',
              description: 'Müşterilere sunmak için ilk aracınızı ekleyin.',
              actionLabel: 'Araç Ekle',
              onAction: () => _openAddVehicleDialog(context, dashboardCtrl),
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.lg,
                80,
              ),
              itemCount: vehicles.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: AppSpacing.md),
              itemBuilder: (context, index) {
                final vehicle = vehicles[index];
                return _buildVehicleTile(context, vehicle, dashboardCtrl);
              },
            ),
    );
  }

  Widget _buildVehicleTile(
    BuildContext context,
    Vehicle vehicle,
    CompanyDashboardController controller,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.radiusMd,
        border: Border.all(color: AppColors.border),
      ),
      padding: AppSpacing.edgeInsetsMd,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: AppColors.surfaceVariant,
            child: Icon(
              Icons.directions_car_rounded,
              color: vehicle.isActive ? AppColors.primary : AppColors.muted,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        vehicle.fullName,
                        style: AppTypography.titleMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: vehicle.isActive
                            ? AppColors.successBg
                            : AppColors.surfaceVariant,
                        borderRadius: AppRadius.radiusFull,
                      ),
                      child: Text(
                        vehicle.isActive ? 'Aktif' : 'Pasif',
                        style: AppTypography.labelSmall.copyWith(
                          color: vehicle.isActive
                              ? AppColors.success
                              : AppColors.muted,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  '${vehicle.year} • ${vehicle.transmission.label} • ${vehicle.fuel.label}',
                  style: AppTypography.bodySmall,
                ),
                const SizedBox(height: 4),
                Text(
                  '${CurrencyFormatter.formatKurus(vehicle.dailyRate)} / gün',
                  style: AppTypography.labelLarge.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          IconButton(
            icon: Icon(
              vehicle.isActive
                  ? Icons.toggle_on_rounded
                  : Icons.toggle_off_rounded,
              size: 36,
              color: vehicle.isActive ? AppColors.success : AppColors.muted,
            ),
            tooltip: vehicle.isActive ? 'Pasife Al' : 'Aktife Al',
            onPressed: () => _toggleStatus(context, vehicle, controller),
          ),
        ],
      ),
    );
  }

  Future<void> _toggleStatus(
    BuildContext context,
    Vehicle vehicle,
    CompanyDashboardController controller,
  ) async {
    final success = await controller.toggleVehicleStatus(vehicle.id);
    if (success && context.mounted) {
      AppSnackbar.showSuccess(
        context,
        'Araç durumu ${!vehicle.isActive ? "Aktif" : "Pasif"} olarak güncellendi.',
      );
    }
  }

  void _openAddVehicleDialog(
    BuildContext context,
    CompanyDashboardController controller,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AddVehicleModal(controller: controller),
    );
  }
}

class _AddVehicleModal extends StatefulWidget {
  final CompanyDashboardController controller;

  const _AddVehicleModal({required this.controller});

  @override
  State<_AddVehicleModal> createState() => _AddVehicleModalState();
}

class _AddVehicleModalState extends State<_AddVehicleModal> {
  final _formKey = GlobalKey<FormState>();

  final _brandCtrl = TextEditingController();
  final _modelCtrl = TextEditingController();
  final _yearCtrl = TextEditingController(text: '2024');
  final _dailyRateLiraCtrl = TextEditingController(text: '1500');
  final _pickupLocationCtrl = TextEditingController(text: 'Merkez Ofis');
  final _minAgeCtrl = TextEditingController(text: '21');
  final _minLicenceCtrl = TextEditingController(text: '1');

  TransmissionType _transmission = TransmissionType.automatic;
  FuelType _fuel = FuelType.gasoline;

  @override
  void dispose() {
    _brandCtrl.dispose();
    _modelCtrl.dispose();
    _yearCtrl.dispose();
    _dailyRateLiraCtrl.dispose();
    _pickupLocationCtrl.dispose();
    _minAgeCtrl.dispose();
    _minLicenceCtrl.dispose();
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
                  Text('Yeni Araç Ekle', style: AppTypography.titleLarge),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(color: AppColors.border),
              const SizedBox(height: AppSpacing.md),

              Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      label: 'Marka',
                      hint: 'Örn: Ford',
                      controller: _brandCtrl,
                      validator: (v) =>
                          ValidationUtils.validateMinLength(v, 2, 'Marka'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: AppTextField(
                      label: 'Model',
                      hint: 'Örn: Focus 1.5 EcoBlue',
                      controller: _modelCtrl,
                      validator: (v) =>
                          ValidationUtils.validateMinLength(v, 2, 'Model'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),

              Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      label: 'Model Yılı',
                      hint: '2024',
                      controller: _yearCtrl,
                      keyboardType: TextInputType.number,
                      validator: ValidationUtils.validatePositiveNumber,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: AppTextField(
                      label: 'Günlük Ücret (₺)',
                      hint: '1500',
                      controller: _dailyRateLiraCtrl,
                      keyboardType: TextInputType.number,
                      validator: ValidationUtils.validatePositiveNumber,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Vites', style: AppTypography.labelLarge),
                        const SizedBox(height: 4),
                        DropdownButtonFormField<TransmissionType>(
                          value: _transmission,
                          decoration: const InputDecoration(),
                          items: TransmissionType.values.map((t) {
                            return DropdownMenuItem(
                              value: t,
                              child: Text(t.label),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null)
                              setState(() => _transmission = val);
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Yakıt', style: AppTypography.labelLarge),
                        const SizedBox(height: 4),
                        DropdownButtonFormField<FuelType>(
                          value: _fuel,
                          decoration: const InputDecoration(),
                          items: FuelType.values.map((f) {
                            return DropdownMenuItem(
                              value: f,
                              child: Text(f.label),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) setState(() => _fuel = val);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),

              AppTextField(
                label: 'Teslimat Noktası / Konumu',
                hint: 'Örn: Kadıköy Ofis / Havalimanı',
                controller: _pickupLocationCtrl,
                validator: (v) =>
                    ValidationUtils.validateMinLength(v, 3, 'Teslimat Konumu'),
              ),
              const SizedBox(height: AppSpacing.md),

              Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      label: 'Min. Sürücü Yaşı',
                      controller: _minAgeCtrl,
                      keyboardType: TextInputType.number,
                      validator: ValidationUtils.validatePositiveNumber,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: AppTextField(
                      label: 'Min. Ehliyet Yılı',
                      controller: _minLicenceCtrl,
                      keyboardType: TextInputType.number,
                      validator: ValidationUtils.validatePositiveNumber,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),

              AppButton(label: 'Aracı Kaydet', onPressed: _saveVehicle),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveVehicle() async {
    if (!_formKey.currentState!.validate()) return;
    final company = widget.controller.company;
    if (company == null) return;

    final lira = int.parse(_dailyRateLiraCtrl.text.trim());
    final newVehicle = Vehicle(
      id: 'veh_${DateTime.now().millisecondsSinceEpoch}',
      companyId: company.id,
      brand: _brandCtrl.text.trim(),
      model: _modelCtrl.text.trim(),
      year: int.parse(_yearCtrl.text.trim()),
      transmission: _transmission,
      fuel: _fuel,
      seats: 5,
      dailyRate: CurrencyFormatter.liraToKurus(lira),
      images: const [
        'https://images.unsplash.com/photo-1541899481282-d53bffe3c35d?w=600',
      ],
      pickupLocation: _pickupLocationCtrl.text.trim(),
      minDriverAge: int.parse(_minAgeCtrl.text.trim()),
      minLicenceYears: int.parse(_minLicenceCtrl.text.trim()),
      isActive: true,
    );

    final success = await widget.controller.addVehicle(newVehicle);
    if (success && mounted) {
      Navigator.pop(context);
      AppSnackbar.showSuccess(context, 'Yeni araç filoya eklendi.');
    }
  }
}
