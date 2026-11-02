import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';

/// Sayfa veya modül yüklenirken ortalanmış dönen gösterge ve açıklama metni sunan bileşen.
class AppLoading extends StatelessWidget {
  /// Göstergenin altında görüntülenecek opsiyonel yüklenme mesajı.
  final String? message;

  const AppLoading({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Tasarım rengiyle uyumlu dairesel ilerleme indikatörü
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
          if (message != null) ...[
            const SizedBox(height: AppSpacing.md),
            Text(
              message!,
              style: AppTypography.bodyMedium.copyWith(color: AppColors.muted),
            ),
          ],
        ],
      ),
    );
  }
}
