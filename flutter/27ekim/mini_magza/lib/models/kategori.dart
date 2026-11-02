/// Uygulama genelinde ürünlerin gruplandırıldığı kategorileri temsil eden numaralandırma (enum).
///
/// Mağazada satılan ürün çeşitlerini ve filtreleme seçeneklerini belirler.
enum Kategori {
  /// Tüm ürünleri kapsayan filtre seçeneği ('Tümü').
  hepsi,

  /// Elektronik ürünler kategorisi (bilgisayar, telefon, kulaklık vb.).
  elektronik,

  /// Takı ve mücevher ürünleri kategorisi (yüzük, kolye, bileklik vb.).
  taki,

  /// Erkek giyim ürünleri kategorisi (pantolon, gömlek, mont vb.).
  erekekGiyim,

  /// Kadın giyim ürünleri kategorisi (elbise, ceket, sweatshirt vb.).
  kadinGiyim;

  /// API'den gelen İngilizce kategori metnini ilgili [Kategori] enum değerine dönüştürür.
  ///
  /// Örneğin FakeStoreAPI'den gelen `"electronics"` metnini `Kategori.elektronik` yapar.
  /// Eşleşmeyen veya bilinmeyen bir metin geldiğinde varsayılan olarak `Kategori.elektronik` döner.
  static Kategori apiMetindenUret(String apiMetni) {
    // Büyük/küçük harf duyarlılığını kaldırmak ve boşlukları temizlemek için trim ve toLowerCase kullanılır.
    switch (apiMetni.toLowerCase().trim()) {
      case 'electronic':
      case 'electronics':
        return Kategori.elektronik;
      case 'jewelery':
      case 'jewelry':
        return Kategori.taki;
      case "men's clothing":
        return Kategori.erekekGiyim;
      case "women's clothing":
        return Kategori.kadinGiyim;
      default:
        return Kategori.elektronik;
    }
  }
}

/// [Kategori] enum'ı için yardımcı metot ve özellikleri barındıran genişletme (extension).
///
/// Enum değerlerini kullanıcı arayüzünde (UI) görüntülenebilir Türkçe etiketlere dönüştürür.
extension KategoriExtension on Kategori {
  /// Kategorinin kullanıcı arayüzünde (ekranda) gösterilecek Türkçe başlığını döndürür.
  String get gorunenAd {
    switch (this) {
      case Kategori.hepsi:
        return 'Tümü';
      case Kategori.elektronik:
        return 'Elektronik';
      case Kategori.taki:
        return 'Takı & Mücevher';
      case Kategori.erekekGiyim:
        return 'Erkek Giyim';
      case Kategori.kadinGiyim:
        return 'Kadın Giyim';
    }
  }

  /// Geriye dönük uyumluluk amacıyla [Kategori.apiMetindenUret] metodunu çağırır.
  static Kategori apiMetindenUret(String apiMetni) => Kategori.apiMetindenUret(apiMetni);
}