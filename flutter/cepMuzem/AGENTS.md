
# Cep Müzem — Agent Çalışma Yönergesi

## Başlangıç Sırası

1. Her görevde önce proje kökündeki `project.md` dosyasını oku.
2. `.agents/skills/` altındaki SKILL.md dosyalarının YAML description alanlarını incele.
3. Göreve uygun skill dosyalarının tamamını oku.
4. UI ile ilgili her görevde `museum-design-system` skill'ini kullan.
5. Kodlamadan önce kısa bir plan hazırla.
6. Planın ardından kullanıcı tarafından tanımlanan görevi uygula.
7. Sonunda değişen dosyaları, test sonuçlarını ve eksikleri bildir.

## Talimat Önceliği

1. Kullanıcının açık talimatı
2. project.md
3. AGENTS.md
4. İlgili SKILL.md dosyaları
5. Mevcut proje kodu

Çelişki olduğunda Agent kendi ürün kararını üretmez.

## Kesin Teknik Kararlar

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
- 2D müze simülasyonu
- Gelecekte 3D renderer desteği

Veri akışı:

View
→ ChangeNotifier ViewModel
→ Repository Interface
→ Repository Implementation
→ Data Source

UI doğrudan Firebase işlemi gerçekleştirmez.

## Kesin Ürün Kararları

- Uygulama kişisel dijital müze odaklıdır.
- Sosyallik Pinterest düzeyinde sakin tutulur.
- Instagram veya Pinterest arayüzü kopyalanmaz.
- Beğeni ve takipçi rekabeti ön plana çıkarılmaz.
- Ana sayfada önce takip edilenlerin bütün erişilebilir müzeleri gösterilir.
- Takip edilenlerin müzeleri bittikten sonra popülerler gösterilir.
- Takip edilenlerde müze yoksa popülerler doğrudan başlar.
- Aynı müze akış içerisinde tekrarlanmaz.
- Kullanıcı müzeleri beğenebilir, yorumlayabilir ve kaydedebilir.
- Gizli hesapların içeriği yalnızca yetkili kullanıcılara açıktır.
- V1'de 2D simülasyon kullanılır.
- V1'de 3D özelliği gösterilmez.

## Kesin Tasarım Kararları

Tasarım kaynağı:
`.agents/skills/museum-design-system/SKILL.md`

Konsept: Yaşayan Müze

Renkler:
- Ivory: #F6F1E7
- Parchment: #EDE2D0
- Museum Stone: #C9BBA5
- Antique Bronze: #8B6B43
- Walnut: #332C27
- Olive: #69715D
- Terracotta: #AA6753
- Museum White: #FFFCF7

Tipografi:
- Başlık: Cormorant Garamond
- Gövde: Inter

İkon ailesi:
- Material Symbols

Ana navigasyon:
1. Keşfet
2. Harita
3. Müzeni Oluştur
4. Profil

Bildirim ekranı sağ üstteki zil ikonundan açılır.

## Kesin Müze Şablonları

V1'de üç oda şablonu bulunur:

1. Klasik Galeri — 4 eser
2. Taş Koridor — 6 eser
3. Arşiv Salonu — 8 eser

Şablonlar 2D'dir ve belirlenmiş eser yuvaları içerir.

Agent bunların dışında yeni oda şablonu üretmez.

## Popülerlik

Son 30 günlük etkileşimler kullanılır.

Puan:
- 1 beğeni = 1 puan
- 1 yorum = 2 puan

Eşitlik durumunda en yeni yayınlanan müze önce gelir.

Gizli veya erişilemeyen müzeler popüler akışta gösterilmez.

## Agent Yetki Sınırları

Agent şunları yapabilir:
- Tanımlanmış özellikleri geliştirmek
- Hata düzeltmek
- Test yazmak
- Mevcut mimariye uygun refactoring yapmak
- Onaylı tasarım bileşenlerini kullanmak

Agent şunları yapamaz:
- Yeni ürün özelliği icat etmek
- Yeni ekran eklemek
- Yeni bottom navigation öğesi eklemek
- Tema renklerini değiştirmek
- Yeni font belirlemek
- Mimariyi değiştirmek
- Onaysız teknoloji veya paket kullanmak
- Veri modellerini keyfî değiştirmek
- Yeni müze şablonu üretmek
- Popülerlik algoritmasını değiştirmek
- Gizlilik kurallarını gevşetmek
- Kapsam dışı 3D özellik geliştirmek

## Firebase

Firebase hedef mimaridir.

Gerçek Firebase bağlantısı için kullanıcıya ait
Firebase projesi ve platform yapılandırması gerekir.

Firebase bağlantısı yoksa:
- Sahte gerçek bağlantı gösterilmez.
- Ayrı MockRepository kullanılabilir.
- Demo verileri açıkça DEMO olarak belirtilir.
- Gerçek kullanıcı işlemi yapılmış gibi davranılmaz.

## Fonksiyonellik

- Görünen her buton çalışmalıdır.
- İşlevsiz kontrol eklenmez.
- Boş yönlendirme oluşturulmaz.
- Sahte başarı bildirimi gösterilmez.
- Veriler gerçekten saklanmadan kalıcı denmez.
- Hata, boş, yükleniyor ve erişim engeli durumları yönetilir.
- Gizlilik yalnızca UI seviyesinde uygulanmaz.
- Çalışan özellikler kullanıcı istemeden bozulmaz.

## Geliştirme Sırası

1. Flutter proje iskeleti
2. Tema ve ortak bileşenler
3. Navigasyon ve splash
4. Authentication altyapısı
5. Müze keşif ekranı
6. Müze detay ve 2D simülasyon
7. Müze oluşturma
8. Profil ve gizlilik
9. Sosyal etkileşimler
10. Bildirimler
11. Harita ve ziyaretler
12. Entegrasyon testleri

Bu sıralama teknik bağımlılıklara göre küçük
alt adımlara bölünebilir.

## Test

Mümkün olan her aşamada:

- dart format
- flutter analyze
- flutter test

Testler çalıştırılamıyorsa nedeni belirtilir.

## Görev Sonu Raporu

- Oluşturulan dosyalar
- Değiştirilen dosyalar
- Çalışan özellikler
- Test sonuçları
- Gerçek entegrasyon eksikleri
- Sonraki geliştirme aşaması

## Son Kural

Agent bağımsız bir ürün tasarımcısı değildir.

Ürün kararlarını kullanıcı belirler.

Agent bu kararları eksiksiz ve kontrollü
şekilde uygulayan geliştiricidir.
