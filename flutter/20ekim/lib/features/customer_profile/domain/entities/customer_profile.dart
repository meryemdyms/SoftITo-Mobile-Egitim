/// Müşterinin yaş ve ehliyet uygunluk denetimleri için kullanılan profil varlığı.
///
/// Demo veri sınırları dahilindedir; gerçek kimlik verisi saklanmaz.
class CustomerProfile {
  /// Bağlı olduğu kullanıcı ID'si.
  final String userId;

  /// Doğum tarihi (sürücü yaşı kuralı denetiminde kullanılır).
  final DateTime birthDate;

  /// Ehliyet / sürücü belgesi numarası.
  final String drivingLicenceNumber;

  /// Ehliyet sınıfı (B, A2, C vb.).
  final String licenceClass;

  /// Ehliyet veriliş tarihi (ehliyet süresi kuralı denetiminde kullanılır).
  final DateTime issueDate;

  const CustomerProfile({
    required this.userId,
    required this.birthDate,
    required this.drivingLicenceNumber,
    required this.licenceClass,
    required this.issueDate,
  });

  /// Verilen referans tarihe göre sürücünün tam yaşını hesaplar.
  int ageAt(DateTime date) {
    int age = date.year - birthDate.year;
    if (date.month < birthDate.month ||
        (date.month == birthDate.month && date.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  /// Verilen referans tarihe göre ehliyetin kaç yıllık olduğunu hesaplar.
  int licenceYearsAt(DateTime date) {
    int years = date.year - issueDate.year;
    if (date.month < issueDate.month ||
        (date.month == issueDate.month && date.day < issueDate.day)) {
      years--;
    }
    return years;
  }

  /// Belirli alanları güncelleyerek yeni bir [CustomerProfile] nesnesi oluşturur.
  CustomerProfile copyWith({
    String? userId,
    DateTime? birthDate,
    String? drivingLicenceNumber,
    String? licenceClass,
    DateTime? issueDate,
  }) {
    return CustomerProfile(
      userId: userId ?? this.userId,
      birthDate: birthDate ?? this.birthDate,
      drivingLicenceNumber: drivingLicenceNumber ?? this.drivingLicenceNumber,
      licenceClass: licenceClass ?? this.licenceClass,
      issueDate: issueDate ?? this.issueDate,
    );
  }
}
