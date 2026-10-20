import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/enums/fuel_type.dart';
import '../../../../core/enums/transmission_type.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/app_button.dart';
import '../controllers/vehicle_search_controller.dart';

class SearchFilterModal extends StatefulWidget {
  final VehicleSearchController controller;

  const SearchFilterModal({super.key, required this.controller});

  @override
  State<SearchFilterModal> createState() => _SearchFilterModalState();
}

class _SearchFilterModalState extends State<SearchFilterModal> {
  TransmissionType? _transmission;
  FuelType? _fuel;
  double _maxPriceLira = 5000;
  String _sortBy = 'recommended';

  @override
  void initState() {
    super.initState();
    _transmission = widget.controller.selectedTransmission;
    _fuel = widget.controller.selectedFuel;
    if (widget.controller.maxDailyRate != null) {
      _maxPriceLira = widget.controller.maxDailyRate! / 100.0;
    }
    _sortBy = widget.controller.sortBy;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.xl,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Filtreler ve Sıralama',
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

              // Sort By
              Text('Sıralama', style: AppTypography.labelLarge),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                children: [
                  _buildSortChip('Önerilen', 'recommended'),
                  _buildSortChip('Fiyat (Artan)', 'price_asc'),
                  _buildSortChip('Fiyat (Azalan)', 'price_desc'),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),

              // Transmission
              Text('Vites Türü', style: AppTypography.labelLarge),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                children: TransmissionType.values.map((type) {
                  final isSelected = _transmission == type;
                  return ChoiceChip(
                    label: Text(type.label),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _transmission = selected ? type : null;
                      });
                    },
                    selectedColor: AppColors.primary,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : AppColors.ink,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Fuel
              Text('Yakıt Türü', style: AppTypography.labelLarge),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.xs,
                children: FuelType.values.map((type) {
                  final isSelected = _fuel == type;
                  return ChoiceChip(
                    label: Text(type.label),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _fuel = selected ? type : null;
                      });
                    },
                    selectedColor: AppColors.primary,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : AppColors.ink,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Max Daily Price Slider
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Maksimum Günlük Ücret',
                    style: AppTypography.labelLarge,
                  ),
                  Text(
                    CurrencyFormatter.formatKurus(
                      CurrencyFormatter.liraToKurus(_maxPriceLira.toInt()),
                    ),
                    style: AppTypography.labelLarge.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              Slider(
                value: _maxPriceLira,
                min: 800,
                max: 6000,
                divisions: 26,
                activeColor: AppColors.primary,
                label: '${_maxPriceLira.toInt()} ₺',
                onChanged: (val) => setState(() => _maxPriceLira = val),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      label: 'Sıfırla',
                      variant: AppButtonVariant.outline,
                      onPressed: () {
                        widget.controller.resetFilters();
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: AppButton(
                      label: 'Uygula',
                      onPressed: () {
                        widget.controller.setSortBy(_sortBy);
                        widget.controller.setFilter(
                          transmission: _transmission,
                          clearTransmission: _transmission == null,
                          fuel: _fuel,
                          clearFuel: _fuel == null,
                          maxRate: CurrencyFormatter.liraToKurus(
                            _maxPriceLira.toInt(),
                          ),
                        );
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSortChip(String label, String value) {
    final isSelected = _sortBy == value;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) setState(() => _sortBy = value);
      },
      selectedColor: AppColors.primary,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : AppColors.ink,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
      ),
    );
  }
}
