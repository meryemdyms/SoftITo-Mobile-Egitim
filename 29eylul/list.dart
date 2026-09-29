void main() {
  final List<String> aktifMikroservisler = [
    "auth-service:v2.1",
    "gateway-service:v1.9",
    "payment-processor:v3.0",
  ];

  aktifMikroservisler.add("telemetry-collector:v1.0");

  print(
    "Aktif servisler: (${aktifMikroservisler.length} adet): $aktifMikroservisler",
  );

  // Sabit uzunluktaki liste (fixed-length)
  //içeriğini değiştirebiliriz (güncelleme) ancak yeni eleman ekleyemeyiz
  final List<String> cekirdekYukDengeleyiciler = List.filled(4, "Port-Kapalı",growable: false);
  cekirdekYukDengeleyiciler[0] = "LB-NODE-01; 192.168.1.10 (Online)";
  cekirdekYukDengeleyiciler[1] = "LB-NODE-02; 192.168.1.11 (Online)";

  //HATA!!! Fixed length listeye eleman eklenmez
  print("Çekirdek Yün Dengeleyici Portları: $cekirdekYukDengeleyiciler");
  

  //Programatik List Üretici
  //Bu kodun amacı elle tek tek eleman yazmak yerine, belirli bir kurala göre otomatik olarak 3 elemanlı bir liste üretmek.
  final List<String> kubernetsPortlari = List.generate(3,
  (index) => "pod-node-eu-west-${index+1} [Ram:16GB, CPU:4 Cores]",
  );

  print("Oluşturulan K8s Podları: $kubernetsPortlari");

  //Değiştirilemez List
  final List<String> guvenlikDuvariPortlari = List.unmodifiable([
    "22/TCP (SSH)",
    "443/TCP (HTTPS)",
    "6443/TCP (k8S-API)",
  ]);

  //guvenlikDuvariPortlari[0] = "80/TCP"; //Hata cannot modift an unmodifiable list
  //List.unmodifiable() ile oluşturulan listede hiçbir elemanı değiştiremezsin, ekleyemezsin veya silemezsin.
  print("Güvenlik Duvarı Korumalı Portlar: $guvenlikDuvariPortlari");

  



}