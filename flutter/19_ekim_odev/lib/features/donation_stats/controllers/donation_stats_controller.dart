import 'package:flutter/foundation.dart';
import '../../../core/constants/app_constants.dart';
import '../../donation_history/models/donation_history_model.dart';
import '../models/donation_stats_model.dart';

class DonationStatsController {
  DonationStatsController({List<DonationRecord>? initialRecords})
      : state = ValueNotifier<DonationStats>(
          const DonationStats(
            totalDonations: 4,
            totalUnits: 4,
            daysSinceLastDonation: 64,
            daysUntilNextDonation: 26,
            isEligible: false,
            monthlyDistribution: [
              DonationMonthStat(monthLabel: 'May', donationCount: 1),
              DonationMonthStat(monthLabel: 'Haz', donationCount: 0),
              DonationMonthStat(monthLabel: 'Tem', donationCount: 1),
              DonationMonthStat(monthLabel: 'Ağu', donationCount: 1),
              DonationMonthStat(monthLabel: 'Eyl', donationCount: 0),
              DonationMonthStat(monthLabel: 'Eki', donationCount: 1),
            ],
          ),
        ) {
    if (initialRecords != null && initialRecords.isNotEmpty) {
      calculateStats(initialRecords);
    }
  }

  final ValueNotifier<DonationStats> state;

  void calculateStats(List<DonationRecord> records) {
    if (records.isEmpty) {
      state.value = const DonationStats(
        totalDonations: 0,
        totalUnits: 0,
        daysSinceLastDonation: 0,
        daysUntilNextDonation: 0,
        isEligible: true,
        monthlyDistribution: [],
      );
      return;
    }

    final totalDonations = records.length;
    final totalUnits = records.fold(0, (sum, r) => sum + r.units);

    // En son bağışı bul
    final sortedRecords = [...records]..sort((a, b) => b.date.compareTo(a.date));
    final latestRecord = sortedRecords.first;
    final daysSince = DateTime.now().difference(latestRecord.date).inDays;
    final remainingDays = AppConstants.minDonationIntervalDays - daysSince;

    // Son 6 ayın istatistiğini oluştur
    final now = DateTime.now();
    final months = ['Oca', 'Şub', 'Mar', 'Nis', 'May', 'Haz', 'Tem', 'Ağu', 'Eyl', 'Eki', 'Kas', 'Ara'];
    final List<DonationMonthStat> monthly = [];

    for (int i = 5; i >= 0; i--) {
      final targetDate = DateTime(now.year, now.month - i, 1);
      final monthLabel = months[targetDate.month - 1];
      final countInMonth = records.where((r) {
        return r.date.year == targetDate.year && r.date.month == targetDate.month;
      }).length;
      monthly.add(DonationMonthStat(monthLabel: monthLabel, donationCount: countInMonth));
    }

    state.value = DonationStats(
      totalDonations: totalDonations,
      totalUnits: totalUnits,
      daysSinceLastDonation: daysSince,
      daysUntilNextDonation: remainingDays > 0 ? remainingDays : 0,
      isEligible: remainingDays <= 0,
      monthlyDistribution: monthly,
    );
  }

  void dispose() {
    state.dispose();
  }
}
