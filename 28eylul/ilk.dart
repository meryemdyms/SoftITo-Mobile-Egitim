

  /*
  //print("İlk dersimiz - Dart SDK aktif olmalı");
  //Jsdeki gibi let x="Ahmet"; x=42; hata veriri

  //1. Açık belirtilen veri tipleri
  int seansSuresiDakika = 45;
  double seansUcretiTL=2750.50;
  String uzmanAdi = "Dr Aygen Yıldırım";
  bool aktifMi = true;

  //2.String interpolation
  //JS deki `${}`bunun yerine sadece $değişken işlem varsa ${işlem} şeklinde kullanılır
  print("Uzman: $uzmanAdi | Süre: $seansSuresiDakika dk | Ücret $seansUcretiTL ₺");
  print("KDV dahil (%20) ${seansUcretiTL*1.20} ₺");

  //3. var ile tip çıkarıı
  var tedaviAdi = "Kahve ile peeling"; //var ile string girdiğimi dart otomatik tanıdı
  
  //4. dynamic veri tipini bağımsız kullanabilirsiniz ancak flutterda önerilmez
  dynamic serbestKutu = "Lazer epilasyon";
  serbestKutu=1000; //izin verilir ancak veri tip güvenilirliğini yok eder
 */

/*
 //const:Derleme anında değeri belli olan veriler,bellekte tek bir yerde saklanır
 const String klinik_adi="SoftITo Güzellik Merkezi";
 const double kdv_orani = 0.20;

 //const DateTime suankiZaman = DateTime.now()//Hata derleme anında bunu bilemeyiz

 //final:Çalışma anında hesaplanır, bir kere atandıktan sonra değişmez
 final DateTime randevuZamani = DateTime.now();
 final String takipKodu = "SOFT-" + randevuZamani.microsecondsSinceEpoch.toString();

 print("Klinik adı: $klinik_adi");
 print("oluşturulma tarihi:$randevuZamani | Kod: $takipKodu");
*/

/*
//Bir değişken varsayılan olarak asla null olamaz
String zorunluDanisanAdi = "Meltem Demir";
String? danisanAlerjiNotu; //bu şekilde null olarak kullanabilirim
print("alerji notu: $danisanAlerjiNotu");

//ifNull operatörü - null ise varsayılan değer atama
String goruntulenecekNot = danisanAlerjiNotu ?? "Bilinen bir alerjisi yok"; //null ise bunu göster diyoruz
print("Rapor: $goruntulenecekNot");

//null aware
print("alerji metin uzunluğu: ${danisanAlerjiNotu?.length}");
*/

//Klasik sıralı fonksiyon
double topla(double a, double b) => a+b;

// Modern Dart / Flutter standardı: Named parameters ({})
void seansKaydiOlustur({
  required String danisan,
  required String tedavi,
  required double birimFiyat,
  int seansSayisi = 1,        // default değer
  double indirimOrani = 0.0,  // default değer
  String? uzmanHekim,         // null olabilir
}) {
  final double brutTutar = birimFiyat * seansSayisi;
  final double indirimTutari = brutTutar * (indirimOrani / 100);
  final double netTutar = brutTutar - indirimTutari;

  print("""
=============================
      SoftITo Seans Sözleşmesi
-----------------------------
Danışan         : $danisan
Tedavi          : $tedavi (x$seansSayisi Seans)
Uzman Hekim     : ${uzmanHekim ?? "Nöbetçi Estetisyen"}
Brüt Tutar      : $brutTutar ₺
İndirim         : -$indirimTutari ₺ (%$indirimOrani)
Ödenecek Tutar  : $netTutar ₺
=============================
""");
}

void main() {
  seansKaydiOlustur(
    danisan: "Sümeyye Muhammed",
    tedavi: "Medikal Cilt Yenileme",
    birimFiyat: 4500.0,
    seansSayisi: 3,
    indirimOrani: 15.0,
    uzmanHekim: "Dr. Shahd",
  );
}

