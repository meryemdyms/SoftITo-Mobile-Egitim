import 'package:flutter/foundation.dart';

/// Müzenin yayınlanma yaşam döngüsü durumları (project.md Madde 10)
enum MuseumStatus {
  /// Taslak durumunda; henüz yayınlanmadı
  draft,

  /// Medyalar ve sahne yükleniyor
  publishing,

  /// Başarıyla yayınlandı, ziyarete ve keşfe açık
  published,

  /// Küratör tarafından arşive kaldırıldı
  archived;

  /// String değerden [MuseumStatus] türeten yardımcı metot
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

/// Cep Müzem — Müze Veri Modeli (MuseumModel)
///
/// project.md Madde 16 veri modelleri spesifikasyonu:
/// - id, ownerId, title, description, coverUrl, location
/// - status, sceneVersion, likeCount, commentCount, likeCount30d, commentCount30d
/// - createdAt, publishedAt, updatedAt
///
/// Popülerlik Skoru Formülü (project.md Madde 8 & 16):
/// score = likeCount30d + (2 * commentCount30d)
@immutable
class MuseumModel {
  /// Müzenin benzersiz kimliği
  final String id;

  /// Müzeyi oluşturan küratörün kimliği
  final String ownerId;

  /// Müzenin başlığı / adı
  final String title;

  /// Müzenin kısa açıklaması ve küratör metni
  final String description;

  /// Müzenin sergi kataloğu kapak görseli URL'si
  final String coverUrl;

  /// İsteğe bağlı coğrafi konum açıklaması (ör. "Galata, İstanbul")
  final String? location;

  /// Müzenin yayınlanma durumu (draft, publishing, published, archived)
  final MuseumStatus status;

  /// Gelecekte 3D renderer desteği için sahne şema versiyonu (Varsayılan: 1)
  final int sceneVersion;

  /// Toplam beğeni sayısı
  final int likeCount;

  /// Toplam yorum sayısı
  final int commentCount;

  /// Popülerlik algoritması için son 30 gündeki beğeni sayısı
  final int likeCount30d;

  /// Popülerlik algoritması için son 30 gündeki yorum sayısı
  final int commentCount30d;

  /// Müzenin oluşturulma tarihi
  final DateTime createdAt;

  /// Müzenin yayınlanma tarihi
  final DateTime? publishedAt;

  /// Müzenin son güncellenme tarihi
  final DateTime updatedAt;

  // View katmanında hızlı erişim için zenginleştirilmiş alanlar
  /// Küratörün adı
  final String? ownerName;

  /// Küratörün profil fotoğrafı URL'si
  final String? ownerPhotoUrl;

  /// Aktif oturum kullanıcısı tarafından kaydedilip kaydedilmediği
  final bool isSavedByCurrentUser;

  /// Aktif oturum kullanıcısı tarafından beğenilip beğenilmediği
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
  ///
  /// Son 30 günlük etkileşimler kullanılır:
  /// - 1 beğeni = 1 puan
  /// - 1 yorum = 2 puan
  ///
  /// score = likeCount30d + (2 * commentCount30d)
  int get popularityScore => likeCount30d + (2 * commentCount30d);

  /// Değişmez (immutable) nesneyi kopyalar
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

