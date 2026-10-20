
---
name: customer-experience
description: Müşteri ana sayfa, arama formu, filtreleme, araç listesi/detayı, firma vitrini, profil ve rezervasyonlarım ekranlarında kullan.
---

# customer-experience

## Ekran düzeni
- Home: alış/iade yeri, başlangıç/bitiş tarih-saat, keşif/kampanyalar.
- Results: araç kartında fotoğraf, firma, günlük fiyat, temel özellikler; fiyat/vites/yakıt/firma filtreleri; sıralama.
- Vehicle Details: galeri, koşullar, müsaitlik, toplam fiyat ön gösterimi, firma sayfası linki, CTA.
- Company Storefront: doğrulanmış demo iletişim/konum bilgisi, firmanın araçları ve kampanyaları.
- Profile/My Bookings: müşteri bilgileri, confirmed/active/completed/cancelled durum ve ayrıntılar.
- Guest browse ve customer booking geçişleri kesintisiz olmalı: araç + arama parametreleri login dönüşünde korunur.

## Sınırlar
- UI'da repository ya da date/fiyat kuralı yazma.
- Sonuç yoksa filtreleri sıfırlama seçeneği; loading ve hata state'leri; kartı semantik olarak erişilebilir tasarla.
- Arama filtreleri tek controller state'inde; her build sırasında ağır hesap yapma.
