
# Agent Çalışma Kuralları

Bu dosya, Araç Kiralama Platformu üzerinde çalışan
tüm AI agent'ların uyması gereken kuralları tanımlar.

Proje Flutter, Feature-first MVVM ve
Provider (ChangeNotifier) mimarisi kullanır.

Agent mevcut mimariyi, ürün kapsamını ve
tasarım sistemini korumakla yükümlüdür.

---

## 1. Zorunlu Dosya Okuma Sırası

Her geliştirme görevinden önce aşağıdaki dosyalar
sırasıyla okunmalıdır:

1. `project.md`
2. `AGENTS.md`
3. `.agents/skills/SKILL.md`
4. Görevle ilgili diğer `SKILL.md` dosyaları

Ana `SKILL.md` bütün görevlerde zorunludur.

Alt skill'ler yalnızca kendi kullanım alanlarına
uygun görevlerde çalıştırılır.

Bir görev birden fazla skill gerektirebilir.

Skill dosyaları kendi YAML `description`
alanlarına göre seçilir.

Hiçbir skill, `project.md` içerisindeki
temel mimari kararları geçersiz kılamaz.

---

## 2. Talimat Önceliği

Talimatların öncelik sırası:

1. Kullanıcının güncel isteği
2. `project.md`
3. `AGENTS.md`
4. `.agents/skills/SKILL.md`
5. Görevle ilgili alt skill dosyaları

Belgeler arasında çelişki varsa:

- Çelişki tespit edilir.
- Kullanıcıya bildirilir.
- Mimari sessizce değiştirilmez.
- Kalıcı karar değişikliği onay gerektirir.

---

## 3. Göreve Başlamadan Önce

Agent doğrudan kod yazmaya başlamamalıdır.

Öncelikle:

1. Kullanıcının isteğini analiz eder.
2. Mevcut proje dosyalarını inceler.
3. Etkilenen feature'ları belirler.
4. Mevcut controller, model ve repository'leri kontrol eder.
5. Kullanılabilecek ortak widget'ları araştırır.
6. İlgili skill dosyalarını okur.
7. Gerekli değişiklikleri planlar.
8. Ardından geliştirmeye başlar.

Küçük ve açık görevlerde plan kısa tutulabilir.

Mevcut bir çözüm varsa aynı işi yapan yeni
bir yapı oluşturulmaz.

---

## 4. Mimari Kurallar

Proje Feature-first MVVM mimarisini kullanır.

Standart feature organizasyonu:

lib/
  features/
    feature_name/
      domain/
        entities/
        repositories/
        usecases/

      data/
        models/
        datasources/
        repositories/

      presentation/
        controllers/
        views/
        widgets/

Katman sorumlulukları:

### View
- Kullanıcı arayüzünü oluşturur.
- Kullanıcı etkileşimlerini controller'a iletir.
- Repository'ye doğrudan erişmez.
- İş mantığı içermez.

### Controller / ViewModel
- ChangeNotifier kullanır.
- Ekran durumunu yönetir.
- Repository veya use case üzerinden işlem yapar.
- Loading, success, empty ve error durumlarını yönetir.
- Gerektiğinde notifyListeners() çağırır.

### Domain
- Entity ve iş kurallarını içerir.
- Repository arayüzlerini tanımlar.
- Flutter UI katmanından bağımsızdır.

### Data
- Repository implementasyonlarını içerir.
- Mock ve yerel veri kaynaklarını yönetir.
- Veri dönüşümlerini gerçekleştirir.

Basit CRUD işlemlerinde gereksiz use case
oluşturulması zorunlu değildir.

---

## 5. Feature Sınırları

Her özellik kendi feature klasöründe geliştirilir.

Kurallar:

- Feature'lar birbirinin presentation katmanını
  doğrudan kullanmaz.
- Feature'lar birbirinin data implementasyonuna
  doğrudan bağımlı olmaz.
- Ortak iş kuralları uygun domain sözleşmeleri
  üzerinden paylaşılır.
- Tekrar kullanılabilir genel UI bileşenleri
  `core/widgets/` içerisinde tutulur.
- Feature'a özgü widget'lar ilgili feature'ın
  `presentation/widgets/` klasöründe bulunur.

Gereksiz abstraction ve klasör oluşturulmaz.

---

## 6. Rol ve Yetkilendirme

Uygulamada iki hesap rolü vardır:

- customer
- company

Misafir kullanıcı oturumsuz durumdur.

Kurallar:

- Müşteri ve firma panelleri ayrıdır.
- Misafirler araçları ve firmaları inceleyebilir.
- Rezervasyon için müşteri girişi gerekir.
- Firma yalnızca kendi araçlarını, kampanyalarını,
  rezervasyonlarını ve profilini yönetebilir.
- Müşteri yalnızca kendi rezervasyonlarını yönetebilir.
- Yetki kontrolü yalnızca UI seviyesinde yapılmaz.
- Repository seviyesinde sahiplik kontrolü uygulanır.

Rol bazlı yönlendirmelerde
`roles-and-auth` ve `routing-and-navigation`
skill'leri birlikte kullanılır.

---

## 7. UI ve Tema Yönetimi

Uygulama Material Design 3 kullanır.

Tüm ekranlar merkezi tema sistemine uymalıdır.

Temel kurallar:

- Renkler tema üzerinden alınır.
- Sabit renk değerleri ekranlarda kullanılmaz.
- Ortak buton ve input bileşenleri tercih edilir.
- Formlar validasyon içerir.
- Loading, empty, error ve success durumları yönetilir.
- Dialog ve Snackbar kullanımları tutarlı olmalıdır.
- Responsive ve erişilebilir tasarım uygulanır.
- Kullanıcı etkileşimlerine görsel geri bildirim verilir.

UI geliştirmelerinde `ui-design-system` ve
gerektiğinde `forms-and-validation` kullanılır.

---

## 8. Veri ve Repository Kuralları

İlk sürümde gerçek backend bulunmaz.

Veri mock ve yerel veri kaynaklarından sağlanır.

Kurallar:

- View doğrudan veri kaynağına erişmez.
- Repository arayüzleri domain katmanındadır.
- Repository implementasyonları data katmanındadır.
- Modeller `project.md` ile uyumlu olmalıdır.
- Yeni veri saklama paketi kullanıcı onayı
  olmadan eklenmez.
- Gerçek şifre, ehliyet veya kimlik bilgileri
  güvensiz şekilde saklanmaz.
- Backend varmış gibi güvenlik garantisi verilmez.

---

## 9. Yeni Feature Geliştirme

Yeni bir özellik istendiğinde:

1. Mevcut feature'lar incelenir.
2. Yeni feature gerekip gerekmediği belirlenir.
3. İlgili alt skill'ler okunur.
4. Domain modelleri ve iş kuralları hazırlanır.
5. Repository sözleşmeleri oluşturulur.
6. Data implementasyonları geliştirilir.
7. Controller oluşturulur.
8. View ve widget'lar hazırlanır.
9. Router ve Provider kayıtları yapılır.
10. Gerekli testler yazılır.

Yeni feature için:

- `architecture-and-scaffold`
- `feature-delivery`

skill'leri uygulanır.

Özelliğin türüne göre diğer skill'ler de kullanılır.

---

## 10. Mevcut Özellikleri Düzenleme

Var olan ekran veya özellik güncellenirken:

- Gereksiz yeni feature oluşturulmaz.
- Mevcut mimari korunur.
- Çalışan kod sebepsiz silinmez.
- Kapsam dışındaki dosyalar değiştirilmez.
- Gereksiz refactoring yapılmaz.
- Mevcut ortak bileşenler yeniden kullanılır.
- Etkilenen testler güncellenir.

---

## 11. Kod Standartları

Agent aşağıdaki Dart/Flutter standartlarını uygular:

- Dosya isimleri snake_case
- Sınıf isimleri PascalCase
- Değişken/metot isimleri camelCase
- Uygun yerlerde const kullanımı
- Tek sorumluluk prensibi
- Anlaşılır ve modüler kod
- Gereksiz bağımlılıklardan kaçınma
- Build içinde asenkron veri işlemi yapmama
- Controller yaşam döngüsünü doğru yönetme
- Hassas verileri loglamama

Ayrıntılı kurallar için:

`code-style-and-review`

skill'i kullanılır.

---

## 12. Agent Yetki Sınırları

Agent kullanıcı onayı olmadan:

- Mimari yaklaşımı değiştiremez.
- State management sistemini değiştiremez.
- Yeni backend teknolojisi seçemez.
- Yeni bağımlılık veya ücretli servis ekleyemez.
- Kullanıcı rollerini değiştiremez.
- Rezervasyon iş kurallarını değiştiremez.
- Tema sistemini yeniden tasarlayamaz.
- Geniş çaplı refactoring yapamaz.
- Çalışan özellikleri kaldıramaz.
- Proje kapsamını genişletemez.

Kullanıcının açıkça istediği görevler
bu sınırlar içinde uygulanır.

---

## 13. Test ve Kalite Kontrol

Her geliştirme sonrasında uygun kontroller yapılır.

Temel komutlar:

```bash
dart format .
flutter analyze
flutter test
```

Kontrol edilecekler:

- Derleme hataları
- Analiz uyarıları
- Bozuk importlar
- Eksik Provider kayıtları
- Eksik router bağlantıları
- Widget lifecycle hataları
- İş mantığı regresyonları
- Rol ve yetki ihlalleri

Testler çalıştırılamıyorsa nedeni raporlanır.

Tamamlanmamış işlem tamamlandı olarak gösterilmez.

---

## 14. Görev Sonu Raporu

Her görev sonunda agent şu bilgileri paylaşır:

1. Yapılan işlemler
2. Oluşturulan dosyalar
3. Güncellenen dosyalar
4. Kullanılan skill'ler
5. Test ve analiz sonuçları
6. Bilinen eksikler
7. Kullanıcı kararı gerektiren konular

Basit görevlerde rapor kısa tutulabilir.

---

## 15. Skill Kataloğu

### Ana Skill

`SKILL.md`
- Her görevde zorunlu
- Genel proje koordinasyonu
- Mimari ve geliştirme kontrolü
- Skill seçimi
- Kalite ve görev sonu denetimi

Konum:
`.agents/skills/SKILL.md`

### Mimari ve Geliştirme

`architecture-and-scaffold`
- Yeni feature veya modül
- Klasör ve katman organizasyonu
- Mimari bağımlılıklar

`code-style-and-review`
- Kod standartları
- Refactoring
- Performans
- Code review

`feature-delivery`
- Uçtan uca yeni özellik geliştirme
- Feature entegrasyonu
- Kabul kriterleri

`data-and-repository`
- Model ve entity
- Repository
- Mock veri
- Yerel saklama
- Dependency injection

`testing-and-quality`
- Unit test
- Widget test
- Integration test
- Regresyon ve analiz

### Kullanıcı ve Firma

`roles-and-auth`
- Kullanıcı kaydı
- Giriş ve çıkış
- Misafir akışı
- Rol ve yetkilendirme

`routing-and-navigation`
- go_router
- Route guard
- Shell navigasyonu
- Giriş sonrası geri dönüş

`customer-experience`
- Müşteri ana sayfası
- Arama ve filtreler
- Araç detayları
- Profil ve rezervasyonlar

`company-panel`
- Firma dashboard
- Araç yönetimi
- Rezervasyon yönetimi
- Firma vitrini

`security-and-privacy`
- Demo güvenliği
- Hassas veriler
- Yetki kontrolleri
- KVKK hazırlığı

### Uygulama Özellikleri

`booking-logic`
- Rezervasyon
- Müsaitlik kontrolü
- Tarih çakışması
- Rezervasyon durumları

`campaigns-and-pricing`
- Kampanyalar
- İndirim hesaplama
- Fiyatlandırma

`maps-and-location`
- Harita
- Kullanıcı konumu
- Yakındaki firmalar
- Konum izinleri

### UI ve Etkileşimler

`ui-design-system`
- Material Design 3
- Tema ve renkler
- Ortak widget'lar
- Responsive tasarım

`forms-and-validation`
- Form yönetimi
- Input validasyonu
- Dialog
- Snackbar
- Kullanıcı etkileşimleri

---

## 16. Ana Prensip

Bu projede öncelik yalnızca çalışan kod
üretmek değildir.

Hedef:

- Modüler
- Test edilebilir
- Sürdürülebilir
- Ölçeklenebilir
- Anlaşılır
- Tutarlı

bir Flutter uygulaması geliştirmektir.

Her geliştirme mevcut proje bütünlüğünü
korumalıdır.

Agent, kullanıcı tarafından belirlenen
mimari ve ürün kararlarına bağlı kalmalıdır.
