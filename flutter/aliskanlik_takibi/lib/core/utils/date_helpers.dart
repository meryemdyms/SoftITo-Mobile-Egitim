/// Ritmo Tarih ve Saat Yardımcı Fonksiyonları.
///
/// Uygulama genelinde Türkçe ay/gün isimlerinin biçimlendirilmesi,
/// saat bilgilerinden arındırılmış saf takvim günü karşılaştırmaları
/// ve ISO 8601 (YYYY-MM-DD) tarih çevrimleri bu sınıf üzerinden sağlanır.
class DateHelpers {
  // Doğrudan örneklenmeyi önlemek için private yapıcı
  DateHelpers._();

  /// 1-tabanlı (1 = Ocak, 12 = Aralık) Türkçe ay isimleri listesi.
  /// 0. indeks boş bırakılarak ay numarası doğrudan erişilebilir kılınmıştır.
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

  /// 1-tabanlı (1 = Pazartesi, 7 = Pazar) Türkçe tam gün isimleri listesi.
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

  /// 1-tabanlı Türkçe kısa gün isimleri listesi (Örn: grafik ve takvimler için).
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

  /// Saat, dakika, saniye ve milisaniye bilgilerini sıfırlayarak
  /// sadece Yıl-Ay-Gün bilgisini içeren saf [DateTime] nesnesi döndürür.
  ///
  /// Alışkanlık takip süreçlerinde gün karşılaştırmalarının saat farkından
  /// etkilenmemesi için zorunlu olarak kullanılır.
  static DateTime dateOnly(DateTime dt) {
    return DateTime(dt.year, dt.month, dt.day);
  }

  /// İki [DateTime] nesnesinin aynı takvim gününe (yıl, ay ve gün) denk gelip gelmediğini kontrol eder.
  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  /// Tarihi "22 Ekim 2026, Perşembe" gibi tam ve kullanıcı dostu Türkçe formatında biçimlendirir.
  static String formatFull(DateTime dt) {
    final dayName = dayNames[dt.weekday];
    final monthName = monthNames[dt.month];
    return '${dt.day} $monthName ${dt.year}, $dayName';
  }

  /// Tarihi "22 Ekim" formatında kısa gün ve ay olarak biçimlendirir.
  static String formatDayMonth(DateTime dt) {
    return '${dt.day} ${monthNames[dt.month]}';
  }

  /// Tarih nesnesini standart "YYYY-MM-DD" ISO 8601 formatına dönüştürür.
  /// Yerel veritabanında günlük ilerleme anahtarı olarak saklanırken kullanılır.
  static String toIsoDate(DateTime dt) {
    final y = dt.year.toString().padLeft(4, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  /// "YYYY-MM-DD" formatındaki metin dizgisinden [DateTime] nesnesi üretir.
  /// Biçim hatalıysa varsayılan olarak şu anki zamanı döndürür.
  static DateTime fromIsoDate(String str) {
    final parts = str.split('-');
    if (parts.length != 3) return DateTime.now();
    return DateTime(
      int.parse(parts[0]),
      int.parse(parts[1]),
      int.parse(parts[2]),
    );
  }

  /// Haftanın gün indeksini döndürür (1 = Pazartesi, 7 = Pazar).
  static int getWeekdayIndex(DateTime dt) => dt.weekday;
}
