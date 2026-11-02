import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:susadim/features/workout/models/workout_entry.dart';

/// Egzersiz ve yakılan kalori takibi modülünün durum yönetimini (State Management)
/// ve iş kurallarını yöneten denetleyici sınıfı.
///
/// [ChangeNotifier] mimarisi ile çalışır; veri eklendiğinde, silindiğinde veya
/// güncellendiğinde arayüze (UI) [notifyListeners] ile bildirim gönderir.
class WorkoutController extends ChangeNotifier {
  /// [WorkoutController] kurucu metodu.
  ///
  /// [initialCalorieGoal] parametresi ile varsayılan günlük kalori yakım hedefi (varsayılan: 500 kcal) atanır.
  WorkoutController({int initialCalorieGoal = 500})
      : _dailyCalorieGoal = initialCalorieGoal;

  /// Günlük yakılması hedeflenen kalori miktarı (kcal)
  int _dailyCalorieGoal;

  /// Gün içerisinde tamamlanan egzersizlerin tutulduğu özel (private) liste
  final List<WorkoutEntry> _workouts = <WorkoutEntry>[];

  // ===========================================================================
  // Getter Özellikleri (Read-Only Access)
  // ===========================================================================

  /// Günlük kalori hedefini döndürür
  int get dailyCalorieGoal => _dailyCalorieGoal;

  /// Egzersiz listesini dış dünyaya değiştirilemez (read-only) liste olarak sunar.
  ///
  /// [UnmodifiableListView], listenin controller dışından izinsiz değiştirilmesini
  /// önleyerek verinin güvenliğini ve tutarlılığını sağlar.
  UnmodifiableListView<WorkoutEntry> get workouts =>
      UnmodifiableListView<WorkoutEntry>(_workouts);

  /// Gün içinde yapılan tüm egzersizlerden yakılan toplam kalori miktarını (kcal) hesaplar.
  ///
  /// [fold] metodu, listedeki `caloriesBurned` değerlerini toplayarak tek bir sonuca ulaşır.
  int get totalCaloriesBurned {
    return _workouts.fold<int>(0, (sum, item) => sum + item.caloriesBurned);
  }

  /// Tamamlanan tüm antrenmanların toplam aktif süresini (dakika) hesaplar.
  int get totalActiveMinutes {
    return _workouts.fold<int>(0, (sum, item) => sum + item.durationMinutes);
  }

  /// Günlük kalori hedefine göre ilerleme oranını 0.0 ile 1.0 arasında döndürür.
  ///
  /// [clamp] fonksiyonu, değerin 0.0 ile 1.0 aralığının dışına taşmasını engeller.
  double get calorieProgressRatio {
    if (_dailyCalorieGoal <= 0) return 0.0;
    final ratio = totalCaloriesBurned / _dailyCalorieGoal;
    return ratio.clamp(0.0, 1.0);
  }

  /// Günlük kalori hedefine ulaşmak için yakılması gereken kalan kalori miktarını hesaplar.
  /// Hedef aşılmışsa negatif değer yerine 0 döner.
  int get remainingCalories {
    final remaining = _dailyCalorieGoal - totalCaloriesBurned;
    return remaining < 0 ? 0 : remaining;
  }

  // ===========================================================================
  // Durum Değiştiren Metotlar (Mutations)
  // ===========================================================================

  /// Yeni bir egzersiz kaydı oluşturur ve listeye ekler.
  ///
  /// - [title]: Egzersizin adı (boş olamaz)
  /// - [durationMinutes]: Süre (0'dan büyük olmalı)
  /// - [caloriesBurned]: Yakılan kalori (0'dan büyük olmalı)
  /// - [intensity]: Efor yoğunluk seviyesi
  ///
  /// Geçersiz parametreler verildiğinde işlem yapılmadan fonksiyon sonlandırılır (Early Return).
  void addWorkout({
    required String title,
    required int durationMinutes,
    required int caloriesBurned,
    required WorkoutIntensity intensity,
  }) {
    // Veri doğrulama kontrolü (Validation)
    if (title.trim().isEmpty || durationMinutes <= 0 || caloriesBurned <= 0) {
      return;
    }

    // Yeni egzersiz nesnesi oluşturulur
    final entry = WorkoutEntry(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title.trim(),
      durationMinutes: durationMinutes,
      caloriesBurned: caloriesBurned,
      intensity: intensity,
      timestamp: DateTime.now(),
    );

    // Yeni antrenmanı listenin en başına (en üste) ekler
    _workouts.insert(0, entry);

    // Değişikliği dinleyicilere bildirerek arayüzü günceller
    notifyListeners();
  }

  /// Verilen [id]'ye sahip antrenmanı listeden siler ve arayüzü yeniler.
  void removeWorkout(String id) {
    _workouts.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  /// Günlük kalori yakım hedefini yeni bir değerle günceller.
  void updateCalorieGoal(int newGoal) {
    if (newGoal <= 0) return;
    _dailyCalorieGoal = newGoal;
    notifyListeners();
  }

  /// Tüm egzersiz kayıtlarını temizler (sıfırlar) ve arayüzü günceller.
  void reset() {
    _workouts.clear();
    notifyListeners();
  }
}
