import 'package:flutter/foundation.dart';

enum MuseumStatus {
  draft,
  publishing,
  published,
  archived;

  static MuseumStatus fromString(String value) {
    switch (value) {
      case 'draft':
        return MuseumStatus.draft;
      case 'publishing':
        return MuseumStatus.publishing;
      case 'published':
        return MuseumStatus.published;
      case 'archived':
        return MuseumStatus.archived;
      default:
        return MuseumStatus.draft;
    }
  }

  String get value => name;
}

@immutable
class MuseumModel {
  final String id;
  final String ownerId;
  final String title;
  final String description;
  final String coverUrl;
  final String? location;
  final MuseumStatus status;
  final int sceneVersion;
  final int likeCount;
  final int commentCount;
  final int likeCount30d;
  final int commentCount30d;
  final DateTime createdAt;
  final DateTime? publishedAt;
  final DateTime updatedAt;

  // View kolaylığı için ek profil bilgileri
  final String? ownerName;
  final String? ownerPhotoUrl;
  final bool isSavedByCurrentUser;
  final bool isLikedByCurrentUser;

  const MuseumModel({
    required this.id,
    required this.ownerId,
    required this.title,
    required this.description,
    required this.coverUrl,
    this.location,
    required this.status,
    this.sceneVersion = 1,
    this.likeCount = 0,
    this.commentCount = 0,
    this.likeCount30d = 0,
    this.commentCount30d = 0,
    required this.createdAt,
    this.publishedAt,
    required this.updatedAt,
    this.ownerName,
    this.ownerPhotoUrl,
    this.isSavedByCurrentUser = false,
    this.isLikedByCurrentUser = false,
  });

  /// Kesin Popülerlik Algoritması (project.md Madde 8 & 16):
  /// score = likeCount30d + (2 * commentCount30d)
  int get popularityScore => likeCount30d + (2 * commentCount30d);

  MuseumModel copyWith({
    String? id,
    String? ownerId,
    String? title,
    String? description,
    String? coverUrl,
    String? location,
    MuseumStatus? status,
    int? sceneVersion,
    int? likeCount,
    int? commentCount,
    int? likeCount30d,
    int? commentCount30d,
    DateTime? createdAt,
    DateTime? publishedAt,
    DateTime? updatedAt,
    String? ownerName,
    String? ownerPhotoUrl,
    bool? isSavedByCurrentUser,
    bool? isLikedByCurrentUser,
  }) {
    return MuseumModel(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      title: title ?? this.title,
      description: description ?? this.description,
      coverUrl: coverUrl ?? this.coverUrl,
      location: location ?? this.location,
      status: status ?? this.status,
      sceneVersion: sceneVersion ?? this.sceneVersion,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount ?? this.commentCount,
      likeCount30d: likeCount30d ?? this.likeCount30d,
      commentCount30d: commentCount30d ?? this.commentCount30d,
      createdAt: createdAt ?? this.createdAt,
      publishedAt: publishedAt ?? this.publishedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      ownerName: ownerName ?? this.ownerName,
      ownerPhotoUrl: ownerPhotoUrl ?? this.ownerPhotoUrl,
      isSavedByCurrentUser: isSavedByCurrentUser ?? this.isSavedByCurrentUser,
      isLikedByCurrentUser: isLikedByCurrentUser ?? this.isLikedByCurrentUser,
    );
  }
}
