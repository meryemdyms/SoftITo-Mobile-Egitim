import 'package:flutter/foundation.dart';

@immutable
class MuseumItemModel {
  final String id;
  final String museumId;
  final String roomId;
  final String slotId;
  final String title;
  final String description;
  final List<String> imageUrls;
  final String? audioUrl;
  final double positionX; // 0.0 - 1.0 normalized
  final double positionY; // 0.0 - 1.0 normalized
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;

  const MuseumItemModel({
    required this.id,
    required this.museumId,
    required this.roomId,
    required this.slotId,
    required this.title,
    required this.description,
    required this.imageUrls,
    this.audioUrl,
    required this.positionX,
    required this.positionY,
    required this.sortOrder,
    required this.createdAt,
    required this.updatedAt,
  });

  MuseumItemModel copyWith({
    String? id,
    String? museumId,
    String? roomId,
    String? slotId,
    String? title,
    String? description,
    List<String>? imageUrls,
    String? audioUrl,
    double? positionX,
    double? positionY,
    int? sortOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MuseumItemModel(
      id: id ?? this.id,
      museumId: museumId ?? this.museumId,
      roomId: roomId ?? this.roomId,
      slotId: slotId ?? this.slotId,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrls: imageUrls ?? this.imageUrls,
      audioUrl: audioUrl ?? this.audioUrl,
      positionX: positionX ?? this.positionX,
      positionY: positionY ?? this.positionY,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
