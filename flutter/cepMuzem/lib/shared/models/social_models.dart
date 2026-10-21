import 'package:flutter/foundation.dart';

@immutable
class FollowModel {
  final String followerId;
  final String followingId;
  final String status; // 'pending', 'accepted'
  final DateTime createdAt;

  const FollowModel({
    required this.followerId,
    required this.followingId,
    required this.status,
    required this.createdAt,
  });
}

@immutable
class MuseumLikeModel {
  final String museumId;
  final String userId;
  final DateTime createdAt;

  const MuseumLikeModel({
    required this.museumId,
    required this.userId,
    required this.createdAt,
  });
}

@immutable
class MuseumCommentModel {
  final String id;
  final String museumId;
  final String authorId;
  final String authorName;
  final String? authorPhotoUrl;
  final String text;
  final DateTime createdAt;

  const MuseumCommentModel({
    required this.id,
    required this.museumId,
    required this.authorId,
    required this.authorName,
    this.authorPhotoUrl,
    required this.text,
    required this.createdAt,
  });
}

@immutable
class SavedMuseumModel {
  final String userId;
  final String museumId;
  final DateTime savedAt;

  const SavedMuseumModel({
    required this.userId,
    required this.museumId,
    required this.savedAt,
  });
}
