import '../../../shared/models/user_model.dart';

/// Cep Müzem — Kimlik Doğrulama Repository Arabirimi (AuthRepository)
///
/// MVVM mimarisinde veri katmanı ile ViewModel arasındaki soyutlama katmanıdır.
/// UI doğrudan Firebase veya veritabanı işlemi gerçekleştirmez; bu kontratı kullanır.
///
/// Hedef mimari Firebase Authentication'dır. Firebase yapılandırması
/// sağlanmadığında MockAuthRepository bu kontratı uygulayarak demo verisi sunar.
abstract class AuthRepository {
  /// Oturum durumu değişikliklerini yayınlayan stream.
  /// Kullanıcı giriş yaptığında [UserModel], çıkış yaptığında `null` yayar.
  Stream<UserModel?> get authStateChanges;

  /// Bellekteki veya oturumdaki mevcut aktif kullanıcı bilgisi.
  /// Oturum açık değilse `null` döner.
  UserModel? get currentUser;

  /// E-posta ve şifre ile sisteme oturum açma işlemi.
  ///
  /// Başarılı olursa oturum açan [UserModel] döner,
  /// geçersiz giriş veya şifre hatalarında hata fırlatır.
  Future<UserModel> signIn({required String email, required String password});

  /// Ad, soyad, e-posta ve şifre ile yeni küratör hesabı oluşturma işlemi.
  ///
  /// project.md kuralları gereği ad, soyad, e-posta ve şifre zorunludur.
  /// Başarılı olursa oluşturulan [UserModel] döner.
  Future<UserModel> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  });

  /// Aktif kullanıcı oturumunu güvenli şekilde kapatır.
  Future<void> signOut();

  /// Gerçek Firebase projesinin yapılandırılıp yapılandırılmadığını belirtir.
  /// Mock implementasyonunda `false` döner, UI demo uyarısını bu alana göre gösterir.
  bool get isFirebaseConfigured;
}

