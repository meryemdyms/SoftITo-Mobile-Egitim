import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../../core/enums/user_role.dart';
import '../../../../core/errors/app_exceptions.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

/// Kimlik doğrulama, kullanıcı oturumu ve yetkilendirme durumunu yöneten ChangeNotifier kontrolcüsü (ViewModel).
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
    // Repository üzerindeki auth akışını dinleyerek oturum değişikliklerini yayınlar
    _sub = _authRepository.authStateChanges.listen((user) {
      _currentUser = user;
      notifyListeners();
    });
  }

  /// Aktif oturum açmış kullanıcı nesnesi.
  User? get currentUser => _currentUser;

  /// Kullanıcının giriş yapıp yapmadığını belirtir.
  bool get isAuthenticated => _currentUser != null;

  /// Giriş yapan kullanıcının müşteri olup olmadığını belirtir.
  bool get isCustomer => _currentUser?.role == UserRole.customer;

  /// Giriş yapan kullanıcının firma yetkilisi olup olmadığını belirtir.
  bool get isCompany => _currentUser?.role == UserRole.company;

  /// Asenkron bir kimlik doğrulama işlemi yürütülüyor mu?
  bool get isLoading => _isLoading;

  /// Son işlemde oluşan hata mesajı (varsa).
  String? get errorMessage => _errorMessage;

  /// Giriş başarılı olduktan sonra geri dönülecek hedef rota.
  String? get returnTo => _returnTo;

  /// Giriş sonrası yönlendirme için hedef rotayı kaydeder.
  void setReturnTo(String? path) {
    _returnTo = path;
  }

  /// Kayıtlı geri dönüş rotasını temizler.
  void clearReturnTo() {
    _returnTo = null;
  }

  /// Hata mesajını sıfırlar ve arayüzü günceller.
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// E-posta, şifre ve rol ile giriş yapar.
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

  /// Yeni bireysel müşteri hesabı oluşturur.
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

  /// Yeni araç kiralama firma hesabı oluşturur.
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

  /// Mevcut oturumu kapatır ve durumu temizler.
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
