
---
name: campaigns-and-pricing
description: Kampanya oluşturma, listeleme, indirim hesaplama, para formatlama ve checkout fiyatlarında kullan.
---

# campaigns-and-pricing

## Uygunluk
Kampanya: aynı companyId, rezervasyon aralığı kuralına göre aktif tarih, ilgili vehicleId veya tüm firma araçları, indirim 0..100. Geçerlilik başlangıç/bitişi açıkça doğrulanır.

## Ücret
- Gün sayısı booking skill'den gelir. Para `int` kuruş.
- Base = dayCount * dailyRateMinor; kampanya hesaplaması deterministik ve yuvarlama kuralı tek utility'de.
- **İlk sürümde bir rezervasyona en fazla bir kampanya**. Birden çok uygun kampanya varsa kullanıcıya en yüksek indirimi otomatik uygula; eşitlikte deterministik id sırası.
- Final = max(0,base-discount). Rezervasyona price snapshot yaz; kampanya sonradan değişse fiyat değişmez.
- UI gün/ara toplam/indirim/ödenecek tutarı açıkça ayırır; `firmada ödeme` ifadesini korur.

## Test
Süresi bitmiş kampanya, başka firma, araç filtresi, %0/%100, kuruş yuvarlama, eşit kampanyalar, snapshot değişmezliği.
