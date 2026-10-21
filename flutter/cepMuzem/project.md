
# Cep Müzem — project.md

## 1. Proje Tanımı

Cep Müzem, kullanıcıların gezdikleri yerleri, anılarını, sanat eserlerini ve kişisel koleksiyonlarını etkileşimli dijital müzelere dönüştürebildiği mobil uygulamadır.

Kullanıcılar müzelerine görseller, açıklamalar ve sesli notlar ekleyebilir; kendi müzelerini yönetebilir ve başka kullanıcıların erişime açık müzelerini gezebilir.

Uygulamanın temel kimliği:

Kişisel dijital müze + sakin sosyal keşif + etkileşimli müze deneyimi.

## 2. Ürün İlkeleri

- Kişisel müze oluşturmak temel deneyimdir.
- Sosyallik Pinterest düzeyinde sakin tutulur.
- Instagram ve Pinterest arayüzleri taklit edilmez.
- Takipçi ve beğeni rekabeti ön plana çıkarılmaz.
- Kullanıcılar müzeleri keşfedebilir, beğenebilir, yorumlayabilir ve kaydedebilir.
- Anılar ve koleksiyonlar görsel olarak ön plandadır.
- İşlevsiz özellik arayüzde gösterilmez.

## 3. Platform ve Teknoloji

- Flutter / Dart
- Android ve iOS
- Material 3
- Feature-first + MVVM
- ChangeNotifier
- go_router
- Firebase Authentication
- Cloud Firestore
- Firebase Storage
- flutter_map + OpenStreetMap

Veri akışı:

View → ViewModel → Repository Interface → Implementation → Data Source

Firebase bağlantısı kullanıcı projesiyle yapılandırılır.

Firebase yokken ayrı demo repository kullanılabilir.
Demo gerçek çok kullanıcılı uygulama gibi sunulmaz.

## 4. Tasarım Sistemi

Konsept: Yaşayan Müze

Uygulama modern, aydınlık ve tarihi müze atmosferinde olacaktır.

### Kesin Palet

- Background: #F6F1E7
- Surface: #FFFCF7
- Secondary Surface: #EDE2D0
- Border: #C9BBA5
- Primary: #332C27
- Accent: #8B6B43
- Olive: #69715D
- Terracotta: #AA6753

### Tipografi

- Başlık: Cormorant Garamond
- Gövde: Inter

### Arayüz

- Material Symbols ikonları
- 20dp ekran yatay boşluğu
- 16dp kart radius
- 12dp buton radius
- 24dp modal üst radius
- Sakin ve kısa animasyonlar

Bütün UI ayrıntıları museum-design-system skill'inde tanımlanır.

## 5. Navigasyon

Bottom navigation:

1. Keşfet
2. Harita
3. Müzeni Oluştur
4. Profil

Bildirimler ana sayfanın sağ üstündeki zil ikonundan açılır.

## 6. Splash

- Logo
- Uygulama adı
- Oturum kontrolü
- Oturum varsa ana sayfa
- Oturum yoksa giriş

## 7. Authentication

### Kayıt

- Ad
- Soyad
- E-posta
- Şifre

### Giriş

- E-posta
- Şifre

Oturum Firebase Authentication ile yönetilir.

## 8. Ana Sayfa / Keşfet

Ana sayfa dijital sergi kataloğu şeklinde tasarlanır.

Pinterest masonry veya Instagram feed tasarımı kopyalanmaz.

### Takip Edilen Hesap Yok

Doğrudan popüler müzeler gösterilir.

### Takip Edilen Hesap Var

1. Takip edilenlerin erişilebilir bütün yayınlı müzeleri gösterilir.
2. En yeni müzeler önce gelir.
3. Bu müzeler tamamen bitirilir.
4. Ardından popüler müzeler başlar.
5. Tekrar eden müzeler kaldırılır.

Takip edilenlerin müzesi yoksa popülerlerden başlanır.

### Popülerlik

Son 30 gün dikkate alınır.

score = likeCount30d + (2 * commentCount30d)

- Beğeni: 1 puan
- Yorum: 2 puan

Eşit puanda yeni yayınlanan önce gelir.

Gizli veya yetkisiz müzeler popüler akışa girmez.

### Müze Kartı

- Kapak görseli
- Müze adı
- Kısa açıklama
- Müze sahibi
- Kaydetme işlemi

## 9. Müze Detay / Simülasyon

V1'de çalışan 2D etkileşimli müze deneyimi kullanılır.

- Oda görüntülenir.
- Eser seçilebilir.
- Eser detayı alttan açılır.
- Görseller gösterilir.
- Açıklama okunur.
- Sesli not varsa dinlenir.
- Müze beğenilebilir.
- Yorum yapılabilir.
- Müze kaydedilebilir.
- Müze sahibinin profiline geçilebilir.

Gelecekte 3D renderer eklenebilecek şekilde sahne modelleri bağımsız tasarlanır.

V1'de 3D ekran veya buton bulunmaz.

## 10. Müze Oluşturma

### Adım 1 — Yeni Müze / Taslak
- Yeni müze
- Taslağa devam

### Adım 2 — Müze Bilgileri
- Müze adı (zorunlu)
- Açıklama
- Kapak görseli

### Adım 3 — Oda Seçimi

Üç kesin şablon:

1. Klasik Galeri — 4 eser
2. Taş Koridor — 6 eser
3. Arşiv Salonu — 8 eser

### Adım 4 — Eser Ekleme
- Eser adı
- Görsel
- Açıklama
- İsteğe bağlı sesli not

### Adım 5 — Yerleşim
- Eser boş yuvaya atanır.
- Dolu yuvaya ikinci eser eklenmez.
- Yerleşim değiştirilebilir.
- Eser kaldırılabilir ve düzenlenebilir.

### Adım 6 — Konum
- İsteğe bağlı konum
- Konumu olmayan müze için harita pini yok

### Adım 7 — Önizleme
- Gerçek 2D sahne
- Eser detayları
- Ses kontrolü

### Adım 8 — Yayınlama

Şartlar:
- Müze adı
- En az bir tamamlanmış eser
- Geçerli yerleşim
- Tamamlanmış medya yüklemeleri

Müze durumları:
- draft
- publishing
- published
- archived

Taslaklar kalıcı saklanır.
Başarısız yayınlamada veri korunur.

## 11. Profil

### Kendi Profilim

- Profil fotoğrafı
- Ad soyad
- Takipçi sayısı
- Takip edilen sayısı
- Müzelerim
- Kaydettiklerim
- Profil düzenleme
- Gizlilik ayarları
- Çıkış

### Diğer Kullanıcı Profili

- Profil bilgileri
- Takip et / takipten çık
- Erişilebilir müzeler
- Gizli hesaplarda takip isteği

## 12. Gizlilik

Hesap türleri:
- Açık
- Gizli

Açık hesap doğrudan takip edilir.

Gizli hesap:
- Takip isteği
- Onay
- Ret

Gizli müzeler yalnızca sahibi ve onaylı takipçilere açıktır.

Güvenlik Firestore ve Storage kurallarıyla sağlanır.

## 13. Sosyal Özellikler

### Beğeni
- Aynı müze bir kez beğenilir.
- Tekrar dokununca beğeni kaldırılır.

### Yorum
- Erişilebilir müzelere yorum yapılır.
- Boş yorum gönderilemez.

### Kaydetme
- Beğeniden bağımsızdır.
- Aynı müze bir kez kaydedilir.
- Kaydedilenler profilde gösterilir.
- Kaydetmek erişim hakkı vermez.

### Takip
- Açık hesap: doğrudan
- Gizli hesap: onaylı takip isteği

## 14. Bildirimler

Bildirim türleri:
- Beğeni
- Yorum
- Takip
- Takip isteği
- Takip kabulü

İşlemler:
- Listeleme
- Okundu işaretleme
- Tümünü okundu yapma
- Takip isteği onaylama
- Takip isteği reddetme
- İlgili içeriğe yönlendirme

V1 uygulama içi bildirimleri kapsar.
Push bildirim V1 kapsamında değildir.

## 15. Harita

Harita içeriği:
- Erişilebilir ve konumlu yayınlı müzeler
- Kullanıcının manuel eklediği ziyaret yerleri

Harici Places API kullanılmaz.

İşlemler:
- Pin gösterme
- Pin seçme
- Müze detayına geçiş
- Ziyaret işaretleme
- Ziyaret geçmişi

Pin seçmek ziyaret kaydı değildir.

Konum izni olmadan manuel gezinme çalışır.

## 16. Veri Modelleri

### User
- id
- firstName
- lastName
- email
- photoUrl
- isPrivate
- followerCount
- followingCount
- createdAt

### Follow
- followerId
- followingId
- status
- createdAt

### Museum
- id
- ownerId
- title
- description
- coverUrl
- location
- status
- sceneVersion
- likeCount
- commentCount
- createdAt
- publishedAt
- updatedAt

### MuseumRoom
- id
- museumId
- name
- templateId
- sortOrder

### RoomTemplate
- id
- name
- backgroundAsset
- slotDefinitions
- templateVersion

### MuseumScene
- museumId
- schemaVersion
- rooms

### MuseumItem
- id
- museumId
- roomId
- slotId
- title
- description
- imageUrls
- audioUrl
- positionX
- positionY
- sortOrder
- createdAt
- updatedAt

### MuseumLike
- museumId
- userId
- createdAt

### MuseumComment
- id
- museumId
- authorId
- text
- createdAt

### SavedMuseum
- userId
- museumId
- savedAt

### Notification
- id
- recipientId
- actorId
- type
- museumId
- commentId
- isRead
- createdAt

### Place
- id
- name
- latitude
- longitude
- museumId
- category

### VisitedPlace
- userId
- placeId
- visitedAt
- note

## 17. Dosya Mimarisi

lib/
  app/
    router/
    theme/

  core/
    services/
    errors/
    utils/

  features/
    auth/
    splash/
    explore/
    museum_detail/
    museum_creation/
    museum_scene/
    map/
    profile/
    social/
    saved_museums/
    notifications/

  shared/
    widgets/
    models/

Her feature gerekli oldukça:
- models/
- views/
- viewmodels/
- repositories/
- widgets/

şeklinde düzenlenir.

## 18. Güvenlik

- Firebase Security Rules zorunlu
- Storage Rules zorunlu
- Kullanıcı sahipliği kontrolü
- Gizli hesap erişimi
- Özel medya koruması
- Güvenli sayaç işlemleri
- Bildirim erişim kontrolü
- Repository üzerinden veri erişimi

## 19. Test ve Kalite

- Görünen bütün kontroller çalışır.
- Boş ve hata durumları yönetilir.
- Taslaklar gerçek veritabanına bağlandığında kalıcıdır.
- Yetkisiz erişim engellenir.
- Ses ve görsel hataları yönetilir.
- Android/iOS uyumu test edilir.
- Widget ve repository testleri yazılır.
- flutter analyze ve flutter test çalıştırılır.

## 20. Geliştirme Aşamaları

### Aşama 1
- Proje iskeleti
- Tema
- Router
- Splash
- Authentication iskeleti

### Aşama 2
- Ana sayfa
- Müze detay
- 2D simülasyon
- Eser etkileşimleri

### Aşama 3
- Müze oluşturma
- Taslak yönetimi
- Medya yönetimi
- Yayınlama

### Aşama 4
- Profil
- Gizlilik
- Takip
- Beğeni
- Yorum
- Kaydetme
- Bildirimler

### Aşama 5
- Harita
- Ziyaretler
- Entegrasyon
- Güvenlik testleri
- Final testleri

## 21. Agent Talimatları

1. Önce project.md oku.
2. AGENTS.md oku.
3. İlgili skill dosyalarını oku.
4. Tasarımda museum-design-system zorunludur.
5. Mimariyi değiştirme.
6. Kapsamı genişletme.
7. Yeni ürün özelliği icat etme.
8. İşlevsiz kontrol oluşturma.
9. Gizlilik kurallarını bozma.
10. Mock ve gerçek veriyi ayır.
11. Her görev sonunda testleri raporla.
12. Yeni karar gerektiğinde kullanıcı onayı iste.
