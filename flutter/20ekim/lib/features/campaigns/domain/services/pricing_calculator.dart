import 'dart:math';

import '../entities/campaign.dart';

/// Fiyat hesaplama sonucunu temsil eden snapshot modeli.
class PriceCalculationResult {
  /// Toplam gün sayısı.
  final int dayCount;

  /// İndirimsiz ham taban ücret (kuruş).
  final int basePrice;

  /// Uygulanan indirim tutarı (kuruş).
  final int discountAmount;

  /// İndirim sonrası ödenecek nihai toplam tutar (kuruş).
  final int totalPrice;

  /// Uygulanan en avantajlı kampanya (varsa).
  final Campaign? appliedCampaign;

  const PriceCalculationResult({
    required this.dayCount,
    required this.basePrice,
    required this.discountAmount,
    required this.totalPrice,
    this.appliedCampaign,
  });
}

/// Gün sayısı ve kampanyalara göre nihai kiralama bedelini hesaplayan etki alanı (Domain) servisi.
///
/// Parasal işlemler kuruş üzerinden tamsayı (`int`) ile yapılır.
class PricingCalculator {
  PricingCalculator._();

  /// Taban fiyatı ve en uygun kampanyayı otomatik seçerek hesaplama sonucunu döner.
  static PriceCalculationResult calculate({
    required int dailyRate,
    required int dayCount,
    required String vehicleId,
    required DateTime startAt,
    required DateTime endAt,
    required List<Campaign> availableCampaigns,
  }) {
    // Kiralama süresi en az 1 gün kabul edilir
    final int safeDays = dayCount < 1 ? 1 : dayCount;
    final int basePrice = safeDays * dailyRate;

    // Araç ve tarihe uygun aktif kampanyaları filtrele
    final eligibleCampaigns = availableCampaigns.where((c) {
      return c.isEligibleFor(vehicleId, startAt, endAt);
    }).toList();

    // En yüksek indirim oranına göre sırala; eşitlikte deterministik ID sıralaması yap
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
      // Tamsayı kuruş üzerinden indirim hesaplama
      discountAmount = (basePrice * bestCampaign.discountPercent) ~/ 100;
    }

    // Toplam tutar asla negatif olamaz
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
