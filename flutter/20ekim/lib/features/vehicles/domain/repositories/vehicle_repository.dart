import '../entities/vehicle.dart';

abstract class VehicleRepository {
  Future<List<Vehicle>> getVehicles({bool activeOnly = true});
  Future<Vehicle?> getVehicleById(String id);
  Future<List<Vehicle>> getCompanyVehicles(String companyId);
  Future<Vehicle> addVehicle(Vehicle vehicle, {required String actorCompanyId});
  Future<Vehicle> updateVehicle(
    Vehicle vehicle, {
    required String actorCompanyId,
  });
  Future<Vehicle> toggleVehicleStatus(
    String vehicleId, {
    required String actorCompanyId,
  });
}
