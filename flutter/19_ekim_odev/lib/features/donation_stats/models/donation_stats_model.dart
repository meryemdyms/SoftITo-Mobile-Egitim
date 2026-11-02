import 'package:flutter/foundation.dart';
import '../../../core/constants/app_constants.dart';

/// Aylık bağış dağılımını temsil eden model sınıfı (İstatistik grafikleri için kullanılır).
@immutable
class DonationMonthStat {
  const DonationMonthStat({
    required this.monthLabel,
    required this.donationCount,
  });

  /// Ay etiketi (örn: 'Oca', 'Şub')
  final String monthLabel;

  /// İlgili ayda yapılan bağış adedi
  final int donationCount;
}

/// Kullanıcının genel bağış istatistiklerini tutan değiştirilemez model sınıfı.
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

  /// Yapılan toplam bağış sayısı
  final int totalDonations;

  /// Toplam bağışlanan kan ünitesi miktarı
  final int totalUnits;

  /// Son bağıştan bu yana geçen gün sayısı
  final int daysSinceLastDonation;

  /// Bir sonraki bağışın yapılabileceği tarihe kalan gün sayısı (0 ise bağışa uygun)
  final int daysUntilNextDonation;

  /// Donörün an itibarıyla kan vermeye uygun olup olmadığı
  final bool isEligible;

  /// Son aylara ait bağış dağılımı listesi
  final List<DonationMonthStat> monthlyDistribution;

  /// Yapılan bağışlar sayesinde kurtarılan tahmini can sayısı (1 bağış = 3 can)
  int get livesSaved => totalDonations * AppConstants.livesSavedPerDonation;

  /// İstatistik nesnesini yeni değerlerle kopyalar.
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

