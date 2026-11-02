import 'package:flutter/material.dart';

/// Ürünün stok durumunu görsel bir rozet (badge) olarak gösteren widget.
///
/// Stok miktarı 0 olduğunda kırmızı renkte "Tükendi", 0'dan büyük olduğunda
/// yeşil tonlarında "Stok: X" şeklinde bilgi sunar.
class StokRozeti extends StatelessWidget {
  /// Gösterilecek mevcut ürün stok adedi.
  final int stok;

  /// [StokRozeti] için sabit kurucu metot.
  const StokRozeti({
    super.key,
    required this.stok,
  });

  @override
  Widget build(BuildContext context) {
    // Stok miktarının sıfır olup olmadığını kontrol eder.
    final tukendiMi = stok == 0;

    // Duruma göre arkaplan ve kenarlık renklerini belirler.
    final arkaPlanRengi = tukendiMi ? Colors.red.shade100 : Colors.green.shade100;
    final kenarlikRengi = tukendiMi ? Colors.red.shade400 : Colors.green.shade400;
    final yaziRengi = tukendiMi ? Colors.red.shade900 : Colors.green.shade900;
    final etiketMetni = tukendiMi ? 'Tükendi' : 'Stok: $stok';

    return Container(
      // Rozet içi iç boşluk (padding) ayarı
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        // Duruma özel yumuşak arkaplan rengi
        color: arkaPlanRengi,
        // Yuvarlatılmış köşeler
        borderRadius: BorderRadius.circular(6),
        // İnce sınır çizgisi
        border: Border.all(
          color: kenarlikRengi,
          width: 0.8,
        ),
      ),
      child: Text(
        etiketMetni,
        style: TextStyle(
          color: yaziRengi,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}