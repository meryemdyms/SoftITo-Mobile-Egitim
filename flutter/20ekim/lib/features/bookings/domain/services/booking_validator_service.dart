import '../../../../core/errors/app_exceptions.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../customer_profile/domain/entities/customer_profile.dart';
import '../../../vehicles/domain/entities/vehicle.dart';
import '../entities/reservation.dart';

/// Rezervasyon oluşturma iş kurallarını denetleyen etki alanı (Domain) doğrulama servisi.
///
/// Şartname Kuralları:
/// 1. Araç ilanda aktif olmalıdır.
/// 2. Bitiş tarihi başlangıç tarihinden sonra olmalıdır.
/// 3. Başlangıç tarihi geçmişte olamaz.
/// 4. Müşteri yaşı aracın `minDriverAge` koşulunu sağlamalıdır.
/// 5. Müşteri ehliyet süresi aracın `minLicenceYears` koşulunu sağlamalıdır.
/// 6. Tarih aralığı aracın bloke dönemleriyle çakışmamalıdır.
/// 7. Tarih aralığı aracın onaylanmış veya aktif rezervasyonlarıyla çakışmamalıdır.
class BookingValidatorService {
  BookingValidatorService._();

  /// Tüm rezervasyon kurallarını doğrular; uygunsuzluk durumunda [BookingException] fırlatır.
  static void validateBookability({
    required Vehicle vehicle,
    required CustomerProfile customerProfile,
    required DateTime startAt,
    required DateTime endAt,
    required List<Reservation> existingVehicleReservations,
    required DateTime currentTime,
  }) {
    if (!vehicle.isActive) {
      throw const BookingException(
        'Seçilen araç şu anda kiralamaya aktif değildir.',
      );
    }

    if (!startAt.isBefore(endAt)) {
      throw const BookingException(
        'Bitiş tarihi başlangıç tarihinden sonra olmalıdır.',
      );
    }

    // Başlangıç zamanı geçmişte olamaz (5 dakikalık tolerans payı tanınır)
    if (startAt.isBefore(currentTime.subtract(const Duration(minutes: 5)))) {
      throw const BookingException(
        'Kiralama başlangıç tarihi geçmişte olamaz.',
      );
    }

    // Minimum sürücü yaşı kontrolü
    final customerAge = customerProfile.ageAt(currentTime);
    if (customerAge < vehicle.minDriverAge) {
      throw BookingException(
        'Bu araç için minimum sürücü yaşı ${vehicle.minDriverAge}\'dir. (Yaşınız: $customerAge)',
      );
    }

    // Minimum ehliyet süresi (yıl) kontrolü
    final licenceYears = customerProfile.licenceYearsAt(currentTime);
    if (licenceYears < vehicle.minLicenceYears) {
      throw BookingException(
        'Bu araç için en az ${vehicle.minLicenceYears} yıllık ehliyet gereklidir. (Ehliyet süreniz: $licenceYears yıl)',
      );
    }

    // Firmanın bloke ettiği dönem kontrolü
    if (vehicle.isBlockedIn(startAt, endAt)) {
      throw const BookingException(
        'Araç seçilen tarih aralığında firma tarafından bloklanmıştır.',
      );
    }

    // Mevcut onaylı veya aktif rezervasyonlarla çakışma kontrolü
    for (final reservation in existingVehicleReservations) {
      if (reservation.blocksCalendar) {
        if (DateFormatter.areIntervalsOverlapping(
          startAt,
          endAt,
          reservation.startAt,
          reservation.endAt,
        )) {
          throw const BookingException(
            'Seçilen tarih aralığında bu araç için başka bir rezervasyon bulunmaktadır.',
          );
        }
      }
    }
  }

  /// Belirtilen tarihlerde aracın müsait olup olmadığını hata fırlatmadan boolean (`true`/`false`) olarak döner.
  static bool isVehicleAvailable({
    required Vehicle vehicle,
    required DateTime startAt,
    required DateTime endAt,
    required List<Reservation> existingVehicleReservations,
  }) {
    if (!vehicle.isActive) return false;
    if (!startAt.isBefore(endAt)) return false;
    if (vehicle.isBlockedIn(startAt, endAt)) return false;

    for (final reservation in existingVehicleReservations) {
      if (reservation.blocksCalendar) {
        if (DateFormatter.areIntervalsOverlapping(
          startAt,
          endAt,
          reservation.startAt,
          reservation.endAt,
        )) {
          return false;
        }
      }
    }
    return true;
  }
}
