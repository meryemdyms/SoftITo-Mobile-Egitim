import 'package:flutter/material.dart';

/// Ritmo Tasarım Sistemi (Design System) Renk Paleti.
///
/// `project.md` ve `ui-design` kurallarına uygun olarak hazırlanmıştır.
/// Doğal tonlar, sakinleştirici yeşil tonları ve sıcak pastel vurgular içerir.
/// Uygulama genelindeki tüm renkler bu sınıf üzerinden merkezi olarak yönetilir.
class AppColors {
  // Bu sınıfın doğrudan örneklenmesini (instantiation) engellemek için private yapıcı
  AppColors._();

  // ==========================================
  // ANA MARKA VE TEMA RENKLERİ
  // ==========================================

  /// Uygulama ana arka plan rengi (#F6F4EE).
  /// Gözü yormayan, sıcak ve mat kâğıt beyazı tonu.
  static const Color background = Color(0xFFF6F4EE);

  /// Birincil marka rengi (#344E41).
  /// Derin orman yeşili; butonlarda, ana başlıklarda ve odak noktalarında kullanılır.
  static const Color primary = Color(0xFF344E41);

  /// İkincil marka rengi (#A3B899).
  /// Adaçayı yeşili; ikincil butonlar, ilerleme göstergeleri ve rozetlerde kullanılır.
  static const Color secondary = Color(0xFFA3B899);

  /// Vurgu rengi (#E8CDA9).
  /// Sıcak kum/bej tonu; yapboz parçaları ve özel rozet alanlarında kullanılır.
  static const Color accent = Color(0xFFE8CDA9);

  /// Yumuşak vurgu rengi (#D9A6A0).
  /// Gül kurusu / pastel pembe tonu; dikkat çekici etiketler ve ikincil vurgular için uygundur.
  static const Color softAccent = Color(0xFFD9A6A0);

  // ==========================================
  // YÜZEY, KART VE KENARLIK RENKLERİ
  // ==========================================

  /// Kartların ve panellerin altındaki hafif kontrastlı yüzey rengi (#FAF8F3)
  static const Color surface = Color(0xFFFAF8F3);

  /// Yüzey varyant rengi (#EDE9DF); pasif alanlar ve arka plan dolguları için kullanılır
  static const Color surfaceVariant = Color(0xFFEDE9DF);

  /// Kartların arka plan rengi (#FFFFFF - saf beyaz)
  static const Color cardBg = Color(0xFFFFFFFF);

  /// Kart ve bileşen sınırlarını ayıran ince kenarlık rengi (#E0DDD5)
  static const Color border = Color(0xFFE0DDD5);

  // ==========================================
  // METİN VE TİPOGRAFİ RENKLERİ
  // ==========================================

  /// Birincil metin rengi (#24332B - koyu yeşil/antrasit); başlıklar ve ana içerikler için
  static const Color textPrimary = Color(0xFF24332B);

  /// İkincil metin rengi (#6B7B70); alt başlıklar ve açıklama metinleri için
  static const Color textSecondary = Color(0xFF6B7B70);

  /// Silik metin rengi (#9AA69D); pasif ipuçları ve yer tutucu (placeholder) metinleri için
  static const Color textMuted = Color(0xFF9AA69D);

  /// Koyu zeminler (ör. birincil butonlar) üzerindeki açık metin rengi (#F6F4EE)
  static const Color textOnPrimary = Color(0xFFF6F4EE);

  // ==========================================
  // DURUM VE GERİ BİLDİRİM RENKLERİ
  // ==========================================

  /// Başarı durumu rengi (#3D6B51); tamamlanan hedefler ve onay bildirimleri için
  static const Color success = Color(0xFF3D6B51);

  /// Uyarı ve dikkat durumu rengi (#D49B42); streak ateşi ve hatırlatmalar için
  static const Color warning = Color(0xFFD49B42);

  /// Hata durumu rengi (#C04B44); form doğrulama hataları ve iptal işlemleri için
  static const Color error = Color(0xFFC04B44);

  /// Bilgilendirme rengi (#4C7B8B); rehber ipuçları ve bilgi kutuları için
  static const Color info = Color(0xFF4C7B8B);
}
