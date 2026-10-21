
---
name: quality-release
description: Test, hata düzeltme, performans, regresyon, güvenlik, erişilebilirlik ve final teslim aşamalarında kullan.
---

# Quality and Release

## Temel İlke

Çalışmayan hiçbir özellik kullanıcıya sunulmaz.

Görsel olarak tamamlanmış ancak davranışı
eksik ekran tamamlandı kabul edilmez.

## Zorunlu Kontroller

- Kod formatı
- Statik analiz
- Unit test
- Widget test
- Gerekli entegrasyon testleri
- Navigasyon
- Erişim kontrolü
- Veri kalıcılığı
- Hata yönetimi

## Komutlar

dart format .
flutter analyze
flutter test

Komutlar çalıştırılamıyorsa neden belirtilir.

## Test Edilecek Akışlar

- Kayıt/giriş
- Oturum kontrolü
- Müze oluşturma
- Taslak saklama
- Oda seçimi
- Eser yerleşimi
- Müze yayınlama
- 2D simülasyon
- Eser detay paneli
- Ses oynatma
- Beğeni/yorum
- Kaydetme
- Takip
- Gizli hesap
- Bildirimler
- Harita
- Ziyaret kaydı

## UI Testleri

- Loading
- Empty
- Error
- Success
- Permission denied
- Form validation
- Keyboard overflow
- Responsive layout
- Accessibility
- Büyük metin ölçeği

## Performans

- Gereksiz rebuild azaltılır.
- Görseller optimize edilir.
- Listeleme sayfalaması korunur.
- Müze sahnesi performansı kontrol edilir.

## Regresyon

Yeni değişiklik çalışan eski özellikleri bozmamalıdır.

İlgili testler tekrar çalıştırılır.

## Tamamlanma Kriterleri

- Gereksinim uygulanmış olmalı.
- Görünen kontroller çalışmalı.
- Hata durumları ele alınmalı.
- Güvenlik korunmalı.
- Testler yapılmalı.
- Değişen dosyalar raporlanmalı.

Test başarılı değilse görev tamamen başarılı
olarak raporlanamaz.

## Yasaklar

- Testleri geçmek için silmek
- Hataları gizlemek
- Sahte başarı raporu
- İlgisiz dosyalarda değişiklik
- Onaysız kapsam genişletme
