import 'package:flutter/foundation.dart';
import '../models/donation_history_model.dart';

class DonationHistoryController {
  DonationHistoryController({this.onDonationAdded})
      : state = ValueNotifier<DonationHistoryState>(
          DonationHistoryState(
            records: [
              DonationRecord(
                id: 'don_001',
                date: DateTime.now().subtract(const Duration(days: 64)),
                hospitalName: 'Kızılay Kadıköy Kan Bağış Merkezi',
                city: 'İstanbul',
                donationType: 'Tam Kan',
                units: 1,
                status: 'Tamamlandı',
                notes: 'Düzenli periyodik bağış',
              ),
              DonationRecord(
                id: 'don_002',
                date: DateTime.now().subtract(const Duration(days: 160)),
                hospitalName: 'Ümraniye EAH Kan Merkezi',
                city: 'İstanbul',
                donationType: 'Tam Kan',
                units: 1,
                status: 'Tamamlandı',
                notes: 'Acil çağrı üzerine yapıldı',
              ),
              DonationRecord(
                id: 'don_003',
                date: DateTime.now().subtract(const Duration(days: 260)),
                hospitalName: 'Kızılay Beşiktaş Kan Bağış Çadırı',
                city: 'İstanbul',
                donationType: 'Trombosit',
                units: 1,
                status: 'Tamamlandı',
                notes: 'Aferez trombosit bağışı',
              ),
              DonationRecord(
                id: 'don_004',
                date: DateTime.now().subtract(const Duration(days: 370)),
                hospitalName: 'Zeynep Kamil Kadın ve Çocuk Hastalıkları EAH',
                city: 'İstanbul',
                donationType: 'Tam Kan',
                units: 1,
                status: 'Tamamlandı',
              ),
            ],
          ),
        );

  final ValueNotifier<DonationHistoryState> state;
  final ValueChanged<DonationRecord>? onDonationAdded;

  void addDonation({
    required DateTime date,
    required String hospitalName,
    required String city,
    required String donationType,
    int units = 1,
    String notes = '',
  }) {
    final record = DonationRecord(
      id: 'don_${DateTime.now().millisecondsSinceEpoch}',
      date: date,
      hospitalName: hospitalName,
      city: city,
      donationType: donationType,
      units: units,
      status: 'Tamamlandı',
      notes: notes,
    );

    final updated = [record, ...state.value.records];
    state.value = state.value.copyWith(records: updated);
    onDonationAdded?.call(record);
  }

  void removeDonation(String id) {
    final updated = state.value.records.where((r) => r.id != id).toList();
    state.value = state.value.copyWith(records: updated);
  }

  void dispose() {
    state.dispose();
  }
}
