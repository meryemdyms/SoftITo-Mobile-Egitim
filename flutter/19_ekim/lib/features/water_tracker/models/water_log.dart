/// Tüketilen içeceğin türünü temsil eden enum.
///
/// Farklı sıvı türlerinin hidrasyon ve kafein etkileri farklı olabileceğinden,
/// kayıt sırasında içecek kategorisini ayrıştırmayı sağlar.
enum DrinkType {
  /// Sade içme suyu
  water,

  /// Çay (Siyah çay, yeşil çay, bitki çayı)
  tea,

  /// Kahve (Espresso, filtre kahve vb.)
  coffee,

  /// Elektrolit ve sporcu içeceği
  sportsDrink;

  /// Arayüzde (UI) kullanıcıya gösterilecek Türkçe etiket adı
  String get displayName {
    switch (this) {
      case DrinkType.water:
        return 'Su';
      case DrinkType.tea:
        return 'Çay';
      case DrinkType.coffee:
        return 'Kahve';
      case DrinkType.sportsDrink:
        return 'Elektrolit / Spor';
    }
  }
}

/// Her bir su/sıvı tüketim kaydını temsil eden değişmez (immutable) veri modeli.
///
/// Alanların tamamı `final` olarak tanımlanmıştır; bu sayede oluşturulan bir kayıt
/// sonradan doğrudan mutasyona uğramaz ve durum güvenliği (thread-safe, predictable state) sağlanır.
class WaterLog {
  /// [WaterLog] nesnesini başlatan const yapıcı metot (constructor).
  ///
  /// `const` yapıcılar, nesnelerin derleme zamanında sabit olarak ele alınabilmesini
  /// ve bellekte gereksiz kopyaların oluşmamasını sağlar.
  const WaterLog({
    required this.id,
    required this.amountMl,
    required this.timestamp,
    this.type = DrinkType.water,
  });

  /// Kaydı tekil olarak tanımlayan benzersiz kimlik (ID)
  final String id;

  /// Tüketilen sıvı miktarı (mililitre - ml cinsinden)
  final int amountMl;

  /// Sıvının tüketildiği tarih ve saat bilgisi
  final DateTime timestamp;

  /// Sıvının kategorisi/türü (varsayılan olarak [DrinkType.water])
  final DrinkType type;
}
