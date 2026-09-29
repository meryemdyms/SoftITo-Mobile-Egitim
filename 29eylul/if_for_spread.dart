//Spread ... ya da ...? ve collection is ve collection for kullanımı

void main(){
  print("Pipline Konfigürasyonu");

  final bool productionMu = true;
  final bool debugLoggingAktif=false;
  final List<String>? cloudWatchEklentileri=["datadog-agent:v7","prometheus-exporter"];
  final List<String>? geciciTestYamalari = null;

  final List<String> aktifPiplineAdimlari = [
    "git-checkout",
    "security-sast-scan",

    if(productionMu) "production-kms-check",
    if(debugLoggingAktif) "verbose-debug-logger" else "minified-json-logger",

    ...["docker-build","helm-chart-package"],

    ...?cloudWatchEklentileri, //dolu olduğu için ekleme yapçaz
    ...?geciciTestYamalari, //null olduğu için hiçbir işlem yapmaz / çökmezde

  ];

  for(int i=0; i<aktifPiplineAdimlari.length;i++){
    print("Adım ${i+1}: ${aktifPiplineAdimlari[i]}");
  }


  final List<int> izinliPortlar = [8080,8443,9090];
  final List<String> firewallGuvenlikKurallari = [
    "INGRESS-DEFAULT-DROP",
    for(var port in izinliPortlar) "ALOOW-TCP_PORT-$port (VPC_INTERNAL)", 
    "EGRESS_ALL_ALLOW"

  ];

  print("Dinamik Güvenlik Kuralları (collection for):---");
  firewallGuvenlikKurallari.forEach((kural)=>print(" * $kural"));

}