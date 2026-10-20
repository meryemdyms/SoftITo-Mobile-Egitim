import 'package:flutter_test/flutter_test.dart';
import 'package:car_rental_platform/features/campaigns/domain/entities/campaign.dart';
import 'package:car_rental_platform/features/campaigns/domain/services/pricing_calculator.dart';

void main() {
  group('PricingCalculator & Campaign Rules', () {
    final startAt = DateTime(2026, 11, 1, 10, 0);
    final endAt = DateTime(2026, 11, 4, 10, 0); // 3 days

    test('calculates base price correctly without campaigns', () {
      final result = PricingCalculator.calculate(
        dailyRate: 150000, // 1500 TL
        dayCount: 3,
        vehicleId: 'veh_1',
        startAt: startAt,
        endAt: endAt,
        availableCampaigns: [],
      );

      expect(result.dayCount, 3);
      expect(result.basePrice, 450000);
      expect(result.discountAmount, 0);
      expect(result.totalPrice, 450000);
      expect(result.appliedCampaign, isNull);
    });

    test('applies eligible campaign and rounds kuruş integer properly', () {
      final campaign = Campaign(
        id: 'camp_1',
        companyId: 'comp_1',
        title: '%15 İndirim',
        description: 'Test kampanya',
        discountPercent: 15,
        validFrom: DateTime(2026, 1, 1),
        validTo: DateTime(2026, 12, 31),
        active: true,
      );

      final result = PricingCalculator.calculate(
        dailyRate: 150000, // 1500 TL
        dayCount: 3, // Base: 450.000 kurus
        vehicleId: 'veh_1',
        startAt: startAt,
        endAt: endAt,
        availableCampaigns: [campaign],
      );

      // 450000 * 15 / 100 = 67500 kurus discount
      expect(result.basePrice, 450000);
      expect(result.discountAmount, 67500);
      expect(result.totalPrice, 382500); // 3825 TL
      expect(result.appliedCampaign?.id, 'camp_1');
    });

    test('picks campaign with highest discount if multiple are eligible', () {
      final campLow = Campaign(
        id: 'camp_low',
        companyId: 'comp_1',
        title: '%10 İndirim',
        description: '',
        discountPercent: 10,
        validFrom: DateTime(2026, 1, 1),
        validTo: DateTime(2026, 12, 31),
        active: true,
      );
      final campHigh = Campaign(
        id: 'camp_high',
        companyId: 'comp_1',
        title: '%25 İndirim',
        description: '',
        discountPercent: 25,
        validFrom: DateTime(2026, 1, 1),
        validTo: DateTime(2026, 12, 31),
        active: true,
      );

      final result = PricingCalculator.calculate(
        dailyRate: 100000, // 1000 TL
        dayCount: 2, // Base: 200.000 kurus
        vehicleId: 'veh_1',
        startAt: startAt,
        endAt: endAt,
        availableCampaigns: [campLow, campHigh],
      );

      expect(result.appliedCampaign?.id, 'camp_high');
      expect(result.discountAmount, 50000); // 25% of 200.000
      expect(result.totalPrice, 150000);
    });

    test('ignores expired or vehicle-restricted campaigns', () {
      final expiredCamp = Campaign(
        id: 'camp_exp',
        companyId: 'comp_1',
        title: 'Geçmiş',
        description: '',
        discountPercent: 30,
        validFrom: DateTime(2025, 1, 1),
        validTo: DateTime(2025, 12, 31), // expired!
        active: true,
      );
      final otherCarCamp = Campaign(
        id: 'camp_other',
        companyId: 'comp_1',
        title: 'Farklı Araç',
        description: '',
        discountPercent: 20,
        eligibleVehicleIds: ['veh_other'], // not veh_1
        validFrom: DateTime(2026, 1, 1),
        validTo: DateTime(2026, 12, 31),
        active: true,
      );

      final result = PricingCalculator.calculate(
        dailyRate: 100000,
        dayCount: 2,
        vehicleId: 'veh_1',
        startAt: startAt,
        endAt: endAt,
        availableCampaigns: [expiredCamp, otherCarCamp],
      );

      expect(result.appliedCampaign, isNull);
      expect(result.discountAmount, 0);
      expect(result.totalPrice, 200000);
    });
  });
}
