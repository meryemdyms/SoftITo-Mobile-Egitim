import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_loading.dart';
import '../controllers/map_discovery_controller.dart';

class MapDiscoveryView extends StatelessWidget {
  const MapDiscoveryView({super.key});

  @override
  Widget build(BuildContext context) {
    final mapCtrl = context.watch<MapDiscoveryController>();

    if (mapCtrl.isLoading) {
      return const Scaffold(
        body: AppLoading(message: 'Harita ve firmalar yükleniyor...'),
      );
    }

    final selected = mapCtrl.selectedCompany;
    final distanceKm = selected != null
        ? mapCtrl.calculateDistanceKm(selected)
        : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Haritada Keşfet'),
        actions: [
          TextButton.icon(
            onPressed: mapCtrl.toggleSimulatedLocationPermission,
            icon: Icon(
              mapCtrl.locationPermissionGranted
                  ? Icons.my_location_rounded
                  : Icons.location_disabled_rounded,
              size: 18,
              color: mapCtrl.locationPermissionGranted
                  ? AppColors.primary
                  : AppColors.muted,
            ),
            label: Text(
              mapCtrl.locationPermissionGranted ? 'Konum Açık' : 'Konum İzni',
              style: TextStyle(
                color: mapCtrl.locationPermissionGranted
                    ? AppColors.primary
                    : AppColors.muted,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // FlutterMap OpenStreetMap
          FlutterMap(
            options: MapOptions(
              initialCenter: selected != null
                  ? LatLng(selected.latitude, selected.longitude)
                  : const LatLng(41.0082, 28.9784),
              initialZoom: 11.5,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName:
                    'com.softito.carrental.car_rental_platform',
              ),
              MarkerLayer(
                markers: [
                  // User simulated marker if permission granted
                  if (mapCtrl.userSimulatedLocation != null)
                    Marker(
                      point: mapCtrl.userSimulatedLocation!,
                      width: 44,
                      height: 44,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.person_pin_circle_rounded,
                            color: AppColors.primary,
                            size: 28,
                          ),
                        ),
                      ),
                    ),

                  // Company markers
                  ...mapCtrl.companies.map((comp) {
                    final isSelected = selected?.id == comp.id;
                    return Marker(
                      point: LatLng(comp.latitude, comp.longitude),
                      width: isSelected ? 48 : 38,
                      height: isSelected ? 48 : 38,
                      child: GestureDetector(
                        onTap: () => mapCtrl.selectCompany(comp),
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primaryDark
                                : AppColors.primary,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.storefront_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ],
          ),

          // OSM Attribution Banner
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.85),
                borderRadius: AppRadius.radiusSm,
              ),
              child: const Text(
                '© OpenStreetMap contributors',
                style: TextStyle(fontSize: 10, color: AppColors.muted),
              ),
            ),
          ),

          // Selected Company Bottom Card
          if (selected != null)
            Positioned(
              bottom: AppSpacing.lg,
              left: AppSpacing.lg,
              right: AppSpacing.lg,
              child: Container(
                padding: AppSpacing.edgeInsetsMd,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: AppRadius.radiusLg,
                  border: Border.all(color: AppColors.border),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: AppColors.primary.withOpacity(0.1),
                          child: const Icon(
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
                                selected.name,
                                style: AppTypography.titleMedium,
                              ),
                              Text(
                                selected.address,
                                style: AppTypography.bodySmall,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.access_time_rounded,
                              size: 14,
                              color: AppColors.muted,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              selected.openingHours,
                              style: AppTypography.bodySmall,
                            ),
                          ],
                        ),
                        if (distanceKm != null)
                          Text(
                            '~${distanceKm.toStringAsFixed(1)} km uzaklıkta',
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AppButton(
                      label: 'Firma Vitrinine Git',
                      height: 40,
                      onPressed: () =>
                          context.push('/companies/${selected.id}'),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
