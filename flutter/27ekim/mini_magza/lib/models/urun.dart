import 'kategori.dart';
import 'degerlendirme.dart';

/// Mağazada satılan her bir ürünü temsil eden ana veri modeli (Entity/Model).
///
/// Ürünün kimlik bilgisi, adı, fiyatı, kategorisi, görselleri, stok durumu
/// ve kullanıcının favori tercihini tutar. Değişmez (immutable) bir yapıdadır.
class Urun {
  /// Ürünün veritabanı veya API tarafındaki benzersiz kimlik numarası (ID).
  final int id;

  /// Ürünün adı veya başlığı.
  final String baslik;

  /// Ürün hakkında detaylı açıklama metni.
  final String aciklama;

  /// Ürünün para birimi cinsinden birim satış fiyatı.
  final double fiyat;

  /// Ürünün internet ortamındaki görsel bağlantı adresi (URL).
  final String resimUrl;

  /// Ürünün dahil olduğu kategori ([Kategori] enum değeri).
  final Kategori kategori;

  /// Mağazada kalan mevcut stok adedi.
  final int stokAdedi;

  /// Kullanıcının bu ürünü favorilerine ekleyip eklemediğini belirten durum bayrağı.
  final bool favoriMi;

  /// Ürünün kullanıcı değerlendirme puanını ve oy sayısını tutan model nesnesi.
  final Degerlendirme degerlendirme;

  /// [Urun] sınıfı için sabit (const) kurucu metot.
  ///
  /// `favoriMi` parametresi verilmezse varsayılan olarak `false` kabul edilir.
  const Urun({
    required this.id,
    required this.baslik,
    required this.aciklama,
    required this.fiyat,
    required this.resimUrl,
    required this.kategori,
    required this.stokAdedi,
    required this.degerlendirme,
    this.favoriMi = false,
  });

  /// FakeStoreAPI veya benzeri bir REST API'den gelen JSON harita verisini
  /// [Urun] nesnesine dönüştüren fabrika kurucu metot (Factory Constructor).
  factory Urun.fromJson(Map<String, dynamic> json) {
    return Urun(
      // 'id' alanını int türünde alır.
      id: json['id'] as int,

      // API'den gelen 'title' alanını alır; güvenli geri dönüş sağlar.
      baslik: (json['title'] as String?) ?? (json['price']?.toString() ?? ''),

      // 'description' alanını ürün açıklaması olarak atar.
      aciklama: (json['description'] as String?) ?? '',

      // 'price' alanını güvenli biçimde double türüne çevirir.
      fiyat: (json['price'] as num).toDouble(),

      // 'category' metnini Kategori enum değerine dönüştürür.
      kategori: Kategori.apiMetindenUret((json['category'] as String?) ?? ''),

      // 'image' alanından görsel bağlantısını alır.
      resimUrl: (json['image'] as String?) ?? '',

      // API'de rating altındaki değerlendirme sayısını veya stok bilgisini alır.
      stokAdedi: json['rating'] is Map
          ? ((json['rating'] as Map)['count'] as num?)?.toInt() ?? 10
          : (json['stock'] as num?)?.toInt() ?? 10,

      // 'rating' nesnesini Degerlendirme modeline dönüştürür.
      degerlendirme: Degerlendirme.fromJson(
        (json['rating'] as Map<String, dynamic>?) ?? {'rate': 0.0, 'count': 0},
      ),

      // İlk yüklemede favori durumu varsayılan olarak false atanır.
      favoriMi: false,
    );
  }

  /// Mevcut nesnenin değerlerini koruyarak yalnızca istenen alanların değiştirildiği
  /// yeni bir [Urun] kopyası üretir (Immutability / Değişmezlik Deseni).
  ///
  /// Örneğin bir ürünün sadece favori durumunu değiştirmek için kullanılır:
  /// `final guncelUrun = urun.copyWith(favoriMi: !urun.favoriMi);`
  Urun copyWith({
    int? id,
    String? baslik,
    String? aciklama,
    double? fiyat,
    String? resimUrl,
    Kategori? kategori,
    int? stokAdedi,
    Degerlendirme? degerlendirme,
    bool? favoriMi,
  }) {
    return Urun(
      id: id ?? this.id,
      baslik: baslik ?? this.baslik,
      aciklama: aciklama ?? this.aciklama,
      fiyat: fiyat ?? this.fiyat,
      resimUrl: resimUrl ?? this.resimUrl,
      kategori: kategori ?? this.kategori,
      stokAdedi: stokAdedi ?? this.stokAdedi,
      degerlendirme: degerlendirme ?? this.degerlendirme,
      favoriMi: favoriMi ?? this.favoriMi,
    );
  }

  /// Hata ayıklama ve konsol çıktılarında ürünün özet bilgilerini okunabilir formatta yazdırır.
  @override
  String toString() {
    return "Urun(id: $id, baslik: $baslik, fiyat: $fiyat, favoriMi: $favoriMi)";
  }
}