import 'package:flutter/foundation.dart';
import '../models/donor_profile_model.dart';

/// Donör profili bilgilerini yöneten ve değişiklikleri reaktif olarak yayınlayan kontrolcü sınıfı.
/// Müsaitlik durumunu değiştirme, kan grubu/konum güncelleme ve yeni bağış kaydetme işlevlerini barındırır.
class DonorProfileController {
  /// Başlangıç profil verileriyle durumu ilklendirir. Dışarıdan verilmezse varsayılan kullanıcı oluşturur.
  DonorProfileController({DonorProfile? initialProfile})
      : state = ValueNotifier<DonorProfile>(
          initialProfile ??
              DonorProfile(
                id: 'donor_001',
                fullName: 'Meryem Duymuş',
                bloodGroup: 'A+',
                city: 'İstanbul',
                district: 'Kadıköy',
                lastDonationDate: DateTime.now().subtract(
                  const Duration(days: 64),
                ),
                isAvailable: true,
                totalDonationsCount: 5,
              ),
        );

  /// Profil durumunu yayınlayan reaktif nesne.
  final ValueNotifier<DonorProfile> state;

  /// Donörün acil çağrılarda aranabilir/müsait olma durumunu açıp kapatır.
  void toggleAvailability(bool isAvailable) {
    state.value = state.value.copyWith(isAvailable: isAvailable);
  }

  /// Donörün kan grubunu günceller.
  void updateBloodGroup(String newBloodGroup) {
    state.value = state.value.copyWith(bloodGroup: newBloodGroup);
  }

  /// Donörün yaşadığı şehir ve ilçe bilgisini günceller.
  void updateCityAndDistrict(String city, String district) {
    state.value = state.value.copyWith(city: city, district: district);
  }

  /// Yeni yapılan bir bağışı donör profiline işler (Son bağış tarihi güncellenir ve bağış sayısı 1 artar).
  void recordDonation(DateTime date) {
    state.value = state.value.copyWith(
      lastDonationDate: date,
      totalDonationsCount: state.value.totalDonationsCount + 1,
    );
  }

  /// Kontrolcü yok edildiğinde state dinleyicisini serbest bırakır.
  void dispose() {
    state.dispose();
  }
}

