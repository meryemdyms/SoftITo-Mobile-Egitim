class Kahraman {
  final String ad;
  final String sinif;
  int seviye;
  double saldirGucu;
  bool hayattaMi;

  Kahraman({
    required this.ad,
    required this.sinif,
    this.seviye = 1,
    this.saldirGucu = 50.0,
    this.hayattaMi = true,
  });

  Kahraman.acemi({required this.ad})
      : sinif = "Çırak Savaşçı",
        seviye = 1,
        saldirGucu = 25.0,
        hayattaMi = true;

  factory Kahraman.fromSaveJson(Map<String, dynamic> jason) {
    return Kahraman(
      ad: jason["ad"] as String,
      sinif: jason["sinif"] as String,
      seviye: jason["seviye"] as int,
      saldirGucu: (jason["hasar"] as num).toDouble(),
      hayattaMi: jason["hayatta"] as bool,
    );
  }

  void kartiYazdir() {
    print(
      "[$sinif] $ad | Seviye: $seviye | Güç: $saldirGucu | Durum: ${hayattaMi ? 'Canli' : 'Ruh Halinde'}",
    );
  }
}

void main() {
  print("Karakter Üretimi");

  final sampiyon = Kahraman(
    ad: "Tuba Aydın",
    sinif: "Şövalye",
    seviye: 10,
    saldirGucu: 120.0,
  );

  sampiyon.kartiYazdir();

  final caylak = Kahraman.acemi(ad: "Furkan Çalışkan");
  caylak.kartiYazdir();

  final Map<String,dynamic> jsondanGelenKarakter = {
    "ad":"Alaaddin",
    "sinif":"Ak Bbüyücü",
    "seviye":50,
    "hasar":350.5,
    "hayatta":true,
  };

  final efsane = Kahraman.fromSaveJson(jsondanGelenKarakter);
  efsane.kartiYazdir();



}
