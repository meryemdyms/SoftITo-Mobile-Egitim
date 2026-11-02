import 'package:flutter/foundation.dart';

/// Cep Müzem — Eser Veri Modeli (MuseumItemModel)
///
/// project.md Madde 16 veri modelleri spesifikasyonu:
/// - id, museumId, roomId, slotId
/// - title, description, imageUrls, audioUrl
/// - positionX, positionY (0.0 - 1.0 aralığında normalize koordinatlar)
/// - sortOrder, createdAt, updatedAt
@immutable
class MuseumItemModel {
  /// Eserin benzersiz kimliği
  final String id;

  /// Ait olduğu müzenin kimliği
  final String museumId;

  /// Ait olduğu oda nesnesinin kimliği
  final String roomId;

  /// Şablondaki yuvanın kimliği (ör. 'slot_1', 'slot_2')
  final String slotId;

  /// Eserin başlığı / adı
  final String title;

  /// Eserin açıklaması ve küratör hikâyesi
  final String description;

  /// Esere ait yüksek çözünürlüklü görsel URL listesi
  final List<String> imageUrls;

  /// İsteğe bağlı sesli küratör rehberi / sesli not URL'si
  final String? audioUrl;

  /// 2D sahnedeki X ekseni konumu (0.0 ile 1.0 arasında normalize edilmiştir)
  final double positionX;

  /// 2D sahnedeki Y ekseni konumu (0.0 ile 1.0 arasında normalize edilmiştir)
  final double positionY;

  /// Eserin salon içi sıralama indeksi
  final int sortOrder;

  /// Eserin oluşturulma zamanı
  final DateTime createdAt;

  /// Eserin son güncellenme zamanı
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

  /// Değişmez (immutable) nesneyi belirli alanlarını güncelleyerek kopyalar
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

