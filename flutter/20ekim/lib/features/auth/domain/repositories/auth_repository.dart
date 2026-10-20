import '../../../../core/enums/user_role.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  User? get currentUser;
  Stream<User?> get authStateChanges;

  Future<User> login({
    required String email,
    required String password,
    required UserRole role,
  });

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

  Future<User> registerCompany({
    required String companyName,
    required String contactName,
    required String email,
    required String phone,
    required String password,
    required String address,
    required String description,
  });

  Future<void> logout();
}
