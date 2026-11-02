import '../entities/customer_profile.dart';

/// Müşteri profili verilerini getirme ve güncelleme sözleşmesi (Interface).
abstract class CustomerProfileRepository {
  /// Verilen kullanıcı ID'sine ait müşteri profilini getirir.
  Future<CustomerProfile?> getProfile(String userId);

  /// Müşteri profilini kaydeder veya günceller (actorUserId ile sahiplik denetimi yapılır).
  Future<CustomerProfile> saveProfile(
    CustomerProfile profile, {
    required String actorUserId,
  });
}
