import 'package:mini_magza/models/degerlendirme.dart';
import '../models/kategori.dart';
import '../models/urun.dart';
import 'i_urun_servisi.dart';

/// Sahte (Mock) ürün verileri sağlayan yerel test servisi.
///
/// [IUrunServisi] arayüzünü uygulayarak harici bir internet bağlantısına veya API'ye
/// ihtiyaç duymadan uygulamanın test edilmesini sağlar.
/// Gerçekçi bir kullanıcı deneyimi simüle etmek amacıyla `Future.delayed` ile ağ gecikmesi taklit edilir.
class MockUrunServisi implements IUrunServisi {
  /// Test ve geliştirme amaçlı hazırda tutulan sabit sahte ürün listesi.
  final List<Urun> _urunDeposu = const [
    Urun(
      id: 1,
      baslik: 'Macbook M5 Pro Laptop',
      aciklama: 'Yeni Nesil Apple M5 Pro İşlemcili, 16GB RAM, 512GB SSD',
      fiyat: 179999.99,
      resimUrl: 'https://picsum.photos/seed/macbook/400/400',
      kategori: Kategori.elektronik,
      stokAdedi: 5,
      degerlendirme: Degerlendirme(puan: 3.4, oySayisi: 100),
    ),
    Urun(
      id: 2,
      baslik: 'Apple iPhone 18 Pro Max',
      aciklama: "Apple'ın yeni amiral gemisi iPhone 18 Pro Max, 256GB Titanyum",
      fiyat: 149999.99,
      resimUrl: 'https://picsum.photos/seed/iphone/400/400',
      kategori: Kategori.elektronik,
      stokAdedi: 14,
      degerlendirme: Degerlendirme(puan: 3.4, oySayisi: 100),
    ),
    Urun(
      id: 3,
      baslik: 'Kablosuz ANC Kulaklık',
      aciklama: 'Aktif gürültü engelleme, 30 saat pil ömrü ve Hi-Res ses kalitesi',
      fiyat: 8499.50,
      resimUrl: 'https://picsum.photos/seed/headphones/400/400',
      kategori: Kategori.elektronik,
      stokAdedi: 25,
      degerlendirme: Degerlendirme(puan: 3.4, oySayisi: 100),
    ),
    Urun(
      id: 4,
      baslik: 'Slim Fit Erkek Kot Pantolon',
      aciklama: 'Rahat kesim, esnek ve %100 pamuklu kaliteli denim kumaş',
      fiyat: 1299.90,
      resimUrl: 'https://picsum.photos/seed/jeans/400/400',
      kategori: Kategori.erekekGiyim,
      stokAdedi: 32,
      degerlendirme: Degerlendirme(puan: 3.4, oySayisi: 100),
    ),
    Urun(
      id: 5,
      baslik: 'Oversize Kapüşonlu Sweatshirt',
      aciklama: 'Kışlık kalın içi polar, unisex rahat kalıp sweatshirt',
      fiyat: 899.90,
      resimUrl: 'https://picsum.photos/seed/hoodie/400/400',
      kategori: Kategori.kadinGiyim,
      stokAdedi: 18,
      degerlendirme: Degerlendirme(puan: 3.4, oySayisi: 100),
    ),
    Urun(
      id: 6,
      baslik: 'Su ve Rüzgar Geçirmez Mont',
      aciklama: 'Nefes alabilir termal kumaş, kapüşonlu outdoor kışlık mont',
      fiyat: 2499.00,
      resimUrl: 'https://picsum.photos/seed/jacket/400/400',
      kategori: Kategori.kadinGiyim,
      stokAdedi: 11,
      degerlendirme: Degerlendirme(puan: 3.4, oySayisi: 100),
    ),
    Urun(
      id: 7,
      baslik: 'Koşu ve Yürüyüş Spor Ayakkabısı',
      aciklama: 'Yüksek taban yastıklama, nefes alabilir fileli hafif tasarım',
      fiyat: 3250.00,
      resimUrl: 'https://picsum.photos/seed/runningshoes/400/400',
      kategori: Kategori.erekekGiyim,
      stokAdedi: 20,
      degerlendirme: Degerlendirme(puan: 3.4, oySayisi: 100),
    ),
    Urun(
      id: 8,
      baslik: 'Hakiki Deri Klasik Ayakkabı',
      aciklama: 'El işçiliği hakiki dana derisi, konforlu ortopedik taban',
      fiyat: 4150.00,
      resimUrl: 'https://picsum.photos/seed/classicshoe/400/400',
      kategori: Kategori.erekekGiyim,
      stokAdedi: 8,
      degerlendirme: Degerlendirme(puan: 3.4, oySayisi: 100),
    ),
    Urun(
      id: 9,
      baslik: 'Günlük Rahat Sneaker',
      aciklama: 'Minimal beyaz tasarım, dayanıklı esnek kauçuk dış taban',
      fiyat: 1899.90,
      resimUrl: 'https://picsum.photos/seed/sneaker/400/400',
      kategori: Kategori.kadinGiyim,
      stokAdedi: 15,
      degerlendirme: Degerlendirme(puan: 3.4, oySayisi: 100),
    ),
  ];

  /// Tüm sahte ürünleri döner.
  ///
  /// Gerçekçi bir ağ gecikmesi hissi vermek için 1500 ms (1.5 saniye) gecikme simüle edilir.
  @override
  Future<List<Urun>> tumUrunleriGetir() async {
    // Ağ gecikmesini simüle etmek için 1.5 saniye beklenir.
    await Future.delayed(const Duration(milliseconds: 1500));
    
    // Orijinal listenin doğrudan değiştirilmesini önlemek için yeni bir liste kopyası döner.
    return List.from(_urunDeposu);
  }

  /// Verilen [kategori]'ye göre sahte ürün deposunu filtreleyerek getirir.
  ///
  /// Filtreleme işlemi için 400 ms yapay gecikme uygulanır.
  @override
  Future<List<Urun>> kategoriyeGoreGetir(Kategori kategori) async {
    // 400 milisaniyelik kısa bir filtreleme gecikmesi simüle edilir.
    await Future.delayed(const Duration(milliseconds: 400));
    
    // Tümü seçildiyse deponun tamamı döndürülür.
    if (kategori == Kategori.hepsi) {
      return List.from(_urunDeposu);
    }
    
    // Sadece kategorisi eşleşen ürünler filtrelenerek liste olarak döndürülür.
    return _urunDeposu.where((urun) => urun.kategori == kategori).toList();
  }

  /// Verilen [aramaMetni]'ne göre ürün başlıklarında arama yapar.
  ///
  /// Arama işlemi için 300 ms yapay gecikme uygulanır.
  @override
  Future<List<Urun>> adaGoreAra(String aramaMetni) async {
    // 300 milisaniye arama gecikmesi simüle edilir.
    await Future.delayed(const Duration(milliseconds: 300));
    
    // Boş arama sorgularında deponun tamamı döner.
    if (aramaMetni.trim().isEmpty) {
      return List.from(_urunDeposu);
    }

    // Başlıkta aranan kelimeyi büyük/küçük harf duyarsız kontrol eder.
    return _urunDeposu.where((urun) {
      final baslikKucuk = urun.baslik.toLowerCase();
      final arananKucuk = aramaMetni.toLowerCase();
      return baslikKucuk.contains(arananKucuk);
    }).toList();
  }
}

