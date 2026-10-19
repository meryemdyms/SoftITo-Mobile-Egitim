class AppConstants {
  const AppConstants._();

  static const String appName = 'Kırmızı Çağrı';
  static const String appTagline = 'Her Damla Kan, Kurtarılan Bir Can';

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

  static const List<String> urgencyLevels = [
    'Normal',
    'Acil',
    'Çok Acil',
  ];

  static const List<String> donationTypes = [
    'Tam Kan',
    'Trombosit',
    'Plazma',
  ];

  /// Erkekler için ortalama 90 gün, kadınlar için 120 gün bağış aralığı
  static const int minDonationIntervalDays = 90;
  static const int livesSavedPerDonation = 3;

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
