import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';

/// Buton görsel stillerini belirleyen varyant türleri.
enum AppButtonVariant {
  /// Birincil vurgulu buton (mavi arka plan, beyaz metin).
  primary,

  /// İkincil buton (açık gri arka plan, koyu metin).
  secondary,

  /// Çerçeveli buton (şeffaf arka plan, renkli kenarlık).
  outline,

  /// Kritik veya silme eylemleri için tehlike butonu (kırmızı).
  destructive,
}

/// Uygulama genelinde kullanılan, erişilebilir (min. 48px dokunma alanı) standart buton bileşeni.
///
/// Yüklenme (loading) durumu, ikon desteği ve farklı görsel varyantları yönetir.
class AppButton extends StatelessWidget {
  /// Buton üzerinde gösterilecek metin etiketi.
  final String label;

  /// Tıklama geri çağrım fonksiyonu. Null ise buton devre dışı (disabled) olur.
  final VoidCallback? onPressed;

  /// Butonun görsel stili (varsayılan: primary).
  final AppButtonVariant variant;

  /// İşlem devam ederken buton içinde dönen yükleme göstergesi gösterir.
  final bool isLoading;

  /// Metnin solunda yer alacak opsiyonel ikon.
  final IconData? icon;

  /// Özel genişlik değeri (boş bırakılırsa tam genişlik - double.infinity alır).
  final double? width;

  /// Buton yüksekliği (varsayılan: 48.0 logical pixel).
  final double height;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.isLoading = false,
    this.icon,
    this.width,
    this.height = 48.0,
  });

  @override
  Widget build(BuildContext context) {
    // Butonun aktif olup olmadığını belirler
    final bool isEnabled = onPressed != null && !isLoading;

    Color bg;
    Color fg;
    BorderSide? border;

    // Seçilen varyanta ve aktiflik durumuna göre renklerin belirlenmesi
    switch (variant) {
      case AppButtonVariant.primary:
        bg = isEnabled ? AppColors.primary : AppColors.muted.withOpacity(0.4);
        fg = Colors.white;
        border = null;
        break;
      case AppButtonVariant.secondary:
        bg = isEnabled
            ? AppColors.surfaceVariant
            : AppColors.surfaceVariant.withOpacity(0.5);
        fg = isEnabled ? AppColors.ink : AppColors.muted;
        border = null;
        break;
      case AppButtonVariant.outline:
        bg = Colors.transparent;
        fg = isEnabled ? AppColors.primary : AppColors.muted;
        border = BorderSide(
          color: isEnabled ? AppColors.primary : AppColors.border,
        );
        break;
      case AppButtonVariant.destructive:
        bg = isEnabled
            ? AppColors.destructive
            : AppColors.destructive.withOpacity(0.4);
        fg = Colors.white;
        border = null;
        break;
    }

    // Buton içeriği: Yükleniyorsa CircularProgressIndicator, değilse ikon ve metin
    Widget content = isLoading
        ? SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2.2,
              valueColor: AlwaysStoppedAnimation<Color>(fg),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18, color: fg),
                const SizedBox(width: AppSpacing.sm),
              ],
              Text(label, style: AppTypography.labelLarge.copyWith(color: fg)),
            ],
          );

    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: Material(
        color: bg,
        borderRadius: AppRadius.radiusMd,
        shape: border != null
            ? RoundedRectangleBorder(
                borderRadius: AppRadius.radiusMd,
                side: border,
              )
            : null,
        child: InkWell(
          borderRadius: AppRadius.radiusMd,
          onTap: isEnabled ? onPressed : null,
          child: Center(child: content),
        ),
      ),
    );
  }
}
