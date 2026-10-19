import 'package:flutter/foundation.dart';
import '../models/blood_request_model.dart';

class BloodRequestController {
  BloodRequestController()
      : state = ValueNotifier<BloodRequestState>(
          BloodRequestState(
            requests: [
              BloodRequest(
                id: 'req_001',
                patientName: 'Ahmet Yılmaz',
                bloodGroup: 'A+',
                hospitalName: 'Şişli Hamidiye Etfal EAH',
                city: 'İstanbul',
                unitsNeeded: 3,
                unitsCollected: 1,
                urgency: 'Çok Acil',
                createdAt: DateTime.now().subtract(const Duration(hours: 2)),
                matchedDonorCount: 8,
              ),
              BloodRequest(
                id: 'req_002',
                patientName: 'Zeynep Kaya',
                bloodGroup: '0-',
                hospitalName: 'Kartal Dr. Lütfi Kırdar Şehir Hastanesi',
                city: 'İstanbul',
                unitsNeeded: 2,
                unitsCollected: 2,
                urgency: 'Acil',
                createdAt: DateTime.now().subtract(const Duration(hours: 5)),
                isFulfilled: true,
                matchedDonorCount: 4,
              ),
              BloodRequest(
                id: 'req_003',
                patientName: 'Mehmet Demir',
                bloodGroup: 'B+',
                hospitalName: 'Ankara Bilkent Şehir Hastanesi',
                city: 'Ankara',
                unitsNeeded: 4,
                unitsCollected: 2,
                urgency: 'Normal',
                createdAt: DateTime.now().subtract(const Duration(days: 1)),
                matchedDonorCount: 12,
              ),
              BloodRequest(
                id: 'req_004',
                patientName: 'Elif Şahin',
                bloodGroup: 'AB-',
                hospitalName: 'İzmir Ege Üniversitesi Tıp Fakültesi',
                city: 'İzmir',
                unitsNeeded: 2,
                unitsCollected: 0,
                urgency: 'Çok Acil',
                createdAt: DateTime.now().subtract(const Duration(hours: 8)),
                matchedDonorCount: 3,
              ),
            ],
          ),
        );

  final ValueNotifier<BloodRequestState> state;

  void addRequest({
    required String patientName,
    required String bloodGroup,
    required String hospitalName,
    required String city,
    required int unitsNeeded,
    required String urgency,
  }) {
    final newRequest = BloodRequest(
      id: 'req_${DateTime.now().millisecondsSinceEpoch}',
      patientName: patientName,
      bloodGroup: bloodGroup,
      hospitalName: hospitalName,
      city: city,
      unitsNeeded: unitsNeeded,
      unitsCollected: 0,
      urgency: urgency,
      createdAt: DateTime.now(),
      matchedDonorCount: 5,
    );

    final updatedList = [newRequest, ...state.value.requests];
    state.value = state.value.copyWith(requests: updatedList);
  }

  void filterByBloodGroup(String? bloodGroup) {
    if (state.value.filterBloodGroup == bloodGroup) {
      state.value = state.value.copyWith(filterBloodGroup: () => null);
    } else {
      state.value = state.value.copyWith(filterBloodGroup: () => bloodGroup);
    }
  }

  void supportRequest(String requestId) {
    final updatedList = state.value.requests.map((req) {
      if (req.id == requestId) {
        final newCollected = req.unitsCollected + 1;
        final isCompleted = newCollected >= req.unitsNeeded;
        return req.copyWith(
          unitsCollected: newCollected,
          isFulfilled: isCompleted,
        );
      }
      return req;
    }).toList();

    state.value = state.value.copyWith(requests: updatedList);
  }

  void dispose() {
    state.dispose();
  }
}
