import 'package:flutter/foundation.dart';

@immutable
class DonationRecord {
  const DonationRecord({
    required this.id,
    required this.date,
    required this.hospitalName,
    required this.city,
    required this.donationType,
    this.units = 1,
    this.status = 'Tamamlandı',
    this.notes = '',
  });

  final String id;
  final DateTime date;
  final String hospitalName;
  final String city;
  final String donationType;
  final int units;
  final String status;
  final String notes;

  DonationRecord copyWith({
    String? id,
    DateTime? date,
    String? hospitalName,
    String? city,
    String? donationType,
    int? units,
    String? status,
    String? notes,
  }) {
    return DonationRecord(
      id: id ?? this.id,
      date: date ?? this.date,
      hospitalName: hospitalName ?? this.hospitalName,
      city: city ?? this.city,
      donationType: donationType ?? this.donationType,
      units: units ?? this.units,
      status: status ?? this.status,
      notes: notes ?? this.notes,
    );
  }
}

@immutable
class DonationHistoryState {
  const DonationHistoryState({
    this.records = const [],
    this.isLoading = false,
  });

  final List<DonationRecord> records;
  final bool isLoading;

  int get totalUnits => records.fold(0, (sum, item) => sum + item.units);

  DonationHistoryState copyWith({
    List<DonationRecord>? records,
    bool? isLoading,
  }) {
    return DonationHistoryState(
      records: records ?? this.records,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
