
---
name: museum-detail
description: Müze detay ekranı, eser bottom sheet, açıklama, ses oynatma ve müze sahibi bağlantılarında kullan.
---

# Müze Detay Ekranı

## Açılış

1. Müze ID alınır.
2. Yayın durumu kontrol edilir.
3. Kullanıcının erişim izni kontrol edilir.
4. Müze repository üzerinden yüklenir.
5. 2D sahne gösterilir.

## Eser Detay Paneli

Eser seçilince alttan panel açılır.

İçerik:
- Eser adı
- Görsel
- Açıklama
- Varsa sesli not

## Ses Davranışı

- Ses dosyası varsa oynatılır.
- Duraklatma ve durdurma çalışır.
- Panel kapanınca ses durur.
- Ses yoksa oynatma ikonu gösterilmez.

## Sosyal İşlemler

- Beğeni
- Yorum
- Kaydet
- Müze sahibinin profiline git

Sosyal işlemler social-notifications skill'ini kullanır.

## Durumlar

- Loading
- Empty
- Error
- Permission denied
- Success

## Test

- Müze açma
- Erişim kontrolü
- Eser seçme
- Panel açma/kapatma
- Ses oynatma
- Beğeni
- Kaydetme
- Yorum
