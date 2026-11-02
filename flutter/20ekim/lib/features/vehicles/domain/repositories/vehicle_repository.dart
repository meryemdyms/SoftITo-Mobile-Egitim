import '../entities/vehicle.dart';

/// Araç sorgulama, ekleme, güncelleme ve aktiflik durumunu yöneten repository sözleşmesi.
abstract class VehicleRepository {
  /// Sistemdeki tüm araçları listeler (varsayılan: yalnızca aktif olanlar).
  Future<List<Vehicle>> getVehicles({bool activeOnly = true});

  /// ID'ye göre tek bir araç detayını getirir.
  Future<Vehicle?> getVehicleById(String id);

  /// Belirli bir firmaya ait tüm araçları listeler.
  Future<List<Vehicle>> getCompanyVehicles(String companyId);

  /// Yeni araç ilanı ekler (actorCompanyId ile sahiplik doğrulanır).
  Future<Vehicle> addVehicle(Vehicle vehicle, {required String actorCompanyId});

  /// Mevcut bir aracı günceller (actorCompanyId ile sahiplik doğrulanır).
  Future<Vehicle> updateVehicle(
    Vehicle vehicle, {
    required String actorCompanyId,
  });

  /// Aracın aktiflik / pasiflik durumunu tersine çevirir.
  Future<Vehicle> toggleVehicleStatus(
    String vehicleId, {
    required String actorCompanyId,
  });
}
