
---
name: explore-feed
description: Ana sayfa, takip edilen müzeler, popüler müzeler, sıralama, keşfet ve sayfalama geliştirirken kullan.
---

# Müze Keşif Akışı

## Ana İlke

Cep Müzem özgün bir dijital sergi kataloğudur.

Pinterest masonry veya Instagram feed kopyası
oluşturulmaz.

## Kullanıcı Kimseyi Takip Etmiyorsa

Doğrudan popüler müzeler gösterilir.

## Kullanıcı Birilerini Takip Ediyorsa

1. Takip edilenlerin erişilebilir bütün yayınlı müzeleri yüklenir.
2. Bu müzeler en yeniden eskiye listelenir.
3. Takip edilen müzeler tamamen bitirilir.
4. Ardından popüler müzeler başlar.
5. Tekrarlanan müzeler kaldırılır.

Takip edilenlerde müze yoksa doğrudan
popüler müzeler gösterilir.

## Popülerlik — Kesin Algoritma

Değerlendirme penceresi:
Son 30 gün

Puan:
- Her beğeni: 1
- Her yorum: 2

Popülerlik puanı:

score = likeCount30d + (2 * commentCount30d)

Yüksek puan önce gelir.

Eşit puanda en son yayınlanan müze önce gelir.

Bu algoritma kullanıcı izni olmadan değiştirilmez.

## Veri Kuralları

- Yalnızca published müzeler listelenir.
- Gizli hesap erişimi kontrol edilir.
- Taslaklar gösterilmez.
- Arşivlenmiş müzeler gösterilmez.
- Takip değişikliklerinde akış yenilenir.
- Sayfalama desteklenir.
- Bölüm geçişi deterministik olmalıdır.
- Hata nedeniyle takip akışı yanlışlıkla atlanmaz.

## Müze Kartı

- Kapak görseli
- Müze adı
- Kısa açıklama
- Müze sahibi
- Kaydetme

Sosyal sayaçlar görselin önüne geçmez.

## Test

- Takip yok
- Takip var
- Takip edilenlerde müze yok
- Popülerlik hesaplama
- Eşit puan
- Tekrar eleme
- Gizli müze
- Sayfalama
- Hata durumu
