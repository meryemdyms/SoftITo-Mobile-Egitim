import 'dart:async';

import '../../../../core/enums/user_role.dart';
import '../../../../core/errors/app_exceptions.dart';
import '../../../../core/mock/mock_data_seed.dart';
import '../../../customer_profile/domain/entities/customer_profile.dart';
import '../../../customer_profile/domain/repositories/customer_profile_repository.dart';
import '../../../companies/domain/entities/company.dart';
import '../../../companies/domain/repositories/company_repository.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

class InMemoryAuthRepository implements AuthRepository {
  final CustomerProfileRepository _profileRepository;
  final CompanyRepository _companyRepository;

  final List<User> _users = List.from(MockDataSeed.initialUsers);
  final StreamController<User?> _authStateController =
      StreamController<User?>.broadcast();
  User? _currentUser;

  InMemoryAuthRepository({
    required CustomerProfileRepository profileRepository,
    required CompanyRepository companyRepository,
  }) : _profileRepository = profileRepository,
       _companyRepository = companyRepository;

  @override
  User? get currentUser => _currentUser;

  @override
  Stream<User?> get authStateChanges => _authStateController.stream;

  @override
  Future<User> login({
    required String email,
    required String password,
    required UserRole role,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final normalizedEmail = email.trim().toLowerCase();
    final user = _users.firstWhere(
      (u) => u.email.toLowerCase() == normalizedEmail && u.role == role,
      orElse: () {
        throw const AuthException('Geçersiz e-posta veya şifre girdiniz.');
      },
    );

    _currentUser = user;
    _authStateController.add(_currentUser);
    return user;
  }

  @override
  Future<User> registerCustomer({
    required String name,
    required String email,
    required String phone,
    required String password,
    required DateTime birthDate,
    required String drivingLicenceNumber,
    required String licenceClass,
    required DateTime issueDate,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final normalizedEmail = email.trim().toLowerCase();
    if (_users.any((u) => u.email.toLowerCase() == normalizedEmail)) {
      throw const AuthException(
        'Bu e-posta adresi ile kayıtlı kullanıcı bulunmaktadır.',
      );
    }

    final newId = 'user_cust_${DateTime.now().millisecondsSinceEpoch}';
    final newUser = User(
      id: newId,
      role: UserRole.customer,
      name: name.trim(),
      email: normalizedEmail,
      phone: phone.trim(),
    );

    _users.add(newUser);

    // Save profile
    final profile = CustomerProfile(
      userId: newId,
      birthDate: birthDate,
      drivingLicenceNumber: drivingLicenceNumber.trim(),
      licenceClass: licenceClass.trim(),
      issueDate: issueDate,
    );
    await _profileRepository.saveProfile(profile, actorUserId: newId);

    _currentUser = newUser;
    _authStateController.add(_currentUser);
    return newUser;
  }

  @override
  Future<User> registerCompany({
    required String companyName,
    required String contactName,
    required String email,
    required String phone,
    required String password,
    required String address,
    required String description,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final normalizedEmail = email.trim().toLowerCase();
    if (_users.any((u) => u.email.toLowerCase() == normalizedEmail)) {
      throw const AuthException(
        'Bu e-posta adresi ile kayıtlı kullanıcı bulunmaktadır.',
      );
    }

    final newUserId = 'user_comp_${DateTime.now().millisecondsSinceEpoch}';
    final newUser = User(
      id: newUserId,
      role: UserRole.company,
      name: contactName.trim(),
      email: normalizedEmail,
      phone: phone.trim(),
    );
    _users.add(newUser);

    final newCompanyId = 'comp_${DateTime.now().millisecondsSinceEpoch}';
    final newCompany = Company(
      id: newCompanyId,
      ownerUserId: newUserId,
      name: companyName.trim(),
      logo: 'https://images.unsplash.com/photo-1549399542-7e3f8b79c341?w=150',
      description: description.trim(),
      address: address.trim(),
      latitude: 41.0082,
      longitude: 28.9784,
      openingHours: '09:00 - 19:00',
      phone: phone.trim(),
      active: true,
    );

    await _companyRepository.updateCompany(newCompany, actorUserId: newUserId);

    _currentUser = newUser;
    _authStateController.add(_currentUser);
    return newUser;
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 100));
    _currentUser = null;
    _authStateController.add(null);
  }

  void dispose() {
    _authStateController.close();
  }
}
