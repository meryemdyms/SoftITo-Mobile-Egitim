import '../../../../core/enums/user_role.dart';
import '../entities/user.dart';

/// Kimlik doğrulama, kullanıcı oturumu ve kayıt işlemlerini tanımlayan sözleşme (Interface).
abstract class AuthRepository {
  /// Şu anda oturum açmış kullanıcı (oturum yoksa null).
  User? get currentUser;

  /// Oturum durumu değişikliklerini anlık olarak bildiren veri akışı (stream).
  Stream<User?> get authStateChanges;

  /// E-posta, şifre ve rol ile giriş yapar.
  Future<User> login({
    required String email,
    required String password,
    required UserRole role,
  });

  /// Yeni bireysel müşteri ve ehliyet profili kaydı oluşturur.
  Future<User> registerCustomer({
    required String name,
    required String email,
    required String phone,
    required String password,
    required DateTime birthDate,
    required String drivingLicenceNumber,
    required String licenceClass,
    required DateTime issueDate,
  });

  /// Yeni araç kiralama firması ve firma vitrin kaydı oluşturur.
  Future<User> registerCompany({
    required String companyName,
    required String contactName,
    required String email,
    required String phone,
    required String password,
    required String address,
    required String description,
  });

  /// Mevcut oturumu kapatır.
  Future<void> logout();
}
