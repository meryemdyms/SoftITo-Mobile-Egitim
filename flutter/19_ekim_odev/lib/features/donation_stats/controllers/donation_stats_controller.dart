import 'package:flutter/foundation.dart';
import '../../../core/constants/app_constants.dart';
import '../../donation_history/models/donation_history_model.dart';
import '../models/donation_stats_model.dart';

/// Kullanıcının bağış kayıtlarını analiz ederek özet istatistikleri ve
/// son 6 aylık bağış grafiği verilerini hesaplayan kontrolcü sınıfı.
class DonationStatsController {
  /// Kontrolcü örneği oluşturulurken başlangıç verilerini tanımlar.
  /// Eğer dışarıdan bağış geçmişi ([initialRecords]) verilmişse istatistikleri otomatik hesaplar.
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

  /// İstatistik verilerini dinlemek için kullanılan reaktif durum nesnesi.
  final ValueNotifier<DonationStats> state;

  /// Verilen bağış kayıtları listesini analiz ederek toplam bağış, son bağıştan geçen süre,
  /// uygunluk durumu ve aylık dağılımı günceller.
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

    // Toplam bağış sayısı ve toplam bağışlanan ünite miktarı
    final totalDonations = records.length;
    final totalUnits = records.fold(0, (sum, r) => sum + r.units);

    // Tarihe göre sıralayıp en son bağışı bulma
    final sortedRecords = [...records]..sort((a, b) => b.date.compareTo(a.date));
    final latestRecord = sortedRecords.first;
    final daysSince = DateTime.now().difference(latestRecord.date).inDays;
    // 90 günlük yasal bağış aralığından kalan gün sayısı
    final remainingDays = AppConstants.minDonationIntervalDays - daysSince;

    // İçinde bulunulan aydan geriye doğru son 6 ayın bağış sayılarını hesaplama
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

    // Yeni hesaplanan değerlerle state nesnesini güncelleme
    state.value = DonationStats(
      totalDonations: totalDonations,
      totalUnits: totalUnits,
      daysSinceLastDonation: daysSince,
      daysUntilNextDonation: remainingDays > 0 ? remainingDays : 0,
      isEligible: remainingDays <= 0,
      monthlyDistribution: monthly,
    );
  }

  /// Kontrolcü sonlandığında state dinleyicisini serbest bırakır.
  void dispose() {
    state.dispose();
  }
}

