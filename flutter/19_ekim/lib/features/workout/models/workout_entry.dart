/// Yapılan egzersizin zorluk ve yoğunluk seviyesini temsil eden enum.
///
/// Antrenmanın kalori tüketim hızını ve efor derecesini sınıflandırmak için kullanılır.
enum WorkoutIntensity {
  /// Düşük yoğunluklu egzersizler (örn: Yürüyüş, esneme, hafif yoga)
  low,

  /// Orta yoğunluklu egzersizler (örn: Tempolu yürüyüş, hafif ağırlık, pilates)
  medium,

  /// Yüksek yoğunluklu egzersizler (örn: HIIT, koşu, crossfit, ağır squat)
  high;

  /// Arayüzde kullanıcıya sunulan Türkçe gösterim adı
  String get displayName {
    switch (this) {
      case WorkoutIntensity.low:
        return 'Hafif';
      case WorkoutIntensity.medium:
        return 'Orta';
      case WorkoutIntensity.high:
        return 'Yoğun';
    }
  }
}

/// Kaydedilen tek bir antrenman/egzersiz hareketini temsil eden değişmez (immutable) veri modeli.
///
/// Model içerisindeki tüm özellikler `final` olarak tanımlanarak veri bütünlüğü korunur.
class WorkoutEntry {
  /// [WorkoutEntry] nesnesini başlatan const yapıcı metot (constructor).
  const WorkoutEntry({
    required this.id,
    required this.title,
    required this.durationMinutes,
    required this.caloriesBurned,
    required this.intensity,
    required this.timestamp,
  });

  /// Egzersizin tekil kimlik numarası (ID)
  final String id;

  /// Egzersizin adı/başlığı (örn: "Sabah Koşusu", "Ağırlık Antrenmanı")
  final String title;

  /// Egzersizin sürdüğü toplam süre (dakika cinsinden)
  final int durationMinutes;

  /// Bu egzersiz sırasında harcanan tahmini kalori miktarı (kcal cinsinden)
  final int caloriesBurned;

  /// Egzersizin efor yoğunluk seviyesi ([WorkoutIntensity])
  final WorkoutIntensity intensity;

  /// Egzersizin kaydedildiği tarih ve zaman bilgisi
  final DateTime timestamp;
}
