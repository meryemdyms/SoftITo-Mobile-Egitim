import '../../../../core/enums/reservation_status.dart';

/// Araç kiralama rezervasyonunu temsil eden ana varlık (Entity).
///
/// Ücret, indirim, kampanya snapshot bilgileri ve rezervasyon durumunu barındırır.
class Reservation {
  /// Rezervasyonun benzersiz kimliği.
  final String id;

  /// Kiralanan aracın kimliği.
  final String vehicleId;

  /// Aracı kiralayan firmanın kimliği.
  final String companyId;

  /// Rezervasyonu oluşturan müşterinin kullanıcı kimliği.
  final String customerId;

  /// Kiralama başlangıç tarih ve saati.
  final DateTime startAt;

  /// Kiralama bitiş tarih ve saati.
  final DateTime endAt;

  /// Aracın teslim alınacağı ofis/nokta.
  final String pickupLocation;

  /// Aracın teslim edileceği iade noktası.
  final String returnLocation;

  /// Hesaplanmış kiralama gün sayısı: `ceil(toplam_saat / 24)`.
  final int dayCount;

  /// İndirimsiz ham taban bedel (kuruş).
  final int basePrice;

  /// Uygulanan indirim tutarı (kuruş).
  final int discountAmount;

  /// Nihai toplam kiralama bedeli (kuruş).
  final int totalPrice;

  /// Uygulanan kampanyanın kimliği (indirim uygulanmadıysa null).
  final String? appliedCampaignId;

  /// Rezervasyonun güncel yaşam döngüsü durumu (`confirmed`, `active`, `completed`, `cancelled`).
  final ReservationStatus status;

  /// Rezervasyonun oluşturulma zaman damgası.
  final DateTime createdAt;

  const Reservation({
    required this.id,
    required this.vehicleId,
    required this.companyId,
    required this.customerId,
    required this.startAt,
    required this.endAt,
    required this.pickupLocation,
    required this.returnLocation,
    required this.dayCount,
    required this.basePrice,
    required this.discountAmount,
    required this.totalPrice,
    this.appliedCampaignId,
    this.status = ReservationStatus.confirmed,
    required this.createdAt,
  });

  /// Bu rezervasyonun aracın takvimini kapatıp kapatmadığını belirtir.
  ///
  /// Proje kuralı 5 & 7 gereğince yalnızca `confirmed` ve `active` durumundaki
  /// rezervasyonlar takvimi bloke eder; `cancelled` ve `completed` olanlar müsaitliği kapatmaz.
  bool get blocksCalendar =>
      status == ReservationStatus.confirmed ||
      status == ReservationStatus.active;

  /// Belirli alanları güncelleyerek yeni bir [Reservation] nesnesi üretir.
  Reservation copyWith({
    String? id,
    String? vehicleId,
    String? companyId,
    String? customerId,
    DateTime? startAt,
    DateTime? endAt,
    String? pickupLocation,
    String? returnLocation,
    int? dayCount,
    int? basePrice,
    int? discountAmount,
    int? totalPrice,
    String? appliedCampaignId,
    ReservationStatus? status,
    DateTime? createdAt,
  }) {
    return Reservation(
      id: id ?? this.id,
      vehicleId: vehicleId ?? this.vehicleId,
      companyId: companyId ?? this.companyId,
      customerId: customerId ?? this.customerId,
      startAt: startAt ?? this.startAt,
      endAt: endAt ?? this.endAt,
      pickupLocation: pickupLocation ?? this.pickupLocation,
      returnLocation: returnLocation ?? this.returnLocation,
      dayCount: dayCount ?? this.dayCount,
      basePrice: basePrice ?? this.basePrice,
      discountAmount: discountAmount ?? this.discountAmount,
      totalPrice: totalPrice ?? this.totalPrice,
      appliedCampaignId: appliedCampaignId ?? this.appliedCampaignId,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
