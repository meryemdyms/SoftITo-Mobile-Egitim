import 'package:flutter/foundation.dart';

/// Cep Müzem — Takip İlişkisi Modeli (FollowModel)
///
/// project.md Madde 13 ve 16 spesifikasyonu:
/// - Açık hesaplarda doğrudan takip oluşur ('accepted').
/// - Gizli hesaplarda onay bekleyen istek oluşur ('pending').
@immutable
class FollowModel {
  /// Takip eden kullanıcının kimliği
  final String followerId;

  /// Takip edilen kullanıcının kimliği
  final String followingId;

  /// Takip durumu ('pending' veya 'accepted')
  final String status;

  /// Takip veya istek oluşturulma zamanı
  final DateTime createdAt;

  const FollowModel({
    required this.followerId,
    required this.followingId,
    required this.status,
    required this.createdAt,
  });
}

/// Cep Müzem — Müze Beğeni Modeli (MuseumLikeModel)
///
/// Bir kullanıcı bir müzeyi yalnızca bir kez beğenebilir.
@immutable
class MuseumLikeModel {
  /// Beğenilen müzenin kimliği
  final String museumId;

  /// Beğenen kullanıcının kimliği
  final String userId;

  /// Beğeni zamanı
  final DateTime createdAt;

  const MuseumLikeModel({
    required this.museumId,
    required this.userId,
    required this.createdAt,
  });
}

/// Cep Müzem — Ziyaretçi Notu / Yorum Modeli (MuseumCommentModel)
///
/// project.md Madde 13: Boş yorum gönderilemez; ziyaretçinin bıraktığı notu saklar.
@immutable
class MuseumCommentModel {
  /// Yorumun benzersiz kimliği
  final String id;

  /// Yorumun ait olduğu müzenin kimliği
  final String museumId;

  /// Yorumu yazan kullanıcının kimliği
  final String authorId;

  /// Yorumu yazan kullanıcının adı
  final String authorName;

  /// Yorumu yazan kullanıcının profil fotoğrafı URL'si
  final String? authorPhotoUrl;

  /// Yorum / ziyaretçi notu metni
  final String text;

  /// Yorumun yazıldığı tarih
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

/// Cep Müzem — Kaydedilen Müze / Yer İmi Modeli (SavedMuseumModel)
///
/// project.md Madde 13:
/// - Beğeniden bağımsızdır.
/// - Aynı müze bir kez kaydedilir ve profilde listelenir.
/// - Kaydetmek erişim hakkı sağlamaz.
@immutable
class SavedMuseumModel {
  /// Müzeyi kaydeden kullanıcının kimliği
  final String userId;

  /// Kaydedilen müzenin kimliği
  final String museumId;

  /// Kaydedilme zamanı
  final DateTime savedAt;

  const SavedMuseumModel({
    required this.userId,
    required this.museumId,
    required this.savedAt,
  });
}

