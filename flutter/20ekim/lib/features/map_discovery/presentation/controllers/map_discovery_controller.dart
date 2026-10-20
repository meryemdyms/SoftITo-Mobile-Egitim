import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/errors/app_exceptions.dart';
import '../../../companies/domain/entities/company.dart';
import '../../../companies/domain/repositories/company_repository.dart';

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

  List<Company> get companies => _companies;
  Company? get selectedCompany => _selectedCompany;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  LatLng? get userSimulatedLocation => _userSimulatedLocation;
  bool get locationPermissionGranted => _locationPermissionGranted;

  void selectCompany(Company? company) {
    _selectedCompany = company;
    notifyListeners();
  }

  void toggleSimulatedLocationPermission() {
    _locationPermissionGranted = !_locationPermissionGranted;
    if (_locationPermissionGranted) {
      // Default to Kadıköy / Üsküdar center for demo
      _userSimulatedLocation = const LatLng(41.0000, 29.0400);
    } else {
      _userSimulatedLocation = null;
    }
    notifyListeners();
  }

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

  double _degreesToRadians(double degrees) => degrees * pi / 180;

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
