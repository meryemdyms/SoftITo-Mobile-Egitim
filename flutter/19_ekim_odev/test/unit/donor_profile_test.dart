import 'package:flutter_test/flutter_test.dart';
import 'package:kirmizi_cagri/features/donor_profile/controllers/donor_profile_controller.dart';
import 'package:kirmizi_cagri/features/donor_profile/models/donor_profile_model.dart';

void main() {
  group('DonorProfileController Tests', () {
    test('Can toggle availability and update blood group', () {
      final controller = DonorProfileController();

      controller.toggleAvailability(false);
      expect(controller.state.value.isAvailable, isFalse);

      controller.updateBloodGroup('AB+');
      expect(controller.state.value.bloodGroup, 'AB+');

      controller.recordDonation(DateTime.now());
      expect(controller.state.value.lastDonationDate, isNotNull);

      controller.dispose();
    });

    test('DonorProfile eligibility logic functions correctly', () {
      final eligibleProfile = DonorProfile(
        id: '1',
        fullName: 'Test',
        bloodGroup: '0+',
        city: 'İstanbul',
        district: 'Beşiktaş',
        lastDonationDate: DateTime.now().subtract(const Duration(days: 95)),
      );

      expect(eligibleProfile.isEligibleToDonate, isTrue);
      expect(eligibleProfile.daysUntilNextDonation, 0);

      final waitingProfile = DonorProfile(
        id: '2',
        fullName: 'Test 2',
        bloodGroup: '0+',
        city: 'İstanbul',
        district: 'Beşiktaş',
        lastDonationDate: DateTime.now().subtract(const Duration(days: 30)),
      );

      expect(waitingProfile.isEligibleToDonate, isFalse);
      expect(waitingProfile.daysUntilNextDonation, 60);
    });
  });
}
