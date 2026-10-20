
---
name: project-orchestrator
description: >
  Araç kiralama uygulamasındaki tüm geliştirme,
  düzenleme, hata düzeltme, refactoring, mimari
  değerlendirme ve yeni özellik işlemlerinde kullan.
  Projenin ana koordinasyon skill'idir.
---

# PROJECT ORCHESTRATOR

## 1. Amaç

Bu skill, araç kiralama platformunun bütün geliştirme
sürecini yönetmek için oluşturulmuştur.

Agent'ın görevi yalnızca çalışan kod üretmek değildir.

Aynı zamanda:

- Mevcut proje mimarisini korumak
- Kod tekrarını engellemek
- Feature-first MVVM yapısını sürdürmek
- İlgili skill dosyalarını doğru kullanmak
- Müşteri ve firma rollerini birbirinden ayırmak
- Modüler ve sürdürülebilir kod geliştirmek
- Ortak UI bileşenlerini yeniden kullanmak
- Gerekli testleri gerçekleştirmek
- Kullanıcının belirlediği kapsamın dışına çıkmamak

zorundadır.

## 2. Temel Kural

Her geliştirme görevinde aşağıdaki dosyalar
öncelikli olarak incelenmelidir:

1. project.md
2. AGENTS.md
3. project-orchestrator/SKILL.md
4. Görevle ilgili diğer SKILL.md dosyaları

Öncelik sırası:

Kullanıcının güncel talimatları
→ project.md
→ AGENTS.md
→ ilgili SKILL.md dosyaları

Belgeler arasında çelişki varsa agent bunu
bildirmeli, mimariyi sessizce değiştirmemelidir.

## 3. Göreve Başlamadan Önce

Agent doğrudan kod yazmaya başlamamalıdır.

Önce mevcut projeyi incelemelidir.

Kontrol edilecekler:

- Mevcut klasör yapısı
- İlgili feature
- Var olan modeller
- Controller / ViewModel yapısı
- Repository ve servisler
- Ortak widget'lar
- Tema ve tasarım sistemi
- Router yapısı
- Provider bağımlılıkları
- İlgili testler

Mevcut bir yapı varsa sıfırdan oluşturmak yerine
onu kullanmalı veya geliştirmelidir.

## 4. Mimari Kurallar

Proje Feature-first MVVM mimarisi kullanır.

Standart feature yapısı:

lib/features/<feature_name>/
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

Her feature yalnızca ihtiyaç duyduğu dosyaları
içermelidir.

Boş veya gereksiz dosyalar oluşturulmaz.

Katmanların görevleri:

VIEW:
- Kullanıcı arayüzünü oluşturur.
- Kullanıcı etkileşimlerini controller'a iletir.
- İş mantığı içermez.

CONTROLLER:
- ChangeNotifier kullanır.
- Ekran durumunu yönetir.
- Repository veya use case çağırır.
- UI durum değişikliklerini bildirir.

DOMAIN:
- Entity ve iş kurallarını içerir.
- Framework bağımlılığı minimumdur.
- Repository sözleşmelerini tanımlar.

DATA:
- Repository implementasyonlarını içerir.
- Mock ve yerel veriyi yönetir.
- Verilerin dönüşümünden sorumludur.

## 5. Rol Yönetimi

Uygulamada iki temel kullanıcı profili vardır:

CUSTOMER
COMPANY

Misafir kullanıcı oturumsuz durumdur.

Kurallar:

- Müşteri ve firma panelleri ayrı tutulur.
- Ortak bileşenler yeniden kullanılabilir.
- Firma yalnızca kendi verilerini yönetebilir.
- Müşteri yalnızca kendi rezervasyonlarını yönetebilir.
- Misafir araçları inceleyebilir.
- Rezervasyon oluşturmak için müşteri girişi gereklidir.
- Yetki kontrolü sadece UI seviyesinde yapılmaz.
- Repository seviyesinde sahiplik kontrolü zorunludur.

Rol bazlı yönlendirmede routing-and-navigation
ve roles-and-auth skill'leri kullanılır.

## 6. Widget Yönetimi

Bir widget geliştirilmeden önce mevcut
widget'lar kontrol edilmelidir.

Widget yerleşim kuralları:

Genel UI bileşenleri:
lib/core/widgets/

Feature'a özgü bileşenler:
lib/features/<feature>/presentation/widgets/

Kurallar:

- Aynı widget tekrar tekrar oluşturulmaz.
- Genel widget'lar domain'e bağımlı olmaz.
- Sayfalar küçük, anlaşılır widget'lara ayrılır.
- Gereksiz widget soyutlamaları yapılmaz.
- Material Design 3 sistemi korunur.
- Renkler merkezi tema üzerinden kullanılır.

## 7. State Management

State management olarak Provider + ChangeNotifier
kullanılır.

Kurallar:

- Ekran state'i controller tarafından yönetilir.
- Widget içerisinde veri erişimi yapılmaz.
- Asenkron işlemler controller veya ilgili katmanda yürütülür.
- Loading, success, empty ve error durumları ele alınır.
- notifyListeners() yalnızca gerekli durumlarda çağrılır.
- Controller yaşam döngüsü doğru yönetilir.
- Aynı amaçla ikinci bir state management sistemi eklenmez.

## 8. Yeni Feature Oluşturma

Yeni özellik istenirse:

1. Var olan feature'lar incelenir.
2. Yeni feature gerekip gerekmediği belirlenir.
3. İlgili skill dosyaları okunur.
4. Domain modelleri ve iş kuralları belirlenir.
5. Repository sözleşmeleri oluşturulur.
6. Gerekli data implementasyonları eklenir.
7. Controller oluşturulur.
8. View ve widget'lar geliştirilir.
9. Router ve Provider bağlantıları yapılır.
10. Testler yazılır ve çalıştırılır.

Yeni feature oluşturulurken
architecture-and-scaffold ve feature-delivery
skill'leri uygulanır.

## 9. Mevcut Feature Düzenleme

Var olan ekran veya özellik değiştirilirken:

- Yeni feature oluşturulmaz.
- İlgili dosyalar incelenir.
- Mevcut kod korunarak düzenlenir.
- Gereksiz refactoring yapılmaz.
- Başka özelliklerin davranışı değiştirilmez.
- Gerekirse mevcut testler güncellenir.
- Değişiklik sonrası regresyon kontrol edilir.

## 10. Form ve Etkileşim Kuralları

Bütün formlar:

- Validasyon içermeli
- Hata mesajlarını göstermeli
- Loading durumunu yönetmeli
- Tekrarlı gönderimi engellemeli
- Kullanıcı girdilerini korumalı
- Uygun klavye türünü kullanmalı
- Gerekli durumlarda onay diyaloğu göstermeli

Form işlemlerinde forms-and-validation
skill'i kullanılmalıdır.

## 11. Tema ve Tasarım

Uygulama Material Design 3 kullanır.

Temel renk ailesi:

Primary: #2563EB
Dark: #0B1220
Background: #F8FAFC
Surface: #FFFFFF
Muted: #64748B

Bu renkler widget içerisinde sabit yazılmaz.

Merkezi tema sistemi kullanılır.

Tasarım ilkeleri:

- Modern
- Minimal fakat karakterli
- Profesyonel
- Tutarlı
- Erişilebilir
- Responsive
- Kullanımı kolay

Her UI geliştirmesinde ui-design-system
skill'i dikkate alınır.

## 12. Kod Kalitesi

Agent aşağıdaki kurallara uymalıdır:

- Dart isimlendirme standartları
- Gerektiğinde const constructor
- Küçük ve tek sorumluluklu sınıflar
- Tekrarsız kod
- Açık ve anlaşılır değişken isimleri
- Gereksiz bağımlılık eklememe
- Widget build içerisinde asenkron işlem yapmama
- Controller ve stream dispose işlemlerini yönetme
- Hataları kullanıcıya anlaşılır biçimde gösterme
- Hassas bilgileri loglamama

## 13. Test ve Kontrol

Her geliştirmeden sonra mümkünse:

dart format .
flutter analyze
flutter test

komutları çalıştırılır.

Yeni iş kuralları için unit test,
ekran davranışları için widget test yazılır.

Başarısız testler gizlenmez.

Agent tamamlanmamış bir işlemi
tamamlandı olarak bildiremez.

## 14. Yasaklanan Davranışlar

Agent:

- Kullanıcı onayı olmadan mimariyi değiştiremez.
- Gereksiz paket ekleyemez.
- Mevcut çalışan kodu sebepsiz silemez.
- Başka feature'ın iç katmanlarına doğrudan bağımlılık kuramaz.
- UI içerisine veri erişimi taşıyamaz.
- Aynı widget'ı gereksiz yere çoğaltamaz.
- Kendi kararıyla yeni kullanıcı rolü ekleyemez.
- Mock sistemi gerçek backend gibi sunamaz.
- Gerçek kişisel verileri güvensiz biçimde kaydedemez.
- Testleri çalıştırmadan çalıştırılmış gibi raporlayamaz.

## 15. Görev Sonu Raporu

Agent her görev sonunda şunları bildirmelidir:

1. Yapılan işlem
2. Oluşturulan dosyalar
3. Değiştirilen dosyalar
4. Kullanılan skill'ler
5. Test ve analiz sonuçları
6. Bilinen eksikler
7. Varsa kullanıcı kararı gerektiren konular

## 16. Ana İlke

Öncelik en kısa kodu yazmak değil,
en doğru ve sürdürülebilir yapıyı oluşturmaktır.

Her feature bağımsız geliştirilebilir,
test edilebilir ve gerektiğinde değiştirilebilir
olmalıdır.

Agent mevcut proje bütünlüğünü korumaktan
sorumludur.
