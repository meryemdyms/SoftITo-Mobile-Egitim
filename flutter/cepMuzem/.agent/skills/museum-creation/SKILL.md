
---
name: museum-creation
description: Müze oluşturma, taslak, oda şablonu, eser ekleme, yerleşim, önizleme, yayınlama ve müze yönetimi için kullan.
---

# Müze Oluşturma

## Kesin Akış

1. Yeni müze veya taslağa devam
2. Müze bilgileri
3. 2D oda şablonu
4. Eser ekleme
5. Eser yerleşimi
6. Konum ve görünürlük
7. Önizleme
8. Yayınlama

Yeni adım kullanıcı onayı olmadan eklenmez.

## Müze Bilgileri

- Müze adı zorunlu
- Açıklama
- Kapak görseli

## Kesin Oda Şablonları

### Klasik Galeri
- 4 eser yuvası
- Klasik sergi salonu atmosferi

### Taş Koridor
- 6 eser yuvası
- Tarihi taş koridor atmosferi

### Arşiv Salonu
- 8 eser yuvası
- Eski koleksiyon ve arşiv atmosferi

V1'de yalnızca bu üç oda şablonu bulunur.

Şablonlar önceden tanımlanmış slotlar içerir.

## Eser

- Eser adı
- Görsel
- Açıklama
- İsteğe bağlı sesli not

Ses kaydedilebilir veya dosya olarak yüklenebilir.

Metinden otomatik ses üretimi V1 kapsamında değildir.

## Yerleşim

- Eser boş yuvaya atanır.
- Dolu yuvaya ikinci eser atanmaz.
- Yerleşim değiştirilebilir.
- Eser düzenlenebilir.
- Eser kaldırılabilir.
- Yerleşim kalıcı saklanır.

## Taslak

- Otomatik taslak kaydı desteklenir.
- Taslak kullanıcıya özeldir.
- Uygulama yeniden açıldığında gerçek depodan geri yüklenir.
- Yükleme hataları taslağı yok etmez.

Mock veri kalıcılığı gerçek depolama gibi gösterilmez.

## Müze Durumları

- draft
- publishing
- published
- archived

## Yayınlama Şartları

- Müze adı bulunmalıdır.
- En az bir tamamlanmış eser bulunmalıdır.
- Geçerli oda yerleşimi olmalıdır.
- Medya yüklemeleri tamamlanmalıdır.
- Kullanıcı müzenin sahibi olmalıdır.

## Müze Yönetimi

- Düzenleme
- Arşivleme
- Silme
- Silme onayı

## Yasaklar

- Yeni müze şablonu eklemek
- 3D oda eklemek
- Otomatik ses üretmek
- Ücretli müze özelliği eklemek
- Başka kullanıcının müzesini düzenlemek
- Kaydedilmemiş taslağı kaydedilmiş göstermek

## Test

- Taslak oluşturma
- Taslak geri yükleme
- Boş başlık
- Geçersiz eser
- Slot çakışması
- Yayınlama
- Hatalı yükleme
- Sahiplik kontrolü
