import 'package:flutter/foundation.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/extensions/date_extensions.dart';

@immutable
class DonorProfile {
  const DonorProfile({
    required this.id,
    required this.fullName,
    required this.bloodGroup,
    required this.city,
    required this.district,
    this.lastDonationDate,
    this.isAvailable = true,
    this.totalDonationsCount = 0,
  });

  final String id;
  final String fullName;
  final String bloodGroup;
  final String city;
  final String district;
  final DateTime? lastDonationDate;
  final bool isAvailable;
  final int totalDonationsCount;

  bool get isEligibleToDonate {
    if (lastDonationDate == null) return true;
    return lastDonationDate!.daysAgo() >= AppConstants.minDonationIntervalDays;
  }

  int get daysUntilNextDonation {
    if (lastDonationDate == null) return 0;
    final passedDays = lastDonationDate!.daysAgo();
    final remaining = AppConstants.minDonationIntervalDays - passedDays;
    return remaining > 0 ? remaining : 0;
  }

  DonorProfile copyWith({
    String? id,
    String? fullName,
    String? bloodGroup,
    String? city,
    String? district,
    DateTime? lastDonationDate,
    bool? isAvailable,
    int? totalDonationsCount,
  }) {
    return DonorProfile(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      city: city ?? this.city,
      district: district ?? this.district,
      lastDonationDate: lastDonationDate ?? this.lastDonationDate,
      isAvailable: isAvailable ?? this.isAvailable,
      totalDonationsCount: totalDonationsCount ?? this.totalDonationsCount,
    );
  }
}
