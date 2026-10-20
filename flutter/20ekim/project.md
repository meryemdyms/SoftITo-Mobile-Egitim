
# Araç Kiralama Platformu — Proje Anayasası

> Bu belge projenin tek yetkili ürün ve mimari kaynağıdır. Tüm skill'ler buna tabidir. Karar değişikliği için önce bu dosya güncellenir; agent kapsam dışı kararları kendiliğinden değiştiremez.

## 1. Amaç ve kapsam
- Flutter ile öncelikli iOS + Android uygulaması. Tek firmaya ait olmayan, çoklu araç kiralama firmalarını müşterilerle buluşturan platform.
- Roller: **guest**, **customer**, **company**. Gelecekte **admin** rolü genişletilebilecek; ilk sürümde admin arayüzü yok.
- İlk sürüm **offline/local demo**: sunucu, gerçek ödeme, SMS/e-posta doğrulaması ve gerçek kişilerle çok cihazlı veri senkronizasyonu **yok**.
- Misafir araç, firma vitrini, kampanya ve haritaya bakabilir. Rezervasyon için müşteri oturumu zorunlu.
- Ödeme tipi: **firmada ödeme** (simüle edilen akış, gerçek tahsilat yok).
- Başlangıç dili Türkçe; metinler merkezî yerelleştirmeye uygun yapılandırılır.

## 2. Sabit teknoloji ve mimari kararlar
- **Feature-first MVVM**: `features/<feature>/data`, `domain`, `presentation` alt katmanları; `presentation/controllers` içinde `ChangeNotifier` controller/ViewModel.
- **Provider / ChangeNotifier** state management; aynı işi yapan ikinci state management paketi kullanılmaz.
- Navigation: `go_router`; rol ve session guard'ları merkezî router'da.
- Tema: Material 3, merkezi `ColorScheme`, `ThemeData`, design token ve reusable widgets.
- Veri: repository arayüzleri domain'de, local implementation data'da. Data source mock + yerel kalıcılık; ilk adımda in-memory mock, kalıcılık eklenecekse seçilen tek adapter üzerinden.
- Modeller: `Vehicle` tek araç/ilan varlığıdır (ayrı `Listing` entity oluşturulmaz). Domain entity'ler immutable.
- Rezervasyon: müsaitlik uygunsa **otomatik confirmed**. Başarılı oluşturma atomik olmalı (tek cihaz yerel işlem sınırında). Başka cihazla çakışmasız işlem **garanti edilmez**.
- Klasörler feature temelli; bir feature başka feature'ın `data` veya `presentation` iç detaylarını doğrudan import etmez. Paylaşılan sözleşmeler domain/service arayüzleri üzerinden.

## 3. Mimarinin standart klasör yapısı
```text
lib/
  main.dart
  app/
    app.dart
    router/app_router.dart
    theme/{app_theme,app_colors,app_spacing,app_typography}.dart
    di/app_providers.dart
  core/
    constants/
    enums/
    errors/
    utils/
    services/             # konum, yerel oturum, saat, kimlik saklama arayüzleri
    widgets/              # yalnızca gerçekten genel UI
  features/
    auth/
      domain/{entities,repositories,usecases}/
      data/{models,datasources,repositories}/
      presentation/{controllers,views,widgets}/
    customer_profile/
      domain/{entities,repositories,usecases}/
      data/{models,datasources,repositories}/
      presentation/{controllers,views,widgets}/
    companies/
      domain/{entities,repositories,usecases}/
      data/{models,datasources,repositories}/
      presentation/{controllers,views,widgets}/
    vehicles/
      domain/{entities,repositories,usecases}/
      data/{models,datasources,repositories}/
      presentation/{controllers,views,widgets}/
    search/
      domain/{entities,repositories,usecases}/
      data/{models,datasources,repositories}/
      presentation/{controllers,views,widgets}/
    bookings/
      domain/{entities,repositories,usecases}/
      data/{models,datasources,repositories}/
      presentation/{controllers,views,widgets}/
    campaigns/
      domain/{entities,repositories,usecases}/
      data/{models,datasources,repositories}/
      presentation/{controllers,views,widgets}/
    map_discovery/
      domain/{entities,repositories,usecases}/
      data/{models,datasources,repositories}/
      presentation/{controllers,views,widgets}/
    customer_shell/presentation/{controllers,views,widgets}/
    company_dashboard/presentation/{controllers,views,widgets}/
  l10n/
  test/{unit,widget,integration}/
assets/{images,icons,mock}/
.agents/skills/<skill-name>/SKILL.md
AGENTS.md
project.md
```

Yalnızca ihtiyacı olan klasör/dosyalar oluşturulur; her feature'a boş usecase veya repository klasörü zorunlu değildir. UI widget birden çok feature tarafından kullanılıyorsa `core/widgets` ancak domain bağımlılığı yoksa; domain'e özel paylaşımlar ilgili feature'ın presentation/widgets'ında kalır.

## 4. Domain ve akışlar
- `User`: id, role (`customer|company`), name, email, phone. Misafir = oturumsuz durum; `guest` kullanıcı kaydı değildir.
- `CustomerProfile`: userId, birthDate, drivingLicenceNumber, class, issueDate (demo/test verisi; gerçek kişisel veri kaydetme).
- `Company`: id, ownerUserId, name, logo, description, address, latitude, longitude, openingHours, phone, active.
- `Vehicle`: id, companyId, brand, model, year, transmission, fuel, seats, dailyRate, images, pickupLocation, isActive, blockedPeriods, minDriverAge, minLicenceYears.
- `Reservation`: id, vehicleId, companyId, customerId, startAt, endAt, pickupLocation, returnLocation, dayCount, basePrice, discountAmount, totalPrice, appliedCampaignId?, status, createdAt.
- `Campaign`: id, companyId, title, description, discountPercent, validFrom, validTo, eligibleVehicleIds? (boş/null ise firma araçları); aktiflik ve uygunluk ayrı kontrol edilir.
- Tarih-saat değerleri tek ve tutarlı formatta işlenir, zaman dilimi sınırları açıkça belirtilir. Parasal hesaplar tamsayı kuruş üzerinden yapılır (`int`), UI'da ₺ olarak formatlanır; `double` para için kullanılmaz.

## 5. İş kuralları
1. Anasayfada alış konumu, iade konumu, başlangıç/bitiş tarih-saat formu bulunur. Başlangıç gelecekte ve bitiş başlangıçtan sonra olmalı.
2. Arama sonuçları tarih ve konuma uygun *aktif* araçları gösterir; filtre: fiyat, vites, yakıt, firma; sıralama: fiyat ve uygun diğer seçenekler.
3. Araç kartında firma ismi ve günlük fiyat açıkça gösterilir; firma vitrinine gidilebilir.
4. Üyelik olmadan keşif serbest; kirala aksiyonunda login'e yönlenip ardından **kaldığı bağlama** dönülür.
5. Rezervasyon için müşteri profili ve yaş/ehliyet koşulları doğrulanır. Bitiş sınırı dışlayıcı aralıktır `[start, end)`; iki aralık `newStart < oldEnd && newEnd > oldStart` ise çakışır. `cancelled` rezervasyonlar müsaitliği kapatmaz; `confirmed`, `active` kapatır. Bloklu dönemler ayrıca denetlenir.
6. Ücret = `ceil(toplam_saat / 24)` * günlük ücret; en az 1 gün. Kampanya uygun ise indirim tek kez uygulanır; negatif toplam olmaz; indirim ve uygulanan kampanya rezervasyona snapshot olarak yazılır.
7. İlk sürüm statüleri: `confirmed -> active -> completed`, ayrıca `confirmed -> cancelled` ve `active -> cancelled` **yok** (aktif iptali manuel operasyon/gelecek sürüm). Geçersiz geçiş reddedilir. Müşteri yalnızca confirmed durumunda iptal edebilir. Firma confirmed'i iptal edebilir, active'i completed yapabilir.
8. Müşteri yalnızca kendi rezervasyonlarını, firma yalnızca kendi araç/rezervasyon/kampanya/profilini görüp yönetebilir. UI kontrolü yanında repository seviyesinde de role/ownership kontrolü vardır.
9. Firma aracı ekleyip düzenleyebilir, pasife alabilir, müsait olmayan aralıkları kapatabilir. Başka firmaya ait araç yönetilemez.
10. Haritada konum izni isteğe bağlıdır; izin verilmezse manuel şehir/konum seçimi ve harita keşfi devam eder.

## 6. Ekran sınırları
- **Guest/customer shell**: Home/Search, Results, Vehicle Details, Company Storefront, Campaigns, Map, Auth, Profile, My Bookings.
- **Company shell**: Dashboard (teslim/iade ve özet), Vehicle Management, Reservation Management, Campaign Management, Company Profile Editor.
- Firma hesabı müşteri işlemi yapamaz; yeni rol eklemek ileride ayrı karar gerektirir.
- Firma kaydı demo ortamında anında kullanılabilir; gerçek firma doğrulama/onay admin + backend aşamasında.

## 7. UX / UI tasarım sözleşmesi
- Material 3: marka yönü rafine, modern, klişe olmayan. Renk ailesi başlangıcı `#2563EB` (accent), `#0B1220` (ink), `#F8FAFC` (canvas), `#FFFFFF` (surface), `#64748B` (muted). Bunlar token'lardan okunur; UI'da hardcode edilmez.
- Buton, input, modal, date/time picker, field error, toast/snackbar, loading, empty state, skeleton, cards ve responsive boşluklar ortak API ile.
- En az 44–48 logical px dokunma alanı, semantik etiket, klavye ve ekran okuyucu desteği. Hata mesajları Türkçe ve işlem yapılabilir olmalı.
- Görseller varsayılan olarak asset/mock, resim URL'sine çevrim içi bağımlılık yok.

## 8. Güvenlik, sınırlamalar ve kalite kapıları
- Gerçek şifre/ehliyet/kimlik bilgisi local düz metin saklanmaz. Auth ilk sürümde **demo kimlik doğrulama** olarak açıkça etiketlenir ve yalnızca sahte hesaplar kullanılabilir. Üretim güvenliği iddia edilmez.
- Konsol loglarına şifre veya ehliyet bilgisi yazılmaz. Demo veri kaybı/sıfırlama olasılığı UI'da açık olur.
- Değişiklikler küçük ve kapsamlı; her özellikte success/loading/empty/error, rol sınırları ve temel testler gözden geçirilir.
- Değişiklikten sonra mümkünse `dart format .`, `flutter analyze`, ilgili `flutter test` çalıştırılır. Çalıştırılamazsa neden raporlanır.
- Agent dış API, ücretli servis, dependency, izin, kullanıcı verisi, yeni rol veya ürün kapsamı eklemeden önce **karar gerektirir**; karar verilene kadar mock/abstraction kullanır.

## 9. Sıralama
1. Bootstrap, tema, router, DI, role/session shell, ortak UI.
2. Auth/demo profil ve giriş sonrası geri dönüş.
3. Firma ve araç mock/repository; müşteri arama/list/detail.
4. Rezervasyon kuralları ve testler.
5. Firma dashboard + CRUD + rezervasyon yaşam döngüsü.
6. Kampanyalar ve fiyat snapshot.
7. Harita/konum ve izin fallback.
8. Erişilebilirlik, validation, edge-case, test, cilalama.
9. Sonraki sürüm: backend, çok cihazlı gerçek rezervasyon atomikliği, güvenli auth, ödeme, bildirim, değerlendirme, firma onayı.

## 10. Skill yönlendirme
Agent her iş için `AGENTS.md` ve ilgili `.agents/skills/*/SKILL.md` dosyalarını okur. Bir özelliğin birden fazla konuyu etkilemesi halinde ilgili tüm skill'ler birlikte uygulanır. Kapsamdan sapma/çelişki ortaya çıkarsa kodlamadan önce kararı ve alternatifi raporlar.
