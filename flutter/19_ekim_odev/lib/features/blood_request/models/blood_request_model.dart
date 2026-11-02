import 'package:flutter/foundation.dart';

/// Kan bağış talebini temsil eden veri modeli.
/// Değiştirilemez (immutable) yapıda olup bir hastanın veya hastanenin kan ihtiyacını belgeler.
@immutable
class BloodRequest {
  const BloodRequest({
    required this.id,
    required this.patientName,
    required this.bloodGroup,
    required this.hospitalName,
    required this.city,
    required this.unitsNeeded,
    this.unitsCollected = 0,
    required this.urgency,
    required this.createdAt,
    this.isFulfilled = false,
    this.matchedDonorCount = 0,
  });

  /// Talebin benzersiz kimlik numarası
  final String id;

  /// Kan aranan hastanın adı ve soyadı
  final String patientName;

  /// İhtiyaç duyulan kan grubu (örn: 'A+', '0-')
  final String bloodGroup;

  /// Hastanın tedavi gördüğü hastane adı
  final String hospitalName;

  /// Talebin yapıldığı şehir
  final String city;

  /// İhtiyaç duyulan toplam kan ünitesi sayısı
  final int unitsNeeded;

  /// Şu ana kadar toplanan kan ünitesi sayısı
  final int unitsCollected;

  /// Aciliyet durumu ('Normal', 'Acil', 'Çok Acil')
  final String urgency;

  /// Talebin sisteme girildiği tarih ve saat
  final DateTime createdAt;

  /// Talebin tamamlanıp kapanmadığını belirten bayrak
  final bool isFulfilled;

  /// Bu çağrıyla eşleşen veya bildirim gönderilen donör sayısı
  final int matchedDonorCount;

  /// İhtiyaç duyulan kanın ne kadarının karşılandığını veren ilerleme yüzdesi (0.0 ile 1.0 arası)
  double get progressPercentage {
    if (unitsNeeded <= 0) return 1.0;
    final ratio = unitsCollected / unitsNeeded;
    return ratio > 1.0 ? 1.0 : ratio;
  }

  /// Mevcut modelin kopyasını alarak istenen alanları güncellemeye yarayan yardımcı metot.
  BloodRequest copyWith({
    String? id,
    String? patientName,
    String? bloodGroup,
    String? hospitalName,
    String? city,
    int? unitsNeeded,
    int? unitsCollected,
    String? urgency,
    DateTime? createdAt,
    bool? isFulfilled,
    int? matchedDonorCount,
  }) {
    return BloodRequest(
      id: id ?? this.id,
      patientName: patientName ?? this.patientName,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      hospitalName: hospitalName ?? this.hospitalName,
      city: city ?? this.city,
      unitsNeeded: unitsNeeded ?? this.unitsNeeded,
      unitsCollected: unitsCollected ?? this.unitsCollected,
      urgency: urgency ?? this.urgency,
      createdAt: createdAt ?? this.createdAt,
      isFulfilled: isFulfilled ?? this.isFulfilled,
      matchedDonorCount: matchedDonorCount ?? this.matchedDonorCount,
    );
  }
}

/// Kan talepleri sayfasının anlık durumunu (State) saklayan sınıf.
@immutable
class BloodRequestState {
  const BloodRequestState({
    this.requests = const [],
    this.filterBloodGroup,
    this.isLoading = false,
  });

  /// Sistemdeki tüm kan talepleri listesi
  final List<BloodRequest> requests;

  /// Kullanıcının filtrelediği kan grubu (null ise filtre yok, hepsi listelenir)
  final String? filterBloodGroup;

  /// Yükleme durumunu belirten bayrak
  final bool isLoading;

  /// Seçili kan grubuna göre filtrelenmiş talepler listesini döndürür.
  List<BloodRequest> get filteredRequests {
    if (filterBloodGroup == null || filterBloodGroup!.isEmpty) {
      return requests;
    }
    return requests
        .where((r) => r.bloodGroup == filterBloodGroup)
        .toList();
  }

  /// Durum nesnesini güvenle güncellemek için copyWith metodu.
  BloodRequestState copyWith({
    List<BloodRequest>? requests,
    String? Function()? filterBloodGroup,
    bool? isLoading,
  }) {
    return BloodRequestState(
      requests: requests ?? this.requests,
      filterBloodGroup: filterBloodGroup != null
          ? filterBloodGroup()
          : this.filterBloodGroup,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

