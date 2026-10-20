import '../entities/customer_profile.dart';

abstract class CustomerProfileRepository {
  Future<CustomerProfile?> getProfile(String userId);
  Future<CustomerProfile> saveProfile(
    CustomerProfile profile, {
    required String actorUserId,
  });
}
