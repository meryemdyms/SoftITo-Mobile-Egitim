import '../../../../core/enums/user_role.dart';

/// Sistemdeki aktif veya kayıtlı kullanıcıyı temsil eden değişmez (immutable) varlık.
class User {
  /// Kullanıcı benzersiz kimliği.
  final String id;

  /// Kullanıcının rolü (`customer` veya `company`).
  final UserRole role;

  /// Kullanıcı adı ve soyadı veya yetkili kişi adı.
  final String name;

  /// İletişim ve giriş için e-posta adresi.
  final String email;

  /// İletişim telefon numarası.
  final String phone;

  const User({
    required this.id,
    required this.role,
    required this.name,
    required this.email,
    required this.phone,
  });

  /// Kullanıcının bireysel müşteri olup olmadığını kontrol eder.
  bool get isCustomer => role == UserRole.customer;

  /// Kullanıcının kiralama firması olup olmadığını kontrol eder.
  bool get isCompany => role == UserRole.company;

  /// Belirli alanları güncelleyerek yeni bir [User] nesnesi üretir.
  User copyWith({
    String? id,
    UserRole? role,
    String? name,
    String? email,
    String? phone,
  }) {
    return User(
      id: id ?? this.id,
      role: role ?? this.role,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
    );
  }
}
