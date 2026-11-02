import 'package:flutter/foundation.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/extensions/date_extensions.dart';

/// Donörün profil bilgilerini, kan grubunu, konumunu ve bağış uygunluk
/// durumunu temsil eden değiştirilemez model sınıfı.
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

  /// Donörün benzersiz kullanıcı kimliği
  final String id;

  /// Donörün adı ve soyadı
  final String fullName;

  /// Donörün kan grubu (örn: '0+', 'A-')
  final String bloodGroup;

  /// İkamet ettiği şehir
  final String city;

  /// İkamet ettiği ilçe
  final String district;

  /// En son yapılan kan bağışının tarihi (Daha önce bağış yapmamışsa null)
  final DateTime? lastDonationDate;

  /// Donörün acil çağrılarda müsait olup olmadığını belirten anahtar
  final bool isAvailable;

  /// Donörün sistemde kayıtlı toplam bağış sayısı
  final int totalDonationsCount;

  /// Donörün an itibarıyla tıbben kan vermeye uygun olup olmadığını hesaplar.
  /// Son bağıştan bu yana en az [AppConstants.minDonationIntervalDays] (90 gün) geçmiş olmalıdır.
  bool get isEligibleToDonate {
    if (lastDonationDate == null) return true;
    return lastDonationDate!.daysAgo() >= AppConstants.minDonationIntervalDays;
  }

  /// Bir sonraki bağışa kalan gün sayısını hesaplar (Uygunsa 0 döner).
  int get daysUntilNextDonation {
    if (lastDonationDate == null) return 0;
    final passedDays = lastDonationDate!.daysAgo();
    final remaining = AppConstants.minDonationIntervalDays - passedDays;
    return remaining > 0 ? remaining : 0;
  }

  /// Profil nesnesini yeni değerlerle kopyalar.
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

