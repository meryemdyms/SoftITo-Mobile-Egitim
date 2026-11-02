import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/errors/app_exceptions.dart';
import '../../../companies/domain/entities/company.dart';
import '../../../companies/domain/repositories/company_repository.dart';

/// Harita keşif ekranında kiralama firmalarının konumlarını, mesafe hesaplamalarını
/// ve simüle edilmiş konum izinlerini yöneten ViewModel/Controller.
class MapDiscoveryController extends ChangeNotifier {
  final CompanyRepository _companyRepository;

  List<Company> _companies = [];
  Company? _selectedCompany;
  bool _isLoading = false;
  String? _errorMessage;
  LatLng? _userSimulatedLocation;
  bool _locationPermissionGranted = false;

  MapDiscoveryController({required CompanyRepository companyRepository})
    : _companyRepository = companyRepository;

  /// Haritada gösterilecek aktif firmalar listesi.
  List<Company> get companies => _companies;

  /// Haritada veya kartta seçilmiş aktif firma.
  Company? get selectedCompany => _selectedCompany;

  /// Harita verileri yükleniyor mu?
  bool get isLoading => _isLoading;

  /// Hata mesajı (varsa).
  String? get errorMessage => _errorMessage;

  /// Kullanıcının simüle edilmiş cihaz konumu (izin verilmediyse null).
  LatLng? get userSimulatedLocation => _userSimulatedLocation;

  /// Konum izninin verilip verilmediği durumu.
  bool get locationPermissionGranted => _locationPermissionGranted;

  /// Harita üzerinde bir firmayı seçer ve arayüzü bilgilendirir.
  void selectCompany(Company? company) {
    _selectedCompany = company;
    notifyListeners();
  }

  /// Simüle edilmiş konum iznini açar veya kapatır.
  void toggleSimulatedLocationPermission() {
    _locationPermissionGranted = !_locationPermissionGranted;
    if (_locationPermissionGranted) {
      // Demo amaçlı Kadıköy / Üsküdar merkez koordinatları atanır
      _userSimulatedLocation = const LatLng(41.0000, 29.0400);
    } else {
      _userSimulatedLocation = null;
    }
    notifyListeners();
  }

  /// Haversine formülü kullanarak kullanıcının konumu ile firma arasındaki mesafeyi (km) hesaplar.
  double? calculateDistanceKm(Company company) {
    if (_userSimulatedLocation == null) return null;
    const earthRadiusKm = 6371.0;
    final dLat = _degreesToRadians(
      company.latitude - _userSimulatedLocation!.latitude,
    );
    final dLon = _degreesToRadians(
      company.longitude - _userSimulatedLocation!.longitude,
    );

    final a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(_userSimulatedLocation!.latitude)) *
            cos(_degreesToRadians(company.latitude)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadiusKm * c;
  }

  /// Dereceyi radyana çeviren yardımcı metot.
  double _degreesToRadians(double degrees) => degrees * pi / 180;

  /// Aktif firmaların konumlarını repository üzerinden yükler.
  Future<void> loadMapCompanies() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _companies = await _companyRepository.getAllCompanies(activeOnly: true);
      if (_companies.isNotEmpty && _selectedCompany == null) {
        _selectedCompany = _companies.first;
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e is AppException
          ? e.message
          : 'Harita verisi yüklenemedi.';
      notifyListeners();
    }
  }
}
