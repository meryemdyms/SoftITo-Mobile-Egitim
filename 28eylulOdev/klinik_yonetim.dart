//1.Enumları (derleme Zamanı güvenliği)
//Enum, sabit ve sınırlı bir değer kümesini tek bir tip altında toplar.
//Burda sınırlı ve belirli durum kısmı kilit
//Eğer string olarak atasaydık ve bir hata olduğunda çalışma zamanında öğrenirdik enum ile derleme zamanında direk hatayı alıp düzeltebiliyoruz
//derleme zamanı güvenliği ile kastedilen budur.
//enum adı büyük harfle başlar, değerler küçük harfle başlar
//.name ile enum değerinin adınısı string olarak verir
enum HizmetKategorisi 
{ 
  ciltYenileme, 
  medikalEstetik, 
  lazerEpilasyon,
  lipo
}

enum SeansDurumu
{ 
 bekliyor, 
 odadaIslemde, 
 tamamlandi,
 iptalEdildi 
}

enum OdemeYontemi 
{ 
  krediKarti,
  havaleEft,
  nakit,
  klinikPaketKredisi
}

//Danışan (müşteri) Modeli
class Danisan {
  //danisan modelimize ait değişkenleri tanımladık
  //final değişken bir kez atanır, sonra değiştirilemez.
  //başlangıçta atamayıp çalışma zamanında atanabilir ancak tek kural sadece bir kere atama yapılabilir değiştirilemez.final ile const arasındaki önemli farklardan biri de zaten bu.
  //kural: varsayılan olarak fieldları final yaparız ancak değerin sonradan değişmesi gerekiyorsa var tercih ederiz
  final String id;
  final String adSoyad;
  final String telefon;
  final bool vipUyeMi;
  final List<String> alerjiler; // boş olabilir ama null olamaz
  final String? ozelCiltNotu; // Opsiyonel Null olabilir

  //constructor tanımladık -> nesne oluşturulurken alanlara değerleri atayan yerdir. final alanlar burada tek seferlik atanır.
  //const: Bu sınıftan derleme zamanı sabiti nesne üretilebilir. Şartı, tüm alanların final olması.
  //required: Bu parametreler verilmek zorunda. Unutursan derleme hatası olur.
  // parametreleri {} içinde alırsam (named şekilde) kullanırken (ad : deger) şeklinde kullanmalıyım ve sırayla yazmak zrounda değilim. Çoklu paremetreli durumlarda sırayı hatırlamama gerek olmaması açısından kolaylık.

  const Danisan({
    required this.id,
    required this.adSoyad,
    required this.telefon,
    //bunlar zorunlu değil varsayılan değer verdik dışardan gelmezse varsayılan değerler ile doldurulur
    this.vipUyeMi = false,
    this.alerjiler = const [],
    this.ozelCiltNotu,
  });

 //Burada hassasCiltMi adında bir getter tanımlıyoruz.
 //alerjiler.isNotEmpty alerjiler listemiz boş değilse true döner
  bool get hassasCiltMi => alerjiler.isNotEmpty;


  //Bilgi özet kartı
  //Burda da getter tanımlıyoruz
  //Bu sefer bize String döndürücek
  //kosul ? dogruysa : yanlissa şekinde ternary operatör kullandık
  //join() listedeki elemanları birleştirip String oluşturur. ',' değerleri arasına ne koycağını belirler
  //basit iafede de $ yeterliyken karmaşık bir ifade varsa ${} şeklinde kullanırız

  String get bilgiOzeti {
    final String alerjiBilgisi = alerjiler.isEmpty
        ? "Kayıtlı Alerji Yok"
        : "Alerjiler: ${alerjiler.join(', ')}";
    final String notBilgisi = ozelCiltNotu ?? "Özel medikal not girilmemiş"; //Soldaki değer null değilse onu kullan, null ise sağdaki değeri kullan
    final String vipRozeti = vipUyeMi ? "VİP" : "Standart";
    return "$vipRozeti $adSoyad ($telefon) | $alerjiBilgisi | Not: $notBilgisi";
  }
}

// Seans (randevu) Modeli
class SeansKaydi {
  final String seansKodu;
  final Danisan danisan; //daha önce oluşturduğumuz kendi tipimizi kullandık
  final HizmetKategorisi kategori; //oluşturduğumuz enum'u tip olarak kullandık
  final String islemAdi;
  final double birimFiyat;
  final int seansSayisi;
  final double indirimOrani; // Örn 10.0
  final String? sorumluUzman;
  SeansDurumu durum; //final tanımlamadık çünkü seans durumu zaman içerisinde değişebilir.
  OdemeYontemi? odemeTipi;

  //Burda constructor const yapılmamış çünkü içinde değişebilir alanlar içeriyor
  SeansKaydi({
    required this.seansKodu,
    required this.danisan,
    required this.kategori,
    required this.islemAdi,
    required this.birimFiyat,
    this.seansSayisi = 1,
    this.indirimOrani = 0.0,
    this.sorumluUzman,
    this.durum = SeansDurumu.bekliyor,
    this.odemeTipi,
  });

  double get brutTutar => birimFiyat * seansSayisi;

 // Danışan VIP üyeyse mevcut indirim oranına %10 ek indirim eklenir.
  double get indirimTutari {
    double toplamOran = indirimOrani;
    if (danisan.vipUyeMi) {
      toplamOran += 10.0;
    }
    return brutTutar * (toplamOran / 100.0);
  }

  //daha önce tanımladığımız 2 getteri kullanarak farklı bir getter tanımladık
  double get netTutar => brutTutar - indirimTutari;
}

// Yönetim Servisi
class KlinikYoneticisi {
  final String subeAdi;
  final List<SeansKaydi> _seanslar = []; //SeansKaydi nesnelerinden oluşan bir liste.
  //_seanslar, dışarıya açık olmayan/private tutulmak istenen bir field.Bu değişken iç kullanım içindir, dışarıya açık değildir.
  //Çünkü final, listenin kendisini başka bir listeyle değiştirmemizi engelliyor: ancak listeye ekleme silem yapbiliriz
  final Map<String, Danisan> _danisanRehberi = {}; //Map, key-value (anahtar-değer) şeklinde veri tutar.


  KlinikYoneticisi({required this.subeAdi});

  //Danışan kaydetme
  //void: bir sonuç üretip çağırana vermek için değil, işlem yapmak için yazılmış
  void danisanKaydet(Danisan danisan) {
    _danisanRehberi[danisan.id] = danisan; // Danışanın id'sini key, danışan nesnesini value olarak Map'e kaydeder.
    print(
      "Rehbere Eklendi: ${danisan.adSoyad} (${danisan.vipUyeMi ? "VİP" : "Standart"})",
    );
  }

  void randevuOlustur(SeansKaydi seans) {
    _seanslar.add(seans);//List'e yeni eleman ekler.
    print(
      "Randevu Kaydedildi [${seans.seansKodu}]: ${seans.danisan.adSoyad}->${seans.islemAdi}",
    );
  }

  void seansiTamamla({required String seansKodu, required OdemeYontemi odeme}) {
    for (var seans in _seanslar) {
      if (seans.seansKodu == seansKodu) {
        seans.durum = SeansDurumu.tamamlandi;
        seans.odemeTipi = odeme;
        print(
          "Seans Tamamlandı: [${seans.seansKodu}]: ${seans.netTutar.toStringAsFixed(2)} tahsil edildi (${odeme.name})",
          //toStringAsFixed(2) sonucunun tipi artık double değil, String.
          //odeme.name ile enumun değerine String erişir
        );
        return;
      }
    }
    print("Hata [$seansKodu] kodlu seans bulunamadı");
    return;
  }

  void seansiIptalEt(String seansKodu, {String? iptalNedeni}) {//Burda hem positional parameter. hem de named parametre kullandık
    for (var seans in _seanslar) { //_seanslar listesindeki elemanları sırayla dolaş ve o anki elemana seans adını ver.
      if (seans.seansKodu == seansKodu) { //2. seansKodu metoda parametre olarak gelen kod.
        seans.durum = SeansDurumu.iptalEdildi;
        print(
          "Seans İptal Edildi [${seans.seansKodu}]: ${iptalNedeni ?? "Gerekçe Belirtilmedi"}",
        );
        return;
      }
    }
  }

  // Finansal Rapor Metotları(fonksiyonel dart)
  double get toplamTahsilEdilenCiro => _seanslar
      .where((s) => s.durum == SeansDurumu.tamamlandi)//where, belirli koşulu sağlayan elemanları filtreler. Sadece durumu tamamlandi olan seansları al.
      .fold(0.0, (toplam, s) => toplam + s.netTutar);//fold, koleksiyondaki değerleri kullanarak tek bir sonuç üretir.

  double get beklenenPotansiyelCiro => _seanslar
      .where(
        (s) =>
            s.durum == SeansDurumu.bekliyor ||
            s.durum == SeansDurumu.odadaIslemde,
      )
      .fold(0.0, (toplam, s) => toplam + s.netTutar);

  // kategori bazlı seans sayıları

  Map<HizmetKategorisi, int> kategoriBazliSeansDagilimi() {
    final Map<HizmetKategorisi, int> dagilim = {}; //Önce boş Map oluşturuyoruz.
    for (var kat in HizmetKategorisi.values) { //Her enum'un .values özelliği bütün enum değerlerini verir.
      dagilim[kat] = 0; //her kategori için başlangıç değerini 0 yapıyoruz.
    }
    for (var s in _seanslar) { //Her seansı dolaşıyoruz.
      dagilim[s.kategori] = (dagilim[s.kategori] ?? 0) + 1;
    }
    return dagilim;
  }

  Set<String> gorevliUzmanKadrosu() { //Set, Liste benzer ama en önemli özelliği:Tekrarlı eleman tutmaz.
    //Seanslardan uzman isimlerini al → null olanları çıkar → tekrar eden uzmanları kaldır.
    return _seanslar.map((s) => s.sorumluUzman)
    .whereType<String>().toSet();//yalnızca String olan değerleri bırakıyor.
  }

  //Uzmansız kalan seanslar
  List<SeansKaydi> uzmansizSeanslariGetir() {
    return _seanslar.where((s) => s.sorumluUzman == null).toList();
  }

  void gunSonuRaporuYazdir() {
    print("Günlük Seans ve İşlem Çizelgesi");
    print("---------------------------------------");
    print(
      "${'Kod'.padRight((10))} | " //String'in sağ tarafını boşluklarla doldurarak belirtilen genişliğe ulaştırır.
      "${'Danışan'.padRight(16)} | "
      "${'İşlem'.padRight(20)} | "
      "${'Uzman'.padRight(18)} | "
      "${'Tutar'.padRight(10)} | "
      "${'Durum'} | ",
    );
    print("---------------------------------------");

    for (var s in _seanslar) {
      final String uzman = s.sorumluUzman ?? " Nöbetçi Bekliyor";
      final String durumRozet = switch (s.durum) {//s.durum değerine bakıyor.
        SeansDurumu.tamamlandi => "Tamamlandı",
        SeansDurumu.odadaIslemde => "İşlemde",
        SeansDurumu.bekliyor => "Bekliyor",
        SeansDurumu.iptalEdildi => "İptal",
      };

      print(
        "${s.seansKodu.padRight(10)} | "
        "${s.danisan.adSoyad.padRight(10)} | "
        "${s.islemAdi.padRight(10)} | "
        "${uzman.padRight(10)} | "
        "${s.netTutar.toStringAsFixed(2).padRight(10)} | "
        "$durumRozet",
      );
    }

    print("---------------------------------------");
    print("Finansal Özet:");
    print(
      " * Gerçekleşen (kasadaki net ciro) : ${toplamTahsilEdilenCiro.toStringAsFixed(2)}",
    );
    print(
      " * Bekleyen Potansiyen Alacak : ${beklenenPotansiyelCiro.toStringAsFixed(2)}",
    );
    print(" * Toplam Seans : ${_seanslar.length} Randevu");
    print("---------------------------------------");
    print("Aktif Uzmanlar");
    final uzmanlar = gorevliUzmanKadrosu();
    if (uzmanlar.isEmpty) {
      print("Kayıtlı Uzman Bulunamadı");
    } else {
      print(" ${uzmanlar.join(', ')}");
    }
    final uzmansizlar = uzmansizSeanslariGetir();
    if (uzmansizlar.isNotEmpty) {
      print(
        "Dikkat: ${uzmansizlar.length} adet seansa henüz uzman atanmamıştır",
      );
      for (var u in uzmansizlar) {
        print("->[${u.seansKodu}] ${u.danisan.adSoyad} (${u.islemAdi})");
      }
    }
    print("---------------------------------------");
  }
}

void main() {
  print("Klinik yönetim sistemi başlatılıyor....");
  final yonetici = KlinikYoneticisi(subeAdi: "Softito Bağcılar Şubesi");

  //danışanları oluşturalım
  final d1 = Danisan(
    id: "DAN-101",
    adSoyad: "Ahmet Yılmaz",
    telefon: "0555 555 55 55",
    vipUyeMi: true,
    alerjiler: ["Retinol,Aspirin"],
    ozelCiltNotu: "Cilt bariyeri hassas",
  );
  final d2 = Danisan(
    id: "DAN-102",
    adSoyad: "Ahmet Yılan",
    telefon: "0555 555 55 55",
    vipUyeMi: false,
    alerjiler: [],
  );
  final d3 = Danisan(
    id: "DAN-103",
    adSoyad: "Mehmet Yılmaz",
    telefon: "0555 555 55 55",
    vipUyeMi: true,
    alerjiler: ["Retinol,Aspirin"],
  );
  final d4 = Danisan(
    id: "DAN-104",
    adSoyad: "Ahmet Mehmet Yılmaz",
    telefon: "0555 555 55 55",
    vipUyeMi: true,
    alerjiler: [],
    ozelCiltNotu: "Cilt bariyeri hassas",
  );

  yonetici.danisanKaydet(d1);
  yonetici.danisanKaydet(d2);
  yonetici.danisanKaydet(d3);
  yonetici.danisanKaydet(d4);

  print("Danışan güvenlik kontrolü");
  print(d1.bilgiOzeti);
  print(d2.bilgiOzeti);
  print("----------------------------------");

  // randevular oluşturuluyor
  final seans1 = SeansKaydi(
    seansKodu: "SNS-2026-1",
    danisan: d1,
    kategori: HizmetKategorisi.Lipo,
    islemAdi: "Lipo gerisini bilmiyorum",
    birimFiyat: 6500.0,
    seansSayisi: 2,
    indirimOrani: 5.0,
    sorumluUzman: "Sümeyye Arab",
  );
  final seans2 = SeansKaydi(
    seansKodu: "SNS-2026-2",
    danisan: d2,
    kategori: HizmetKategorisi.ciltYenileme,
    islemAdi: "Siverex ile tyüz temizleme",
    birimFiyat: 2500.0,
    seansSayisi: 5,
    indirimOrani: 15.0,
    sorumluUzman: null,
  );
  final seans3 = SeansKaydi(
    seansKodu: "SNS-2026-3",
    danisan: d3,
    kategori: HizmetKategorisi.lazerEpilasyon,
    islemAdi: "Tüm Vücut",
    birimFiyat: 25000.0,
    seansSayisi: 15,
    indirimOrani: 0.0,
    sorumluUzman: "Tuba Aydın",
  );
  final seans4 = SeansKaydi(
    seansKodu: "SNS-2026-4",
    danisan: d4,
    kategori: HizmetKategorisi.medikalEstetik,
    islemAdi: "Burun Estetiği",
    birimFiyat: 1500.0,
    seansSayisi: 3,
    sorumluUzman: "Alaaddin Odabaşı",
  );
  yonetici.randevuOlustur(seans1);
  yonetici.randevuOlustur(seans2);
  yonetici.randevuOlustur(seans3);
  yonetici.randevuOlustur(seans4);
  print("Seanslar Gönderiliyor");

  //seans 1 başarıyla tamamlanıyor (kredi kartı ile ödeme);
  yonetici.seansiTamamla(
    seansKodu: "SNS-2026-1",
    odeme: OdemeYontemi.krediKarti,
  );
  //seans 2 başarıyla tamamlanıyor (nakit ödeme);
  yonetici.seansiTamamla(seansKodu: "SNS-2026-2", odeme: OdemeYontemi.nakit);
  //seans 4 iptal ediliyor
  yonetici.seansiIptalEt(
    "SNS-2026-04",
    iptalNedeni: "Danışanın şehir dışından tanıdığı geldiği için gelemedi",
  );

  yonetici.gunSonuRaporuYazdir();
}