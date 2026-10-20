import 'dart:math';

import '../entities/campaign.dart';

class PriceCalculationResult {
  final int dayCount;
  final int basePrice;
  final int discountAmount;
  final int totalPrice;
  final Campaign? appliedCampaign;

  const PriceCalculationResult({
    required this.dayCount,
    required this.basePrice,
    required this.discountAmount,
    required this.totalPrice,
    this.appliedCampaign,
  });
}

class PricingCalculator {
  PricingCalculator._();

  /// Calculates total pricing and automatically selects best eligible campaign.
  /// Currency unit: int kuruş.
  static PriceCalculationResult calculate({
    required int dailyRate,
    required int dayCount,
    required String vehicleId,
    required DateTime startAt,
    required DateTime endAt,
    required List<Campaign> availableCampaigns,
  }) {
    final int safeDays = dayCount < 1 ? 1 : dayCount;
    final int basePrice = safeDays * dailyRate;

    // Filter eligible campaigns
    final eligibleCampaigns = availableCampaigns.where((c) {
      return c.isEligibleFor(vehicleId, startAt, endAt);
    }).toList();

    // Sort by discount percent descending, tie-break by ID ascending
    eligibleCampaigns.sort((a, b) {
      final cmp = b.discountPercent.compareTo(a.discountPercent);
      if (cmp != 0) return cmp;
      return a.id.compareTo(b.id);
    });

    final Campaign? bestCampaign = eligibleCampaigns.isNotEmpty
        ? eligibleCampaigns.first
        : null;

    int discountAmount = 0;
    if (bestCampaign != null && bestCampaign.discountPercent > 0) {
      discountAmount = (basePrice * bestCampaign.discountPercent) ~/ 100;
    }

    final int totalPrice = max(0, basePrice - discountAmount);

    return PriceCalculationResult(
      dayCount: safeDays,
      basePrice: basePrice,
      discountAmount: discountAmount,
      totalPrice: totalPrice,
      appliedCampaign: bestCampaign,
    );
  }
}
