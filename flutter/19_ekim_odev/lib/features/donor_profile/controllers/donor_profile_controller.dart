import 'package:flutter/foundation.dart';
import '../models/donor_profile_model.dart';

class DonorProfileController {
  DonorProfileController({DonorProfile? initialProfile})
      : state = ValueNotifier<DonorProfile>(
          initialProfile ??
              DonorProfile(
                id: 'donor_001',
                fullName: 'Meryem Duymuş',
                bloodGroup: 'A+',
                city: 'İstanbul',
                district: 'Kadıköy',
                lastDonationDate: DateTime.now().subtract(
                  const Duration(days: 64),
                ),
                isAvailable: true,
                totalDonationsCount: 5,
              ),
        );

  final ValueNotifier<DonorProfile> state;

  void toggleAvailability(bool isAvailable) {
    state.value = state.value.copyWith(isAvailable: isAvailable);
  }

  void updateBloodGroup(String newBloodGroup) {
    state.value = state.value.copyWith(bloodGroup: newBloodGroup);
  }

  void updateCityAndDistrict(String city, String district) {
    state.value = state.value.copyWith(city: city, district: district);
  }

  void recordDonation(DateTime date) {
    state.value = state.value.copyWith(
      lastDonationDate: date,
      totalDonationsCount: state.value.totalDonationsCount + 1,
    );
  }

  void dispose() {
    state.dispose();
  }
}
