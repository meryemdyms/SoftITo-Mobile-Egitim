import 'package:flutter_test/flutter_test.dart';
import 'package:car_rental_platform/core/enums/fuel_type.dart';
import 'package:car_rental_platform/core/enums/reservation_status.dart';
import 'package:car_rental_platform/core/enums/transmission_type.dart';
import 'package:car_rental_platform/core/errors/app_exceptions.dart';
import 'package:car_rental_platform/features/bookings/domain/entities/reservation.dart';
import 'package:car_rental_platform/features/bookings/domain/services/booking_validator_service.dart';
import 'package:car_rental_platform/features/customer_profile/domain/entities/customer_profile.dart';
import 'package:car_rental_platform/features/vehicles/domain/entities/date_range.dart';
import 'package:car_rental_platform/features/vehicles/domain/entities/vehicle.dart';

void main() {
  group('BookingValidatorService Rules', () {
    final now = DateTime(2026, 10, 20, 12, 0);

    final vehicle = Vehicle(
      id: 'veh_1',
      companyId: 'comp_1',
      brand: 'Renault',
      model: 'Megane',
      year: 2024,
      transmission: TransmissionType.automatic,
      fuel: FuelType.gasoline,
      seats: 5,
      dailyRate: 150000,
      images: const [],
      pickupLocation: 'Kadıköy',
      minDriverAge: 23,
      minLicenceYears: 2,
      isActive: true,
      blockedPeriods: [
        DateRange(
          startAt: DateTime(2026, 11, 10, 10, 0),
          endAt: DateTime(2026, 11, 15, 10, 0),
        ),
      ],
    );

    final validProfile = CustomerProfile(
      userId: 'user_1',
      birthDate: DateTime(2000, 1, 1), // 26 years old
      drivingLicenceNumber: 'TR-12345',
      licenceClass: 'B',
      issueDate: DateTime(2020, 1, 1), // 6 years licence
    );

    test('valid booking passes successfully', () {
      expect(
        () => BookingValidatorService.validateBookability(
          vehicle: vehicle,
          customerProfile: validProfile,
          startAt: DateTime(2026, 10, 25, 10, 0),
          endAt: DateTime(2026, 10, 28, 10, 0),
          existingVehicleReservations: [],
          currentTime: now,
        ),
        returnsNormally,
      );
    });

    test('throws if driver is younger than minDriverAge', () {
      final youngProfile = CustomerProfile(
        userId: 'user_young',
        birthDate: DateTime(2005, 1, 1), // 21 years old (< 23)
        drivingLicenceNumber: 'TR-12345',
        licenceClass: 'B',
        issueDate: DateTime(2023, 1, 1),
      );

      expect(
        () => BookingValidatorService.validateBookability(
          vehicle: vehicle,
          customerProfile: youngProfile,
          startAt: DateTime(2026, 10, 25, 10, 0),
          endAt: DateTime(2026, 10, 28, 10, 0),
          existingVehicleReservations: [],
          currentTime: now,
        ),
        throwsA(isA<BookingException>()),
      );
    });

    test('throws if driver licence is less than minLicenceYears', () {
      final newLicenceProfile = CustomerProfile(
        userId: 'user_new_driver',
        birthDate: DateTime(1995, 1, 1), // 31 years old
        drivingLicenceNumber: 'TR-12345',
        licenceClass: 'B',
        issueDate: DateTime(2026, 5, 1), // only 5 months licence (< 2 years)
      );

      expect(
        () => BookingValidatorService.validateBookability(
          vehicle: vehicle,
          customerProfile: newLicenceProfile,
          startAt: DateTime(2026, 10, 25, 10, 0),
          endAt: DateTime(2026, 10, 28, 10, 0),
          existingVehicleReservations: [],
          currentTime: now,
        ),
        throwsA(isA<BookingException>()),
      );
    });

    test('throws if dates overlap with company blocked periods', () {
      expect(
        () => BookingValidatorService.validateBookability(
          vehicle: vehicle,
          customerProfile: validProfile,
          startAt: DateTime(2026, 11, 12, 10, 0), // overlaps with 10-15 Nov
          endAt: DateTime(2026, 11, 16, 10, 0),
          existingVehicleReservations: [],
          currentTime: now,
        ),
        throwsA(isA<BookingException>()),
      );
    });

    test('throws if dates overlap with confirmed reservation', () {
      final existingRes = Reservation(
        id: 'res_1',
        vehicleId: 'veh_1',
        companyId: 'comp_1',
        customerId: 'other_cust',
        startAt: DateTime(2026, 10, 26, 10, 0),
        endAt: DateTime(2026, 10, 29, 10, 0),
        pickupLocation: 'Kadıköy',
        returnLocation: 'Kadıköy',
        dayCount: 3,
        basePrice: 450000,
        discountAmount: 0,
        totalPrice: 450000,
        status: ReservationStatus.confirmed,
        createdAt: now,
      );

      expect(
        () => BookingValidatorService.validateBookability(
          vehicle: vehicle,
          customerProfile: validProfile,
          startAt: DateTime(2026, 10, 25, 10, 0),
          endAt: DateTime(2026, 10, 28, 10, 0), // overlaps with 26-29
          existingVehicleReservations: [existingRes],
          currentTime: now,
        ),
        throwsA(isA<BookingException>()),
      );
    });

    test('cancelled reservations do NOT block booking', () {
      final cancelledRes = Reservation(
        id: 'res_cancelled',
        vehicleId: 'veh_1',
        companyId: 'comp_1',
        customerId: 'other_cust',
        startAt: DateTime(2026, 10, 25, 10, 0),
        endAt: DateTime(2026, 10, 28, 10, 0),
        pickupLocation: 'Kadıköy',
        returnLocation: 'Kadıköy',
        dayCount: 3,
        basePrice: 450000,
        discountAmount: 0,
        totalPrice: 450000,
        status: ReservationStatus.cancelled, // cancelled!
        createdAt: now,
      );

      expect(
        () => BookingValidatorService.validateBookability(
          vehicle: vehicle,
          customerProfile: validProfile,
          startAt: DateTime(2026, 10, 25, 10, 0),
          endAt: DateTime(2026, 10, 28, 10, 0),
          existingVehicleReservations: [cancelledRes],
          currentTime: now,
        ),
        returnsNormally,
      );
    });
  });
}
