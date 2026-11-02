import 'package:flutter/material.dart';

/// Cep Müzem — Kesin Tasarım Renk Paleti (museum-design-system)
///
/// Konsept: "Yaşayan Müze"
/// Tarihi bir müzenin sakin, asil, aydınlık ve sıcak atmosferini yansıtır.
///
/// Renk Kullanım Oranları:
/// - %65 açık fildişi (Ivory)
/// - %25 parşömen ve müze beyazı yüzey (Parchment, Museum White)
/// - %10 bronz, ceviz ve zeytin vurguları (Antique Bronze, Deep Walnut, Archive Olive)
class AppColors {
  // Özel yapıcı; bu sınıfın örneklenmesini engeller.
  AppColors._();

  /// Ana arka plan rengi (#F6F1E7) — Fildişi (Ivory)
  /// Tüm scaffold ve sayfa zeminlerinde sakin ve göz yormayan tarihi bir fon oluşturur.
  static const Color ivory = Color(0xFFF6F1E7);

  /// Kart ve yüzey rengi (#FFFCF7) — Müze Beyazı (Museum White)
  /// Kartlar, diyaloglar ve alt paneller için sıcak, saf ve temiz bir zemin rengidir.
  static const Color museumWhite = Color(0xFFFFFCF7);

  /// İkincil yüzey rengi (#EDE2D0) — Parşömen (Parchment)
  /// Rozetler, ikincil butonlar ve bilgi kutularında eski kâğıt/parşömen dokusu sağlar.
  static const Color parchment = Color(0xFFEDE2D0);

  /// Kenarlık ve ayırıcı rengi (#C9BBA5) — Müze Taşı (Museum Stone)
  /// Kart sınırları, input çerçeveleri ve bölücü çizgilerde kullanılan traverten tonu.
  static const Color museumStone = Color(0xFFC9BBA5);

  /// Ana metin, başlık ve birincil CTA (#332C27) — Koyu Ceviz (Deep Walnut)
  /// Yüksek kontrastlı, okunabilir, zengin ve ahşap dokulu koyu kahve tonu.
  static const Color deepWalnut = Color(0xFF332C27);

  /// Vurgu rengi (#8B6B43) — Antik Bronz (Antique Bronze)
  /// Seçili durumlar, simge vurguları, etiketler ve özel aksiyonlarda kullanılır.
  static const Color antiqueBronze = Color(0xFF8B6B43);

  /// İkincil vurgu rengi (#69715D) — Arşiv Zeytini (Archive Olive)
  /// Doğa, arşiv ve dinginlik hissi veren sakin yeşil tonu.
  static const Color archiveOlive = Color(0xFF69715D);

  /// Sınırlı dikkat/hata/uyarı rengi (#AA6753) — Pişmiş Toprak (Terracotta)
  /// Beğeni kalbi, silme işlemleri, doğrulama hataları ve kritik uyarılarda kullanılır.
  static const Color terracotta = Color(0xFFAA6753);

  /// İkincil gövde ve alt yazı metin rengi (#695F56) — Koyu Gri/Kahve
  /// Tarih, sayaç, açıklama ve ipucu metinlerinde yumuşak kontrast sağlar.
  static const Color secondaryText = Color(0xFF695F56);
}

