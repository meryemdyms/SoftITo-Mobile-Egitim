/// Ürüne ait değerlendirme ve puanlama bilgilerini temsil eden model sınıfı.
///
/// API'den gelen değerlendirme puanını (`puan`) ve toplam değerlendiren
/// kullanıcı sayısını (`oySayisi`) saklar.
class Degerlendirme {
  /// Ürünün ortalama değerlendirme puanı (Örn: 4.5).
  final double puan;

  /// Ürüne oy veren toplam kullanıcı sayısı (Örn: 120).
  final int oySayisi;

  /// [Degerlendirme] sınıfı için sabit (const) kurucu metot.
  ///
  /// Tüm alanlar zorunludur ve nesne oluşturulduktan sonra değiştirilemez (immutable).
  const Degerlendirme({
    required this.puan,
    required this.oySayisi,
  });

  /// JSON formatındaki harita (Map) verisini [Degerlendirme] nesnesine dönüştüren fabrika kurucu metot.
  ///
  /// FakeStoreAPI'de değerlendirme nesnesi şu formatta gelir:
  /// `{"rate": 3.9, "count": 120}`
  /// `as num?` dönüşümü sayesinde hem `int` hem de `double` değerler güvenle karşılanır;
  /// `null` gelme ihtimaline karşı varsayılan değerler atanır.
  factory Degerlendirme.fromJson(Map<String, dynamic> json) {
    return Degerlendirme(
      // 'rate' değerini güvenli bir şekilde double türüne çevirir, null ise 0.0 atar.
      puan: (json['rate'] as num?)?.toDouble() ?? 0.0,
      
      // 'count' değerini güvenli bir şekilde int türüne çevirir, null ise 0 atar.
      oySayisi: (json['count'] as num?)?.toInt() ?? 0,
    );
  }
}