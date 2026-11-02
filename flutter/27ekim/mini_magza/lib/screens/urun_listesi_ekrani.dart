import 'package:flutter/material.dart';
import '../models/urun.dart';
import '../models/kategori.dart';
import '../services/api_urun_servisi.dart';
import '../services/i_urun_servisi.dart';
import '../widgets/urun_karti.dart';

class UrunListesiEkrani extends StatefulWidget {
  const UrunListesiEkrani({super.key});

  @override
  State<UrunListesiEkrani> createState() => _UrunListesiEkraniState();
}

class _UrunListesiEkraniState extends State<UrunListesiEkrani> {
  final IUrunServisi _servis = ApiUrunServisi();

  final TextEditingController _aramaController = TextEditingController();

  List<Urun> _tumUrunler = [];
  List<Urun> _filtrelenmisUrunler = [];
  bool _yukleniyorMu = true;
  Kategori _seciliKategori = Kategori.hepsi; // başlangıç değeri bu. başlangıçta hepsi seçili.
  String _aramaKelimesi = "";
  List<Urun> _gosterilenUrunler = [];

  @override
  void initState() {
    super.initState();
    _urunleriYukle();
  }

  // önce başlaması lazım yukarıda initState ile başlattık
  // ekran kapanınca controller dispose edilmeli
  @override
  void dispose() {
    _aramaController.dispose();
    super.dispose();
  }

  // çok fazla ürün olursa pagination yaparsın, her sayfada tekrar arama yapar kullanıcı.

  Future<void> _urunleriYukle() async {
    setState(() {
      _yukleniyorMu = true;
    });

    //final urunler = await _servis.kategoriyeGoreGetir(_seciliKategori);
    final urunler = await _servis.tumUrunleriGetir();

    if (mounted) {
      setState(() {
        _tumUrunler = urunler;
        _gosterilenUrunler = urunler;
        _yukleniyorMu = false;
      });
      _filtreyiUygula(); // ilk açılışta liste dolsun diye
    }
  }

  void _filtreyiUygula() {
    final aranan = _aramaController.text.trim().toLowerCase();

    setState(() {
      _filtrelenmisUrunler = _tumUrunler.where((urun) {
        final kategoriUygunMu = (_seciliKategori == Kategori.hepsi) ||
            (urun.kategori == _seciliKategori);
        final aramaUygunMu = aranan.isEmpty ||
            urun.baslik.toLowerCase().contains(aranan) ||
            urun.aciklama.toLowerCase().contains(aranan);

        return kategoriUygunMu && aramaUygunMu;
      }).toList();
    });
  }

  void _favoriyiDegistir(Urun hedefUrun) {
    // id değişmiyor, sadece favoriMi tersine döner.
    final yeniUrun = hedefUrun.copyWith(favoriMi: !hedefUrun.favoriMi);
    final index = _tumUrunler.indexWhere((u) => u.id == hedefUrun.id);

    if (index != -1) {
      // indexWhere bulamazsa -1 döner
      _tumUrunler[index] = yeniUrun;
    }
    _filtreyiUygula(); // içinde setState var, ekranı o yeniler
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Mini Mağaza",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Badge(
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
          // ARAMA KUTUSU
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: TextField(
              controller: _aramaController,
              onChanged: (_) => _filtreyiUygula(),
              decoration: InputDecoration(
                hintText: "Ürün veya marka ara...",
                prefixIcon: const Icon(Icons.search),
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

          // KATEGORİ ÇİPLERİ
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: Kategori.values.map((kategori) {
                final seciliMi = _seciliKategori == kategori;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                );
              }).toList(),
            ),
          ),

          // ÜRÜN LİSTESİ
          Expanded(
            child: _yukleniyorMu
                ? const Center(child: CircularProgressIndicator())
                : _filtrelenmisUrunler.isEmpty
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
                    : ListView.builder(
                        itemCount: _filtrelenmisUrunler.length,
                        itemBuilder: (context, index) {
                          final urun = _filtrelenmisUrunler[index];
                          return UrunKarti(
                            urun: urun,
                            onFavoriTiklandi: () => _favoriyiDegistir(urun),
                            onDetayTiklandi: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('${urun.baslik} TIKLANDI!'),
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