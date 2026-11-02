import '../../../../core/enums/reservation_status.dart';
import '../../../../core/enums/user_role.dart';
import '../entities/reservation.dart';

/// Rezervasyon oluşturma, sorgulama ve durum güncelleme işlemlerini tanımlayan sözleşme (Interface).
abstract class ReservationRepository {
  /// Yeni bir rezervasyon kaydı oluşturur (atomik çakışma ve sahiplik denetimi uygulanır).
  Future<Reservation> createReservation(
    Reservation reservation, {
    required String actorCustomerId,
  });

  /// Müşterinin kendi oluşturduğu rezervasyonları listeler.
  Future<List<Reservation>> getCustomerReservations(
    String customerId, {
    required String actorCustomerId,
  });

  /// Firmanın araçlarına ait rezervasyonları listeler.
  Future<List<Reservation>> getCompanyReservations(
    String companyId, {
    required String actorCompanyId,
  });

  /// Belirli bir araca ait tüm rezervasyonları getirir (takvim müsaitliği denetimlerinde kullanılır).
  Future<List<Reservation>> getVehicleReservations(String vehicleId);

  /// ID'ye göre tekil rezervasyon kaydını getirir.
  Future<Reservation?> getReservationById(String id);

  /// Rezervasyon durumunu günceller (rol yetkisi ve durum geçiş matrisi denetlenir).
  Future<Reservation> updateStatus({
    required String reservationId,
    required ReservationStatus newStatus,
    required String actorId,
    required UserRole actorRole,
  });
}
