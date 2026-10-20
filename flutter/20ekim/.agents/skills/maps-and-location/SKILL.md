
---
name: maps-and-location
description: Harita, kullanıcı konumu, firma pinleri, koordinat, konum izni veya yakın firma sorgularında kullan.
---

# maps-and-location

## Paket
`flutter_map` + OpenStreetMap varsayılan tercihtir; paket eklemeden önce mevcut bağımlılığı ve kullanıcı kararını kontrol et. Halka açık tile sunucusunu production-grade garanti gibi sunma; kullanım politikası, attribution ve cache kurallarına uy.

## Davranış
- Konum yalnız harita/çevredeki firmalar için gerektiğinde izinle alınır. İzin yoksa elle yer/şehir seçimi ve tüm firmaları görme sürer.
- Firma konumları Company.lat/lng'den gelir; yalnız aktif firmalar gösterilir. Pin → vitrin.
- Yakınlık mesafesini açık üniteyle hesapla; kullanıcı konumu yoksa sıralama mesafeye dayandırılmaz.
- Loading/permission denied/disabled/error/empty durumları ayrı UI.
- Haritada OSM atıf ve gerekli lisans bilgisi görünür.

## Test
Konum izni reddi, boş koordinat, yanlış koordinat sınırı, aynı konumda çok pin, firma detay geçişi.
