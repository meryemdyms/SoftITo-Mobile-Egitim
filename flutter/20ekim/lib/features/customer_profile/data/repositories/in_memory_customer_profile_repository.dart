import '../../../../core/errors/app_exceptions.dart';
import '../../../../core/mock/mock_data_seed.dart';
import '../../domain/entities/customer_profile.dart';
import '../../domain/repositories/customer_profile_repository.dart';

class InMemoryCustomerProfileRepository implements CustomerProfileRepository {
  final Map<String, CustomerProfile> _profiles = Map.from(
    MockDataSeed.initialProfiles,
  );

  @override
  Future<CustomerProfile?> getProfile(String userId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _profiles[userId];
  }

  @override
  Future<CustomerProfile> saveProfile(
    CustomerProfile profile, {
    required String actorUserId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 150));

    // Ownership validation
    if (actorUserId != profile.userId) {
      throw const PermissionDeniedException(
        'Yalnızca kendi profilinizi düzenleyebilirsiniz.',
      );
    }

    _profiles[profile.userId] = profile;
    return profile;
  }
}
