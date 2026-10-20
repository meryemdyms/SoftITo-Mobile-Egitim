class DateRange {
  final DateTime startAt;
  final DateTime endAt;

  const DateRange({required this.startAt, required this.endAt});

  /// Overlap check: [startAt, endAt) with [otherStart, otherEnd)
  bool overlapsWith(DateTime otherStart, DateTime otherEnd) {
    return startAt.isBefore(otherEnd) && endAt.isAfter(otherStart);
  }

  Map<String, dynamic> toJson() => {
    'startAt': startAt.toIso8601String(),
    'endAt': endAt.toIso8601String(),
  };

  factory DateRange.fromJson(Map<String, dynamic> json) => DateRange(
    startAt: DateTime.parse(json['startAt'] as String),
    endAt: DateTime.parse(json['endAt'] as String),
  );
}
