import 'package:flutter/foundation.dart';

/// Cep Müzem — Kullanıcı / Küratör Veri Modeli (UserModel)
///
/// project.md Madde 16 veri modelleri spesifikasyonu:
/// - id, firstName, lastName, email, photoUrl
/// - isPrivate, followerCount, followingCount, createdAt
@immutable
class UserModel {
  /// Kullanıcının benzersiz kimliği
  final String id;

  /// Küratörün adı
  final String firstName;

  /// Küratörün soyadı
  final String lastName;

  /// Küratörün e-posta adresi
  final String email;

  /// Profil fotoğrafı URL'si (varsa)
  final String? photoUrl;

  /// Hesabın gizlilik durumu (project.md Madde 12: gizli hesapların içerikleri yetkili takipçilere açıktır)
  final bool isPrivate;

  /// Takipçi sayısı
  final int followerCount;

  /// Takip edilen kullanıcı sayısı
  final int followingCount;

  /// Hesabın oluşturulma tarihi
  final DateTime createdAt;

  const UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.photoUrl,
    this.isPrivate = false,
    this.followerCount = 0,
    this.followingCount = 0,
    required this.createdAt,
  });

  /// Kullanıcının ad ve soyadını birleştiren yardımcı getter
  String get fullName => '$firstName $lastName'.trim();

  /// Değişmez (immutable) nesneyi kopyalar
  UserModel copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? photoUrl,
    bool? isPrivate,
    int? followerCount,
    int? followingCount,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      isPrivate: isPrivate ?? this.isPrivate,
      followerCount: followerCount ?? this.followerCount,
      followingCount: followingCount ?? this.followingCount,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

