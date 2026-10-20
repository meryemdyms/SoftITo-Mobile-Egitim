import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../../core/enums/user_role.dart';
import '../../../../core/errors/app_exceptions.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthController extends ChangeNotifier {
  final AuthRepository _authRepository;
  StreamSubscription<User?>? _sub;

  User? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;
  String? _returnTo;

  AuthController({required AuthRepository authRepository})
    : _authRepository = authRepository {
    _currentUser = _authRepository.currentUser;
    _sub = _authRepository.authStateChanges.listen((user) {
      _currentUser = user;
      notifyListeners();
    });
  }

  User? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isCustomer => _currentUser?.role == UserRole.customer;
  bool get isCompany => _currentUser?.role == UserRole.company;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get returnTo => _returnTo;

  void setReturnTo(String? path) {
    _returnTo = path;
  }

  void clearReturnTo() {
    _returnTo = null;
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<bool> login({
    required String email,
    required String password,
    required UserRole role,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentUser = await _authRepository.login(
        email: email,
        password: password,
        role: role,
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e is AppException
          ? e.message
          : 'Giriş yapılırken bir hata oluştu.';
      notifyListeners();
      return false;
    }
  }

  Future<bool> registerCustomer({
    required String name,
    required String email,
    required String phone,
    required String password,
    required DateTime birthDate,
    required String drivingLicenceNumber,
    required String licenceClass,
    required DateTime issueDate,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentUser = await _authRepository.registerCustomer(
        name: name,
        email: email,
        phone: phone,
        password: password,
        birthDate: birthDate,
        drivingLicenceNumber: drivingLicenceNumber,
        licenceClass: licenceClass,
        issueDate: issueDate,
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e is AppException
          ? e.message
          : 'Kayıt olunurken bir hata oluştu.';
      notifyListeners();
      return false;
    }
  }

  Future<bool> registerCompany({
    required String companyName,
    required String contactName,
    required String email,
    required String phone,
    required String password,
    required String address,
    required String description,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentUser = await _authRepository.registerCompany(
        companyName: companyName,
        contactName: contactName,
        email: email,
        phone: phone,
        password: password,
        address: address,
        description: description,
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e is AppException
          ? e.message
          : 'Firma kaydı oluşturulurken bir hata oluştu.';
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();
    await _authRepository.logout();
    _currentUser = null;
    _returnTo = null;
    _isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
