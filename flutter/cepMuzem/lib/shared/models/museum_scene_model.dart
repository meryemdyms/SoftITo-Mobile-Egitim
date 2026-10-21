import 'package:flutter/foundation.dart';

import 'museum_item_model.dart';

@immutable
class MuseumRoomModel {
  final String id;
  final String museumId;
  final String name;
  final String templateId;
  final int sortOrder;
  final List<MuseumItemModel> items;

  const MuseumRoomModel({
    required this.id,
    required this.museumId,
    required this.name,
    required this.templateId,
    required this.sortOrder,
    this.items = const [],
  });

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

@immutable
class MuseumSceneModel {
  final String museumId;
  final int schemaVersion;
  final List<MuseumRoomModel> rooms;

  const MuseumSceneModel({
    required this.museumId,
    this.schemaVersion = 1,
    required this.rooms,
  });

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
