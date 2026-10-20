import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/services/clock.dart';
import '../../features/auth/data/repositories/in_memory_auth_repository.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/presentation/controllers/auth_controller.dart';
import '../../features/bookings/data/repositories/in_memory_reservation_repository.dart';
import '../../features/bookings/domain/repositories/reservation_repository.dart';
import '../../features/bookings/presentation/controllers/booking_controller.dart';
import '../../features/campaigns/data/repositories/in_memory_campaign_repository.dart';
import '../../features/campaigns/domain/repositories/campaign_repository.dart';
import '../../features/campaigns/presentation/controllers/campaigns_controller.dart';
import '../../features/companies/data/repositories/in_memory_company_repository.dart';
import '../../features/companies/domain/repositories/company_repository.dart';
import '../../features/company_dashboard/presentation/controllers/company_dashboard_controller.dart';
import '../../features/customer_profile/data/repositories/in_memory_customer_profile_repository.dart';
import '../../features/customer_profile/domain/repositories/customer_profile_repository.dart';
import '../../features/customer_profile/presentation/controllers/customer_profile_controller.dart';
import '../../features/map_discovery/presentation/controllers/map_discovery_controller.dart';
import '../../features/search/presentation/controllers/vehicle_search_controller.dart';
import '../../features/vehicles/data/repositories/in_memory_vehicle_repository.dart';
import '../../features/vehicles/domain/repositories/vehicle_repository.dart';

class AppProviders extends StatefulWidget {
  final Widget child;

  const AppProviders({super.key, required this.child});

  @override
  State<AppProviders> createState() => _AppProvidersState();
}

class _AppProvidersState extends State<AppProviders> {
  late final Clock _clock;
  late final InMemoryCustomerProfileRepository _profileRepository;
  late final InMemoryCompanyRepository _companyRepository;
  late final InMemoryAuthRepository _authRepository;
  late final InMemoryVehicleRepository _vehicleRepository;
  late final InMemoryReservationRepository _reservationRepository;
  late final InMemoryCampaignRepository _campaignRepository;

  @override
  void initState() {
    super.initState();
    _clock = const SystemClock();
    _profileRepository = InMemoryCustomerProfileRepository();
    _companyRepository = InMemoryCompanyRepository();
    _authRepository = InMemoryAuthRepository(
      profileRepository: _profileRepository,
      companyRepository: _companyRepository,
    );
    _vehicleRepository = InMemoryVehicleRepository();
    _reservationRepository = InMemoryReservationRepository();
    _campaignRepository = InMemoryCampaignRepository();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Services and Repositories
        Provider<Clock>.value(value: _clock),
        Provider<CustomerProfileRepository>.value(value: _profileRepository),
        Provider<CompanyRepository>.value(value: _companyRepository),
        Provider<AuthRepository>.value(value: _authRepository),
        Provider<VehicleRepository>.value(value: _vehicleRepository),
        Provider<ReservationRepository>.value(value: _reservationRepository),
        Provider<CampaignRepository>.value(value: _campaignRepository),

        // ChangeNotifier Controllers
        ChangeNotifierProvider<AuthController>(
          create: (_) => AuthController(authRepository: _authRepository),
        ),
        ChangeNotifierProvider<CustomerProfileController>(
          create: (_) =>
              CustomerProfileController(profileRepository: _profileRepository),
        ),
        ChangeNotifierProvider<VehicleSearchController>(
          create: (_) => VehicleSearchController(
            vehicleRepository: _vehicleRepository,
            reservationRepository: _reservationRepository,
            companyRepository: _companyRepository,
          )..searchVehicles(),
        ),
        ChangeNotifierProvider<BookingController>(
          create: (_) => BookingController(
            reservationRepository: _reservationRepository,
            vehicleRepository: _vehicleRepository,
            profileRepository: _profileRepository,
            campaignRepository: _campaignRepository,
            clock: _clock,
          ),
        ),
        ChangeNotifierProvider<CompanyDashboardController>(
          create: (_) => CompanyDashboardController(
            companyRepository: _companyRepository,
            vehicleRepository: _vehicleRepository,
            reservationRepository: _reservationRepository,
            campaignRepository: _campaignRepository,
            clock: _clock,
          ),
        ),
        ChangeNotifierProvider<MapDiscoveryController>(
          create: (_) =>
              MapDiscoveryController(companyRepository: _companyRepository)
                ..loadMapCompanies(),
        ),
        ChangeNotifierProvider<CampaignsController>(
          create: (_) =>
              CampaignsController(campaignRepository: _campaignRepository)
                ..loadCampaigns(),
        ),
      ],
      child: widget.child,
    );
  }
}
