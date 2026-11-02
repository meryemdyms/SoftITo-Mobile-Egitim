import 'package:flutter/material.dart';
import '../models/urun.dart';
import 'stok_rozeti.dart';

/// Ürün listesinde her bir ürünü kart görünümünde sergileyen özel widget.
///
/// Ürünün görselini, stok durumunu, adını, özet açıklamasını, fiyatını
/// ve favoriye ekleme butonunu içerir.
class UrunKarti extends StatelessWidget {
  /// Kart üzerinde gösterilecek ürün nesnesi.
  final Urun urun;

  /// Favori ikonuna tıklandığında tetiklenecek geri çağırma (callback) fonksiyonu.
  final VoidCallback onFavoriTiklandi;

  /// Karta genel olarak tıklandığında (detay için) tetiklenecek callback fonksiyonu.
  final VoidCallback onDetayTiklandi;

  /// [UrunKarti] için sabit kurucu metot.
  const UrunKarti({
    super.key,
    required this.urun,
    required this.onFavoriTiklandi,
    required this.onDetayTiklandi,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      // Kartlar arası dış boşluklar
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      // Hafif derinlik ve gölge efekti
      elevation: 2,
      // Yuvarlatılmış kart kenarları
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        // Tıklama dalgalanma efektinin kart köşelerinden taşmasını önler.
        borderRadius: BorderRadius.circular(16),
        // Karta tıklandığında detay callback'ini çalıştırır.
        onTap: onDetayTiklandi,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ÜRÜN GÖRSELİ
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  urun.resimUrl,
                  width: 90,
                  height: 90,
                  fit: BoxFit.cover,
                  // Görsel internetten yüklenirken gösterilecek yükleme göstergesi
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return Container(
                      width: 90,
                      height: 90,
                      color: Colors.grey.shade100,
                      child: const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    );
                  },
                  // Görsel yüklenemediğinde veya URL hatalı olduğunda gösterilecek alternatif ikon
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 90,
                      height: 90,
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.broken_image, color: Colors.grey),
                    );
                  },
                ),
              ),

              const SizedBox(width: 14),

              // ÜRÜN BİLGİLERİ (Başlık, Açıklama, Stok, Fiyat)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Stok rozeti
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        StokRozeti(stok: urun.stokAdedi),
                      ],
                    ),
                    const SizedBox(height: 6),

                    // Ürün Başlığı (En fazla 1 satır, taşarsa ...)
                    Text(
                      urun.baslik,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Ürün Açıklaması (En fazla 2 satır, taşarsa ...)
                    Text(
                      urun.aciklama,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade700,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Ürün Fiyatı (Virgülden sonra 2 basamaklı ve ₺ simgeli)
                    Text(
                      '${urun.fiyat.toStringAsFixed(2)} ₺',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),

              // FAVORİ BUTONU (Kalp İkonu)
              IconButton(
                icon: Icon(
                  // Favoride ise dolu kırmızı kalp, değilse gri boş kalp ikonu gösterir.
                  urun.favoriMi ? Icons.favorite : Icons.favorite_border,
                  color: urun.favoriMi ? Colors.red : Colors.grey,
                ),
                onPressed: onFavoriTiklandi,
              ),
            ],
          ),
        ),
      ),
    );
  }
}