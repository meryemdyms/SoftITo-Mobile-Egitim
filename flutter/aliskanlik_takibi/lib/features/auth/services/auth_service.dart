import 'package:flutter/foundation.dart';
import '../../../core/services/storage_service.dart';
import '../models/user_model.dart';

/// Ritmo Demo Oturum ve Kimlik Doğrulama Servisi
/// Gerçek backend entegrasyonu öncesi yerel demo oturum sağlar.
class AuthService extends ChangeNotifier {
  final StorageService storage;

  AuthService({required this.storage});

  StorageService get _storage => storage;

  static const String _keyCurrentUser = 'ritmo_current_user';
  static const String _keyOnboardingDone = 'ritmo_onboarding_done';

  UserModel? _currentUser;
  bool _hasSeenOnboarding = false;
  bool _isInitialized = false;

  UserModel? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;
  bool get hasSeenOnboarding => _hasSeenOnboarding;
  bool get isInitialized => _isInitialized;

  Future<void> init() async {
    _hasSeenOnboarding = _storage.getBool(_keyOnboardingDone) ?? false;
    final userJson = _storage.getJson(_keyCurrentUser);
    if (userJson != null) {
      _currentUser = UserModel.fromJson(userJson);
    }
    _isInitialized = true;
    notifyListeners();
  }

  /// Demo Giriş İşlemi
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    if (email.trim().isEmpty || password.trim().isEmpty) return false;

    // Demo kullanıcı (mevcut kayıtlı kullanıcı varsa onu kullanır veya yenisini üretir)
    final existingUserJson = _storage.getJson(_keyCurrentUser);
    if (existingUserJson != null) {
      _currentUser = UserModel.fromJson(existingUserJson);
    } else {
      _currentUser = UserModel(
        id: 'usr_demo_${DateTime.now().millisecondsSinceEpoch}',
        firstName: 'Ritmo',
        lastName: 'Kullanıcısı',
        email: email.trim(),
        createdAt: DateTime.now(),
      );
      await _storage.setJson(_keyCurrentUser, _currentUser!.toJson());
    }

    notifyListeners();
    return true;
  }

  /// Demo Kayıt İşlemi
  Future<bool> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    if (firstName.trim().isEmpty || email.trim().isEmpty || password.length < 6) {
      return false;
    }

    _currentUser = UserModel(
      id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
      firstName: firstName.trim(),
      lastName: lastName.trim(),
      email: email.trim(),
      createdAt: DateTime.now(),
    );

    await _storage.setJson(_keyCurrentUser, _currentUser!.toJson());
    notifyListeners();
    return true;
  }

  /// Onboarding Tamamlama
  Future<void> setOnboardingCompleted() async {
    _hasSeenOnboarding = true;
    await _storage.setBool(_keyOnboardingDone, true);
    notifyListeners();
  }

  /// Oturumu Kapatma
  Future<void> logout() async {
    _currentUser = null;
    await _storage.remove(_keyCurrentUser);
    notifyListeners();
  }
}
