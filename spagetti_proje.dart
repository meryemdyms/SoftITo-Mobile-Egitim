class Urun {
  String id;
  String ad;
  double fiyat;
  int stok;
  String tip;

  Urun(this.id, this.ad, this.fiyat, this.stok, this.tip);

  
}

abstract class KargoUcret{double kargoUcretiHesapla()=>29.90;}

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
    print("DB calistirildi: " + sql);
  }
}

class SmtpMailServisi implements IMail {
  @override
  void mailGonder(String email, String mesaj) {
    print("SMTP Mail gonderildi: " + to);
  }
}

class NetgsmSmsServisi implements ISms {
  @override
  void smsGonder(String tel, String mesaj) {
    print("SMS iletildi: " + gsm);
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

class SiparisYoneticisi implements ISiparisIslemleri {
  SqliteVeritabani db = SqliteVeritabani();
  SmtpMailServisi mailci = SmtpMailServisi();
  NetgsmSmsServisi smsci = NetgsmSmsServisi();

  @override
  void siparisKaydet(String orderId, double tutar) {
    db.kaydet("INSERT INTO siparisler VALUES ('$orderId', $tutar)");
  }

  @override
  void odemeYap(String tip, double tutar) {
    if (tip == "KREDI_KARTI") {
      print("$tutar TL Kredi kartindan POS ile cekildi.");
    } else if (tip == "HAVALE") {
      print("$tutar TL Havale kontrol edildi.");
    } else if (tip == "KAPIDA_ODEME") {
      print("$tutar TL Kapida odeme tahsil edilecek (Komisyon +15 TL).");
    } else if (tip == "CRYPTO") {
      print("$tutar TL USDT transferi onaylandi.");
    } else {
      print("Gecersiz odeme yontemi");
    }
  }

  @override
  void kargoGonder(String orderId, String adres) {
    print("MNG Kargo takip fis basildi: $adres");
  }

  @override
  void mailGonder(String email, String mesaj) {
    mailci.mailAt(email, mesaj);
  }

  @override
  void smsGonder(String tel, String mesaj) {
    smsci.smsYolla(tel, mesaj);
  }

  @override
  void faturaYazdir(String orderId) {
    print("Fatura PDF cikarildi: $orderId");
  }

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
      toplam += sepet[i].kargoUcretiHesapla();
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

    odemeYap(odemeTipi, sonTutar);
    siparisKaydet(orderId, sonTutar);
    faturaYazdir(orderId);
    mailGonder(email, "Sayin $musteriAdi, siparisiniz alindi. Tutar: $sonTutar TL");
    smsGonder(tel, "Siparisiniz onaylandi: $orderId");
    kargoGonder(orderId, adres);
  }
}

void main() {
  var siparisci = SiparisYoneticisi();

  var urun1 = Urun("1", "Kablosuz Mouse", 450.0, 5, "FIZIKSEL");
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