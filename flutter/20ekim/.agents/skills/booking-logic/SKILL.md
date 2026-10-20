
---
name: booking-logic
description: Rezervasyon oluşturma, müsaitlik, çakışma, ücret, iptal, teslim/iade durumları veya takvim üzerinde çalışırken kullan.
---

# booking-logic

## Tek doğruluk kaynağı
Bookability mantığı domain use case/service'de; araç detay, arama sonuçları ve checkout **aynı** doğrulama servisini çağırır.

## Doğrulamalar
1. `startAt < endAt`, başlangıç geçmişte değil, müşteri profil/ehliyet yaşı ve süresi araç kriterlerine uygun, araç aktif.
2. Aralık `[startAt,endAt)`. Çakışma `a.start < b.end && a.end > b.start`.
3. `confirmed`/`active` rezervasyonlar ve blockedPeriods müsaitliği kapatır. `completed` geçmiş aralıkta kalır; geçmiş döneme yeni rezervasyon zaten yasaktır. `cancelled` bloklamaz.
4. Rezervasyon doğrulama ve insert tek local kritik bölgede/transaction içinde. Backend olmadan başka cihaz tutarlılığı garanti edilmez.
5. Tam veya kesirli 24 saat `ceil(durationHours / 24)`, en az 1 gün. Tutarları `int` kuruş sakla.
6. Uygun kampanya indirimi hesaplandıktan sonra basePrice/discount/total ve campaignId snapshot kaydet.
7. İzinli statü geçişleri: new→confirmed; confirmed→active, confirmed→cancelled; active→completed. Başka geçişler reddedilir.
8. İşlem sahipliği: yalnızca ilgili müşteri rezervasyonunu görür/confirmed iptal edebilir; firma kendi rezervasyonunu active/completed yapabilir veya confirmed iptal eder.

## Test matrisi
Komşu sınırda çakışmaz; 1 saniye taşma çakışır; eşzamanlı iki local istekten biri başarısız; invalid dates; pasif araç; bloke gün; min yaş; kampanya süresi; idempotency/tekrar tıklama; statü atlama; farklı firma erişimi.
