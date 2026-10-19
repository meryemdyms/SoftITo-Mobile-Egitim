# Kan Bağış Uygulaması  

Bu doküman, Flutter projesinde geliştirme yapacak olan Ajan (Antigravity), yapay zekâ ve yazılım geliştiriciler için bağlayıcı bir kılavuzdur. Projede üretilen her kod satırı buradaki kurallara **UYMAK ZORUNDADIR**.

## 1. Proje Özeti ve Teknolojiler

- **Uygulama Adı:** Kırmızı Çağrı
**Amaç:** Kan bağışçılarını ihtiyaç sahipleriyle buluşturmak ve bağışçının verdiği kanları takip edip görselleştirmesini sağlamak
**Odak:** İki ana akış: (1) kan çağrısı ile bağışçı eşleşmesi, (2) bağış geçmişi ve grafikle takip
- **Hedef Platformlar:** iOS ve Android
- **Flutter SDK:** 3.29.0+
- **Dart SDK:** 3.0.0+
- **Tasarım Dili:** Material 3
- **Tema:** Aydınlık ve koyu tema desteği [?]
- **Tema Yönetimi:** `ValueNotifier<ThemeMode>` ile reaktif geçiş


## 2. Mimari Yapı: Özellik (Feature) Bazlı

Kodlar tek bir yerde toplanmayacaktır. Her modül kendi feature klasöründe kodlanacaktır.

```text
lib/
├── core/
│   ├── constants/
│   ├── theme/
│   └── extensions/
├── features/
│   ├── blood_request/     (kan çağrısı oluşturma, listeleme, eşleşme)
│   ├── donation_history/  (bağış kayıtları, ekleme/listeleme)
│   ├── donation_stats/    (grafikler, toplam ve aralık hesapları)
│   └── donor_profile/     (kan grubu, son bağış tarihi)
└── main.dart
```

Her feature şu yapıdadır:

```text
<feature_adı>/
├── controllers/
├── models/
├── views/
└── widgets/
```

- **Veri Kaynağı:** [?] (çağrı ve eşleşme akışı için backend gerekir)

> **Not:** `main.dart` sadece uygulama başlatma, temel servis başlatımları ve tema yapılandırmasını içermelidir.

---

## 3. Kırmızı Çizgiler ve Kod Kalite Standartları

1. **State Yönetimi:**
   - Sayfa düzeyinde `setState` **KULLANILMAYACAKTIR**.
   - `ValueNotifier` ve `ValueListenableBuilder` kullanılacaktır.
   - Buton animasyonu gibi mikro UI durumlarında sınırlı `setState` kullanılabilir.

2. **UI ve Performans:**
   - Statik tüm widget'larda `const` **ZORUNLUDUR**.
   - Renk ve metin stilleri tema dosyalarından alınır; hard-coded renk yasaktır.
   - **40 satırı geçen** `build` metotları alt widget'lara parçalanır.

3. **Paketler:**
   - Onay almadan harici state paketi (Bloc, MobX, Redux vb.) **EKLENMEYECEKTİR**.
   - Grafik için `fl_chart` kullanılabilir [?]. Başka harici paket onay gerektirir.
   - Dart ve Flutter'ın yerel API'leri esastır.

4. **Kişisel Veri:**
   - Kan grubu, telefon, konum gibi kişisel veriler loglara yazılmaz.

---


## 4. Geliştirme, Analiz ve Test Komutları

Her kod değişikliğinden sonra aşağıdaki komutlar sorunsuz çalışmalıdır:

- **Statik analiz (0 uyarı, 0 hata):**
```bash
  flutter analyze
```
- **Testler:**
```bash
  flutter test
```
- **Çalıştırma:**
```bash
  flutter run
```

---
## 5. Ajanın Çıktı ve Yanıt Verme Standartları

- **Açıklamalar:** Türkçe, net ve doğrudan.
- **Değişiklik sunumu:** Küçük değişikliklerde tüm dosyayı değil, hedef satırları ve diff'i göster.
- **Dosya yolları:** Bahsedilen her dosya için projeye göre tıklanabilir markdown linki ver.
- **Doğrulama:** Kod yazdıktan sonra "Şimdi `flutter analyze` ile kontrol edebilirsin" de.