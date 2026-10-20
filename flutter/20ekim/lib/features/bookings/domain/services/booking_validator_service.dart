import '../../../../core/errors/app_exceptions.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../customer_profile/domain/entities/customer_profile.dart';
import '../../../vehicles/domain/entities/vehicle.dart';
import '../entities/reservation.dart';

class BookingValidatorService {
  BookingValidatorService._();

  /// Validates all bookability rules:
  /// - startAt < endAt
  /// - startAt not in past relative to currentTime
  /// - vehicle is active
  /// - customer age & driving licence age meet vehicle requirements
  /// - no overlap with vehicle blockedPeriods
  /// - no overlap with active/confirmed reservations
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

    // Start cannot be in the past (allowing 5 minute clock skew grace)
    if (startAt.isBefore(currentTime.subtract(const Duration(minutes: 5)))) {
      throw const BookingException(
        'Kiralama başlangıç tarihi geçmişte olamaz.',
      );
    }

    // Driver age requirement
    final customerAge = customerProfile.ageAt(currentTime);
    if (customerAge < vehicle.minDriverAge) {
      throw BookingException(
        'Bu araç için minimum sürücü yaşı ${vehicle.minDriverAge}\'dir. (Yaşınız: $customerAge)',
      );
    }

    // Driver licence requirement
    final licenceYears = customerProfile.licenceYearsAt(currentTime);
    if (licenceYears < vehicle.minLicenceYears) {
      throw BookingException(
        'Bu araç için en az ${vehicle.minLicenceYears} yıllık ehliyet gereklidir. (Ehliyet süreniz: $licenceYears yıl)',
      );
    }

    // Blocked periods check
    if (vehicle.isBlockedIn(startAt, endAt)) {
      throw const BookingException(
        'Araç seçilen tarih aralığında firma tarafından bloklanmıştır.',
      );
    }

    // Existing active / confirmed reservations check
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

  /// Checks if vehicle is available for the given dates without throwing, returning a boolean.
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
