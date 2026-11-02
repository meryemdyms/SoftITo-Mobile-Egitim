import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:susadim/features/water_tracker/models/water_log.dart';

/// Su takip modülünün iş mantığını (Business Logic) ve durum yönetimini (State Management)
/// üstlenen denetleyici sınıfı.
///
/// [ChangeNotifier] sınıfından türetilmiştir. Durumda (State) bir değişiklik olduğunda
/// [notifyListeners] metodunu çağırarak bu sınıfı dinleyen widget'ların (`ListenableBuilder`,
/// `AnimatedBuilder` vb.) yeniden çizilmesini (rebuild) tetikler.
class WaterTrackerController extends ChangeNotifier {
  /// [WaterTrackerController] kurucu metodu.
  ///
  /// [initialGoalMl] ile varsayılan günlük hedef (varsayılan: 2500 ml) belirlenir.
  WaterTrackerController({int initialGoalMl = 2500})
      : _dailyGoalMl = initialGoalMl;

  /// Günlük içilmesi hedeflenen su miktarı (ml)
  int _dailyGoalMl;

  /// Eklenen su tüketim kayıtlarının tutulduğu özel (private) liste
  final List<WaterLog> _logs = <WaterLog>[];

  // ===========================================================================
  // Getter Özellikleri (Read-Only Access)
  // ===========================================================================

  /// Günlük su hedefini (ml) dış dünyaya sunar
  int get dailyGoalMl => _dailyGoalMl;

  /// Tüketim loglarını dış dünyaya salt okunur (read-only) liste olarak sunar.
  ///
  /// [UnmodifiableListView], listenin dışarıdan doğrudan `logs.clear()` veya `logs.add()`
  /// yapılarak bozulmasını engeller; durumun yalnızca controller metotlarıyla
  /// değiştirilmesini (Encapsulation) garanti eder.
  UnmodifiableListView<WaterLog> get logs => UnmodifiableListView<WaterLog>(_logs);

  /// Gün içerisinde şimdiye kadar tüketilen toplam sıvı miktarını (ml) hesaplar.
  ///
  /// [fold] metodu, listedeki her bir [WaterLog] nesnesinin `amountMl` değerini
  /// başlangıç değeri 0 olan akümülatöre ekleyerek tek bir toplam değere indirger.
  int get totalConsumedMl {
    return _logs.fold<int>(0, (sum, log) => sum + log.amountMl);
  }

  /// Günlük hedefe göre ilerleme oranını 0.0 ile 1.0 arasında bir katsayı olarak döndürür.
  ///
  /// [clamp] fonksiyonu, değerin 0.0'ın altına düşmesini veya 1.0'ın (yani %100'ün)
  /// üstüne çıkarak dairesel göstergeyi (CircularProgressIndicator) bozmasını engeller.
  double get progressRatio {
    if (_dailyGoalMl <= 0) return 0.0;
    final ratio = totalConsumedMl / _dailyGoalMl;
    return ratio.clamp(0.0, 1.0);
  }

  /// Günlük hedefe ulaşmak için kalan su miktarını (ml) hesaplar.
  /// Hedef aşılmışsa negatif değer yerine 0 döner.
  int get remainingMl {
    final remaining = _dailyGoalMl - totalConsumedMl;
    return remaining < 0 ? 0 : remaining;
  }

  /// Tüketilen toplam su miktarının günlük hedefe ulaşıp ulaşmadığını belirtir
  bool get isGoalAchieved => totalConsumedMl >= _dailyGoalMl;

  // ===========================================================================
  // Durum Değiştiren Metotlar (Mutations)
  // ===========================================================================

  /// Yeni bir su/sıvı tüketim kaydı ekler.
  ///
  /// - [amountMl]: Eklenecek miktar (ml). Sıfır veya negatif ise işlem yapılmaz.
  /// - [type]: İçeceğin türü (varsayılan: [DrinkType.water]).
  ///
  /// Dönüş Değeri:
  /// Bu ekleme işlemiyle birlikte günlük hedefe ilk kez ulaşılmışsa `true`,
  /// aksi halde `false` döner. Böylece arayüz tarafında tebrik kutlaması (dialog) tetiklenebilir.
  bool addWater(int amountMl, {DrinkType type = DrinkType.water}) {
    if (amountMl <= 0) return false;

    // Ekleme öncesinde hedefe ulaşılmış mıydı?
    final wasAchieved = isGoalAchieved;

    // Yeni kayıt oluşturulur (ID olarak mikrosaniye zaman damgası kullanılır)
    final log = WaterLog(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      amountMl: amountMl,
      timestamp: DateTime.now(),
      type: type,
    );

    // Yeni kaydı listenin en başına ekler (en güncel kayıt en üstte görünür)
    _logs.insert(0, log);

    // Ekleme sonrasında hedefe ulaşıldı mı?
    final nowAchieved = isGoalAchieved;

    // Dinleyicilere durumun değiştiğini bildirir
    notifyListeners();

    // Önceden ulaşılmamışken şimdi ilk kez hedefe ulaşıldıysa true döner
    return !wasAchieved && nowAchieved;
  }

  /// Belirtilen [id]'ye sahip su kaydını listeden siler ve arayüzü günceller.
  void removeLog(String id) {
    _logs.removeWhere((log) => log.id == id);
    notifyListeners();
  }

  /// Günlük su hedefini yeni bir değerle günceller.
  /// Pozitif olmayan geçersiz değerler yoksayılır.
  void updateDailyGoal(int newGoalMl) {
    if (newGoalMl <= 0) return;
    _dailyGoalMl = newGoalMl;
    notifyListeners();
  }

  /// Günlük tüm su tüketim kayıtlarını sıfırlar (temizler) ve arayüzü günceller.
  void reset() {
    _logs.clear();
    notifyListeners();
  }
}
