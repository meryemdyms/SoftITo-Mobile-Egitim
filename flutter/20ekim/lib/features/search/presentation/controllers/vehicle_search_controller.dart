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

/// Araç arama, takvim müsaitliği denetleme, filtreleme ve sıralama işlemlerini yöneten ViewModel/Controller.
class VehicleSearchController extends ChangeNotifier {
  final VehicleRepository _vehicleRepository;
  final ReservationRepository _reservationRepository;
  final CompanyRepository _companyRepository;

  // Arama Parametreleri
  String _pickupLocation = 'İstanbul / Kadıköy';
  String _returnLocation = 'İstanbul / Kadıköy';
  DateTime _startDateTime = DateTime.now().add(
    const Duration(days: 1, hours: 2),
  );
  DateTime _endDateTime = DateTime.now().add(const Duration(days: 4, hours: 2));

  // Filtreler
  TransmissionType? _selectedTransmission;
  FuelType? _selectedFuel;
  String? _selectedCompanyId;
  int? _maxDailyRate; // kuruş cinsinden tamsayı
  String _sortBy = 'recommended'; // 'price_asc', 'price_desc', 'recommended'

  // Durum
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

  /// Alış noktası konumu.
  String get pickupLocation => _pickupLocation;

  /// İade noktası konumu.
  String get returnLocation => _returnLocation;

  /// Kiralama başlangıç tarih ve saati.
  DateTime get startDateTime => _startDateTime;

  /// Kiralama bitiş tarih ve saati.
  DateTime get endDateTime => _endDateTime;

  /// Hesaplanmış toplam gün sayısı: `ceil(toplam_saat / 24)`.
  int get dayCount =>
      DateFormatter.calculateDayCount(_startDateTime, _endDateTime);

  /// Seçilen vites filtresi.
  TransmissionType? get selectedTransmission => _selectedTransmission;

  /// Seçilen yakıt filtresi.
  FuelType? get selectedFuel => _selectedFuel;

  /// Seçilen firma ID filtresi.
  String? get selectedCompanyId => _selectedCompanyId;

  /// Seçilen maksimum günlük ücret filtresi (kuruş).
  int? get maxDailyRate => _maxDailyRate;

  /// Seçilen sıralama kriteri.
  String get sortBy => _sortBy;

  /// Arama işlemi yükleniyor mu?
  bool get isLoading => _isLoading;

  /// Hata mesajı (varsa).
  String? get errorMessage => _errorMessage;

  /// Filtrelenmiş ve sıralanmış araç listesi.
  List<Vehicle> get vehicles => _filteredVehicles;

  /// Araç kartlarında firma adını hızlı göstermek için firma haritası.
  Map<String, Company> get companiesMap => _companiesMap;

  /// Arama tarihlerini ve konumlarını günceller ve müsait araçları yeniden arar.
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

  /// Filtre kriterlerini günceller ve listeyi filtreler.
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
    if (clearTransmission) {
      _selectedTransmission = null;
    } else if (transmission != null) {
      _selectedTransmission = transmission;
    }

    if (clearFuel) {
      _selectedFuel = null;
    } else if (fuel != null) {
      _selectedFuel = fuel;
    }

    if (clearCompany) {
      _selectedCompanyId = null;
    } else if (companyId != null) {
      _selectedCompanyId = companyId;
    }

    if (clearMaxRate) {
      _maxDailyRate = null;
    } else if (maxRate != null) {
      _maxDailyRate = maxRate;
    }

    _applyFiltersAndSort();
    notifyListeners();
  }

  /// Tüm filtreleri sıfırlar ve varsayılana döner.
  void resetFilters() {
    _selectedTransmission = null;
    _selectedFuel = null;
    _selectedCompanyId = null;
    _maxDailyRate = null;
    _sortBy = 'recommended';
    _applyFiltersAndSort();
    notifyListeners();
  }

  /// Sıralama türünü ayarlar ('price_asc', 'price_desc', 'recommended').
  void setSortBy(String sort) {
    _sortBy = sort;
    _applyFiltersAndSort();
    notifyListeners();
  }

  /// Seçili tarih aralığında çakışmayan ve aktif olan araçları arar.
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

      // Her aracın seçili tarih aralığında müsait olup olmadığı kontrol edilir
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

  /// Filtreleri ve sıralama kurallarını araç listesine uygular.
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
