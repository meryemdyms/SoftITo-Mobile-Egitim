abstract class LoncaUyesi {
  final String rumuz;

  LoncaUyesi({required this.rumuz});

  //soyut metot
  void ozelYetenekKullan();

  void loncayaSelamVer() {
    print("$rumuz Lonca Bayrağını Selamladı: 'Onur ve zafer için'");
  }
}

class Sovalye extends LoncaUyesi {
  Sovalye({required super.rumuz});

  @override
  void ozelYetenekKullan() {
    print("$rumuz Demir kalkanını kaldırdı ve savunma duvarı ördü");
  }
}

class Sifaci extends LoncaUyesi {
  Sifaci({required super.rumuz});

  @override
  void ozelYetenekKullan() {
    print("$rumuz Kutsal ışık büyüsü ile tüm takımın canını tazeledi");
  }
}

void savasAlnindaKomutVer(List<LoncaUyesi> takim){
  print("Liderin Emriyle takım yetenekleri devreye girsin");

  for(var t in takim){
    t.loncayaSelamVer();
    //herkes kendi özel yeteneğini kullansın
    t.ozelYetenekKullan();
  }
}

void main(){
  print("Lonca Takımı");
  final List<LoncaUyesi> loncBirligi = [
    Sovalye(rumuz: "Kızıl Şövalye Adil"),
    Sifaci(rumuz: "Orman Perisi Shahd"),
    Sovalye(rumuz: "Gümüş Muhafızı Eren"),
  ];

  //Hepsini tek bir emirle çalıştırıyoruz
  savasAlnindaKomutVer(loncBirligi);
}

