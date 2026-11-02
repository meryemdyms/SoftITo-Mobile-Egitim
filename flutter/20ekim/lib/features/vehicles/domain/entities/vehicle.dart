import '../../../../core/enums/fuel_type.dart';
import '../../../../core/enums/transmission_type.dart';
import 'date_range.dart';

/// Platformda kiralanabilir bir aracı / ilanı temsil eden ana varlık (Entity).
///
/// Proje mimarisi gereği `Vehicle` tek araç/ilan modelidir; ayrı bir Listing entity'si bulunmaz.
class Vehicle {
  /// Aracın benzersiz kimliği.
  final String id;

  /// Aracın ait olduğu araç kiralama firmasının ID'si.
  final String companyId;

  /// Araç markası (örn. "Fiat", "Toyota").
  final String brand;

  /// Araç modeli (örn. "Egea Sedan 1.4 Fire", "Corolla Hybrid").
  final String model;

  /// Model yılı.
  final int year;

  /// Vites türü (otomatik / manuel).
  final TransmissionType transmission;

  /// Yakıt türü (benzin, dizel, hibrit, elektrik).
  final FuelType fuel;

  /// Yolcu koltuk kapasitesi.
  final int seats;

  /// Günlük kiralama bedeli (kuruş cinsinden tamsayı: 150000 = 1.500 ₺).
  final int dailyRate;

  /// Araç görsel URL veya asset yolları listesi.
  final List<String> images;

  /// Aracın teslim alınacağı varsayılan ofis/nokta.
  final String pickupLocation;

  /// Aracın ilanda aktif olup olmadığı (firma tarafından pasife alınabilir).
  final bool isActive;

  /// Firmanın bu araç için kapattığı/bloke ettiği tarih aralıkları listesi.
  final List<DateRange> blockedPeriods;

  /// Aracı kiralamak için gereken minimum sürücü yaşı kuralı.
  final int minDriverAge;

  /// Aracı kiralamak için gereken minimum ehliyet süresi (yıl).
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

  /// Marka ve modeli birleştiren tam araç ismi.
  String get fullName => '$brand $model';

  /// Talep edilen [startAt, endAt) aralığının aracın bloke dönemleriyle çakışıp çakışmadığını denetler.
  bool isBlockedIn(DateTime startAt, DateTime endAt) {
    for (final period in blockedPeriods) {
      if (period.overlapsWith(startAt, endAt)) {
        return true;
      }
    }
    return false;
  }

  /// Belirli alanları güncelleyerek yeni bir [Vehicle] nesnesi üretir.
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
