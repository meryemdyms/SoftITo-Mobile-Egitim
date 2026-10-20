import 'package:flutter/foundation.dart';

import '../../../../core/enums/reservation_status.dart';
import '../../../../core/enums/user_role.dart';
import '../../../../core/errors/app_exceptions.dart';
import '../../../../core/services/clock.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../campaigns/domain/repositories/campaign_repository.dart';
import '../../../campaigns/domain/services/pricing_calculator.dart';
import '../../../customer_profile/domain/repositories/customer_profile_repository.dart';
import '../../../vehicles/domain/entities/vehicle.dart';
import '../../../vehicles/domain/repositories/vehicle_repository.dart';
import '../../domain/entities/reservation.dart';
import '../../domain/repositories/reservation_repository.dart';
import '../../domain/services/booking_validator_service.dart';

class BookingController extends ChangeNotifier {
  final ReservationRepository _reservationRepository;
  final VehicleRepository _vehicleRepository;
  final CustomerProfileRepository _profileRepository;
  final CampaignRepository _campaignRepository;
  final Clock _clock;

  List<Reservation> _myReservations = [];
  bool _isLoading = false;
  String? _errorMessage;

  BookingController({
    required ReservationRepository reservationRepository,
    required VehicleRepository vehicleRepository,
    required CustomerProfileRepository profileRepository,
    required CampaignRepository campaignRepository,
    required Clock clock,
  }) : _reservationRepository = reservationRepository,
       _vehicleRepository = vehicleRepository,
       _profileRepository = profileRepository,
       _campaignRepository = campaignRepository,
       _clock = clock;

  List<Reservation> get myReservations => _myReservations;
  VehicleRepository get vehicleRepository => _vehicleRepository;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadCustomerReservations(String customerId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _myReservations = await _reservationRepository.getCustomerReservations(
        customerId,
        actorCustomerId: customerId,
      );
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e is AppException
          ? e.message
          : 'Rezervasyonlar yüklenirken bir hata oluştu.';
      notifyListeners();
    }
  }

  /// Calculates pricing snapshot preview
  Future<PriceCalculationResult> calculatePricePreview({
    required Vehicle vehicle,
    required DateTime startAt,
    required DateTime endAt,
  }) async {
    final dayCount = DateFormatter.calculateDayCount(startAt, endAt);
    final campaigns = await _campaignRepository.getCompanyCampaigns(
      vehicle.companyId,
    );

    return PricingCalculator.calculate(
      dailyRate: vehicle.dailyRate,
      dayCount: dayCount,
      vehicleId: vehicle.id,
      startAt: startAt,
      endAt: endAt,
      availableCampaigns: campaigns,
    );
  }

  /// Validates and creates a new reservation
  Future<Reservation?> createReservation({
    required String customerId,
    required Vehicle vehicle,
    required DateTime startAt,
    required DateTime endAt,
    required String pickupLocation,
    required String returnLocation,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final profile = await _profileRepository.getProfile(customerId);
      if (profile == null) {
        throw const BookingException(
          'Rezervasyon yapabilmek için müşteri profil bilgilerinizi doldurmalısınız.',
        );
      }

      final existingReservations = await _reservationRepository
          .getVehicleReservations(vehicle.id);

      // Validate bookability
      BookingValidatorService.validateBookability(
        vehicle: vehicle,
        customerProfile: profile,
        startAt: startAt,
        endAt: endAt,
        existingVehicleReservations: existingReservations,
        currentTime: _clock.now(),
      );

      // Calculate price snapshot
      final priceResult = await calculatePricePreview(
        vehicle: vehicle,
        startAt: startAt,
        endAt: endAt,
      );

      final newReservation = Reservation(
        id: 'res_${DateTime.now().millisecondsSinceEpoch}',
        vehicleId: vehicle.id,
        companyId: vehicle.companyId,
        customerId: customerId,
        startAt: startAt,
        endAt: endAt,
        pickupLocation: pickupLocation,
        returnLocation: returnLocation,
        dayCount: priceResult.dayCount,
        basePrice: priceResult.basePrice,
        discountAmount: priceResult.discountAmount,
        totalPrice: priceResult.totalPrice,
        appliedCampaignId: priceResult.appliedCampaign?.id,
        status: ReservationStatus.confirmed,
        createdAt: _clock.now(),
      );

      final created = await _reservationRepository.createReservation(
        newReservation,
        actorCustomerId: customerId,
      );

      _myReservations.insert(0, created);
      _isLoading = false;
      notifyListeners();
      return created;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e is AppException
          ? e.message
          : 'Rezervasyon oluşturulurken bir hata oluştu.';
      notifyListeners();
      return null;
    }
  }

  /// Cancels confirmed reservation for customer
  Future<bool> cancelReservation({
    required String reservationId,
    required String customerId,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final updated = await _reservationRepository.updateStatus(
        reservationId: reservationId,
        newStatus: ReservationStatus.cancelled,
        actorId: customerId,
        actorRole: UserRole.customer,
      );

      final index = _myReservations.indexWhere((r) => r.id == reservationId);
      if (index >= 0) {
        _myReservations[index] = updated;
      }
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e is AppException
          ? e.message
          : 'Rezervasyon iptal edilirken bir hata oluştu.';
      notifyListeners();
      return false;
    }
  }
}
