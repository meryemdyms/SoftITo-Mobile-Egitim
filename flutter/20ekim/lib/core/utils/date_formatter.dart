import 'package:intl/intl.dart';

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

  static String formatDateTime(DateTime dateTime) =>
      _dateTimeFormat.format(dateTime);
  static String formatDate(DateTime dateTime) => _dateFormat.format(dateTime);
  static String formatTime(DateTime dateTime) => _timeFormat.format(dateTime);
  static String formatShortDateWithMonth(DateTime dateTime) =>
      _shortDateWithMonth.format(dateTime);

  /// Calculates duration in days according to rule: ceil(total_hours / 24), minimum 1 day.
  static int calculateDayCount(DateTime start, DateTime end) {
    final diffMinutes = end.difference(start).inMinutes;
    if (diffMinutes <= 0) return 1;
    final double hours = diffMinutes / 60.0;
    final int days = (hours / 24.0).ceil();
    return days < 1 ? 1 : days;
  }

  /// Checks if two half-open intervals [aStart, aEnd) and [bStart, bEnd) overlap.
  /// Overlap condition: aStart < bEnd && aEnd > bStart.
  /// Neighboring intervals (e.g. aEnd == bStart) do NOT overlap.
  static bool areIntervalsOverlapping(
    DateTime aStart,
    DateTime aEnd,
    DateTime bStart,
    DateTime bEnd,
  ) {
    return aStart.isBefore(bEnd) && aEnd.isAfter(bStart);
  }
}
