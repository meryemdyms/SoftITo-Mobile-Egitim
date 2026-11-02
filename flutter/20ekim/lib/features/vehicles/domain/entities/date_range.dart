/// Başlangıç ve bitiş zamanı içeren yarı açık [startAt, endAt) tarih aralığı modeli.
///
/// Araçların bakım, arıza veya firma tarafından bloke edilen dönemlerini temsil eder.
class DateRange {
  /// Aralığın başlangıç zamanı (dahil).
  final DateTime startAt;

  /// Aralığın bitiş zamanı (hariç).
  final DateTime endAt;

  const DateRange({required this.startAt, required this.endAt});

  /// Bu aralığın [otherStart, otherEnd) ile çakışıp çakışmadığını denetler.
  ///
  /// Koşul: `startAt < otherEnd && endAt > otherStart`.
  bool overlapsWith(DateTime otherStart, DateTime otherEnd) {
    return startAt.isBefore(otherEnd) && endAt.isAfter(otherStart);
  }

  /// JSON serileştirme haritası.
  Map<String, dynamic> toJson() => {
    'startAt': startAt.toIso8601String(),
    'endAt': endAt.toIso8601String(),
  };

  /// JSON haritasından [DateRange] örneği üretir.
  factory DateRange.fromJson(Map<String, dynamic> json) => DateRange(
    startAt: DateTime.parse(json['startAt'] as String),
    endAt: DateTime.parse(json['endAt'] as String),
  );
}
