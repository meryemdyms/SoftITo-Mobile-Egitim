
---
name: map-visits
description: Harita, müze pinleri, ziyaret noktaları, konum izni ve ziyaret geçmişi için kullan.
---

# Harita ve Ziyaret Sistemi

## Teknoloji

flutter_map + OpenStreetMap.

Tile sağlayıcısının kullanım koşulları uygulanır.

## V1 Veri Kaynağı — Kesin

Haritada:
- Koordinatı bulunan erişilebilir yayınlı müzeler
- Kullanıcının manuel eklediği ziyaret noktaları

gösterilir.

Harici Places API kullanılmaz.

Otomatik mekân keşfi eklenmez.

## Müze Pinleri

- Gerçek koordinat bulunmalıdır.
- Müze published durumunda olmalıdır.
- Kullanıcı erişim iznine sahip olmalıdır.
- Gizli müze koordinatları yetkisiz gösterilmez.

## Ziyaret Pinleri

- Kullanıcı ziyaret ettiği yeri manuel işaretler.
- Ziyaret kaydı kullanıcı hesabına bağlanır.
- Ziyaret edilen noktalar farklı ikonla gösterilir.
- Tekrar kayıtlar tutarlı yönetilir.

## Önemli Kural

Bir harita pinine dokunmak ziyaret sayılmaz.

Ziyaret yalnızca açık "Ziyaret ettim"
işlemiyle kaydedilir.

## Konum İzni

- Gerektiğinde izin istenir.
- Reddedilirse manuel harita gezintisi devam eder.
- Konum izinsiz paylaşılmaz.
- İzin hatası uygulamayı kilitlemez.

## Tasarım

- Ziyaret edilmiş: Olive
- Keşfedilecek: Bronze
- Renk yanında ikon/şekil farkı kullanılır.

## Yasaklar

- Konum uydurmak
- Onaysız Places API eklemek
- Pin seçimini ziyaret kabul etmek
- Gizli konumları göstermek
- İşlevsiz navigasyon butonu oluşturmak

## Test

- Harita yükleme
- Pin seçimi
- Koordinat yok
- Konum izni reddi
- Ziyaret kaydı
- Tekrar kayıt
- Özel müze erişimi
