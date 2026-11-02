import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';

/// Uygulama genelinde formlarda kullanılan etiketli standart metin giriş alanı bileşeni.
///
/// Hata mesajları, ikonlar, çok satırlılık ve tıklanabilirlik özelliklerini kapsar.
class AppTextField extends StatelessWidget {
  /// Giriş alanının üzerinde görüntülenecek başlık etiketi.
  final String? label;

  /// Giriş alanı içinde soluk gösterilecek ipucu metni.
  final String? hint;

  /// Metin kontrolcüsü.
  final TextEditingController? controller;

  /// İlk değer (controller kullanılmadığında geçerlidir).
  final String? initialValue;

  /// Form doğrulama fonksiyonu.
  final FormFieldValidator<String>? validator;

  /// Şifre girişleri için metni gizleme durumu.
  final bool obscureText;

  /// Klavye türü (sayısal, e-posta, metin vb.).
  final TextInputType keyboardType;

  /// Klavye eylem butonu (ileri, bitti vb.).
  final TextInputAction textInputAction;

  /// Giriş alanının sol başına eklenecek ikon veya widget.
  final Widget? prefixIcon;

  /// Giriş alanının sağ sonuna eklenecek ikon veya widget.
  final Widget? suffixIcon;

  /// Maksimum satır sayısı.
  final int maxLines;

  /// Salt okunur durumu (tıklanabilir seçim pencereleri için).
  final bool readOnly;

  /// Alana tıklandığında tetiklenecek fonksiyon.
  final VoidCallback? onTap;

  /// Metin değiştiğinde tetiklenecek dinleyici.
  final ValueChanged<String>? onChanged;

  /// Giriş alanının aktiflik durumu.
  final bool enabled;

  const AppTextField({
    super.key,
    this.label,
    this.hint,
    this.controller,
    this.initialValue,
    this.validator,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.readOnly = false,
    this.onTap,
    this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Alan etiketi varsa yukarıda gösterilir
        if (label != null) ...[
          Text(
            label!,
            style: AppTypography.labelLarge.copyWith(color: AppColors.ink),
          ),
          const SizedBox(height: AppSpacing.xs),
        ],
        // Standart TextFormField bileşeni
        TextFormField(
          controller: controller,
          initialValue: initialValue,
          validator: validator,
          obscureText: obscureText,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          maxLines: maxLines,
          readOnly: readOnly,
          onTap: onTap,
          onChanged: onChanged,
          enabled: enabled,
          style: AppTypography.bodyMedium,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }
}
