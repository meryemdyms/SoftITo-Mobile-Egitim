//kod satırlarımızı yürütür
//break ile çıkar
//değer atama olmaz

enum OlaySeviyesi { info, warning, error, critical }

String alarmKanaliniBelirle(OlaySeviyesi seviye, int tekrarSayisi) {
  return switch (seviye) {
    OlaySeviyesi.info => "dev-logs",
    OlaySeviyesi.warning => "dev-warning",
    OlaySeviyesi.error when tekrarSayisi >= 5 =>
      "Sms veya Email (mükerrer hata)",
    OlaySeviyesi.error => "Email:dev@site.com",
    OlaySeviyesi.critical => "ACIL DURUM: Kriz odası otomatik node kapanışı",
  };
}

String httpKoduYorumla(int kod) {
  return switch (kod) {
    >= 200 && < 300 => "2xx Başarılı İstek",
    >= 400 && < 500 => "4xx İstenci Hatası (client error)",
    >= 500 && < 600 => "5xx Sunucu Hatası (internal Server Error)",

    _ => "Tanımsız Hata Kodu",
  };
}

void main() {
  print("Switch Expressions");

  print(
    "Warning Kanalı : "
    "${alarmKanaliniBelirle(OlaySeviyesi.warning, 1)}",
  );

  print(
    "Tekil Error Kanalı : "
    "${alarmKanaliniBelirle(OlaySeviyesi.error, 2)}",
  );

  print(
    "5 kez Tekrarlanan Error Kanalı : "
    "${alarmKanaliniBelirle(OlaySeviyesi.error, 5)}",
  );

  print(
    "Kritik Kanalı : "
    "${alarmKanaliniBelirle(OlaySeviyesi.critical, 1)}",
  );

  print("HTTP 204 : ${httpKoduYorumla(204)}");
  print("HTTP 404 : ${httpKoduYorumla(404)}");
  print("HTTP 502 : ${httpKoduYorumla(502)}");
}
