/// [DateTime] sınıfına Türkçe tarih biçimlendirme ve gün farkı hesaplama
/// yetenekleri kazandıran extension (genişletme) metotları.
extension DateExtensions on DateTime {
  /// Türkçe tam ay isimleri listesi
  static const List<String> _months = [
    'Ocak',
    'Şubat',
    'Mart',
    'Nisan',
    'Mayıs',
    'Haziran',
    'Temmuz',
    'Ağustos',
    'Eylül',
    'Ekim',
    'Kasım',
    'Aralık',
  ];

  /// Türkçe kısaltılmış ay isimleri listesi
  static const List<String> _shortMonths = [
    'Oca',
    'Şub',
    'Mar',
    'Nis',
    'May',
    'Haz',
    'Tem',
    'Ağu',
    'Eyl',
    'Eki',
    'Kas',
    'Ara',
  ];

  /// Tarihi "15 Ekim 2024" formatında Türkçe metne dönüştürür.
  String toFormattedTurkish() {
    return '$day ${_months[month - 1]} $year';
  }

  /// Tarihi "15 Eki" gibi kısa Türkçe formatta döndürür (grafikler veya küçük kartlar için idealdir).
  String toShortDate() {
    return '$day ${_shortMonths[month - 1]}';
  }

  /// Belirtilen tarihin bugünden kaç gün önce olduğunu hesaplar.
  int daysAgo() {
    final now = DateTime.now();
    final difference = now.difference(this);
    return difference.inDays;
  }
}

