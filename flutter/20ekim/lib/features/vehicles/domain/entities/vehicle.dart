import '../../../../core/enums/fuel_type.dart';
import '../../../../core/enums/transmission_type.dart';
import 'date_range.dart';

class Vehicle {
  final String id;
  final String companyId;
  final String brand;
  final String model;
  final int year;
  final TransmissionType transmission;
  final FuelType fuel;
  final int seats;
  final int dailyRate; // in kuruş (minor currency unit: 150000 = 1500 TL)
  final List<String> images;
  final String pickupLocation;
  final bool isActive;
  final List<DateRange> blockedPeriods;
  final int minDriverAge;
  final int minLicenceYears;

  const Vehicle({
    required this.id,
    required this.companyId,
    required this.brand,
    required this.model,
    required this.year,
    required this.transmission,
    required this.fuel,
    required this.seats,
    required this.dailyRate,
    required this.images,
    required this.pickupLocation,
    this.isActive = true,
    this.blockedPeriods = const [],
    this.minDriverAge = 21,
    this.minLicenceYears = 1,
  });

  String get fullName => '$brand $model';

  /// Check if requested interval [startAt, endAt) overlaps with any blocked period.
  bool isBlockedIn(DateTime startAt, DateTime endAt) {
    for (final period in blockedPeriods) {
      if (period.overlapsWith(startAt, endAt)) {
        return true;
      }
    }
    return false;
  }

  Vehicle copyWith({
    String? id,
    String? companyId,
    String? brand,
    String? model,
    int? year,
    TransmissionType? transmission,
    FuelType? fuel,
    int? seats,
    int? dailyRate,
    List<String>? images,
    String? pickupLocation,
    bool? isActive,
    List<DateRange>? blockedPeriods,
    int? minDriverAge,
    int? minLicenceYears,
  }) {
    return Vehicle(
      id: id ?? this.id,
      companyId: companyId ?? this.companyId,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      year: year ?? this.year,
      transmission: transmission ?? this.transmission,
      fuel: fuel ?? this.fuel,
      seats: seats ?? this.seats,
      dailyRate: dailyRate ?? this.dailyRate,
      images: images ?? this.images,
      pickupLocation: pickupLocation ?? this.pickupLocation,
      isActive: isActive ?? this.isActive,
      blockedPeriods: blockedPeriods ?? this.blockedPeriods,
      minDriverAge: minDriverAge ?? this.minDriverAge,
      minLicenceYears: minLicenceYears ?? this.minLicenceYears,
    );
  }
}
