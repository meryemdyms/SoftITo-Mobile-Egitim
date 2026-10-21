import 'package:flutter/foundation.dart';

@immutable
class UserModel {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String? photoUrl;
  final bool isPrivate;
  final int followerCount;
  final int followingCount;
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

  String get fullName => '$firstName $lastName'.trim();

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
