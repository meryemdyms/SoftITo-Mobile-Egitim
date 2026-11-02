import 'user_role.dart';

/// Rezervasyon durumlarını ve yaşam döngüsü geçiş kurallarını temsil eden numaralandırma.
enum ReservationStatus {
  /// Rezervasyon başarıyla oluşturuldu ve onaylandı.
  confirmed('Onaylandı'),

  /// Araç müşteriye fiziksel olarak teslim edildi, kullanım aktif.
  active('Aktif Teslim'),

  /// Araç iade edildi ve kiralama süreci başarıyla sonuçlandı.
  completed('Tamamlandı'),

  /// Rezervasyon kiralama öncesinde iptal edildi.
  cancelled('İptal Edildi');

  /// Arayüzde görüntülenecek Türkçe metin etiketi.
  final String label;

  const ReservationStatus(this.label);

  /// Kullanıcı rolüne (Customer / Company) göre durum geçişinin geçerli olup olmadığını doğrular.
  ///
  /// Kurallar:
  /// - Müşteri (Customer): Yalnızca `confirmed -> cancelled` geçişini yapabilir.
  /// - Firma (Company): `confirmed -> active`, `active -> completed` ve `confirmed -> cancelled` geçişlerini yapabilir.
  /// - Diğer tüm geçişler (örn. `active -> cancelled`) reddedilir.
  bool canTransitionTo(ReservationStatus next, UserRole actorRole) {
    if (this == next) return true;

    // Müşteri rolü için durum izinleri
    if (actorRole == UserRole.customer) {
      if (this == ReservationStatus.confirmed &&
          next == ReservationStatus.cancelled) {
        return true;
      }
      return false;
    }

    // Firma rolü için durum izinleri
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
