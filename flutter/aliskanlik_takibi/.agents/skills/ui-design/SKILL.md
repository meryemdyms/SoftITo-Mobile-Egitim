
---
name: ui-design
description: Yeni ekran, widget, tema, animasyon veya mevcut arayüz düzenlemesi yaparken kullan.
---

# Ritmo UI Design

## Tasarım kimliği

Ritmo modern, sade, sıcak ve premium hissiyatlı bir alışkanlık takip uygulamasıdır.

Arayüz klasik yapılacaklar listesi gibi görünmemelidir.

## Renk paleti

- Background: #F6F4EE
- Primary: #344E41
- Secondary: #A3B899
- Accent: #E8CDA9
- Soft Accent: #D9A6A0

Renkleri merkezi ThemeData üzerinden yönet.

Rastgele renk üretme.

## Genel kurallar

- Material 3 kullan.
- Yuvarlatılmış kartlar tercih et.
- Tutarlı spacing ve padding sistemi oluştur.
- Sade ve modern ikonlar kullan.
- Gereksiz gradient ve gölge kullanma.
- Metin hiyerarşisini koru.
- Responsive tasarım uygula.
- Erişilebilir kontrast ve dokunma alanlarını koru.
- Tekrar eden tasarımlar için ortak widget oluştur.

## Navigasyon

Ana sekmeler:

1. Ana Sayfa
2. Alışkanlıklar
3. Gelişim
4. Başarılar
5. Profil

Alt navigasyon bütün ana sekmelerde tutarlı olmalıdır.

## Ekran öncelikleri

Ana Sayfa:
- Günlük ilerleme
- Bugünün alışkanlıkları
- Streak özeti

Alışkanlık Detayı:
- Günlük hedef
- İlerleme girişi
- Gizli yapboz

Gelişim:
- Takvim
- Grafikler
- İstatistikler

Başarılar:
- Sanat galerisi görünümü
- Tamamlanan eserler
- Yarım kalan hikâyeler

Profil:
- Kullanıcı bilgileri
- Koleksiyon vitrini
- Genel istatistikler

## Animasyonlar

- Kısa ve akıcı olmalıdır.
- Yapboz parçası açılması animasyonla gösterilir.
- Son parça tamamlandığında özel keşif animasyonu çalışır.
- Animasyonlar atlanabilir olmalıdır.
- Gereksiz animasyon oluşturma.

## Yasaklar

- Ekran bazında farklı renk paleti oluşturma.
- Hardcoded tekrar eden stiller kullanma.
- Onaysız tasarım sistemi değiştirme.
- Gereksiz kalabalık arayüz oluşturma.
