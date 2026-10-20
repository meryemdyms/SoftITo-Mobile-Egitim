import '../../../../core/enums/reservation_status.dart';

class Reservation {
  final String id;
  final String vehicleId;
  final String companyId;
  final String customerId;
  final DateTime startAt;
  final DateTime endAt;
  final String pickupLocation;
  final String returnLocation;
  final int dayCount;
  final int basePrice; // in kuruş
  final int discountAmount; // in kuruş
  final int totalPrice; // in kuruş
  final String? appliedCampaignId;
  final ReservationStatus status;
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

  /// True if reservation occupies the vehicle calendar
  /// Only confirmed and active status occupy calendar according to Rule 5 & 7.
  bool get blocksCalendar =>
      status == ReservationStatus.confirmed ||
      status == ReservationStatus.active;

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
