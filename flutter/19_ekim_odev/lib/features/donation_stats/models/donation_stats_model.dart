import 'package:flutter/foundation.dart';
import '../../../core/constants/app_constants.dart';

@immutable
class DonationMonthStat {
  const DonationMonthStat({
    required this.monthLabel,
    required this.donationCount,
  });

  final String monthLabel;
  final int donationCount;
}

@immutable
class DonationStats {
  const DonationStats({
    this.totalDonations = 0,
    this.totalUnits = 0,
    this.daysSinceLastDonation = 0,
    this.daysUntilNextDonation = 0,
    this.isEligible = true,
    this.monthlyDistribution = const [],
  });

  final int totalDonations;
  final int totalUnits;
  final int daysSinceLastDonation;
  final int daysUntilNextDonation;
  final bool isEligible;
  final List<DonationMonthStat> monthlyDistribution;

  int get livesSaved => totalDonations * AppConstants.livesSavedPerDonation;

  DonationStats copyWith({
    int? totalDonations,
    int? totalUnits,
    int? daysSinceLastDonation,
    int? daysUntilNextDonation,
    bool? isEligible,
    List<DonationMonthStat>? monthlyDistribution,
  }) {
    return DonationStats(
      totalDonations: totalDonations ?? this.totalDonations,
      totalUnits: totalUnits ?? this.totalUnits,
      daysSinceLastDonation:
          daysSinceLastDonation ?? this.daysSinceLastDonation,
      daysUntilNextDonation:
          daysUntilNextDonation ?? this.daysUntilNextDonation,
      isEligible: isEligible ?? this.isEligible,
      monthlyDistribution: monthlyDistribution ?? this.monthlyDistribution,
    );
  }
}
