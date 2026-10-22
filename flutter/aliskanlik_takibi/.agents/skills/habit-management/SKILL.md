
---
name: habit-management
description: Alışkanlık oluşturma, düzenleme, günlük ilerleme, hedef planlama, streak ve süreç yönetimi işlemlerinde kullan.
---

# Habit Management

## Alışkanlık özellikleri

Her alışkanlık aşağıdaki bilgileri desteklemelidir:

- Ad
- Kategori
- İkon ve renk
- Hedef türü
- Hedef değeri
- Tekrar sıklığı
- Başlangıç tarihi
- Süreç uzunluğu
- Hatırlatma zamanı

## Hedef türleri

- Boolean: Yapıldı / Yapılmadı
- Quantity: Sayfa, bardak, adım vb.
- Duration: Dakika veya saat

## Tekrar seçenekleri

- Her gün
- Hafta içi
- Seçilen günler

## Günlük ilerleme kuralları

1. Kullanıcı ilerlemesini kaydedebilir.
2. Kısmi ilerleme saklanmalıdır.
3. Hedef tamamlandığında ilgili gün başarılı olur.
4. Hedefin aşılması ek başarılı gün oluşturmaz.
5. Bir gün için en fazla bir yapboz parçası kazanılır.
6. Planlanmamış günler başarısız sayılmaz.

## Streak

- Ardışık başarılı planlı günler üzerinden hesaplanır.
- Kaçırılan planlı gün seriyi keser.
- Planlanmamış günler seriyi bozmaz.
- En uzun streak saklanır.
- Streak kaybı kazanılan parçaları silmez.

## Süreç yönetimi

- Süreli ve süresiz alışkanlıkları destekle.
- Süreli süreçlerde başlangıç ve bitiş tarihlerini koru.
- Süresiz alışkanlıklarda ayrı yapboz dönemleri kullanılabilir.
- Tamamlanan süreçlerin verilerini koru.
- Geçmiş süreçleri yeni süreçlerden bağımsız tut.

İş kuralları UI katmanında uygulanmamalıdır.
