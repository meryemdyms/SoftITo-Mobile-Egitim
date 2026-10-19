import 'package:flutter_test/flutter_test.dart';
import 'package:kirmizi_cagri/features/blood_request/controllers/blood_request_controller.dart';

void main() {
  group('BloodRequestController Tests', () {
    test('Initial requests are populated', () {
      final controller = BloodRequestController();
      expect(controller.state.value.requests.isNotEmpty, isTrue);
      controller.dispose();
    });

    test('addRequest adds a new blood request at the top', () {
      final controller = BloodRequestController();
      final initialCount = controller.state.value.requests.length;

      controller.addRequest(
        patientName: 'Test Hasta',
        bloodGroup: '0-',
        hospitalName: 'Test Hastane',
        city: 'İstanbul',
        unitsNeeded: 3,
        urgency: 'Çok Acil',
      );

      expect(controller.state.value.requests.length, initialCount + 1);
      expect(controller.state.value.requests.first.hospitalName, 'Test Hastane');
      expect(controller.state.value.requests.first.bloodGroup, '0-');
      controller.dispose();
    });

    test('filterByBloodGroup filters requests properly', () {
      final controller = BloodRequestController();
      controller.filterByBloodGroup('A+');
      expect(controller.state.value.filterBloodGroup, 'A+');

      final filtered = controller.state.value.filteredRequests;
      expect(filtered.every((r) => r.bloodGroup == 'A+'), isTrue);

      // Toggling same filter resets to null
      controller.filterByBloodGroup('A+');
      expect(controller.state.value.filterBloodGroup, isNull);
      controller.dispose();
    });

    test('supportRequest increases collected units and marks fulfilled', () {
      final controller = BloodRequestController();
      final req = controller.state.value.requests.first;
      final targetId = req.id;
      final initialCollected = req.unitsCollected;

      controller.supportRequest(targetId);
      final updated = controller.state.value.requests.firstWhere((r) => r.id == targetId);
      expect(updated.unitsCollected, initialCollected + 1);
      controller.dispose();
    });
  });
}
