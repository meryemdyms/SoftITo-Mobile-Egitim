/// Uygulama genelinde kullanılan sabit değerleri barındıran sınıf.
/// Özel kurucu (private constructor) ile bu sınıftan nesne üretilmesi engellenmiştir.
class AppConstants {
  const AppConstants._();

  /// Uygulama adı
  static const String appName = 'Kırmızı Çağrı';

  /// Uygulama sloganı
  static const String appTagline = 'Her Damla Kan, Kurtarılan Bir Can';

  /// Sistemde desteklenen tüm kan grupları listesi
  static const List<String> bloodGroups = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    '0+',
    '0-',
  ];

  /// Kan talebi aciliyet seviyeleri
  static const List<String> urgencyLevels = [
    'Normal',
    'Acil',
    'Çok Acil',
  ];

  /// Kan bağış türleri
  static const List<String> donationTypes = [
    'Tam Kan',
    'Trombosit',
    'Plazma',
  ];

  /// İki tam kan bağışı arasındaki yasal minimum bekleme süresi (gün bazında).
  /// Erkekler için ortalama 90 gün, kadınlar için 120 gündür (burada standart 90 gün alınmıştır).
  static const int minDonationIntervalDays = 90;

  /// Bir ünite kan bağışının ortalama kurtardığı can sayısı
  static const int livesSavedPerDonation = 3;

  /// Kan gruplarının kimlere kan verebileceğini gösteren uyumluluk tablosu (Donör Uyumluluğu)
  static const Map<String, List<String>> canDonateTo = {
    '0-': ['Tüm Gruplar (Genel Verici)'],
    '0+': ['0+', 'A+', 'B+', 'AB+'],
    'A-': ['A-', 'A+', 'AB-', 'AB+'],
    'A+': ['A+', 'AB+'],
    'B-': ['B-', 'B+', 'AB-', 'AB+'],
    'B+': ['B+', 'AB+'],
    'AB-': ['AB-', 'AB+'],
    'AB+': ['AB+ (Yalnızca AB+)'],
  };

  /// Kan gruplarının kimlerden kan alabileceğini gösteren uyumluluk tablosu (Alıcı Uyumluluğu)
  static const Map<String, List<String>> canReceiveFrom = {
    '0-': ['0- (Yalnızca 0-)'],
    '0+': ['0+', '0-'],
    'A-': ['A-', '0-'],
    'A+': ['A+', 'A-', '0+', '0-'],
    'B-': ['B-', '0-'],
    'B+': ['B+', 'B-', '0+', '0-'],
    'AB-': ['AB-', 'A-', 'B-', '0-'],
    'AB+': ['Tüm Gruplar (Genel Alıcı)'],
  };
}

