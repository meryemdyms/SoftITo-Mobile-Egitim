import 'package:flutter/foundation.dart';
import '../models/donation_history_model.dart';

/// Donörün kan bağış geçmişini yöneten kontrolcü sınıfı.
/// Başlangıç mock bağış kayıtlarını yükler, yeni bağış ekleme ve kayıt silme işlevlerini sağlar.
class DonationHistoryController {
  /// Kontrolcü örneği oluşturulduğunda varsayılan geçmiş bağış verileriyle durumu ilklendirir.
  /// [onDonationAdded] callback'i, yeni bir bağış eklendiğinde profil ve istatistik
  /// modüllerini haberdar etmek için kullanılır.
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

  /// Bağış geçmişi listesini yayınlayan reaktif durum nesnesi.
  final ValueNotifier<DonationHistoryState> state;

  /// Yeni bir bağış başarıyla eklendiğinde tetiklenen geri çağırım fonksiyonu.
  final ValueChanged<DonationRecord>? onDonationAdded;

  /// Sisteme yeni bir kan bağışı kaydı ekler ve listeyi günceller.
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

    // Diğer ekranları (Profil & İstatistik) bilgilendirir
    onDonationAdded?.call(record);
  }

  /// Belirtilen kimliğe sahip bağış kaydını listeden siler.
  void removeDonation(String id) {
    final updated = state.value.records.where((r) => r.id != id).toList();
    state.value = state.value.copyWith(records: updated);
  }

  /// Kontrolcü sonlandığında state dinleyicisini serbest bırakır.
  void dispose() {
    state.dispose();
  }
}

