/// Tarih formatlama ve hesaplama uzantıları
extension DateExtensions on DateTime {
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

  String toFormattedTurkish() {
    return '$day ${_months[month - 1]} $year';
  }

  String toShortDate() {
    return '$day ${_shortMonths[month - 1]}';
  }

  int daysAgo() {
    final now = DateTime.now();
    final difference = now.difference(this);
    return difference.inDays;
  }
}
