class Urun {
  String id;
  String ad;
  double fiyat;
  int stok;
  String tip;

  Urun(this.id, this.ad, this.fiyat, this.stok, this.tip);

  
}

abstract class KargoUcret{double kargoUcretiHesapla();}

//Eğer kargo ücreti hesaplamamız gerekse kargoUcreti de implements ederdik ama ihtiyacımız yok direk hiç çağırmıyoruz
class DijitalUrun extends Urun {
  DijitalUrun(String id, String ad, double fiyat, int stok)
      : super(id, ad, fiyat, stok, "DIJITAL");


/*ISP ihlali
  @override
  double kargoUcretiHesapla() {
    throw Exception("Dijital urunlerde kargo hesaplanamaz!");
  }*/
}

class FizikselUrun extends Urun implements KargoUcret {
  FizikselUrun(String id, String ad, double fiyat, int stok)
      : super(id, ad, fiyat, stok, "FIZIKSEL");

  @override
  double kargoUcretiHesapla() {
    return 29.90;
  }
}

//SOLID ihlali. Bir class sadece kendiyle alakalı methotları barındırmalı ve tek iş yapmalı
/*abstract class ISiparisIslemleri {
  void siparisKaydet(String orderId, double tutar);
  void odemeYap(String tip, double tutar);
  void kargoGonder(String orderId, String adres);
  void mailGonder(String email, String mesaj);
  void smsGonder(String tel, String mesaj);
  void faturaYazdir(String orderId);
}*/

abstract class ISiparisKayit {
  void siparisKaydet(String orderId, double tutar);
}

abstract class IOdeme {
  void odemeYap(String tip, double tutar);
}

abstract class IKargo {
  void kargoGonder(String orderId, String adres);
}

abstract class IMail {
  void mailGonder(String email, String mesaj);
}

abstract class ISms {
  void smsGonder(String tel, String mesaj);
}

abstract class IFatura {
  void faturaYazdir(String orderId);
}

class SqliteVeritabani implements ISiparisKayit {
 @override
  void siparisKaydet(String orderId, double tutar) {
    print("DB calistirildi: + $orderId - $tutar");
  }
}

class SmtpMailServisi implements IMail {
  @override
  void mailGonder(String email, String mesaj) {
    print("SMTP Mail gonderildi:  + $email");
  }
}

class NetgsmSmsServisi implements ISms {
  @override
  void smsGonder(String tel, String mesaj) {
    print("SMS iletildi: + $tel");
  }
}

class OdemeServisi implements IOdeme {
  @override
  void odemeYap(String tip, double tutar) {
    if (tip == "KREDI_KARTI") {
      print("$tutar TL Kredi kartindan POS ile cekildi.");
    } else if (tip == "HAVALE") {
      print("$tutar TL Havale kontrol edildi.");
    } else if (tip == "KAPIDA_ODEME") {
      print("$tutar TL Kapida odeme tahsil edilecek.");
    } else if (tip == "CRYPTO") {
      print("$tutar TL USDT transferi onaylandi.");
    }
  }
}

class KargoServisi implements IKargo {
  @override
  void kargoGonder(String orderId, String adres) {
    print("MNG Kargo takip fis basildi: $adres");
  }
}

class FaturaServisi implements IFatura {
  @override
  void faturaYazdir(String orderId) {
    print("Fatura PDF cikarildi: $orderId");
  }
}


//DI ile bağımlılıklar constructor üzerinden dışarıdan alınıyor
class SiparisYoneticisi {

 final ISiparisKayit db;
  final IOdeme odeme;
  final IKargo kargo;
  final IMail mail;
  final ISms sms;
  final IFatura fatura;

    SiparisYoneticisi(
    this.db,
    this.odeme,
    this.kargo,
    this.mail,
    this.sms,
    this.fatura,
  );

  void siparisTamamla(
      String orderId,
      List<Urun> sepet,
      String odemeTipi,
      String musteriAdi,
      String email,
      String tel,
      String adres,
      String kuponKodu) {
    
    double toplam = 0;

    for (var i = 0; i < sepet.length; i++) {
      if (sepet[i].stok <= 0) {
        print("Hata: " + sepet[i].ad + " tukenmis!");
        return;
      }
      toplam += sepet[i].fiyat;
      if (sepet[i] is KargoUcret) {
         toplam += (sepet[i] as KargoUcret).kargoUcretiHesapla();
      }
      sepet[i].stok--;
    }

    if (kuponKodu == "INDIRIM10") {
      toplam = toplam * 0.90;
    } else if (kuponKodu == "YAZ20") {
      toplam = toplam * 0.80;
    } else if (kuponKodu == "SEPETTE50") {
      toplam = toplam - 50;
    }

    double kdv = toplam * 0.20;
    double sonTutar = toplam + kdv;

    odeme.odemeYap(odemeTipi, sonTutar);

    db.siparisKaydet(orderId, sonTutar);

    fatura.faturaYazdir(orderId);

    mail.mailGonder(
      email,
      "Sayin $musteriAdi, siparisiniz alindi. Tutar: $sonTutar TL",
    );

    sms.smsGonder(
      tel,
      "Siparisiniz onaylandi: $orderId",
    );

    kargo.kargoGonder(orderId, adres);
  
  }
}

void main() {
  var siparisci = SiparisYoneticisi(
    SqliteVeritabani(),
  OdemeServisi(),
  KargoServisi(),
  SmtpMailServisi(),
  NetgsmSmsServisi(),
  FaturaServisi(),
  );

  var urun1 = FizikselUrun("1", "Kablosuz Mouse", 450.0, 5);
  var urun2 = DijitalUrun("2", "Flutter Kursu E-Kitap", 150.0, 100);

  var sepet = <Urun>[urun1, urun2];

  siparisci.siparisTamamla(
    "SP-9921",
    sepet,
    "KREDI_KARTI",
    "Selahaddin",
    "selahaddin@kodvance.com",
    "05551112233",
    "Kadikoy / Istanbul",
    "INDIRIM10",
  );
}