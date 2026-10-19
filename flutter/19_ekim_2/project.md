# fitness Su Takip Uygulaması
Bu döküman Flutter projesinde geliştirme yapçak olan Ajan(antigravity) yapay zeka ve yazılım geliştiriciler için bağlayıcı bir klavuzdur.Prpjede üretilen her kod satırı burdaki kurallara UYMAK ZORUNDADIR.

## 1.Proje Özeti ve Teknolojiler
-**Uygulama adı:**Susadım (akıllı su egersiz ve kalori takibi uygulaması)
-**Hedef Platformlar:**İos ve android öncelikli ardından web ve masaüstü platformları
- ** Flutter SDK:**3.29.0
- ** Dart SDK:**3.0.0
- **Tasarım dili:** Material 3, Çift Tema Desteği: Koyu Tema (gece spor salonu paleti, dark obsidian & neon) ve Aydınlık Tema (ferah gündüz atletik paleti, buz beyazı & canlı okyanus);
- **Tema Yönetimi:** Flutter yerel `ValueNotifier<ThemeMode>` ile reaktif aydınlık/karanlık mod geçişi;



---

## Mimari Yapı : Özellik bazlı 
kodlar kesinlikle tek bir yerde toplanmayacaktır. Her modül kendi feature klasöründe kodlanacaktır.

```text
lib/
core/
extension'lar
      constans/app_colors.dart
      theme/app_theme.dart
    features/
       water_traker/
          controller/
          models/
          view/
          widget/
        workout/
          controller/
          models/
          view/
          widget/

    main.dart
```
#### sadece uygulama başlatma ve tema bölümleri

## 3 Kırmızı çizgiler kod kalite standartları
1 -  **State Yönetim Standartları:**
Sayfa düzeyinde ağır `setState`KULLANILMAYACAKTIR
Sadece yerel arayüz durumunu yöneten (örneğin buton animasyonları vb.) 

2 - **UI ve Performans kuralları:**
Statik tüm widget'larda `const`zorunludur
Renk ve metin stilleri kesinlikle tema dosyalarına yazılacaktır
Büyük build methodları yasaktır 40 satırı geçen build metodları özel widgetlara yazılaaktır

3 - **Yasaklı Paketler:**
Projeye onay almadan harici ağır state paketleri EKLENMEYECEKTİR
Dart'ın ve Flutter'ın yerel çekirdek apilerini kullanmak esastır.

## 4 Geliştirme analiz ve test komutları
Ajan yaptığı herhangi bir kod değişikliklerinden sonra mutlaka alttaki komutları çalıştığını doğrulamalıdır.

* **Statk kod analizi(0 uyarı ve 0 hata şart):**
```bash
flutter analyze
```
* **Birim ve widget testleri:**
```bash
flutter test 
```
* **Projeyi çalıştırma:**
```bash
flutter run
```
## 5 Ajanın çıktı ve yanıt verme standartları
 **Açıklamalar** Türkçe teknik terimlerin özünü bozmadan net ve doğrudan olcakatır
 **Değişiklik Sunumları:** Örnek 500 satırlık bir dosyada 3 satır değiştiyse tüm dosyayı baştan sona basma;hedef satırları ve diff yapısını göster
 **Dosya yollar** Bahsedilen ve üretilen her dosya için mutlaka projeye göre tıklanabilir link ver.
 **Doğrulama** Kod yazdıktan sonra kullanıcıya "Şimdi flutter analiz ile kontrol edebilirsin" şeklinde doğrulama yönergeleri ver





