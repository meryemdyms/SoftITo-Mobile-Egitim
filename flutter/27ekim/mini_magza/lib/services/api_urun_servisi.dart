import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/urun.dart';
import '../models/kategori.dart';
import 'i_urun_servisi.dart';

/// Uzak REST API (FakeStoreAPI) üzerinden gerçek ürün verilerini çeken servis sınıfı.
///
/// [IUrunServisi] sözleşmesini (interface) uygulayarak HTTP isteklerini,
/// ağ zaman aşımını (timeout), JSON serileştirme/ayrıştırma ve hata yönetimini üstlenir.
class ApiUrunServisi implements IUrunServisi {
  /// FakeStoreAPI ürünler uç noktası (endpoint) ana URL adresi.
  static const String _baseUrl = 'https://fakestoreapi.com/products';

  /// API'den tüm ürünlerin listesini çeker.
  ///
  /// - İstek için 10 saniyelik zaman aşımı (timeout) tanımlanmıştır.
  /// - Türkçe karakterlerin bozulmaması için `utf8.decode` ile gövde çözümlenir.
  /// - HTTP durum kodu 200 (Başarılı) olduğunda JSON listesini [Urun] listesine eşler.
  /// - Ağ kesintisi ([http.ClientException]) veya sunucu hatalarında anlamlı istisnalar fırlatır.
  @override
  Future<List<Urun>> tumUrunleriGetir() async {
    final uri = Uri.parse(_baseUrl);
    try {
      // Belirtilen adrese HTTP GET isteği gönderilir ve 10 saniye zaman aşımı belirlenir.
      final yanit = await http.get(uri).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw Exception("Ağ isteği zaman aşımına uğradı (Timeout)"),
      );

      // Sunucudan 200 OK yanıtı geldiyse veriyi işle.
      if (yanit.statusCode == 200) {
        // Karakter kodlama sorunlarını önlemek için bodyBytes utf-8 ile çözülür.
        final List<dynamic> hamListe = jsonDecode(utf8.decode(yanit.bodyBytes));
        
        // Ham JSON haritaları Urun.fromJson ile model nesnelerine dönüştürülür.
        return hamListe
            .map((tekilJson) => Urun.fromJson(tekilJson as Map<String, dynamic>))
            .toList();
      } else {
        // 404, 500 gibi beklenmeyen HTTP durum kodları için hata fırlatılır.
        throw Exception('Sunucu hatası oluştu! Durum Kodu: ${yanit.statusCode}');
      }
    } on http.ClientException catch (e) {
      // Cihazın internet bağlantısı olmadığında veya DNS hatasında yakalanır.
      throw Exception('İnternet bağlantısı kurulamadı: $e');
    } catch (hata) {
      // Genel diğer çalışma zamanı hatalarını yakalar.
      throw Exception('Ürünler yüklenirken hata oluştu: $hata');
    }
  }

  /// Seçili [kategori] değerine ait ürünleri API'den filtreleyerek çeker.
  ///
  /// Eğer `Kategori.hepsi` seçildiyse doğrudan [tumUrunleriGetir] metodunu çalıştırır.
  @override
  Future<List<Urun>> kategoriyeGoreGetir(Kategori kategori) async {
    // Tümü seçildiyse doğrudan tüm ürünleri getir.
    if (kategori == Kategori.hepsi) {
      return tumUrunleriGetir();
    }

    // Uygulamadaki enum değerlerini FakeStoreAPI'nin beklediği URL uzantılarına eşler.
    String kategoriYolu;
    switch (kategori) {
      case Kategori.elektronik:
        kategoriYolu = 'electronics';
        break;
      case Kategori.erekekGiyim:
        kategoriYolu = "men's clothing";
        break;
      case Kategori.kadinGiyim:
        kategoriYolu = "women's clothing";
        break;
      case Kategori.taki:
        kategoriYolu = 'jewelery';
        break;
      default:
        return tumUrunleriGetir();
    }

    // Kategoriye özel endpoint URL'i oluşturulur (Örn: /products/category/electronics)
    final uri = Uri.parse('$_baseUrl/category/$kategoriYolu');
    final yanit = await http.get(uri);

    if (yanit.statusCode == 200) {
      final List<dynamic> hamListe = jsonDecode(utf8.decode(yanit.bodyBytes));
      return hamListe
          .map((j) => Urun.fromJson(j as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Kategori Filtreleme Hatası: ${yanit.statusCode}');
    }
  }

  /// Verilen [aramaMetni]'ne göre ürünleri başlık ve açıklama alanlarında arar.
  ///
  /// Önce tüm ürünleri API'den çeker, ardından istemci tarafında (bellekte)
  /// büyük/küçük harf duyarsız arama filtresi uygular.
  @override
  Future<List<Urun>> adaGoreAra(String aramaMetni) async {
    // Arama yapmak için önce tüm ürün listesini getirir.
    final tumUrunler = await tumUrunleriGetir();

    // Arama metni boş ise veya yalnızca boşluklardan oluşuyorsa tüm listeyi döner.
    if (aramaMetni.trim().isEmpty) return tumUrunler;

    final kucukArama = aramaMetni.toLowerCase();

    // Başlık veya açıklamada aranan metni içeren ürünleri filtreler.
    return tumUrunler.where((urun) {
      return urun.baslik.toLowerCase().contains(kucukArama) ||
          urun.aciklama.toLowerCase().contains(kucukArama);
    }).toList();
  }
}