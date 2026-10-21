import 'dart:async';

import '../../../shared/models/user_model.dart';
import 'auth_repository.dart';

/// Firebase yapılandırması henüz tamamlanmadığı için kullanılan DEMO Auth Repository.
/// Demo durumu kullanıcıya ve sisteme açıkça belirtilir.
class MockAuthRepository implements AuthRepository {
  UserModel? _currentUser;
  final StreamController<UserModel?> _controller =
      StreamController<UserModel?>.broadcast();

  MockAuthRepository({bool startWithDemoUser = true}) {
    if (startWithDemoUser) {
      _currentUser = _demoUser;
    }
  }

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

  @override
  bool get isFirebaseConfigured => false;

  @override
  UserModel? get currentUser => _currentUser;

  @override
  Stream<UserModel?> get authStateChanges => _controller.stream;

  @override
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    // Simüle ağ gecikmesi
    await Future.delayed(const Duration(milliseconds: 300));

    if (email.trim().isEmpty || password.trim().isEmpty) {
      throw Exception('E-posta ve şifre boş bırakılamaz.');
    }

    if (password.length < 6) {
      throw Exception('Şifre en az 6 karakter olmalıdır.');
    }

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

  @override
  Future<UserModel> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
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

  @override
  Future<void> signOut() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _currentUser = null;
    _controller.add(null);
  }

  void dispose() {
    _controller.close();
  }
}
