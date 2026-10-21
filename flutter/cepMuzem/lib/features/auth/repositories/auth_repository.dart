import '../../../shared/models/user_model.dart';

abstract class AuthRepository {
  /// Oturum durumu dinleyicisi
  Stream<UserModel?> get authStateChanges;

  /// Mevcut kullanıcı bilgisi
  UserModel? get currentUser;

  /// E-posta ve şifre ile giriş
  Future<UserModel> signIn({required String email, required String password});

  /// Ad, soyad, e-posta ve şifre ile kayıt
  Future<UserModel> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  });

  /// Oturumu kapatma
  Future<void> signOut();

  /// Gerçek Firebase yapılandırma durumu
  bool get isFirebaseConfigured;
}
