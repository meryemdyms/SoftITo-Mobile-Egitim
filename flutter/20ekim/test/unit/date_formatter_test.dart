import 'package:flutter_test/flutter_test.dart';
import 'package:car_rental_platform/core/utils/date_formatter.dart';

void main() {
  group('DateFormatter - Day Count Calculation', () {
    test('less than 24 hours counts as 1 day (ceil rule)', () {
      final start = DateTime(2026, 10, 20, 10, 0);
      final end = DateTime(2026, 10, 20, 16, 0); // 6 hours
      expect(DateFormatter.calculateDayCount(start, end), 1);
    });

    test('exactly 24 hours counts as 1 day', () {
      final start = DateTime(2026, 10, 20, 10, 0);
      final end = DateTime(2026, 10, 21, 10, 0); // 24 hours
      expect(DateFormatter.calculateDayCount(start, end), 1);
    });

    test('24 hours and 1 minute rounds up to 2 days', () {
      final start = DateTime(2026, 10, 20, 10, 0);
      final end = DateTime(2026, 10, 21, 10, 1); // 24h 1m
      expect(DateFormatter.calculateDayCount(start, end), 2);
    });

    test('48 hours counts as 2 days', () {
      final start = DateTime(2026, 10, 20, 10, 0);
      final end = DateTime(2026, 10, 22, 10, 0);
      expect(DateFormatter.calculateDayCount(start, end), 2);
    });
  });

  group('DateFormatter - Interval Overlap Rule [start, end)', () {
    test('Neighboring boundaries do NOT overlap', () {
      final aStart = DateTime(2026, 10, 20, 10, 0);
      final aEnd = DateTime(2026, 10, 22, 10, 0);

      final bStart = DateTime(
        2026,
        10,
        22,
        10,
        0,
      ); // starts exactly when A ends
      final bEnd = DateTime(2026, 10, 24, 10, 0);

      expect(
        DateFormatter.areIntervalsOverlapping(aStart, aEnd, bStart, bEnd),
        isFalse,
      );
      expect(
        DateFormatter.areIntervalsOverlapping(bStart, bEnd, aStart, aEnd),
        isFalse,
      );
    });

    test('1 second overlap DOES overlap', () {
      final aStart = DateTime(2026, 10, 20, 10, 0);
      final aEnd = DateTime(2026, 10, 22, 10, 0);

      final bStart = DateTime(
        2026,
        10,
        22,
        9,
        59,
        59,
      ); // 1 second before A ends
      final bEnd = DateTime(2026, 10, 24, 10, 0);

      expect(
        DateFormatter.areIntervalsOverlapping(aStart, aEnd, bStart, bEnd),
        isTrue,
      );
      expect(
        DateFormatter.areIntervalsOverlapping(bStart, bEnd, aStart, aEnd),
        isTrue,
      );
    });

    test('Completely enclosed interval overlaps', () {
      final aStart = DateTime(2026, 10, 20, 10, 0);
      final aEnd = DateTime(2026, 10, 25, 10, 0);

      final bStart = DateTime(2026, 10, 21, 10, 0);
      final bEnd = DateTime(2026, 10, 23, 10, 0);

      expect(
        DateFormatter.areIntervalsOverlapping(aStart, aEnd, bStart, bEnd),
        isTrue,
      );
    });

    test('Completely separate intervals do not overlap', () {
      final aStart = DateTime(2026, 10, 20, 10, 0);
      final aEnd = DateTime(2026, 10, 22, 10, 0);

      final bStart = DateTime(2026, 10, 25, 10, 0);
      final bEnd = DateTime(2026, 10, 27, 10, 0);

      expect(
        DateFormatter.areIntervalsOverlapping(aStart, aEnd, bStart, bEnd),
        isFalse,
      );
    });
  });
}
