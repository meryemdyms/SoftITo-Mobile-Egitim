import 'package:flutter/material.dart';

/// Uygulamanın merkezi renk paleti ve tasarım belirteçleri (Design Tokens).
///
/// Renklerin doğrudan widget'larda hardcode edilmesini önlemek ve
/// tutarlı bir kurumsal kimlik sağlamak amacıyla kullanılır.
class AppColors {
  AppColors._();

  // Proje şartnamesinde tanımlanan ana marka renkleri
  /// Canlı mavi vurgu rengi (Primary Accent).
  static const Color primary = Color(0xFF2563EB);

  /// Açık mavi varyant; odak ve konteyner arka planlarında kullanılır.
  static const Color primaryLight = Color(0xFF60A5FA);

  /// Koyu mavi varyant; basılı durumlar ve koyu vurgularda kullanılır.
  static const Color primaryDark = Color(0xFF1D4ED8);

  /// Koyu metin ve ana başlıklar için mürekkep rengi (Deep Ink).
  static const Color ink = Color(0xFF0B1220);

  /// Sayfa gövde arka planı (Canvas).
  static const Color canvas = Color(0xFFF8FAFC);

  /// Kart, dialog ve modal yüzey rengi (Surface).
  static const Color surface = Color(0xFFFFFFFF);

  /// İkincil kart ve ayrım arka planı (Surface Variant).
  static const Color surfaceVariant = Color(0xFFF1F5F9);

  /// İkincil açıklamalar ve pasif ikonlar için soluk gri (Slate Muted).
  static const Color muted = Color(0xFF64748B);

  /// Kenarlık ve ayırıcı çizgi rengi (Border).
  static const Color border = Color(0xFFE2E8F0);

  // Durum Bildirim Renkleri (Status Colors)
  /// Başarılı işlemler ve onay rozetleri (Emerald).
  static const Color success = Color(0xFF10B981);

  /// Başarılı durum açık arka planı.
  static const Color successBg = Color(0xFFECFDF5);

  /// Uyarı bildirimleri ve bekleme durumları (Amber).
  static const Color warning = Color(0xFFF59E0B);

  /// Uyarı durum açık arka planı.
  static const Color warningBg = Color(0xFFFFFBEB);

  /// Hata, iptal ve kritik eylemler için kırmızı (Destructive Red).
  static const Color destructive = Color(0xFFEF4444);

  /// Hata durum açık arka planı.
  static const Color destructiveBg = Color(0xFFFEF2F2);

  /// Bilgilendirme ve ipucu rozetleri (Sky Blue).
  static const Color info = Color(0xFF0EA5E9);

  /// Bilgi durum açık arka planı.
  static const Color infoBg = Color(0xFFF0F9FF);
}
