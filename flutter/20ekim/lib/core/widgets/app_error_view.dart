import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';
import 'app_button.dart';

/// Hata durumlarında ekranın ortasında açıklama ve tekrar deneme butonu gösteren widget.
class AppErrorView extends StatelessWidget {
  /// Gösterilecek hata mesajı.
  final String message;

  /// Tekrar dene butonuna tıklandığında çalışacak fonksiyon. Null ise buton gizlenir.
  final VoidCallback? onRetry;

  /// Tekrar dene butonu metni (varsayılan: 'Tekrar Dene').
  final String retryLabel;

  const AppErrorView({
    super.key,
    required this.message,
    this.onRetry,
    this.retryLabel = 'Tekrar Dene',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppSpacing.edgeInsetsXl,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Kırmızı dairesel hata ikonu kapsayıcısı
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: const BoxDecoration(
                color: AppColors.destructiveBg,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                size: 40,
                color: AppColors.destructive,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            const Text('Bir Hata Oluştu', style: AppTypography.titleLarge),
            const SizedBox(height: AppSpacing.sm),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium.copyWith(color: AppColors.muted),
            ),
            // Tekrar deneme butonu
            if (onRetry != null) ...[
              const SizedBox(height: AppSpacing.xl),
              AppButton(
                label: retryLabel,
                variant: AppButtonVariant.outline,
                onPressed: onRetry,
                width: 160,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
