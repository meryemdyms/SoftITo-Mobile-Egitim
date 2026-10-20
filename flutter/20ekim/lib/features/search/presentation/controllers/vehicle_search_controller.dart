import 'package:flutter/foundation.dart';

import '../../../../core/enums/fuel_type.dart';
import '../../../../core/enums/transmission_type.dart';
import '../../../../core/errors/app_exceptions.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../bookings/domain/repositories/reservation_repository.dart';
import '../../../bookings/domain/services/booking_validator_service.dart';
import '../../../companies/domain/entities/company.dart';
import '../../../companies/domain/repositories/company_repository.dart';
import '../../../vehicles/domain/entities/vehicle.dart';
import '../../../vehicles/domain/repositories/vehicle_repository.dart';

class VehicleSearchController extends ChangeNotifier {
  final VehicleRepository _vehicleRepository;
  final ReservationRepository _reservationRepository;
  final CompanyRepository _companyRepository;

  // Search parameters
  String _pickupLocation = 'İstanbul / Kadıköy';
  String _returnLocation = 'İstanbul / Kadıköy';
  DateTime _startDateTime = DateTime.now().add(
    const Duration(days: 1, hours: 2),
  );
  DateTime _endDateTime = DateTime.now().add(const Duration(days: 4, hours: 2));

  // Filters
  TransmissionType? _selectedTransmission;
  FuelType? _selectedFuel;
  String? _selectedCompanyId;
  int? _maxDailyRate; // kuruş
  String _sortBy = 'recommended'; // 'price_asc', 'price_desc', 'recommended'

  // State
  bool _isLoading = false;
  String? _errorMessage;
  List<Vehicle> _allVehicles = [];
  List<Vehicle> _filteredVehicles = [];
  Map<String, Company> _companiesMap = {};

  VehicleSearchController({
    required VehicleRepository vehicleRepository,
    required ReservationRepository reservationRepository,
    required CompanyRepository companyRepository,
  }) : _vehicleRepository = vehicleRepository,
       _reservationRepository = reservationRepository,
       _companyRepository = companyRepository;

  String get pickupLocation => _pickupLocation;
  String get returnLocation => _returnLocation;
  DateTime get startDateTime => _startDateTime;
  DateTime get endDateTime => _endDateTime;
  int get dayCount =>
      DateFormatter.calculateDayCount(_startDateTime, _endDateTime);

  TransmissionType? get selectedTransmission => _selectedTransmission;
  FuelType? get selectedFuel => _selectedFuel;
  String? get selectedCompanyId => _selectedCompanyId;
  int? get maxDailyRate => _maxDailyRate;
  String get sortBy => _sortBy;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<Vehicle> get vehicles => _filteredVehicles;
  Map<String, Company> get companiesMap => _companiesMap;

  void setSearchDates({
    required DateTime start,
    required DateTime end,
    String? pickup,
    String? returnLoc,
  }) {
    _startDateTime = start;
    _endDateTime = end;
    if (pickup != null) _pickupLocation = pickup;
    if (returnLoc != null) _returnLocation = returnLoc;
    searchVehicles();
  }

  void setFilter({
    TransmissionType? transmission,
    FuelType? fuel,
    String? companyId,
    int? maxRate,
    bool clearTransmission = false,
    bool clearFuel = false,
    bool clearCompany = false,
    bool clearMaxRate = false,
  }) {
    if (clearTransmission)
      _selectedTransmission = null;
    else if (transmission != null)
      _selectedTransmission = transmission;

    if (clearFuel)
      _selectedFuel = null;
    else if (fuel != null)
      _selectedFuel = fuel;

    if (clearCompany)
      _selectedCompanyId = null;
    else if (companyId != null)
      _selectedCompanyId = companyId;

    if (clearMaxRate)
      _maxDailyRate = null;
    else if (maxRate != null)
      _maxDailyRate = maxRate;

    _applyFiltersAndSort();
    notifyListeners();
  }

  void resetFilters() {
    _selectedTransmission = null;
    _selectedFuel = null;
    _selectedCompanyId = null;
    _maxDailyRate = null;
    _sortBy = 'recommended';
    _applyFiltersAndSort();
    notifyListeners();
  }

  void setSortBy(String sort) {
    _sortBy = sort;
    _applyFiltersAndSort();
    notifyListeners();
  }

  Future<void> searchVehicles() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final companies = await _companyRepository.getAllCompanies();
      _companiesMap = {for (var c in companies) c.id: c};

      final activeVehicles = await _vehicleRepository.getVehicles(
        activeOnly: true,
      );

      // Check calendar availability for each vehicle
      final List<Vehicle> availableVehicles = [];
      for (final vehicle in activeVehicles) {
        final reservations = await _reservationRepository
            .getVehicleReservations(vehicle.id);
        final isAvailable = BookingValidatorService.isVehicleAvailable(
          vehicle: vehicle,
          startAt: _startDateTime,
          endAt: _endDateTime,
          existingVehicleReservations: reservations,
        );
        if (isAvailable) {
          availableVehicles.add(vehicle);
        }
      }

      _allVehicles = availableVehicles;
      _applyFiltersAndSort();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e is AppException
          ? e.message
          : 'Araçlar yüklenirken bir hata oluştu.';
      notifyListeners();
    }
  }

  void _applyFiltersAndSort() {
    var result = List<Vehicle>.from(_allVehicles);

    if (_selectedTransmission != null) {
      result = result
          .where((v) => v.transmission == _selectedTransmission)
          .toList();
    }
    if (_selectedFuel != null) {
      result = result.where((v) => v.fuel == _selectedFuel).toList();
    }
    if (_selectedCompanyId != null) {
      result = result.where((v) => v.companyId == _selectedCompanyId).toList();
    }
    if (_maxDailyRate != null) {
      result = result.where((v) => v.dailyRate <= _maxDailyRate!).toList();
    }

    if (_sortBy == 'price_asc') {
      result.sort((a, b) => a.dailyRate.compareTo(b.dailyRate));
    } else if (_sortBy == 'price_desc') {
      result.sort((a, b) => b.dailyRate.compareTo(a.dailyRate));
    }

    _filteredVehicles = result;
  }
}
