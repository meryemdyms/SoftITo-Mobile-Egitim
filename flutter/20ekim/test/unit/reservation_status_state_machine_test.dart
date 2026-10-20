import 'package:flutter_test/flutter_test.dart';
import 'package:car_rental_platform/core/enums/reservation_status.dart';
import 'package:car_rental_platform/core/enums/user_role.dart';

void main() {
  group('ReservationStatus Transition Matrix', () {
    test('Customer can ONLY transition confirmed -> cancelled', () {
      expect(
        ReservationStatus.confirmed.canTransitionTo(
          ReservationStatus.cancelled,
          UserRole.customer,
        ),
        isTrue,
      );
      expect(
        ReservationStatus.confirmed.canTransitionTo(
          ReservationStatus.active,
          UserRole.customer,
        ),
        isFalse,
      );
      expect(
        ReservationStatus.active.canTransitionTo(
          ReservationStatus.completed,
          UserRole.customer,
        ),
        isFalse,
      );
      expect(
        ReservationStatus.active.canTransitionTo(
          ReservationStatus.cancelled,
          UserRole.customer,
        ),
        isFalse,
      );
      expect(
        ReservationStatus.completed.canTransitionTo(
          ReservationStatus.cancelled,
          UserRole.customer,
        ),
        isFalse,
      );
    });

    test('Company can transition confirmed -> active, active -> completed, confirmed -> cancelled', () {
      expect(
        ReservationStatus.confirmed.canTransitionTo(
          ReservationStatus.active,
          UserRole.company,
        ),
        isTrue,
      );
      expect(
        ReservationStatus.active.canTransitionTo(
          ReservationStatus.completed,
          UserRole.company,
        ),
        isTrue,
      );
      expect(
        ReservationStatus.confirmed.canTransitionTo(
          ReservationStatus.cancelled,
          UserRole.company,
        ),
        isTrue,
      );
    });

    test('Company CANNOT transition active -> cancelled, completed -> active, or cancelled -> confirmed', () {
      expect(
        ReservationStatus.active.canTransitionTo(
          ReservationStatus.cancelled,
          UserRole.company,
        ),
        isFalse,
      );
      expect(
        ReservationStatus.completed.canTransitionTo(
          ReservationStatus.active,
          UserRole.company,
        ),
        isFalse,
      );
      expect(
        ReservationStatus.cancelled.canTransitionTo(
          ReservationStatus.confirmed,
          UserRole.company,
        ),
        isFalse,
      );
    });
  });
}
