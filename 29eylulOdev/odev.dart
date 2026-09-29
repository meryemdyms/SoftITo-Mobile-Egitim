enum CihazTipi {
  sensor,
  gateway,
  edgeServer,
  router,
}

class IoTCihaz {
  final String seriNo;
  final String cihazAdi;
  final CihazTipi tip;
  double cpuYukYuzdesi;
  int bellekMb;
  final Set<String> acikPortlar;
  bool sslSertifikasiGecerliMi;
  bool acikMi;

  IoTCihaz({
    required this.seriNo,
    required this.cihazAdi,
    required this.tip,
    required this.cpuYukYuzdesi,
    required this.bellekMb,
    required this.acikPortlar,
    required this.sslSertifikasiGecerliMi,
    required this.acikMi,
  });

  bool get guvenlikAcigiVarMi =>
      !sslSertifikasiGecerliMi ||
      acikPortlar.contains("23/TELNET");
}


// Özel Exception
class CihazErisilemezException implements Exception {
  final String mesaj;

  CihazErisilemezException(this.mesaj);

  @override
  String toString() => mesaj;
}


class IoTCihazYoneticisi {

  final List<IoTCihaz> cihazlar = [
    IoTCihaz(
      seriNo: "SN001",
      cihazAdi: "Sicaklik Sensoru",
      tip: CihazTipi.sensor,
      cpuYukYuzdesi: 32.5,
      bellekMb: 256,
      acikPortlar: {"80/HTTP", "443/HTTPS"},
      sslSertifikasiGecerliMi: true,
      acikMi: true,
    ),

    IoTCihaz(
      seriNo: "SN002",
      cihazAdi: "Ana Gateway",
      tip: CihazTipi.gateway,
      cpuYukYuzdesi: 67.8,
      bellekMb: 1024,
      acikPortlar: {"22/SSH", "23/TELNET", "443/HTTPS"},
      sslSertifikasiGecerliMi: true,
      acikMi: true,
    ),

    IoTCihaz(
      seriNo: "SN003",
      cihazAdi: "Edge Sunucu",
      tip: CihazTipi.edgeServer,
      cpuYukYuzdesi: 91.2,
      bellekMb: 4096,
      acikPortlar: {"22/SSH", "443/HTTPS"},
      sslSertifikasiGecerliMi: true,
      acikMi: true,
    ),

    IoTCihaz(
      seriNo: "SN004",
      cihazAdi: "Ofis Router",
      tip: CihazTipi.router,
      cpuYukYuzdesi: 45.6,
      bellekMb: 512,
      acikPortlar: {"80/HTTP", "443/HTTPS"},
      sslSertifikasiGecerliMi: false,
      acikMi: false,
    ),

    IoTCihaz(
      seriNo: "SN005",
      cihazAdi: "Nem Sensoru",
      tip: CihazTipi.sensor,
      cpuYukYuzdesi: 20.4,
      bellekMb: 128,
      acikPortlar: {"443/HTTPS"},
      sslSertifikasiGecerliMi: true,
      acikMi: true,
    ),

    IoTCihaz(
      seriNo: "SN006",
      cihazAdi: "Yedek Gateway",
      tip: CihazTipi.gateway,
      cpuYukYuzdesi: 88.7,
      bellekMb: 2048,
      acikPortlar: {"23/TELNET", "80/HTTP"},
      sslSertifikasiGecerliMi: false,
      acikMi: false,
    ),
  ];


  // WHERE
  List<IoTCihaz> riskliCihazlariBul() {
    return cihazlar
        .where(
          (s) =>
              s.cpuYukYuzdesi > 85 ||
              s.guvenlikAcigiVarMi,
        )
        .toList();
  }


  // FOLD
  int toplamBellekHesapla() {
    return cihazlar.fold(
      0,
      (toplam, cihaz) => toplam + cihaz.bellekMb,
    );
  }


  // RECORD
  (
    String cihazAdi,
    CihazTipi tip,
    bool alarmDurumu,
  ) cihazBilgisiGetir(String seriNo) {

    for (var cihaz in cihazlar) {
      if (cihaz.seriNo == seriNo) {
        return (
          cihaz.cihazAdi,
          cihaz.tip,
          cihaz.guvenlikAcigiVarMi ||
              cihaz.cpuYukYuzdesi > 85,
        );
      }
    }

    throw Exception("Cihaz bulunamadı: $seriNo");
  }


  // SWITCH EXPRESSION
  String izolasyonBolgesiBelirle(CihazTipi tip) {
    return switch (tip) {
      CihazTipi.sensor => "ZONE-S",
      CihazTipi.gateway => "ZONE-G",
      CihazTipi.edgeServer => "ZONE-E",
      CihazTipi.router => "ZONE-R",
    };
  }


  // ERİŞİM KONTROLÜ
  void cihazErisimKontrol(IoTCihaz cihaz) {

    if (!cihaz.acikMi) {
      throw CihazErisilemezException(
        "${cihaz.cihazAdi} cihazına erişilemiyor.",
      );
    }
  }
}


void main() {

  final yonetici = IoTCihazYoneticisi();


  print("Riskli Cihazlar");
  print("----------------");

  print(
    yonetici
        .riskliCihazlariBul()
        .map((cihaz) => cihaz.cihazAdi)
        .toList(),
  );


  print("\nToplam Bellek");
  print("-------------");

  print(
    "${yonetici.toplamBellekHesapla()} MB",
  );


  print("\nCihaz Bilgisi");
  print("-------------");

  final cihazBilgisi =
      yonetici.cihazBilgisiGetir("SN003");

  print("Cihaz Adı: ${cihazBilgisi.$1}");
  print("Cihaz Tipi: ${cihazBilgisi.$2}");
  print("Alarm Durumu: ${cihazBilgisi.$3}");


  print("\nİzolasyon Bölgesi");
  print("-----------------");

  print(
    yonetici.izolasyonBolgesiBelirle(
      CihazTipi.gateway,
    ),
  );


  print("\nCihaz Erişim Kontrolü");
  print("---------------------");

  try {
    yonetici.cihazErisimKontrol(
      yonetici.cihazlar[3],
    );

    print("Cihaza başarıyla erişildi.");

  } on CihazErisilemezException catch (e) {
    print("Hata: $e");
  }
}