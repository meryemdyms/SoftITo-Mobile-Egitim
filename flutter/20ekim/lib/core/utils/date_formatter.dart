import 'package:intl/intl.dart';

/// Tarih ve saat biçimlendirme ile kiralama süresi/çakışma hesaplama yardımcı sınıfı.
class DateFormatter {
  DateFormatter._();

  static final DateFormat _dateTimeFormat = DateFormat(
    'dd.MM.yyyy HH:mm',
    'tr_TR',
  );
  static final DateFormat _dateFormat = DateFormat('dd.MM.yyyy', 'tr_TR');
  static final DateFormat _timeFormat = DateFormat('HH:mm', 'tr_TR');
  static final DateFormat _shortDateWithMonth = DateFormat(
    'd MMM yyyy',
    'tr_TR',
  );

  /// Tarih ve saat formatı: "02.11.2026 14:30"
  static String formatDateTime(DateTime dateTime) =>
      _dateTimeFormat.format(dateTime);

  /// Yalnızca tarih formatı: "02.11.2026"
  static String formatDate(DateTime dateTime) => _dateFormat.format(dateTime);

  /// Yalnızca saat formatı: "14:30"
  static String formatTime(DateTime dateTime) => _timeFormat.format(dateTime);

  /// Ay ismi içeren kısa tarih: "2 Kas 2026"
  static String formatShortDateWithMonth(DateTime dateTime) =>
      _shortDateWithMonth.format(dateTime);

  /// Proje kuralına göre gün sayısını hesaplar:
  /// `ceil(toplam_saat / 24)`, minimum 1 gün.
  static int calculateDayCount(DateTime start, DateTime end) {
    final diffMinutes = end.difference(start).inMinutes;
    if (diffMinutes <= 0) return 1;
    final double hours = diffMinutes / 60.0;
    final int days = (hours / 24.0).ceil();
    return days < 1 ? 1 : days;
  }

  /// Yarı açık iki zaman aralığının [aStart, aEnd) ve [bStart, bEnd) çakışıp çakışmadığını denetler.
  ///
  /// Çakışma koşulu: `aStart < bEnd && aEnd > bStart`.
  /// Bitişik aralıklar (örneğin aEnd == bStart) çakışma sayılmaz.
  static bool areIntervalsOverlapping(
    DateTime aStart,
    DateTime aEnd,
    DateTime bStart,
    DateTime bEnd,
  ) {
    return aStart.isBefore(bEnd) && aEnd.isAfter(bStart);
  }
}
