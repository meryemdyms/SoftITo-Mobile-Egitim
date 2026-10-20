import '../../../../core/enums/reservation_status.dart';
import '../../../../core/enums/user_role.dart';
import '../../../../core/errors/app_exceptions.dart';
import '../../../../core/mock/mock_data_seed.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../domain/entities/reservation.dart';
import '../../domain/repositories/reservation_repository.dart';

class InMemoryReservationRepository implements ReservationRepository {
  final List<Reservation> _reservations = List.from(
    MockDataSeed.initialReservations,
  );

  @override
  Future<Reservation> createReservation(
    Reservation reservation, {
    required String actorCustomerId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));

    // Ownership check
    if (actorCustomerId != reservation.customerId) {
      throw const PermissionDeniedException(
        'Yalnızca kendi adınıza rezervasyon oluşturabilirsiniz.',
      );
    }

    // Serialized check to prevent local race condition
    final vehicleExisting = _reservations
        .where((r) => r.vehicleId == reservation.vehicleId && r.blocksCalendar)
        .toList();
    for (final existing in vehicleExisting) {
      if (DateFormatter.areIntervalsOverlapping(
        reservation.startAt,
        reservation.endAt,
        existing.startAt,
        existing.endAt,
      )) {
        throw const BookingException(
          'Bu araç seçilen tarih aralığında artık müsait değildir.',
        );
      }
    }

    final confirmedReservation = reservation.copyWith(
      status: ReservationStatus.confirmed,
    );
    _reservations.add(confirmedReservation);
    return confirmedReservation;
  }

  @override
  Future<List<Reservation>> getCustomerReservations(
    String customerId, {
    required String actorCustomerId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 100));

    if (actorCustomerId != customerId) {
      throw const PermissionDeniedException(
        'Yalnızca kendi rezervasyonlarınızı görüntüleyebilirsiniz.',
      );
    }

    return _reservations.where((r) => r.customerId == customerId).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  @override
  Future<List<Reservation>> getCompanyReservations(
    String companyId, {
    required String actorCompanyId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 100));

    if (actorCompanyId != companyId) {
      throw const PermissionDeniedException(
        'Yalnızca firmanıza ait rezervasyonları görüntüleyebilirsiniz.',
      );
    }

    return _reservations.where((r) => r.companyId == companyId).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  @override
  Future<List<Reservation>> getVehicleReservations(String vehicleId) async {
    await Future.delayed(const Duration(milliseconds: 50));
    return _reservations.where((r) => r.vehicleId == vehicleId).toList();
  }

  @override
  Future<Reservation?> getReservationById(String id) async {
    await Future.delayed(const Duration(milliseconds: 50));
    try {
      return _reservations.firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<Reservation> updateStatus({
    required String reservationId,
    required ReservationStatus newStatus,
    required String actorId,
    required UserRole actorRole,
  }) async {
    await Future.delayed(const Duration(milliseconds: 150));

    final index = _reservations.indexWhere((r) => r.id == reservationId);
    if (index < 0) {
      throw const NotFoundException('Rezervasyon bulunamadı.');
    }

    final current = _reservations[index];

    // Ownership & transition permissions
    if (actorRole == UserRole.customer) {
      if (current.customerId != actorId) {
        throw const PermissionDeniedException(
          'Bu rezervasyonu değiştirme yetkiniz yoktur.',
        );
      }
      if (!current.status.canTransitionTo(newStatus, UserRole.customer)) {
        throw BookingException(
          'Müşteri yalnızca "Onaylandı" durumundaki rezervasyonları iptal edebilir. (${current.status.label} -> ${newStatus.label} geçişi yapılamaz)',
        );
      }
    } else if (actorRole == UserRole.company) {
      if (current.companyId != actorId) {
        throw const PermissionDeniedException(
          'Bu rezervasyon firmanıza ait değildir.',
        );
      }
      if (!current.status.canTransitionTo(newStatus, UserRole.company)) {
        throw BookingException(
          'Geçersiz durum geçişi: ${current.status.label} -> ${newStatus.label}',
        );
      }
    } else {
      throw const PermissionDeniedException('Yetkisiz işlem.');
    }

    final updated = current.copyWith(status: newStatus);
    _reservations[index] = updated;
    return updated;
  }
}
