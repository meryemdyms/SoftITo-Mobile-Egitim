
## const
1) Ne işe yarar: İçine girilen derleme zamanında tek bir kere yazılarak değişmez olarak üretir.
2) Neden Kullanılır: Bir widget const olarak tanımlanırsa setState olduğunda flutter bu widget'ı yeniden üretmez.CPU ve pil tasarrufu sağlar.

## final
1) Ne işe yarar:  Çalışma zamanında değeri bir kez atanan ve sonrasında referansı asla değiştirilmeyen değişkenler
** const ve final farkı: const derlenirken bilinmek zorunda (const pi=3.14) final ile çalışma anında belirlenebilir(final saat=DateTime.now())
** Model sınıflarında alanlar her zaman final olmalıdır
tanımlanır ama değer sonradan gelir kullanıcı adı gibi

## late
1) Ne işe yarar: değişken tanımlandığı an değil ilk kullanıldığında veya initState anında başlayacağı zaman kullanılır. Değişken durmadan değişir kart bakiyesi gibi


## required
1) Ne işe yarar: isimlendirilmiş parametrelerde o parametrenin(değişkenin) zorunlu olduğunu belirtir

## override
1) Ne işe yarar: Alt sınfıın üst sınıftan devraldığı metodu ezdiğini belirtir
2) faydası: eğer üst metod adını yanlış yazarsanız (örnek build yerine builds yazarsanız) derleyici @override sayesinde bunu anında hata olarak yakalar

## Null-aware operators (? ?? !)
?. -> place?.title eğer place null ise hata vermez direk null olarak döner
?? -> if null : final id=state.userId ?? 10; // id null ise 10 ata
! (null / forse)-> Bu kod derleyiciye bana güven bu değer o anda kesinlikle null değil der. eğer null gelirse uygulama anında çöker. (ÇOK DİKKATLİ KULLANILMALI)


## Spread operator (...)
1) ne işe yarar: bir listenin elemanlarını tek tek çıkartıp bulunduğu üst listenin içine ekler.Column ve ListView içinde dinamik kart dizini kullanmak için en temiz yöntemdir
...listeAdi.map((p)->_buildCard(p))


## initState
1) Ne zaman çalışır: Widget ağaca fiziksel olarak ilk başladığında yalnızca 1 kere çalışır
2) Ne yapar: ScrollController başlatmaları ve ilk api istekleri burda kurulur
Kural: İçinde doğrudan BuildContext ile Navigator çağrılmaz çünkü widget ağaca tam oturmamıştır.

## didChangeDependencies()
1) Ne zaman çalışır: initState'ten hemen sonra ve widget dinlendiği bir (örnek: Theme.of(context)) değiştiğinde otomatik tetikler
2) Ne yapar: BuildContext güvenli bir şekilde erişerek tema veya ekran boyutu bağımlılıkalrı ile ilgili ilk yüklemeler burda yapılır.

## build(BuildContext context)
1) Ne zaman çalışır: Sayfa ilk açıldığında yani setState() çağrıldığında veya üst widget'ten yeni bir inşa ağaç boyama geldiğinde saniyesinde defalarca çalışır
2) Kural: build() metodu tamamen saf olmalıdır.Asla içinde setState() api isteği ya da controller başlatma yapılmamalıdır.Sadece UI döndürür.

## dispose()
1) Ne zaman çalışır: Widget hafızadan atılmadan hemen önce son bir kez çalışır
2) Ne yapılır: _controller.dispose() stream dinleyicilerin iptalleri burada yapılır. super.dispose() mutlaka son satıra yazılır

## setState((){})
1) Arka planda ne yapar: State'in bağlı olduğu StatefulElemen nesnesine "ben değiştim,build et" sinyali yollar
2) Nerde kulalnılır: Sayfa genelini çizdirmez. Sadece onu dinleyen küçük ValueListenableBuilder'a sinyal gönderilir

## ValurNotifier<T>
1) Arka planda ne iş yapar: ChangeNotifier sınıfından türer.Belleğinde tek bir nesne referansı tutar(T _value)
2) Tetikleme: Değer atandığında (set value(T value)), eğer yeni değer eski değere eşit değilse (_value!=newValue), kayıtlı olan fonksiyonu çağırır.(addListener(){})

## InheritedWidget
1) ne yapar: Widget ağacında alttaki childların aradaki onlarca widget'ı baypass ederek , üst widgetin verisini(state'ine) doğrudan erişmesini sağlayan soyut bir widgettir


## Material 3 Tasarım Dili Renk Algoritması ve Temalar

**primary**: Ana marka rengi
**onPrimary**: Ana rengin üstüne yazılcak yazı rengi(okunabilirlik açısından)
**primaryContainer**: Ana rengin yumuşak pastel arka plan tonu
**onPrimaryContainer**: Ana rengin yumuşak pastel arkaplan tonunun üstüne yazılcak yazı 
**surface**: Sayfa arka plan tuvali
**onSurface**: Sayfa üstündeki ana metin rengi
outlineVariant: İnce sınır ve ayrım çizgilerinin rengi

ThemaMode.system: Cihazın otomatik (akşam karanlık,sabah aydınlık)
color:Colors.black.withOpacity(186) //1-255 arası değer girilmeli **Bu kullanım güncelde istenmiyor**
color:Colors.balck.withValues(alpha: 186/255) //double sayı olarak girilmelidir **güncel ve doğru yöntem**

## Arayüz Düzen ve Liste Bileşenleri

**Expanded ve Flexible**
**Expanded**: Kalan boş alanın TAMAMINI kaplamaya zorlar
**Flexible**: Kalan boş alandan kendi flex değerine oranla pay alır
**Flex**: yanyana iki expended varsa birine flex2 diğerine flex1 veriri bu sayede ekran boyutuna göre otomatik olarak ayarlar.

**Stack ve Positioned**
**Ne yapar?** : Widget'ları z ekseninde üstüste bindirir
**Positioned**: Yalnızca bir stack içinde çalışır
top:10, right:10 vererek bir resmin sağ üst köşesine bildirim rozeti eklemenizi sağlar.

**ListView.builder**:
Klasik **ListView(children:[...],)**içindeki örnek vermek gerekirse 10.000 elemanın tamamını daha sayfa açılmadan belleğe yükler ve doğal olarak telefon donar.

**ListView.builder** ise geri dönüşümlü görünüm alanı mantığını kullanarak ekranda sadece o an eğer 5 kart görünecek ise sadece 5 kartı ram belleğe yükler.Kullanıcı aşağıya kaydıkça yukarıda kalanlar bellekten düşürülüp altta kalanlar belleğe taze olarak yeni olarak üretilir



**shrinkWrap**: true
Bir ListView başka bir dikey kaydırıcının(singleChildScrollView) içine konursa eğer Vertical viewport hatası verir.
shrinkWrap: true yaparak bu çözülebilir ancak:ListView sonsuza kayma (sonsuz scroll) özelliğini kaybeder
**sadece 3 5 elemanınız varsa bunu kullanmalısınız.**


## Inkwell ve GestureDetector
GestureDetector: Tıklama çift tıklama sürükleme olaylarını yakalar ama GÖRSEL HİÇBİR TEPKİ VERMEZ
InkWell: tıklandığı an parmağın altından dışa doğru yayılan bir su dalgası efekti veriri

**ÖNEMLİ KURAL**: Inkwll'in arkasında mutlaka bir material widget olmak zorundadır. Aksi taktirde su dalgası arkadaki tuvli göremediği için hiçbir şekilde görğnmez.


## FORM MİMARİSİ

**GlobalKey<FormState>**: 
Widget içindeki form düğümüne doğrudan dışarıdan erişilemiyor.Bu yüzden widget'in en üstüne koyduğumuz globalkey değişkeni sayesinde formun validate (geçerli) durumunu ve içindeki değerleri (Değişkenleri) dışarıdan okuyoruz

_formKey.currentState?.validate() çağrıldığında o formun altındaki tüm TextFromField validator blokalrını sırayla çalıştırır

**validator**: (String ? value)
fonksiyonda bir hata bulursa geriye String olarak hata metni döndürür.
Vu metin otomatik olarak kırmızı renkte ve inputun altında belirir.
Eğer veri geçerliyse null döner.Flutter için bu alanda hata yok demektir.Null gelmesi.



## Animasyon Motoru

**AnimatedContainer**:genişlik yükseklik padding margin border renk ve gölge oynatır
**AnimatedOpacity**:görünürlüğü 0.0 ila 1.0 arasında yumuşakça soldururu
**AnimatedScale**: Widget merkezinden dışarıya doğru büyütüp küçültür
**AnimatedAlign**: Widget kututnun içinde sağdan sola yukarıdan aşağıya karşı konumunu değiştirir

## Curves
**Curves.linear**: sabit hız(robotik hareketler)
**Curves.easeInOut**: yavaş başlar ortalarda hızlanır sonra yavaşça durur
**Curves.bounceOut**: Hedefe çarptığında top gibi 2 3 kes yaylanarak seker 
**Curves.elasticOut**: Lastik gibi ileri geri titreyerek yerine oturur

## Gorouter

**context.go('/profil'/5)** : Route Yönlendirmesidir.Rota tablosunda hiyerarşiyi takip eder sayfayı temixleyebilir.

**context.push('/profil/5')** :Stack yönlendirmedir.Kullanıcı nerden gelirse gelsin mevcut sayfanın tepesine yeni bir katman ekler ve dönüş sayfası için bir geri ok butonu ekler

**context.pop()** : sayfanın en üstteki yığınını kapatır

**state.pathParametres["id"]** : Gorouter içinde tanımladığımız /:id yapılarına erişmek için kullanır

/profil?user=berat
state.uri.queryParameters["user"] : Opsiyonelik filtreleme ya da arama zamanlarında kullanılır

## Cihaz içi Yerel Depolama Mimarileri

**SharedPreferences**: 
Küçük kullanıcı ayarları 
Düşük güvenirlik
Okuma yazma hızları : Okuma hızı orta / yazma hızı yavaş


**FlutterSecureStorage**:
Şifre Token vb. saklama
En yüksek güvence
orta

**Hive/Isar**:
Yüksek performanslı nesne depolama
Orta (isteğe bağlı şifreleme açılabilir)
Aşırı hızlı



