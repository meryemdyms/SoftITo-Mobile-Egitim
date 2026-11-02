import 'package:flutter/foundation.dart';

import 'museum_item_model.dart';

/// Cep Müzem — Müze Oda Veri Modeli (MuseumRoomModel)
///
/// project.md Madde 16 veri modelleri spesifikasyonu:
/// - id, museumId, name, templateId, sortOrder, items
@immutable
class MuseumRoomModel {
  /// Odanın benzersiz kimliği
  final String id;

  /// Ait olduğu müzenin kimliği
  final String museumId;

  /// Odanın adı (ör. "Giriş Salonu", "Ana Galeri")
  final String name;

  /// Kullanılan oda şablonunun kimliği (classic_gallery, stone_corridor, archive_hall)
  final String templateId;

  /// Oda sıralama indeksi
  final int sortOrder;

  /// Odadaki eser yuvalarına atanmış eser listesi
  final List<MuseumItemModel> items;

  const MuseumRoomModel({
    required this.id,
    required this.museumId,
    required this.name,
    required this.templateId,
    required this.sortOrder,
    this.items = const [],
  });

  /// Değişmez (immutable) nesneyi kopyalar
  MuseumRoomModel copyWith({
    String? id,
    String? museumId,
    String? name,
    String? templateId,
    int? sortOrder,
    List<MuseumItemModel>? items,
  }) {
    return MuseumRoomModel(
      id: id ?? this.id,
      museumId: museumId ?? this.museumId,
      name: name ?? this.name,
      templateId: templateId ?? this.templateId,
      sortOrder: sortOrder ?? this.sortOrder,
      items: items ?? this.items,
    );
  }
}

/// Cep Müzem — Müze Sahnesi Veri Modeli (MuseumSceneModel)
///
/// project.md Madde 9 & 16:
/// - Gelecekte 3D renderer eklenebilecek şekilde sahne modelleri bağımsız tasarlanır.
/// - museumId, schemaVersion, rooms listesi içerir.
@immutable
class MuseumSceneModel {
  /// Sahnenin ait olduğu müze kimliği
  final String museumId;

  /// Sahne şeması sürüm numarası
  final int schemaVersion;

  /// Müzeye ait oda modellerinin listesi
  final List<MuseumRoomModel> rooms;

  const MuseumSceneModel({
    required this.museumId,
    this.schemaVersion = 1,
    required this.rooms,
  });

  /// Değişmez (immutable) nesneyi kopyalar
  MuseumSceneModel copyWith({
    String? museumId,
    int? schemaVersion,
    List<MuseumRoomModel>? rooms,
  }) {
    return MuseumSceneModel(
      museumId: museumId ?? this.museumId,
      schemaVersion: schemaVersion ?? this.schemaVersion,
      rooms: rooms ?? this.rooms,
    );
  }
}

