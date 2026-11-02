import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';

/// Uygulama içi yüzen (floating) bilgilendirme bildirimleri (SnackBar) gösterim yardımcısı.
class AppSnackbar {
  AppSnackbar._();

  /// Başarılı işlem bildirimi gösterir (Yeşil arka plan).
  static void showSuccess(BuildContext context, String message) {
    _show(
      context,
      message: message,
      backgroundColor: AppColors.success,
      icon: Icons.check_circle_outline_rounded,
    );
  }

  /// Hata veya uyarı bildirimi gösterir (Kırmızı arka plan).
  static void showError(BuildContext context, String message) {
    _show(
      context,
      message: message,
      backgroundColor: AppColors.destructive,
      icon: Icons.error_outline_rounded,
    );
  }

  /// Genel bilgilendirme bildirimi gösterir (Koyu lacivert/mürekkep arka plan).
  static void showInfo(BuildContext context, String message) {
    _show(
      context,
      message: message,
      backgroundColor: AppColors.ink,
      icon: Icons.info_outline_rounded,
    );
  }

  /// Ortak SnackBar gösterim mantığı.
  static void _show(
    BuildContext context, {
    required String message,
    required Color backgroundColor,
    required IconData icon,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.radiusMd),
        margin: const EdgeInsets.all(AppSpacing.md),
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                message,
                style: AppTypography.bodyMedium.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
