## Sözleşmeler, SOLID Prensipleri & OOP Mimarisi

### 1.1 Interface (Arayüz/sözleşme)
**Sözcük anlamı**: İki bağımsız sistemin veya sınıfın birbiri ile nasıl konuşacağını belirleyen içi boş metot imzalarından oluşan kurallar bütünüdür.
**Neden kullanılır**: Bir sınıfa göbekten bağımlı kalmamak (örneğin gerçek şarj istasyonu cihazı olmadan sahme/mock şarj servisi ile testi çalıştırabilmek) için.

```dart
abstract interface class  StationContreact{
    Future<void> startCharge({String socketId});
    Stream<double> watchLivePower(); 
}

```
---
### 1.2 `Ìmplements`vs `extends` vs `with`

#### 1.2.1 `Implements` (Arayüz sözleşmesi)
**Sözlük anlamı**: bir sınıfın, bir şablonun belirlediği kuralları kabul edip içini sıfırdan kendisini doldurması
**Neden kullanılır**: Farklı sınıflara ortak bir standart/sözleşme dayatmak, çoklu arayüz desteği sağlamak ve koda bağımlılıkları azaltmak için kullanılır

#### 1.2.2 ` extends ` (Kalıtım/Miras)
**Sözlük anlamı**: Bir sınıfın, başka bir sınıfın özelliklerini ve metotlarını doğrudan miras alması 
**Neden kullanılır**: Ortak özelliklere sahip sınıflar oluşturmak, kod tekrarını önlemek ve hiyerarşik bir yapı oluşturmak için kullanılır


#### 1.2.3 ` with ` (Mixins/yetenek aşılama)
**Sözlük anlamı**: sınıf hiyerarşisini bozmadan, bağımsız bir sınıfa hazır kod blokları(metotlar ve değişkenler) enjekte etmek mekanizmasıdır
**Neden kullanılır**: akraba olmayan sınıflara ortak yetenekler kazandırmak, çoklu kalıtım kimliğini önlemek ve modülerliği arttırmak için.

### 1.2 SOLID Prensipleri

#### 1.2.1 S-Single Responsibility Principle(Tek sorumluluk prensibi)
**kural**: Bir sınıfın veya dosyanın değişmesi için yalnızca 1 sebebi olmalıdır

#### 1.2.2 O-Open/Close Principle
**kural**: Yazılım varlıkları (sınıflar, modüller, fonksiyonlar vb.) **genişlemeye açık**, ancak **değişime kapalı** olmalıdır.


#### 1.2.3 L-Liskov Subtitution Principle(Liskovun yerine geçme prensibi)
**kural**: Bir üst sınıfın yerine, onun alt sınıflarından herhangi biri geçirildiğinde sistemin davranışı bozulmamlı ve hata fırlatmamlıdır

#### 1.2.4 I-Interface Segregation Principle
**kural**: İstemciler(sınıflar), kullanmadıkları metotları içermeye zorlanmamlıdır.Şişma(fat) interface'ler yerine küçük amaca yönelik arayüzler kurulmalıdır.

#### 1.2.5 D-Dependency Inversion Principle(Bağımlılık tersine çevirme prensibi)
**kural**: Yüksek seviyeli modüller (UI,iş mantığı), düşük seviyeli modüllere(veritabanı,HTTP istemcisi) doğrudan bağlı olmamlıdır.Her ikisi de soyutlamalara bağlı olmalıdır.

---

### 1.4 `Coupling`(Bağlaşıklık) & `Cohesion`(Uyum)
***Tightly Coupled(Sıkı bağımlı)**: Sınıfların birbirirnin her detayını bilmesi. Birinde yapılan bir harflik değişiklik diğer 5 dosyayı bozuyorsa sistem sıkı bağımlıdır
***Loosely Coupled(Gevşek Bağımlı)**: Sınıfların sadece interface üzerinden konuşması. Biri değiştiğinde diğeri etkilenmez.
***High Cohesion(Yüksek uyum)**: Bir sınıfın sadece ve sadece kendi uzmanlık alanını yapması.

---

## STREAM TEMELLERİ, CUBİT & ENTERPRISE BLOC

### 2.1 `Stream`Nedir? (Bloc'un kalbindeki Motor)
**Sözlük Anlamı**: Zaman içinde parça parça gelen, akıp giden asenkron veri dizisi.
**BLOC Sırrı**: BLOC kütüphanesi sihirli bir şey yapmaz! BLOCK içinde gizli bir `streamController` vardır.Event'ler borunun bir ucundan girer(`sink.add`),BLOC onları işler ve diğer ucundan ekrana state akıtır(`stream.listen`).


### 2.3. BLoC'un 3 Temel Elemanı: Event → State → Emitter

**Event (Olay):** Kullanıcının veya sistemin BLoC'a attığı emir fişi.

- **Mini Söz Dizimi:** `class StartChargingRequested extends ChargingEvent { final String socketId; }`

**State (Durum):** Ekranın o milisaniyedeki dondurulmuş fotoğrafı (Snapshot).

- **Mini Söz Dizimi:** `class ChargingActiveState extends ChargingState { final double kwh; }`

**Emitter (`emit`):** BLoC'un ürettiği yeni state'i ekrana fırlattığı megafon borusu.

- **Kural:** Senkron çalışır; `emit(NewState())` dendiği anda UI'daki builder'lar tetiklenir.

---

### 2.4. Altın Güvenlik Kilidi: `if (!isClosed)`

**Öğrenci Tuzağı / Çökme Sebebi:**

Kullanıcı ekrandayken asenkron işlem başlar (`await api.fetchSockets()`). Kullanıcı cevap gelmeden geri tuşuna basıp sayfayı kapatır. BLoC/Cubit yok edildiği (`closed`) için hemen ardından gelen `emit()` satırı:

`StateError: Cannot emit new states after calling close`

hatasını fırlatır ve uygulama çöker.

**Çözüm:** Asenkron `await` satırından sonraki her `emit` mutlaka şu şekilde korunmalıdır:

```dart
final data = await repository.getData();

if (!isClosed) {
  emit(DataLoaded(data));
}
```
## 3. BLOC TÜKETİCİ WIDGET'LAR & KARAR AĞACI

### 3.1. `Side Effect` (Yan Etki) Neden `BlocBuilder` İçine Yazılamaz?

- `BlocBuilder`'ın tek görevi **Widget döndürmektir**.
- Flutter motoru ekranı saniyede 60 kez çizebilir (Rebuild). Eğer siz `BlocBuilder` içine `ScaffoldMessenger.showSnackBar` veya `Navigator.push` yazarsanız; kullanıcı cihazı yan çevirdiğinde veya klavye açıldığında kullanıcıya **üst üste 10 defa SnackBar patlar veya 10 kez yeni sayfa açılır!**
- **Kural:** Yan etkiler SADECE `BlocListener` içine yazılır; çünkü `listener` sayfa rebuild olduğunda değil, **yalnızca State değiştiğinde 1 kez** tetiklenir!

### 3.2. `BlocSelector` (Mikro Performans & Pil Tasarrufu)

- **Kavram:** State'in içindeki onlarca alandan sadece **1 tanesini süzüp izlemek**.

---

## 4. EŞİTLİK, DEĞİŞMEZLİK & BLOCObserver

### 4.1. `Referential Equality` vs `Value Equality`

- **Dart Varsayılanı (Referans Eşitliği):** İki nesnenin bellekteki (RAM) adresi aynı mı?
  - `Socket('A') == Socket('A')` → **FALSE çıkar!**
  - İçerikleri aynı olsa da RAM'deki yerleri farklıdır.

- **Değer Eşitliği (Value Equality):** Nesnelerin içindeki veriler aynı mı?
  - `Equatable` paketi tam olarak bunu çözer.
  - Nesnelerin RAM adresine göre değil, `props` listesindeki alanların değerine göre karşılaştırır.

### 4.2. `props` Listesi Yazılmazsa Ne Olur?

- BLoC ekran kartını yormamak için şu denetimi yapar: `if (yeniState == eskiState) ekranıCizme();`

- Eğer siz `StationLoaded` state'ine yeni bir `filterType` alanı eklerseniz ama `props` içine yazmayı unutursanız; BLoC iki state'i eşit zanneder ve **ekran güncellemez, arayüz donuk kalır!**


### 4.3 `Immutability`  (Değişmezlik) & `copyWith` 
**Kural**: State sınıflarının tüm alanları `final` olmalıdır (Değişmez)
- **`copyWith` Mantığı:** Eski nesnenin 5 alanını koruyup, sadece değişen 1 alanını güncelleyerek taze bir nesne üretme yöntemidir.

  ```dart
  final guncel = state.copyWith(
    isCharging: true,
  ); // Diğer alanlar bozulmadan kopyalanır



  ### 4.4. `BlocObserver` (Tüm Uygulamayı Röntgenleme)

- **Kavram:** Uygulamadaki tüm BLoC ve Cubit'lerin arkasında çalışan merkezi bir kara kutu / telemetri kaydedici.

- **İşlevi:** Hangi ekranda hangi Event fırlatıldı, State nereden nereye geçti (`onTransition`) ve nerede hata fırlatıldı (`onError`) tek merkezden konsola loglanır.

- Kurumsal projelerde analitik ve çökme takibi için önemlidir.



## 5. CLEAN ARCHITECTURE KATMANLARI & SORUMLULUKLARI

### 5.1. `Entity` vs `Model / DTO`
- **`Entity` (Varlık):** Saf iş nesnesidir. Bir şarj soketinin gerçek hayattaki özelliklerini (`id`, `kW`, `durum`) tutar. `fromJson` veya `toJson` İÇERMEZ.
- **`Model / DTO` (Data Transfer Object):** API'den gelen ham JSON verisini karşılayan taşıyıcıdır. `Entity`'den türer; `fromJson` ve `toJson` metotlarını barındırır.
- **Sınıfa Zeka Sorusu:** *"Neden Entity içine `fromJson` yazmıyoruz?"*
  > **Cevap:** Yarın backend JSON yerine XML veya Protobuf formatına geçerse; Domain katmanındaki iş kurallarımız ve UI sayfalarımız zerre kadar etkilenmesin, sadece DATA katmanındaki Model etkilensin diye!



### 5.2 `UseCase` (Kullanım Senaryosu)
**Kavram**: Kullanıcının veya sistemin gerçekleştirebileceği tek ve atomik bi iş kuralı
**örnekler**:`StartChargeingSessionUseCase`, `GetStationSocketUsecase`,`"RefundWalletUseCase"`,
**kural**: Her UseCase sınıfının içinde sadece tek bir call() veya execute() metodu olmalıdır!

### 5.3 Reposştory Contract vs Repository Implementation
- **Contract (Domain Katmanında):** Sadece sözleşmedir (abstract interface class StationRepository). Verinin nereden geleceğini bilmez.
- **Implementation (Data Katmanında):** Sözleşmeyi uygulayan somut sınıftır (class StationRepositoryImpl implements StationRepository). Verinin önce yerel diskten mi yoksa internetten mi çekileceğine karar verir.


## 6.BAĞIMLILIK YÖNETİMİ: DEPENDENCY INJECTION & get_it

### 6.1 Neden new Dio() Yazmak Yasaktır?
Eğer 5 ayrı sayfada final dio = Dio(); derseniz:

1.Bellekte 5 ayrı bağlantı havuzu açılır, telefonun soket sınırını zorlar.
2.Base URL veya Timeout değiştiğinde 5 ayrı dosyayı elle değiştirmek zorunda kalırsınız.
3.Test yazarken sahte (mock) veri enjekte edemezsiniz.

### 6.2 GetIt Kayıt Tipleri: Singelton vs LazySingelton vs Factory
- **Singleton:** Uygulama açıldığı milisaniyede nesneyi üretir ve belleğe çiviler.
- **LazySingleton:** Uygulama açıldığında üretmez! Ne zaman ilk kez birisi sl<Dio>() derse o an üretir ve sonrasında hep aynı nesneyi verir. (Bellek ve açılış hızı dostudur).
- **Factory:** Her çağrıldığında yepyeni, sıfır bir kopya üretir.


## 7.KURUMSAL AĞ MİMARİSİ: DIO, INTERCEPTOR & HTTP STTAUS KODLARI
- **Sözlük Anlamı:** Ağ isteği telefondan çıkıp internete gitmeden önce veya sunucudan cevap gelip koda düşmeden önce araya girip paketi inceleyen/değiştiren güvenlik noktası.


### 7.2. `Bearer Token` & `Payload`

- **Bearer Token:** "Bu anahtarı taşıyan kişi giriş yapmaya yetkilidir" anlamına gelen kimlik doğrulama belirteci (`Authorization: Bearer eyJhbGci...`).
- **Payload:** Bir API isteğiyle sunucuya gönderilen veya sunucudan bize dönen asıl veri gövdesi (Body).

### 7.3 HTTP DURUM KODLARI SÖZLÜĞÜ (Sınıfa Tahtada Sorulcak)
200 OK: İstek başarılı, veri gövdede.
201 Created: Yeni kayıt (örneğin yeni şarj oturumu) başarıyla oluşturuldu.
400 Bad Request: İstemci hatası; eksik veya hatalı parametre gönderdin.
401 Unauthorized: Token yok veya süresi dolmuş; hemen Login'e yönlendir!
403 Forbidden: Giriş yaptın ama bu veriyi görmeye yetkin yok (Admin değilsin).
404 Not Found: Aradığın soket veya istasyon sunucuda bulunamadı.
500 Internal Server Error: Backend sunucusu patladı; istemcilik bir hata yok.


## 8. VERİ DAYANIKLILIĞI: CACHE-FIRST & SAVUNMACI KODLAMA


### 8.1. Cache-First (Önce Önbellek) Stratejisi
**Mantık**: Kullanıcı şarj istasyonu listesini açtığında 1 saniye bile beyaz ekranda spinner bekletme! Diskteki dünkü veriyi 0.01 milisaniyede ekrana bas. Arka planda sunucudan taze veriyi çek; gelince ekranı ve diski sessizce güncelle.

### 8.2. `Defensive Programming` (Savunmacı Programlama)
- **Mantık:** Sunucudan gelen veriye asla %100 güvenmeme prensibi.