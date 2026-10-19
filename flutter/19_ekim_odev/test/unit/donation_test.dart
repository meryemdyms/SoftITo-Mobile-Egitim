import 'package:flutter_test/flutter_test.dart';
import 'package:kirmizi_cagri/features/donation_history/controllers/donation_history_controller.dart';
import 'package:kirmizi_cagri/features/donation_history/models/donation_history_model.dart';
import 'package:kirmizi_cagri/features/donation_stats/controllers/donation_stats_controller.dart';

void main() {
  group('DonationHistoryController Tests', () {
    test('Initial records exist and adding donation works', () {
      DonationRecord? addedRecord;
      final controller = DonationHistoryController(
        onDonationAdded: (rec) => addedRecord = rec,
      );

      final initialLength = controller.state.value.records.length;
      final testDate = DateTime.now();

      controller.addDonation(
        date: testDate,
        hospitalName: 'Kartal Kızılay',
        city: 'İstanbul',
        donationType: 'Tam Kan',
        units: 1,
      );

      expect(controller.state.value.records.length, initialLength + 1);
      expect(addedRecord?.hospitalName, 'Kartal Kızılay');

      controller.removeDonation(controller.state.value.records.first.id);
      expect(controller.state.value.records.length, initialLength);

      controller.dispose();
    });
  });

  group('DonationStatsController Tests', () {
    test('Stats calculation accurately computes totals and lives saved', () {
      final records = [
        DonationRecord(
          id: '1',
          date: DateTime.now().subtract(const Duration(days: 100)),
          hospitalName: 'Hastane 1',
          city: 'İstanbul',
          donationType: 'Tam Kan',
          units: 1,
        ),
        DonationRecord(
          id: '2',
          date: DateTime.now().subtract(const Duration(days: 20)),
          hospitalName: 'Hastane 2',
          city: 'İstanbul',
          donationType: 'Tam Kan',
          units: 1,
        ),
      ];

      final statsController = DonationStatsController(initialRecords: records);
      final stats = statsController.state.value;

      expect(stats.totalDonations, 2);
      expect(stats.livesSaved, 6);
      expect(stats.daysSinceLastDonation, 20);
      expect(stats.isEligible, isFalse);
      expect(stats.daysUntilNextDonation, 70);

      statsController.dispose();
    });
  });
}
