import 'package:flutter/foundation.dart';

import '../../../../core/enums/reservation_status.dart';
import '../../../../core/enums/user_role.dart';
import '../../../../core/errors/app_exceptions.dart';
import '../../../../core/services/clock.dart';
import '../../../bookings/domain/entities/reservation.dart';
import '../../../bookings/domain/repositories/reservation_repository.dart';
import '../../../campaigns/domain/entities/campaign.dart';
import '../../../campaigns/domain/repositories/campaign_repository.dart';
import '../../../companies/domain/entities/company.dart';
import '../../../companies/domain/repositories/company_repository.dart';
import '../../../vehicles/domain/entities/vehicle.dart';
import '../../../vehicles/domain/repositories/vehicle_repository.dart';

class CompanyDashboardController extends ChangeNotifier {
  final CompanyRepository _companyRepository;
  final VehicleRepository _vehicleRepository;
  final ReservationRepository _reservationRepository;
  final CampaignRepository _campaignRepository;
  final Clock _clock;

  Company? _company;
  List<Vehicle> _vehicles = [];
  List<Reservation> _reservations = [];
  List<Campaign> _campaigns = [];

  bool _isLoading = false;
  String? _errorMessage;

  CompanyDashboardController({
    required CompanyRepository companyRepository,
    required VehicleRepository vehicleRepository,
    required ReservationRepository reservationRepository,
    required CampaignRepository campaignRepository,
    required Clock clock,
  }) : _companyRepository = companyRepository,
       _vehicleRepository = vehicleRepository,
       _reservationRepository = reservationRepository,
       _campaignRepository = campaignRepository,
       _clock = clock;

  Company? get company => _company;
  List<Vehicle> get vehicles => _vehicles;
  List<Reservation> get reservations => _reservations;
  List<Campaign> get campaigns => _campaigns;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Stats
  int get activeRentalsCount =>
      _reservations.where((r) => r.status == ReservationStatus.active).length;

  int get upcomingReservationsCount => _reservations
      .where((r) => r.status == ReservationStatus.confirmed)
      .length;

  int get todayPickupsCount {
    final now = _clock.now();
    return _reservations.where((r) {
      return (r.status == ReservationStatus.confirmed) &&
          r.startAt.year == now.year &&
          r.startAt.month == now.month &&
          r.startAt.day == now.day;
    }).length;
  }

  int get todayReturnsCount {
    final now = _clock.now();
    return _reservations.where((r) {
      return (r.status == ReservationStatus.active) &&
          r.endAt.year == now.year &&
          r.endAt.month == now.month &&
          r.endAt.day == now.day;
    }).length;
  }

  Future<void> loadDashboardData(String ownerUserId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _company = await _companyRepository.getCompanyByOwnerUserId(ownerUserId);
      if (_company == null) {
        throw const NotFoundException('Firma kaydı bulunamadı.');
      }

      final companyId = _company!.id;
      final results = await Future.wait([
        _vehicleRepository.getCompanyVehicles(companyId),
        _reservationRepository.getCompanyReservations(
          companyId,
          actorCompanyId: companyId,
        ),
        _campaignRepository.getCompanyCampaigns(companyId),
      ]);

      _vehicles = results[0] as List<Vehicle>;
      _reservations = results[1] as List<Reservation>;
      _campaigns = results[2] as List<Campaign>;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e is AppException
          ? e.message
          : 'Firma verileri yüklenirken bir hata oluştu.';
      notifyListeners();
    }
  }

  // Vehicle Management
  Future<bool> addVehicle(Vehicle vehicle) async {
    if (_company == null) return false;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final added = await _vehicleRepository.addVehicle(
        vehicle,
        actorCompanyId: _company!.id,
      );
      _vehicles.add(added);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e is AppException
          ? e.message
          : 'Araç eklenirken bir hata oluştu.';
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateVehicle(Vehicle vehicle) async {
    if (_company == null) return false;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final updated = await _vehicleRepository.updateVehicle(
        vehicle,
        actorCompanyId: _company!.id,
      );
      final index = _vehicles.indexWhere((v) => v.id == vehicle.id);
      if (index >= 0) _vehicles[index] = updated;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e is AppException
          ? e.message
          : 'Araç güncellenirken bir hata oluştu.';
      notifyListeners();
      return false;
    }
  }

  Future<bool> toggleVehicleStatus(String vehicleId) async {
    if (_company == null) return false;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final updated = await _vehicleRepository.toggleVehicleStatus(
        vehicleId,
        actorCompanyId: _company!.id,
      );
      final index = _vehicles.indexWhere((v) => v.id == vehicleId);
      if (index >= 0) _vehicles[index] = updated;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e is AppException
          ? e.message
          : 'Araç durumu değiştirilirken bir hata oluştu.';
      notifyListeners();
      return false;
    }
  }

  // Reservation Status Management
  Future<bool> updateReservationStatus(
    String reservationId,
    ReservationStatus newStatus,
  ) async {
    if (_company == null) return false;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final updated = await _reservationRepository.updateStatus(
        reservationId: reservationId,
        newStatus: newStatus,
        actorId: _company!.id,
        actorRole: UserRole.company,
      );

      final index = _reservations.indexWhere((r) => r.id == reservationId);
      if (index >= 0) _reservations[index] = updated;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e is AppException
          ? e.message
          : 'Rezervasyon durumu güncellenirken hata oluştu.';
      notifyListeners();
      return false;
    }
  }

  // Campaign Management
  Future<bool> addCampaign(Campaign campaign) async {
    if (_company == null) return false;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final added = await _campaignRepository.addCampaign(
        campaign,
        actorCompanyId: _company!.id,
      );
      _campaigns.add(added);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e is AppException
          ? e.message
          : 'Kampanya eklenirken bir hata oluştu.';
      notifyListeners();
      return false;
    }
  }

  // Company Storefront Editor
  Future<bool> updateCompanyProfile(
    Company updatedCompany,
    String actorUserId,
  ) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _company = await _companyRepository.updateCompany(
        updatedCompany,
        actorUserId: actorUserId,
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e is AppException
          ? e.message
          : 'Firma bilgileri güncellenirken hata oluştu.';
      notifyListeners();
      return false;
    }
  }
}
