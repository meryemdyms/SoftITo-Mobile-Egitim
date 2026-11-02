import 'package:flutter/material.dart';
import '../models/urun.dart';
import '../models/kategori.dart';
import '../services/api_urun_servisi.dart';
import '../services/i_urun_servisi.dart';
import '../widgets/urun_karti.dart';

/// Mini Mağaza uygulamasının ana vitrin ve ürün listesi ekranı.
///
/// Kullanıcıların ürünleri listelemesini, kategoriye göre filtrelemesini,
/// başlık ve açıklamaya göre arama yapmasını ve ürünleri favoriye eklemesini sağlar.
class UrunListesiEkrani extends StatefulWidget {
  const UrunListesiEkrani({super.key});

  @override
  State<UrunListesiEkrani> createState() => _UrunListesiEkraniState();
}

/// [UrunListesiEkrani] ekranının durum (state) yönetimini gerçekleştiren sınıf.
class _UrunListesiEkraniState extends State<UrunListesiEkrani> {
  /// Veri kaynağını temsil eden servis nesnesi.
  ///
  /// İsteğe göre [ApiUrunServisi] yerine [MockUrunServisi] verilerek
  /// çevrimdışı test verileriyle de çalıştırılabilir.
  final IUrunServisi _servis = ApiUrunServisi();

  /// Arama kutusuna girilen metni dinlemek ve yönetmek için metin kontrolcüsü.
  final TextEditingController _aramaController = TextEditingController();

  /// API veya servisten çekilen tüm ürünlerin orijinal ana listesi.
  List<Urun> _tumUrunler = [];

  /// Kategori ve arama kriterlerine göre filtrelenip ekranda listelenen ürünler.
  List<Urun> _filtrelenmisUrunler = [];

  /// Verilerin servisten yüklenmekte olduğunu belirten yükleniyor durumu bayrağı.
  bool _yukleniyorMu = true;

  /// Kullanıcının o anda seçmiş olduğu kategori filtresi (Başlangıçta hepsi seçilidir).
  Kategori _seciliKategori = Kategori.hepsi;

  /// Ekran ilk oluşturulduğunda çalışan yaşam döngüsü metodu.
  @override
  void initState() {
    super.initState();
    // Ekran açılır açılmaz ürünleri servisten yükler.
    _urunleriYukle();
  }

  /// Ekran bellekten kaldırıldığında çalışan yaşam döngüsü metodu.
  ///
  /// Bellek sızıntılarını (memory leak) önlemek için controller nesneleri burada dispose edilir.
  @override
  void dispose() {
    _aramaController.dispose();
    super.dispose();
  }

  /// Servis üzerinden ürünleri asenkron olarak çeken ve durumu güncelleyen metot.
  Future<void> _urunleriYukle() async {
    // Yükleme başladığında yükleniyor göstergesini aktif et.
    setState(() {
      _yukleniyorMu = true;
    });

    try {
      // Servisten tüm ürünleri getir.
      final urunler = await _servis.tumUrunleriGetir();

      // Asenkron işlem bittiğinde widget ağaçta hâlâ mevcutsa (mounted) durumu güncelle.
      if (mounted) {
        setState(() {
          _tumUrunler = urunler;
          _yukleniyorMu = false;
        });
        // İlk açılışta listenin filtre kriterlerine göre dolması için filtreyi uygula.
        _filtreyiUygula();
      }
    } catch (hata) {
      if (mounted) {
        setState(() {
          _yukleniyorMu = false;
        });
        // Hata durumunda kullanıcıya bilgilendirici bir SnackBar göster.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ürünler yüklenirken hata oluştu: $hata')),
        );
      }
    }
  }

  /// Seçili kategoriye ve arama kutusuna yazılan metne göre ürün listesini filtreler.
  void _filtreyiUygula() {
    final aranan = _aramaController.text.trim().toLowerCase();

    setState(() {
      _filtrelenmisUrunler = _tumUrunler.where((urun) {
        // Kategori koşulu: 'hepsi' seçiliyse tüm kategoriler geçer; aksi takdirde birebir eşleşme aranır.
        final kategoriUygunMu = (_seciliKategori == Kategori.hepsi) ||
            (urun.kategori == _seciliKategori);

        // Arama koşulu: Arama boşsa geçer; doluysa başlık veya açıklamada aranan kelime aranır.
        final aramaUygunMu = aranan.isEmpty ||
            urun.baslik.toLowerCase().contains(aranan) ||
            urun.aciklama.toLowerCase().contains(aranan);

        return kategoriUygunMu && aramaUygunMu;
      }).toList();
    });
  }

  /// Bir ürünün favori durumunu tersine çevirir (Favori ekle / çıkar).
  ///
  /// Immutability (değişmezlik) gereği orijinal ürün nesnesi doğrudan değiştirilmez;
  /// [copyWith] ile favori durumu tersine çevrilmiş yeni bir kopya üretilip listeye yerleştirilir.
  void _favoriyiDegistir(Urun hedefUrun) {
    // id ve diğer tüm özellikler korunur, yalnızca favoriMi alanı tersine çevrilir.
    final yeniUrun = hedefUrun.copyWith(favoriMi: !hedefUrun.favoriMi);
    final index = _tumUrunler.indexWhere((u) => u.id == hedefUrun.id);

    if (index != -1) {
      // indexWhere ürünü bulursa ilgili indeksi yeni ürün kopyasıyla günceller.
      _tumUrunler[index] = yeniUrun;
    }
    // Ekranda güncel verilerin yansıması ve filtrenin korunması için filtreyi tekrar çalıştırır.
    _filtreyiUygula();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ÜST BAŞLIK ALANI (AppBar)
      appBar: AppBar(
        title: const Text(
          "Mini Mağaza",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          // Sağ üstte favoriye eklenen ürünlerin toplam sayısını rozetle gösterir.
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Badge(
                // Favori olarak işaretlenmiş ürünlerin anlık sayısını hesaplar.
                label: Text(
                  '${_tumUrunler.where((u) => u.favoriMi).length}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                child: const Icon(Icons.favorite, color: Colors.red),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // ARAMA KUTUSU (Search TextField)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: TextField(
              controller: _aramaController,
              // Kullanıcı her harf yazdığında filtreyi anlık olarak tetikler.
              onChanged: (_) => _filtreyiUygula(),
              decoration: InputDecoration(
                hintText: "Ürün veya marka ara...",
                prefixIcon: const Icon(Icons.search),
                // Arama kutusunda metin varsa temizleme butonu (çarpı ikonu) gösterir.
                suffixIcon: _aramaController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _aramaController.clear();
                          _filtreyiUygula();
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),

          // KATEGORİ FİLTRELEME ÇİPLERİ (Category Chips)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: Kategori.values.map((kategori) {
                final seciliMi = _seciliKategori == kategori;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: FilterChip(
                    // Çipin seçili olup olmadığını belirler.
                    selected: seciliMi,
                    // Kategorinin Türkçe görünen adını ekrana yazar.
                    label: Text(kategori.gorunenAd),
                    // Çipe tıklandığında seçili kategoriyi günceller ve filtreyi uygular.
                    onSelected: (secildi) {
                      setState(() {
                        _seciliKategori = kategori;
                      });
                      _filtreyiUygula();
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          // ÜRÜN LİSTESİ ALANI (State'e göre Yükleniyor / Boş / Liste durumları)
          Expanded(
            child: _yukleniyorMu
                // Durum 1: Veriler henüz yükleniyorsa döner çember (spinner) göster.
                ? const Center(child: CircularProgressIndicator())
                : _filtrelenmisUrunler.isEmpty
                    // Durum 2: Kriterlere uygun ürün bulunamadıysa uyarı mesajı göster.
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off_rounded,
                              size: 64,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Aradığınız kriterlere uygun ürün bulunamadı.',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      )
                    // Durum 3: Ürünler başarıyla filtrelendiyse liste olarak render et.
                    : ListView.builder(
                        itemCount: _filtrelenmisUrunler.length,
                        itemBuilder: (context, index) {
                          final urun = _filtrelenmisUrunler[index];
                          return UrunKarti(
                            urun: urun,
                            // Favori butonuna tıklandığında ilgili ürünü favorilere ekler/çıkarır.
                            onFavoriTiklandi: () => _favoriyiDegistir(urun),
                            // Ürün kartına tıklandığında bilgi amaçlı SnackBar gösterir.
                            onDetayTiklandi: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('${urun.baslik} seçildi.'),
                                  duration: const Duration(milliseconds: 600),
                                ),
                              );
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}