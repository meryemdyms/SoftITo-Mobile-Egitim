
# RITMO — PROJECT.md

> Küçük adımlar, büyük değişimler.

## 1. Proje Özeti

Ritmo, kullanıcıların yeni alışkanlıklar kazanmasını, günlük hedeflerini takip etmesini ve kişisel gelişimlerini analiz etmesini sağlayan Flutter mobil uygulamasıdır.

Uygulamanın temel farklılığı Gizli Yapboz Sistemi'dir.

Kullanıcı bir alışkanlık süreci başlattığında kendisine gizli bir görsel atanır. Her başarılı planlı günde yapbozun rastgele bir parçasını kazanır.

Kullanıcı başlangıçta görselin ne olduğunu bilmez. Görseli yalnızca kazandığı parçalar üzerinden keşfeder.

Süreç sonunda:
- Yapbozun mevcut durumu kaydedilir.
- Detaylı gelişim analizi hazırlanır.
- Tamamlanan yapbozlar başarı koleksiyonuna eklenir.
- Eksik yapbozlar Yarım Kalan Hikâyeler bölümünde saklanır.
- Kullanıcı yeni bir süreç başlatabilir.

Temel ilke:

Alışkanlık kazanmak asıl başarıdır. Yapboz, bu başarının görsel ödülüdür.

---

## 2. Proje Amacı

- Kullanıcıların düzenli alışkanlıklar kazanmasını sağlamak.
- Günlük hedeflerin takibini kolaylaştırmak.
- Görsel ödüllerle motivasyonu artırmak.
- Streak sistemiyle devamlılığı desteklemek.
- Gelişim süreçlerini istatistiklerle analiz etmek.
- Tamamlanan süreçleri kişisel koleksiyonda saklamak.
- Önceki ve mevcut performansları karşılaştırmak.
- Sade, modern ve keyifli bir kullanıcı deneyimi oluşturmak.

---

## 3. Teknoloji ve Mimari

### Platform

- Flutter
- Dart
- Android
- iOS
- Material 3

### Mimari

Feature-first mimari kullanılacaktır.

- State yönetimi: ChangeNotifier
- Veri erişimi: Repository Pattern
- UI ve iş mantığı ayrı katmanlarda bulunur.
- Tekrar kullanılabilir bileşenler core altında tutulur.
- Basit CRUD işlemlerinde gereksiz domain/use case katmanları oluşturulmaz.
- Karmaşık hesaplamalar UI dışında gerçekleştirilir.

### Klasör Yapısı

lib/
  core/
    theme/
    routing/
    widgets/
    services/
    utils/

  features/
    auth/
    onboarding/
    home/
    habits/
    puzzle/
    progress/
    collection/
    profile/
    notifications/

Her feature ihtiyaç duyduğu alt klasörleri kullanır:

- models/
- views/
- widgets/
- controllers/
- repositories/

Gereksiz veya boş dosya ve klasör oluşturulmaz.

### Veri Saklama

İlk geliştirmede:

- Mock/demo veriler kullanılabilir.
- Alışkanlıklar ve ilerleme kayıtları cihazda kalıcı tutulur.
- Repository katmanı sonradan backend bağlanabilecek şekilde tasarlanır.
- Günlük kayıtlar, süreçler ve yapbozlar uygulama yeniden açıldığında korunur.

### Kimlik Doğrulama

İlk sürümde giriş ve kayıt arayüzleri hazırlanır.

Kayıt alanları:
- Ad
- Soyad
- E-posta
- Şifre

Gerçek backend henüz belirlenmediği için ilk aşamada demo oturum akışı uygulanır.

Demo oturum gerçek kimlik doğrulama olarak sunulmaz.

- Şifre düz metin olarak saklanmaz.
- Sahte güvenlik garantisi verilmez.
- Gerçek kayıt, giriş, şifre sıfırlama ve hesap yönetimi backend entegrasyonuna bırakılır.

### Bağımlılıklar

- Yalnızca gerekli Flutter paketleri kullanılır.
- Yeni paketler eklenmeden önce mevcut çözümler değerlendirilir.
- Paket seçimi proje mimarisini değiştirmemelidir.

---

## 4. Tasarım Sistemi

### Uygulama Kimliği

Ad: Ritmo

Slogan: Küçük adımlar, büyük değişimler.

Tasarım yaklaşımı:
- Minimal
- Modern
- Premium
- Sıcak
- Sakin
- Estetik
- Kullanıcı dostu

Uygulama klasik yapılacaklar listesi veya ağır oyun arayüzü gibi görünmemelidir.

### Renk Paleti

Background: #F6F4EE
Primary: #344E41
Secondary: #A3B899
Accent: #E8CDA9
Soft Accent: #D9A6A0

Tüm renkler merkezi ThemeData üzerinden yönetilir.

### UI Kuralları

- Material 3 kullan.
- Yuvarlatılmış kartlar tercih et.
- Tutarlı boşluk ve tipografi sistemi kullan.
- Gereksiz gölge ve gradient oluşturma.
- Modern ve sade ikonlar kullan.
- Responsive tasarım uygula.
- Erişilebilir kontrastı koru.
- Tekrar eden tasarımları ortak widgetlara dönüştür.
- Animasyonlar kısa ve atlanabilir olmalıdır.

### Navigasyon

Alt navigasyonda 5 sekme bulunur:

1. Ana Sayfa
2. Alışkanlıklar
3. Gelişim
4. Başarılar
5. Profil

---

## 5. Ekranlar ve Kullanıcı Akışı

### 5.1. Splash

- Uygulama logosu
- Ritmo adı
- Kısa açılış animasyonu
- Oturum durumuna göre yönlendirme

### 5.2. Giriş

- E-posta
- Şifre
- Giriş Yap
- Kayıt Ol
- Şifremi Unuttum

Gerçek backend olmadan şifre sıfırlama işlemi çalışıyormuş gibi gösterilmez.

### 5.3. Kayıt

- Ad
- Soyad
- E-posta
- Şifre
- Form doğrulama
- Kayıt akışı

### 5.4. Onboarding

İlk kullanımda:
- Uygulamanın amacı anlatılır.
- Gizli yapboz sistemi tanıtılır.
- İlk alışkanlığı oluşturma önerilir.
- Hazır alışkanlık örnekleri sunulur.

### 5.5. Ana Sayfa

İçerik:

- Kişisel karşılama
- Günlük ilerleme yüzdesi
- Bugünün alışkanlıkları
- Tamamlanan alışkanlıklar
- Bekleyen alışkanlıklar
- Streak özeti
- Günlük motivasyon mesajı
- Yaklaşan süreç bitişleri
- Yapboz ilerleme özeti

Her alışkanlık kartı:
- İkon
- İsim
- Günlük hedef
- İlerleme durumu
- Tamamlama kontrolü
- Detay yönlendirmesi

### 5.6. Alışkanlıklarım

- Aktif alışkanlıklar
- Tamamlanan süreçler
- Alışkanlık ekleme
- Alışkanlık düzenleme
- Alışkanlık detayları
- Duraklatma ve arşivleme

### 5.7. Alışkanlık Oluşturma

Alanlar:

- İsim
- Kategori
- İkon
- Renk
- Hedef türü
- Hedef miktarı
- Tekrar sıklığı
- Süreç uzunluğu
- Başlangıç tarihi
- Hatırlatma saati

Hedef türleri:

1. Evet / Hayır
2. Miktar
3. Süre

Tekrar seçenekleri:

- Her gün
- Hafta içi
- Seçilen günler

Süre seçenekleri:

- 21 gün
- 30 gün
- 60 gün
- 90 gün
- Süresiz

### 5.8. Alışkanlık Detayı

- Alışkanlık bilgileri
- Günlük hedef
- İlerleme kaydı
- Streak
- Süreç takvimi
- Gizli yapboz
- Açılmış parça sayısı
- Analize yönlendirme

### 5.9. Gelişim

- Günlük analiz
- Haftalık analiz
- Aylık analiz
- Heatmap
- Takvim
- Streak istatistikleri
- Aktif süreç raporları
- Geçmiş yolculuklar

### 5.10. Başarı Koleksiyonu

İki ana bölüm bulunur:

Tamamlanan Eserler:
- Eksiksiz kazanılmış görseller
- Eser adı
- Alışkanlık adı
- Tamamlanma tarihi
- Analiz raporu

Yarım Kalan Hikâyeler:
- Eksik yapbozlar
- Kazanılan parçalar
- Tamamlanma oranı
- Süreç raporu

### 5.11. Profil

- Ad ve soyad
- E-posta
- Profil düzenleme
- Genel başarı istatistikleri
- En uzun streak
- Koleksiyon vitrini
- Bildirim ayarları
- Çıkış yapma

---

## 6. Alışkanlık Yönetimi

### Günlük Hedef Örneği

Alışkanlık: Kitap Okumak

- Hedef: 20 sayfa
- Sıklık: Her gün
- Süreç: 30 gün
- Toplam hedef: 600 sayfa
- Yapboz: 30 parça

### Günlük İlerleme Kuralları

- 0 sayfa: Tamamlanmadı.
- 10 sayfa: %50 ilerleme.
- 20 sayfa: Hedef tamamlandı.
- 30 sayfa: Hedef aşıldı.

Kurallar:

1. Kısmi ilerleme kaydedilir.
2. Hedef tamamlandığında gün başarılı sayılır.
3. Her başarılı planlı gün yalnızca bir yapboz parçası kazandırır.
4. Hedefin aşılması ek parça kazandırmaz.
5. Fazladan ilerleme ertesi güne aktarılmaz.
6. Aynı işlem tekrarlandığında ek ödül oluşturulmaz.
7. Planlanmamış günler başarısız sayılmaz.

---

## 7. Gizli Yapboz Sistemi

Bu sistem Ritmo'nun temel özelliğidir.

### 7.1. Yapboz Oluşturma

Yeni alışkanlık sürecinde:

1. Sistem gizli görsel atar.
2. Planlanan alışkanlık günleri hesaplanır.
3. Yapboz bu sayı kadar parçaya ayrılır.
4. Parçalar için rastgele açılma sırası oluşturulur.
5. Sıra kalıcı olarak saklanır.
6. Kullanıcı görseli ve eser adını bilmez.

### 7.2. Parça Açılma Kuralları

- Her başarılı planlı gün bir parça açılır.
- Parçalar rastgele belirlenmiş sırayla açılır.
- Aynı parça iki kez açılmaz.
- Açılan parça ilgili görsel bölümünü gösterir.
- Kapalı parçalar görseli göstermez.
- Uygulama yeniden açıldığında mevcut durum korunur.

### 7.3. Eksik Günler

- Hedef tamamlanmazsa parça kazanılmaz.
- Kısmi ilerleme parça kazandırmaz.
- Eksik parçalar kapalı kalır.
- Sonraki günün başarısı eski günü tamamlamaz.

### 7.4. Süreç Sonu

Tam başarı:

- Bütün parçalar açılır.
- Son parça animasyonu oynar.
- Görsel tamamen ortaya çıkar.
- Eser adı açıklanır.
- Kutlama animasyonu gösterilir.
- Eser koleksiyona eklenir.
- Süreç analizi hazırlanır.

Eksik başarı:

- Yalnızca kazanılan parçalar görünür.
- Eksik parçalar kapalı kalır.
- Görselin tamamı gösterilmez.
- Yapboz Yarım Kalan Hikâyeler bölümüne eklenir.
- Süreç analizi hazırlanır.

### 7.5. Yeni Süreç

Kullanıcı yeni süreç başlatabilir.

- Yeni süreç oluşturulur.
- Ayrı yapboz kaydı tutulur.
- Ayrı analiz hesaplanır.
- Önceki süreç değiştirilmez.

### 7.6. Görsel Güvenliği

- Gizli görsel kapalı parçalarda görünmemelidir.
- Tam görsel için erken önizleme sunulmaz.
- Görsel adı tamamlanmadan açıklanmaz.
- Açılmamış parçalar yanlışlıkla görünür hâle gelmemelidir.

---

## 8. Streak Sistemi

Streak, ardışık başarılı planlı günleri ifade eder.

Gösterilecek bilgiler:

- Mevcut streak
- En uzun streak
- Başarılı gün sayısı
- Kaçırılan günler
- Haftalık başarı
- Aylık başarı

Kurallar:

- Başarılı planlı gün streak artırır.
- Kaçırılan planlı gün streak keser.
- Planlanmamış gün streak bozmaz.
- Kaybedilen streak eski yapboz parçalarını silmez.
- Geçmiş başarı kayıtları korunur.

---

## 9. Analiz Sistemi

### 9.1. Devam Eden Süreç Analizi

- Toplam planlanan gün
- Geçen gün
- Kalan gün
- Başarılı gün
- Eksik gün
- Günlük ilerleme
- Tamamlama oranı
- Mevcut streak
- En uzun streak
- Günlük grafik
- Haftalık grafik
- Takvim ve heatmap
- Yapboz ilerlemesi

### 9.2. Süreç Sonu Analizi

Süreç bitince ayrıntılı rapor hazırlanır.

Örnek:

30 Günlük Kitap Okuma

- Planlanan gün: 30
- Başarılı gün: 24
- Eksik gün: 6
- Gün başarı oranı: %80
- Toplam hedef: 600 sayfa
- Okunan: 520 sayfa
- Miktar başarı oranı: %86,7
- Yapboz: 24/30 parça

Gün tamamlama oranı ile miktar başarı oranı farklı hesaplanır.

### 9.3. Süreç Sonu Seçenekleri

- Aynı hedefle yeni süreç
- Hedefi yükselt
- Hedefi değiştir
- Alışkanlığı sürdür
- Arşivle

### 9.4. Geçmiş Yolculuklar

- Eski süreçler saklanır.
- Önceki analizler görüntülenir.
- Aynı alışkanlığın farklı dönemleri karşılaştırılır.
- Geçmiş yapbozlar korunur.

---

## 10. Başarı Koleksiyonu

Klasik rozet sistemi yerine yapboz eserleri kullanılır.

### Tamamlanan Eserler

- Tamamlanmış yapbozlar
- Tam görseller
- Eser adı
- İlgili alışkanlık
- Başarı tarihi
- Analiz bağlantısı

### Yarım Kalan Hikâyeler

- Eksik yapbozlar
- Açılmış parçalar
- Kapalı parçalar
- Tamamlanma yüzdesi
- Süreç raporu

### Koleksiyon Serileri

Önerilen kategoriler:

- Huzur Serisi
- Düşler Serisi
- Sanat Serisi
- Doğa Serisi
- Şehir Serisi
- Vintage Serisi

Kullanıcı görseli tamamlayana kadar eser adı gizli kalır.

### Koleksiyon Tasarımı

- Sanat galerisi görünümü
- Estetik eser kartları
- Sade çerçeveler
- Eser detay ekranı
- Profilde koleksiyon vitrini

Klasik bronz, gümüş ve altın rozet sistemi kullanılmaz.

---

## 11. Bildirim Sistemi

- Her alışkanlık için hatırlatma seçilebilir.
- Kullanıcı bildirim saatini belirler.
- Hedef tamamlanmadıysa hatırlatma gönderilir.
- Tamamlanan hedef için gereksiz bildirim gönderilmez.
- Bildirim izinleri kullanıcı kontrolündedir.
- Bildirimler motive edici ve nazik olmalıdır.

---

## 12. Hazır Alışkanlık Önerileri

İlk kullanımda veya alışkanlık eklerken öneriler gösterilir.

Kategoriler:

- Kişisel Gelişim
- Spor
- Sağlık
- Eğitim
- Uyku
- Günlük Rutinler

Örnekler:

- Günde 20 sayfa kitap oku.
- 30 dakika yürüyüş yap.
- 45 dakika ders çalış.
- Günlük su hedefini tamamla.
- 10 dakika meditasyon yap.

Kullanıcı hazır alışkanlıkları düzenleyebilir.

---

## 13. Süresiz Alışkanlıklar

Süresiz alışkanlıklarda önerilen sistem:

- Alışkanlık aktif kalır.
- Yapbozlar dönemlere ayrılır.
- Varsayılan dönem 30 gündür.
- Her dönem yeni yapboz oluşturulur.
- Dönem sonunda analiz hazırlanır.
- Geçmiş dönemler korunur.

---

## 14. Veri Modelleri

Temel modeller:

### User
- id
- firstName
- lastName
- email
- createdAt

### Habit
- id
- userId
- name
- category
- icon
- color
- measurementType
- unit
- status

### HabitSchedule
- id
- habitId
- frequency
- selectedDays
- targetValue
- startDate
- endDate
- reminderTime

### HabitProcess
- id
- habitId
- startDate
- endDate
- plannedDays
- completedDays
- status

### DailyProgress
- id
- processId
- date
- targetValue
- actualValue
- isCompleted
- completedAt

### Puzzle
- id
- processId
- artworkId
- totalPieces
- unlockedPieces
- revealOrder
- status

### PuzzlePiece
- id
- puzzleId
- pieceIndex
- isUnlocked
- unlockedAt
- progressDate

### AnalysisReport
- id
- processId
- plannedDays
- successfulDays
- completionRate
- totalProgress
- longestStreak

### CollectionItem
- id
- userId
- puzzleId
- processId
- status
- collectedAt

### NotificationPreference
- id
- habitId
- enabled
- reminderTime

Veri modelleri gerektiğinde genişletilebilir ancak temel ürün kuralları değiştirilemez.

---

## 15. Sayfa Hiyerarşisi

Splash
  → Login / Register
  → Onboarding
  → Main Navigation

Main Navigation
  → Home
  → Habits
  → Progress
  → Collection
  → Profile

Habits
  → Create Habit
  → Edit Habit
  → Habit Detail
  → Daily Progress
  → Puzzle View

Progress
  → Calendar
  → Statistics
  → Active Process Analysis
  → Completed Process Report

Collection
  → Completed Artworks
  → Unfinished Stories
  → Artwork Detail

Profile
  → User Information
  → Collection Showcase
  → Settings

---

## 16. Geliştirme Aşamaları

### Aşama 1 — Proje ve Tema

- Flutter projesi
- Klasör yapısı
- Tema sistemi
- Navigasyon
- Splash
- Giriş
- Kayıt
- Onboarding

### Aşama 2 — Ana Fonksiyonlar

- Ana sayfa
- Alışkanlık oluşturma
- Alışkanlık düzenleme
- Günlük ilerleme
- Süreç yönetimi
- Streak

### Aşama 3 — Yapboz

- Gizli görsel havuzu
- Yapboz üretimi
- Rastgele parça sırası
- Günlük parça kazanımı
- Parça animasyonu
- Tamamlama animasyonu

### Aşama 4 — Analiz ve Koleksiyon

- Gelişim ekranı
- Takvim
- Grafikler
- Süreç sonu raporu
- Geçmiş yolculuklar
- Başarı koleksiyonu
- Yarım kalan hikâyeler

### Aşama 5 — Tamamlama

- Bildirimler
- Profil
- Veri kalıcılığı
- Testler
- Hata düzeltmeleri
- UI iyileştirmeleri

---

## 17. Sonraki Sürüme Bırakılan Özellikler

İlk geliştirme kapsamında zorunlu değildir:

- Liderlik tablosu
- Sosyal özellikler
- Arkadaş ekleme
- Koleksiyon puanlama sistemi
- Streak koruma hakkı
- Bulut senkronizasyonu
- Gerçek backend entegrasyonu

Bu özellikler kullanıcı istemedikçe otomatik eklenmez.

---

## 18. Kesin İş Kuralları

1. Her süreç kendine ait yapboza sahiptir.
2. Kullanıcı görseli başlangıçta bilmez.
3. Yapboz parça sayısı planlı gün sayısına bağlıdır.
4. Her başarılı planlı gün tek parça kazandırır.
5. Parçalar önceden belirlenmiş rastgele sırayla açılır.
6. Aynı parça tekrar kazanılmaz.
7. Kısmi ilerleme parça kazandırmaz.
8. Kaçırılan günün parçası açılmaz.
9. Eksik parçalar süreç sonunda kapalı kalır.
10. Tam görsel yalnızca bütün parçalar kazanıldığında açılır.
11. Tamamlanan ve eksik yapbozlar ayrı koleksiyon bölümlerinde saklanır.
12. Geçmiş süreçler yeni süreçlerden etkilenmez.
13. Streak kaybı kazanılmış parçaları silmez.
14. Gün başarı oranı ve miktar başarı oranı ayrı hesaplanır.
15. Analiz geçmişi korunur.
16. Kullanıcı onayı olmadan iş kuralları değiştirilmez.

---

## 19. Agent ve Skill Kuralları

Agent her geliştirme görevinde:

1. Önce project.md dosyasını okur.
2. AGENTS.md kurallarını uygular.
3. Göreve uygun skill dosyalarını okur.
4. Gerekli feature ve dosyaları belirler.
5. Mevcut mimari ve tasarım kurallarını korur.
6. Gereksiz kapsam genişletmez.
7. Uygun testleri çalıştırır.
8. Değişiklikleri raporlar.

Mevcut skill dosyaları:

- flutter-architecture
- ui-design
- habit-management
- puzzle-system
- analytics-collection
- testing-quality

Genel SKILL.md oluşturulmayacaktır.

Belirsiz ürün kuralları agent tarafından değiştirilmez.

---

## 20. Geliştirme Notları

- İlk sürüm mobil uygulamadır.
- Flutter iOS ve Android için geliştirilir.
- Merkezi tema sistemi kullanılır.
- İlk geliştirmede mock ve yerel veri desteği kullanılabilir.
- Kalıcı kayıtlar uygulama yeniden açıldığında korunur.
- Gerçek güvenli oturum backend entegrasyonu gerektirir.
- Yapboz görselleri uygun kullanım lisansına sahip olmalıdır.
- Arşivlenmiş yapbozların durumu korunmalıdır.
- Aynı gün tekrar işlem yapılması ek parça üretmemelidir.
- Tarih ve saat hesaplamaları tutarlı olmalıdır.
- Animasyonlar kullanıcı deneyimini yavaşlatmamalıdır.
- Bildirim sistemi cihaz izinlerine uygun davranmalıdır.
- Kullanıcıya cezalandırıcı mesajlar gösterilmemelidir.
- Tamamlanmamış özellikler çalışıyormuş gibi sunulmamalıdır.

---

## 21. Projenin Nihai Hedefi

Ritmo, kullanıcının yalnızca günlük görevlerini işaretlediği bir uygulama değildir.

Kullanıcı kendi alışkanlık yolculuğunu oluşturur, gelişimini ölçer, gizli yapbozlarını keşfeder ve kazandığı eserlerle kişisel bir başarı galerisi oluşturur.

Uygulamanın temel deneyimi:

Küçük Adımlar
→ Düzenli Alışkanlıklar
→ Gizli Keşifler
→ Kişisel Gelişim
→ Başarı Koleksiyonu
