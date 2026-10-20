import 'package:flutter_test/flutter_test.dart';
import 'package:car_rental_platform/core/enums/fuel_type.dart';
import 'package:car_rental_platform/core/enums/reservation_status.dart';
import 'package:car_rental_platform/core/enums/transmission_type.dart';
import 'package:car_rental_platform/core/enums/user_role.dart';
import 'package:car_rental_platform/core/errors/app_exceptions.dart';
import 'package:car_rental_platform/features/bookings/data/repositories/in_memory_reservation_repository.dart';
import 'package:car_rental_platform/features/bookings/domain/entities/reservation.dart';
import 'package:car_rental_platform/features/vehicles/data/repositories/in_memory_vehicle_repository.dart';
import 'package:car_rental_platform/features/vehicles/domain/entities/vehicle.dart';

void main() {
  group('Repository Ownership & Security Verification', () {
    test(
      'VehicleRepository rejects adding vehicle for another company',
      () async {
        final repo = InMemoryVehicleRepository();
        const vehicle = Vehicle(
          id: 'veh_test',
          companyId: 'comp_1',
          brand: 'Fiat',
          model: 'Egea',
          year: 2024,
          transmission: TransmissionType.manual,
          fuel: FuelType.gasoline,
          seats: 5,
          dailyRate: 100000,
          images: [],
          pickupLocation: 'Kadıköy',
        );

        // actorCompanyId is comp_2, but vehicle belongs to comp_1
        expect(
          () => repo.addVehicle(vehicle, actorCompanyId: 'comp_2'),
          throwsA(isA<PermissionDeniedException>()),
        );
      },
    );

    test('ReservationRepository rejects creating reservation with different customer id', () async {
      final repo = InMemoryReservationRepository();
      final res = Reservation(
        id: 'res_test',
        vehicleId: 'veh_1',
        companyId: 'comp_1',
        customerId: 'customer_1',
        startAt: DateTime(2026, 12, 1, 10, 0),
        endAt: DateTime(2026, 12, 3, 10, 0),
        pickupLocation: 'Kadıköy',
        returnLocation: 'Kadıköy',
        dayCount: 2,
        basePrice: 200000,
        discountAmount: 0,
        totalPrice: 200000,
        createdAt: DateTime.now(),
      );

      // actorCustomerId is customer_attacker, but reservation is customer_1
      expect(
        () => repo.createReservation(res, actorCustomerId: 'customer_attacker'),
        throwsA(isA<PermissionDeniedException>()),
      );
    });

    test(
      'ReservationRepository rejects fetching another customer reservations',
      () async {
        final repo = InMemoryReservationRepository();

        expect(
          () => repo.getCustomerReservations(
            'user_cust_1',
            actorCustomerId: 'user_cust_2',
          ),
          throwsA(isA<PermissionDeniedException>()),
        );
      },
    );

    test('ReservationRepository rejects company updating another company reservation', () async {
      final repo = InMemoryReservationRepository();

      // res_1 belongs to comp_1 in seed data
      expect(
        () => repo.updateStatus(
          reservationId: 'res_1',
          newStatus: ReservationStatus.active,
          actorId: 'comp_2', // wrong company!
          actorRole: UserRole.company,
        ),
        throwsA(isA<PermissionDeniedException>()),
      );
    });
  });
}
