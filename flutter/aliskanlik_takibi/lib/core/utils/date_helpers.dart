/// Ritmo Tarih Yardımcı Fonksiyonları
class DateHelpers {
  DateHelpers._();

  static const List<String> monthNames = [
    '',
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

  static const List<String> dayNames = [
    '',
    'Pazartesi',
    'Salı',
    'Çarşamba',
    'Perşembe',
    'Cuma',
    'Cumartesi',
    'Pazar',
  ];

  static const List<String> dayShortNames = [
    '',
    'Pzt',
    'Sal',
    'Çar',
    'Per',
    'Cum',
    'Cmt',
    'Paz',
  ];

  /// Sadece Yıl-Ay-Gün bilgisini tutan DateTime (saatsiz)
  static DateTime dateOnly(DateTime dt) {
    return DateTime(dt.year, dt.month, dt.day);
  }

  /// İki tarihin aynı takvim günü olup olmadığını denetler
  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  /// "22 Ekim 2026, Perşembe" formatında metin döner
  static String formatFull(DateTime dt) {
    final dayName = dayNames[dt.weekday];
    final monthName = monthNames[dt.month];
    return '${dt.day} $monthName ${dt.year}, $dayName';
  }

  /// "22 Ekim" formatında kısa metin
  static String formatDayMonth(DateTime dt) {
    return '${dt.day} ${monthNames[dt.month]}';
  }

  /// ISO 8601 YYYY-MM-DD
  static String toIsoDate(DateTime dt) {
    final y = dt.year.toString().padLeft(4, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  /// ISO 8601 string'den Date döner
  static DateTime fromIsoDate(String str) {
    final parts = str.split('-');
    if (parts.length != 3) return DateTime.now();
    return DateTime(
      int.parse(parts[0]),
      int.parse(parts[1]),
      int.parse(parts[2]),
    );
  }

  /// Haftanın günleri listesi (1=Pzt, 7=Paz)
  static int getWeekdayIndex(DateTime dt) => dt.weekday;
}
