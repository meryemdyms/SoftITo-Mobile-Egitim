import 'package:flutter/material.dart';
import 'screens/urun_listesi_ekrani.dart';

/// Uygulamanın başlangıç noktası (Entry Point).
///
/// Flutter uygulamasını başlatır ve kök widget olan [MiniMagazaUygulamasi]'nı ayağa kaldırır.
void main() {
  // Flutter widget ağacını başlatır ve verilen kök widget'ı ekranda görüntüler.
  runApp(const MiniMagazaUygulamasi());
}

/// Mini Mağaza uygulamasının ana (kök) widget'ı.
///
/// Uygulama düzeyindeki tema ayarlarını, başlığı ve ilk açılacak olan
/// ana ekranı ([UrunListesiEkrani]) tanımlayan StatelessWidget sınıfıdır.
class MiniMagazaUygulamasi extends StatelessWidget {
  const MiniMagazaUygulamasi({super.key});

  @override
  Widget build(BuildContext context) {
    // Uygulamanın genel yapılandırmasını sağlayan MaterialApp döndürülür.
    return MaterialApp(
      // Sağ üst köşedeki "DEBUG" şeridini gizler.
      debugShowCheckedModeBanner: false,
      
      // Cihazın görev yöneticisinde ve sistemde görünen uygulama başlığı.
      title: "Mini Mağaza",
      
      // Uygulamanın genel tema yapılandırması
      theme: ThemeData(
        // En güncel Material 3 tasarım standardını etkinleştirir.
        useMaterial3: true,
        
        // Indigo (çivit mavisi) rengini tohum (seed) olarak kullanarak
        // otomatik ve uyumlu bir renk paleti (ColorScheme) üretir.
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.light,
        ),
      ),
      
      // Uygulama açıldığında kullanıcıyı karşılayacak olan ana ekran.
      home: const UrunListesiEkrani(),
    );
  }
}