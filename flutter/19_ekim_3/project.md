# Fitness Su Takip Uygulaması (Susadım v1)

Bu doküman, Flutter projesinde geliştirme yapacak olan Ajan (Antigravity), yapay zekâ ve yazılım geliştiriciler için bağlayıcı bir kılavuzdur. Projede üretilen her kod satırı buradaki kurallara **UYMAK ZORUNDADIR**.

---

## 1. Proje Özeti ve Teknolojiler

- **Uygulama Adı:** Susadım (akıllı su, egzersiz ve kalori takibi uygulaması)
- **Hedef Platformlar:** iOS ve Android öncelikli, ardından Web ve Masaüstü platformları
- **Flutter SDK:** 3.29.0+
- **Dart SDK:** 3.0.0+
- **Tasarım Dili:** Material 3, Çift Tema Desteği:
  - **Koyu Tema (Birincil):** Gece spor salonu paleti (Dark Obsidian & Neon Cyan / Lime)
  - **Aydınlık Tema:** Ferah gündüz atletik paleti (Buz Beyazı & Canlı Okyanus Mavisi)
- **Tema Yönetimi:** Flutter yerel `ValueNotifier<ThemeMode>` ile reaktif aydınlık/karanlık mod geçişi

---

## 2. Mimari Yapı: Özellik (Feature) Bazlı

Kodlar kesinlikle tek bir yerde toplanmayacaktır. Her modül kendi feature klasöründe kodlanacaktır.

```text
lib/
├── core/
│   ├── constants/
│   │   └── app_colors.dart
│   ├── theme/
│   │   └── app_theme.dart
│   └── extensions/
│       └── context_extensions.dart
├── features/
│   ├── water_tracker/
│   │   ├── controllers/
│   │   │   └── water_tracker_controller.dart
│   │   ├── models/
│   │   │   └── water_tracker_model.dart
│   │   ├── views/
│   │   │   └── water_tracker_view.dart
│   │   └── widgets/
│   │       └── water_tracker_widgets.dart
│   └── workout/
│       ├── controllers/
│       │   └── workout_controller.dart
│       ├── models/
│       │   └── workout_model.dart
│       ├── views/
│       │   └── workout_view.dart
│       └── widgets/
│           └── workout_widgets.dart
└── main.dart
```

> **Not:** `main.dart` dosyası sadece uygulama başlatma, temel servis başlatımları ve tema yapılandırması bölümlerini içermelidir.

---

## 3. Kırmızı Çizgiler ve Kod Kalite Standartları

1. **State Yönetim Standartları:**
   - Sayfa düzeyinde ağır `setState` **KULLANILMAYACAKTIR**.
   - State yönetimi için Flutter çekirdek yapısı olan `ValueNotifier` ve `ValueListenableBuilder` kullanılacaktır.
   - Sadece buton basım animasyonları veya yerel UI geçişleri gibi mikro durumlarda sınırlı `setState` kullanılabilir.

2. **UI ve Performans Kuralları:**
   - Statik tüm widget'larda `const` kullanımı **ZORUNLUDUR**.
   - Renk ve metin stilleri kesinlikle tema dosyalarından (`Theme.of(context)` veya `AppColors`) alınmalıdır; sabit kodlanmış (hard-coded) renkler yasaktır.
   - Büyük `build` metotları yasaktır. **40 satırı geçen** `build` metotları alt özel widget'lara parçalanmalıdır.

3. **Yasaklı Paketler:**
   - Projeye önceden onay almadan harici ağır state paketleri (Bloc, MobX, Redux vb.) **EKLENMEYECEKTİR**.
   - Dart'ın ve Flutter'ın yerel çekirdek API'lerini kullanmak esastır.

---

## 4. Geliştirme, Analiz ve Test Komutları

Geliştirici veya Ajan, yaptığı herhangi bir kod değişikliğinden sonra mutlaka aşağıdaki komutların sorunsuz çalıştığını doğrulamalıdır:

- **Statik Kod Analizi (0 uyarı ve 0 hata şartı):**
  ```bash
  flutter analyze
  ```
- **Birim ve Widget Testleri:**
  ```bash
  flutter test
  ```
- **Projeyi Çalıştırma:**
  ```bash
  flutter run
  ```

---

## 5. Ajanın Çıktı ve Yanıt Verme Standartları

- **Açıklamalar:** Türkçe teknik terimlerin özünü bozmadan net ve doğrudan olacaktır.
- **Değişiklik Sunumları:** Örneğin 500 satırlık bir dosyada 3 satır değiştiyse tüm dosyayı baştan sona basma; hedef satırları ve diff yapısını göster.
- **Dosya Yolları:** Bahsedilen ve üretilen her dosya için mutlaka projeye göre tıklanabilir markdown linki ver (`file:///...`).
- **Doğrulama:** Kod yazdıktan sonra kullanıcıya "Şimdi `flutter analyze` ile kontrol edebilirsin" şeklinde doğrulama yönergeleri ver.
