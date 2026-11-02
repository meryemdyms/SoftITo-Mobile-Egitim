import 'package:flutter/foundation.dart';
import '../../../core/services/storage_service.dart';
import '../models/user_model.dart';

/// Ritmo Demo Oturum ve Kimlik Doğrulama Servisi.
///
/// `project.md` 3. Bölüm (Kimlik Doğrulama) kararlarına uygun olarak tasarlanmıştır:
/// Gerçek backend entegrasyonu öncesinde yerel demo oturum akışını yönetir.
/// Şifreler güvensiz şekilde düz metin olarak saklanmaz, kullanıcı durumu
/// [ChangeNotifier] ile reaktif olarak UI bileşenlerine iletilir.
class AuthService extends ChangeNotifier {
  /// Kalıcı depolama servisi
  final StorageService storage;

  AuthService({required this.storage});

  StorageService get _storage => storage;

  // Yerel depolama anahtarları
  static const String _keyCurrentUser = 'ritmo_current_user';
  static const String _keyOnboardingDone = 'ritmo_onboarding_done';

  UserModel? _currentUser;
  bool _hasSeenOnboarding = false;
  bool _isInitialized = false;

  /// Aktif oturum açmış kullanıcı (oturum yoksa null)
  UserModel? get currentUser => _currentUser;

  /// Kullanıcının oturum açıp açmadığını belirten mantıksal değer
  bool get isLoggedIn => _currentUser != null;

  /// Kullanıcının tanıtım (onboarding) adımlarını tamamlayıp tamamlamadığını belirtir
  bool get hasSeenOnboarding => _hasSeenOnboarding;

  /// Servisin yerel depodan verileri okuyup hazır hâle gelip gelmediği
  bool get isInitialized => _isInitialized;

  /// Servisi başlatır; daha önce kaydedilmiş kullanıcı ve onboarding durumunu hafızaya çeker.
  Future<void> init() async {
    _hasSeenOnboarding = _storage.getBool(_keyOnboardingDone) ?? false;
    final userJson = _storage.getJson(_keyCurrentUser);
    if (userJson != null) {
      _currentUser = UserModel.fromJson(userJson);
    }
    _isInitialized = true;
    notifyListeners();
  }

  /// Demo Giriş İşlemi.
  ///
  /// E-posta ve şifre geçerliliğini denetler, mevcut kayıtlı kullanıcı varsa onu kullanır,
  /// yoksa yeni bir demo kullanıcı modeli oluşturup yerel depoya kaydeder.
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    if (email.trim().isEmpty || password.trim().isEmpty) return false;

    // Demo kullanıcı kontrolü: Mevcut kullanıcıyı yükle veya yenisini üret
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

  /// Demo Kayıt İşlemi.
  ///
  /// Kullanıcının ad, soyad ve e-posta bilgilerini alarak yeni bir hesap oluşturur.
  /// Form geçerliliği (en az 6 haneli şifre, boş olmayan ad vb.) kontrol edilir.
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

  /// Kullanıcının tanıtım (onboarding) sürecini tamamladığını kalıcı olarak işaretler.
  Future<void> setOnboardingCompleted() async {
    _hasSeenOnboarding = true;
    await _storage.setBool(_keyOnboardingDone, true);
    notifyListeners();
  }

  /// Aktif demo oturumunu sonlandırır ve yerel depodaki kullanıcı oturumunu temizler.
  Future<void> logout() async {
    _currentUser = null;
    await _storage.remove(_keyCurrentUser);
    notifyListeners();
  }
}
