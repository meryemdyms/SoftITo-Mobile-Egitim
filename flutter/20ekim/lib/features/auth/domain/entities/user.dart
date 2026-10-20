import '../../../../core/enums/user_role.dart';

class User {
  final String id;
  final UserRole role;
  final String name;
  final String email;
  final String phone;

  const User({
    required this.id,
    required this.role,
    required this.name,
    required this.email,
    required this.phone,
  });

  bool get isCustomer => role == UserRole.customer;
  bool get isCompany => role == UserRole.company;

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
