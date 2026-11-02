import 'dart:async';

import '../../../shared/models/user_model.dart';
import 'auth_repository.dart';

/// Cep Müzem — Demo Kimlik Doğrulama Repository İmplementasyonu (MockAuthRepository)
///
/// AGENTS.md ve project.md kuralları gereği:
/// - Firebase projesi yapılandırılana kadar ayrı Mock/Demo repository açıkça kullanılır.
/// - Sahte gerçek bağlantı yapılmaz; demo olduğu açıkça belirtilir.
/// - Testlerin ve uygulamanın deterministik çalışması için başlangıçta isteğe bağlı bir demo kullanıcı barındırır.
class MockAuthRepository implements AuthRepository {
  /// Bellekte tutulan aktif kullanıcı
  UserModel? _currentUser;

  /// Oturum durumu değişikliklerini yayınlayan yayıncı (broadcast) akış denetleyicisi
  final StreamController<UserModel?> _controller =
      StreamController<UserModel?>.broadcast();

  /// MockAuthRepository yapıcısı
  /// [startWithDemoUser] true olduğunda hazır bir demo küratör profili ile başlatır.
  MockAuthRepository({bool startWithDemoUser = true}) {
    if (startWithDemoUser) {
      _currentUser = _demoUser;
    }
  }

  /// Uygulamayı ilk kez açan geliştirici veya jüri için varsayılan demo küratör kullanıcısı
  static final UserModel _demoUser = UserModel(
    id: 'demo_user_001',
    firstName: 'Küratör',
    lastName: 'Ahmet',
    email: 'demo@cepmuzem.com',
    photoUrl:
        'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200',
    isPrivate: false,
    followerCount: 24,
    followingCount: 12,
    createdAt: DateTime.now().subtract(const Duration(days: 90)),
  );

  /// Demo ortamında Firebase henüz bağlı değildir
  @override
  bool get isFirebaseConfigured => false;

  /// Aktif oturum açmış kullanıcı
  @override
  UserModel? get currentUser => _currentUser;

  /// Oturum değişikliklerini dinleyen stream
  @override
  Stream<UserModel?> get authStateChanges => _controller.stream;

  /// Demo e-posta ve şifre ile giriş işlemi
  ///
  /// - Ağ gecikmesini simüle etmek için 300ms bekler.
  /// - Boş alan ve minimum 6 karakter şifre doğrulamasını kontrol eder.
  @override
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    // Gerçekçi ağ gecikmesi simülasyonu
    await Future.delayed(const Duration(milliseconds: 300));

    // Form alanı doğrulama kontrolleri
    if (email.trim().isEmpty || password.trim().isEmpty) {
      throw Exception('E-posta ve şifre boş bırakılamaz.');
    }

    if (password.length < 6) {
      throw Exception('Şifre en az 6 karakter olmalıdır.');
    }

    // Başarılı girişte demo kullanıcı nesnesi oluşturulup yayılır
    _currentUser = UserModel(
      id: 'demo_user_${DateTime.now().millisecondsSinceEpoch}',
      firstName: email.split('@').first,
      lastName: '(Demo)',
      email: email,
      photoUrl: null,
      isPrivate: false,
      followerCount: 0,
      followingCount: 0,
      createdAt: DateTime.now(),
    );

    _controller.add(_currentUser);
    return _currentUser!;
  }

  /// Demo yeni hesap oluşturma işlemi
  ///
  /// - project.md Madde 7 kurallarına göre: Ad, Soyad, E-posta ve Şifre (en az 6 karakter) zorunludur.
  @override
  Future<UserModel> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    // Ağ gecikmesi simülasyonu
    await Future.delayed(const Duration(milliseconds: 300));

    if (firstName.trim().isEmpty || lastName.trim().isEmpty) {
      throw Exception('Ad ve soyad zorunludur.');
    }
    if (email.trim().isEmpty || !email.contains('@')) {
      throw Exception('Geçerli bir e-posta adresi giriniz.');
    }
    if (password.length < 6) {
      throw Exception('Şifre en az 6 karakter olmalıdır.');
    }

    // Yeni kullanıcı nesnesi oluşturulur
    _currentUser = UserModel(
      id: 'demo_user_${DateTime.now().millisecondsSinceEpoch}',
      firstName: firstName.trim(),
      lastName: lastName.trim(),
      email: email.trim(),
      photoUrl: null,
      isPrivate: false,
      followerCount: 0,
      followingCount: 0,
      createdAt: DateTime.now(),
    );

    _controller.add(_currentUser);
    return _currentUser!;
  }

  /// Oturumu sonlandırır ve stream üzerinden `null` yayar
  @override
  Future<void> signOut() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _currentUser = null;
    _controller.add(null);
  }

  /// Bellek sızıntılarını önlemek için StreamController'ı kapatır
  void dispose() {
    _controller.close();
  }
}

