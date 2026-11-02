/// Uygulama genelinde kullanılan sabit metin ve konfigürasyon değerleri.
class AppConstants {
  AppConstants._();

  /// Uygulamanın başlığı.
  static const String appTitle = 'Araç Kiralama Platformu';

  /// Çevrimdışı ve demo ortamı uyarı açıklaması.
  static const String demoDisclaimer =
      'Demo Veri / Çevrimdışı Sürüm: Gerçek ödeme ve kimlik doğrulaması yapılmaz.';

  /// Ödeme şekli açıklaması (ilk sürümde firmada ödeme modeli geçerlidir).
  static const String paymentTypeLabel =
      'Firmada Ödeme (Teslimatta Nakit / Kart)';

  /// Varsayılan arama şehri.
  static const String defaultCity = 'İstanbul';

  /// Harita ve konum arama için varsayılan merkez enlem değeri.
  static const double defaultLat = 41.0082;

  /// Harita ve konum arama için varsayılan merkez boylam değeri.
  static const double defaultLng = 28.9784;
}
