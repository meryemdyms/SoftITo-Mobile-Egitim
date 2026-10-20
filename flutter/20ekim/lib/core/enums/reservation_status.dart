import 'user_role.dart';

enum ReservationStatus {
  confirmed('Onaylandı'),
  active('Aktif Teslim'),
  completed('Tamamlandı'),
  cancelled('İptal Edildi');

  final String label;
  const ReservationStatus(this.label);

  /// Validates allowed status transitions based on actor role.
  /// Customer: can only transition from confirmed -> cancelled.
  /// Company: can transition confirmed -> active, active -> completed, confirmed -> cancelled.
  bool canTransitionTo(ReservationStatus next, UserRole actorRole) {
    if (this == next) return true;

    if (actorRole == UserRole.customer) {
      if (this == ReservationStatus.confirmed &&
          next == ReservationStatus.cancelled) {
        return true;
      }
      return false;
    }

    if (actorRole == UserRole.company) {
      if (this == ReservationStatus.confirmed &&
          next == ReservationStatus.active) {
        return true;
      }
      if (this == ReservationStatus.confirmed &&
          next == ReservationStatus.cancelled) {
        return true;
      }
      if (this == ReservationStatus.active &&
          next == ReservationStatus.completed) {
        return true;
      }
      return false;
    }

    return false;
  }
}
