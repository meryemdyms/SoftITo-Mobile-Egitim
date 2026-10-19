import 'package:flutter/foundation.dart';

@immutable
class BloodRequest {
  const BloodRequest({
    required this.id,
    required this.patientName,
    required this.bloodGroup,
    required this.hospitalName,
    required this.city,
    required this.unitsNeeded,
    this.unitsCollected = 0,
    required this.urgency,
    required this.createdAt,
    this.isFulfilled = false,
    this.matchedDonorCount = 0,
  });

  final String id;
  final String patientName;
  final String bloodGroup;
  final String hospitalName;
  final String city;
  final int unitsNeeded;
  final int unitsCollected;
  final String urgency;
  final DateTime createdAt;
  final bool isFulfilled;
  final int matchedDonorCount;

  double get progressPercentage {
    if (unitsNeeded <= 0) return 1.0;
    final ratio = unitsCollected / unitsNeeded;
    return ratio > 1.0 ? 1.0 : ratio;
  }

  BloodRequest copyWith({
    String? id,
    String? patientName,
    String? bloodGroup,
    String? hospitalName,
    String? city,
    int? unitsNeeded,
    int? unitsCollected,
    String? urgency,
    DateTime? createdAt,
    bool? isFulfilled,
    int? matchedDonorCount,
  }) {
    return BloodRequest(
      id: id ?? this.id,
      patientName: patientName ?? this.patientName,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      hospitalName: hospitalName ?? this.hospitalName,
      city: city ?? this.city,
      unitsNeeded: unitsNeeded ?? this.unitsNeeded,
      unitsCollected: unitsCollected ?? this.unitsCollected,
      urgency: urgency ?? this.urgency,
      createdAt: createdAt ?? this.createdAt,
      isFulfilled: isFulfilled ?? this.isFulfilled,
      matchedDonorCount: matchedDonorCount ?? this.matchedDonorCount,
    );
  }
}

@immutable
class BloodRequestState {
  const BloodRequestState({
    this.requests = const [],
    this.filterBloodGroup,
    this.isLoading = false,
  });

  final List<BloodRequest> requests;
  final String? filterBloodGroup;
  final bool isLoading;

  List<BloodRequest> get filteredRequests {
    if (filterBloodGroup == null || filterBloodGroup!.isEmpty) {
      return requests;
    }
    return requests
        .where((r) => r.bloodGroup == filterBloodGroup)
        .toList();
  }

  BloodRequestState copyWith({
    List<BloodRequest>? requests,
    String? Function()? filterBloodGroup,
    bool? isLoading,
  }) {
    return BloodRequestState(
      requests: requests ?? this.requests,
      filterBloodGroup: filterBloodGroup != null
          ? filterBloodGroup()
          : this.filterBloodGroup,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
