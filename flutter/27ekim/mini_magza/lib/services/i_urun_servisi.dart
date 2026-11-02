import '../models/kategori.dart';
import '../models/urun.dart';

/// Ürün veri işlemlerini yürüten servisler için soyut sözleşme (Interface / Abstract Class).
///
/// Dependency Inversion (Bağımlılıkların Tersine Çevrilmesi) prensibine uygun olarak,
/// kullanıcı arayüzü (UI) doğrudan somut bir servise değil, bu arayüze bağımlı olur.
/// Böylece testlerde veya çevrimdışı modda [MockUrunServisi], canlı ortamda ise [ApiUrunServisi]
/// kolaylıkla birbirinin yerine kullanılabilir.
abstract class IUrunServisi {
  /// Mağazadaki tüm ürünleri asenkron olarak liste şeklinde getirir.
  ///
  /// Başarılı olduğunda [Urun] listesi döner, hata durumunda istisna fırlatır.
  Future<List<Urun>> tumUrunleriGetir();

  /// Belirtilen [kategoriye] ait ürünleri filtreleyerek getirir.
  ///
  /// [kategori] parametresi olarak [Kategori.hepsi] verilirse tüm ürünler döner.
  Future<List<Urun>> kategoriyeGoreGetir(Kategori kategori);

  /// Ürün başlığı veya açıklamasında verilen [aramaMetni]'ni içeren ürünleri arar ve filtreler.
  ///
  /// [aramaMetni] boş ise tüm ürünler döner.
  Future<List<Urun>> adaGoreAra(String aramaMetni);
}