
---
name: media-management
description: Profil fotoğrafı, müze kapağı, eser görselleri, ses kaydı, ses yükleme, oynatma ve medya silme işlemlerinde kullan.
---

# Medya Yönetimi

## Desteklenen Medya

- Profil fotoğrafı
- Müze kapak görseli
- Eser görselleri
- Sesli not

## Görseller

- Dosya seçme
- Önizleme
- Yükleme
- Hata yönetimi
- Kayıtla ilişkilendirme
- Gerektiğinde silme

Görsellerin oranları uygun şekilde korunur.

## Sesli Not

Kullanıcı:
- Ses kaydedebilir.
- Mevcut ses dosyasını seçebilir.
- Ses yükleyebilir.
- Oynatabilir.
- Duraklatabilir.
- Durdurabilir.

Metinden otomatik ses oluşturulmaz.

## İzinler

- Mikrofon izni işlem sırasında istenir.
- İzin olmadan mikrofon kullanılmaz.
- İzin reddi güvenli ele alınır.

## Depolama

Firebase Storage kullanılır.

Erişim kullanıcı ve müze gizliliğine bağlıdır.

Gizli medya herkese açık sunulmaz.

## Hatalar

- Desteklenmeyen dosya
- Yükleme hatası
- Ağ kesintisi
- Eksik medya
- İzin reddi
- Başarısız silme

Yeniden deneme desteklenir.

## Yasaklar

- Habersiz mikrofon kaydı
- Otomatik ses üretimi
- Sahte ses oynatma
- Gizli medyayı herkese açma
- Teknik gereklilik dışında keyfî dosya limiti
- Yüklenmemiş dosyayı yüklenmiş gösterme

## Test

- Görsel seçme
- Yükleme
- Hata
- Ses kaydı
- Ses oynatma/durdurma
- İzin reddi
- Gizli medya erişimi
