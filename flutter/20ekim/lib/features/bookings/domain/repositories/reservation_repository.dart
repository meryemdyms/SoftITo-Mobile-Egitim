import '../../../../core/enums/reservation_status.dart';
import '../../../../core/enums/user_role.dart';
import '../entities/reservation.dart';

abstract class ReservationRepository {
  Future<Reservation> createReservation(
    Reservation reservation, {
    required String actorCustomerId,
  });
  Future<List<Reservation>> getCustomerReservations(
    String customerId, {
    required String actorCustomerId,
  });
  Future<List<Reservation>> getCompanyReservations(
    String companyId, {
    required String actorCompanyId,
  });
  Future<List<Reservation>> getVehicleReservations(String vehicleId);
  Future<Reservation?> getReservationById(String id);
  Future<Reservation> updateStatus({
    required String reservationId,
    required ReservationStatus newStatus,
    required String actorId,
    required UserRole actorRole,
  });
}
