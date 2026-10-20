import '../../../../core/errors/app_exceptions.dart';
import '../../../../core/mock/mock_data_seed.dart';
import '../../domain/entities/vehicle.dart';
import '../../domain/repositories/vehicle_repository.dart';

class InMemoryVehicleRepository implements VehicleRepository {
  final List<Vehicle> _vehicles = List.from(MockDataSeed.initialVehicles);

  @override
  Future<List<Vehicle>> getVehicles({bool activeOnly = true}) async {
    await Future.delayed(const Duration(milliseconds: 100));
    if (activeOnly) {
      return _vehicles.where((v) => v.isActive).toList();
    }
    return List.unmodifiable(_vehicles);
  }

  @override
  Future<Vehicle?> getVehicleById(String id) async {
    await Future.delayed(const Duration(milliseconds: 50));
    try {
      return _vehicles.firstWhere((v) => v.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<Vehicle>> getCompanyVehicles(String companyId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _vehicles.where((v) => v.companyId == companyId).toList();
  }

  @override
  Future<Vehicle> addVehicle(
    Vehicle vehicle, {
    required String actorCompanyId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 150));

    // Ownership check
    if (vehicle.companyId != actorCompanyId) {
      throw const PermissionDeniedException(
        'Yalnızca kendi firmanıza araç ekleyebilirsiniz.',
      );
    }

    _vehicles.add(vehicle);
    return vehicle;
  }

  @override
  Future<Vehicle> updateVehicle(
    Vehicle vehicle, {
    required String actorCompanyId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 150));

    // Ownership check
    if (vehicle.companyId != actorCompanyId) {
      throw const PermissionDeniedException(
        'Yalnızca kendi firmanıza ait araçları güncelleyebilirsiniz.',
      );
    }

    final index = _vehicles.indexWhere((v) => v.id == vehicle.id);
    if (index < 0) {
      throw const NotFoundException('Araç bulunamadı.');
    }

    _vehicles[index] = vehicle;
    return vehicle;
  }

  @override
  Future<Vehicle> toggleVehicleStatus(
    String vehicleId, {
    required String actorCompanyId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 150));

    final index = _vehicles.indexWhere((v) => v.id == vehicleId);
    if (index < 0) {
      throw const NotFoundException('Araç bulunamadı.');
    }

    final vehicle = _vehicles[index];
    if (vehicle.companyId != actorCompanyId) {
      throw const PermissionDeniedException(
        'Yalnızca kendi firmanıza ait araçların durumunu değiştirebilirsiniz.',
      );
    }

    final updated = vehicle.copyWith(isActive: !vehicle.isActive);
    _vehicles[index] = updated;
    return updated;
  }
}
