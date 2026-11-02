import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_dimensions.dart';
import '../../app/theme/app_typography.dart';

/// Arşiv Butonu Görsel Varyantları
enum ArchiveButtonVariant {
  /// Birincil buton: Koyu ceviz arka plan, beyaz metin (ana aksiyonlar)
  primary,

  /// İkincil buton: Parşömen arka plan, koyu ceviz metin, taş kenarlık
  secondary,

  /// Çerçeveli buton: Şeffaf arka plan, koyu ceviz kenarlık ve metin
  outline,
}

/// Cep Müzem — Özel Arşiv Butonu Bileşeni (ArchiveButton)
///
/// museum-design-system kuralları:
/// - 12dp köşe yuvarlaklığı (button radius)
/// - 44dp minimum dokunma hedefi (erişilebilirlik standardı)
/// - Yükleniyor durumunda dönen belirteç (CircularProgressIndicator)
/// - İsteğe bağlı sol simge desteği
class ArchiveButton extends StatelessWidget {
  /// Buton üzerinde görüntülenecek metin
  final String label;

  /// Butona tıklandığında tetiklenen geri çağrı fonksiyonu
  final VoidCallback? onPressed;

  /// Buton metninin solunda gösterilecek isteğe bağlı simge
  final IconData? icon;

  /// Yükleniyor durumu aktif mi (aktifken tıklama devre dışı bırakılır)
  final bool isLoading;

  /// Butonun görsel stil varyantı (primary, secondary, outline)
  final ArchiveButtonVariant variant;

  const ArchiveButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.variant = ArchiveButtonVariant.primary,
  });

  @override
  Widget build(BuildContext context) {
    // Yükleniyorken tıklanma devre dışı bırakılır
    final effectiveOnPressed = isLoading ? null : onPressed;

    Color backgroundColor;
    Color foregroundColor;
    BorderSide? borderSide;

    // Seçili varyanta göre renkler ve kenarlık belirlenir
    switch (variant) {
      case ArchiveButtonVariant.primary:
        backgroundColor = AppColors.deepWalnut;
        foregroundColor = AppColors.museumWhite;
        borderSide = BorderSide.none;
        break;
      case ArchiveButtonVariant.secondary:
        backgroundColor = AppColors.parchment;
        foregroundColor = AppColors.deepWalnut;
        borderSide = const BorderSide(color: AppColors.museumStone);
        break;
      case ArchiveButtonVariant.outline:
        backgroundColor = Colors.transparent;
        foregroundColor = AppColors.deepWalnut;
        borderSide = const BorderSide(color: AppColors.deepWalnut, width: 1.2);
        break;
    }

    return SizedBox(
      // Erişilebilir 44dp minimum dokunma alanı yüksekliği
      height: AppDimensions.minTouchTarget,
      child: ElevatedButton(
        onPressed: effectiveOnPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          elevation: 0,
          side: borderSide,
          shape: RoundedRectangleBorder(
            borderRadius: AppDimensions.buttonBorderRadius,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.space20,
            vertical: AppDimensions.space8,
          ),
        ),
        child: isLoading
            // Yükleniyor durumu: Dairesel yükleme çarkı
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(foregroundColor),
                ),
              )
            // Normal durum: Simge ve etiket metni
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 18, color: foregroundColor),
                    const SizedBox(width: AppDimensions.space8),
                  ],
                  Text(
                    label,
                    style: AppTypography.buttonText.copyWith(
                      color: foregroundColor,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

