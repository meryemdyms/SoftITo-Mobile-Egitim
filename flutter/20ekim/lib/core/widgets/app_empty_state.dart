import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';
import 'app_button.dart';

/// Liste veya ekranlarda veri bulunamadığında (boş durum) gösterilen görsel ve açıklamalı bileşen.
class AppEmptyState extends StatelessWidget {
  /// Boş durum ana başlığı.
  final String title;

  /// Açıklayıcı alt metin.
  final String? description;

  /// Merkezde gösterilecek ikon (varsayılan: inbox_outlined).
  final IconData icon;

  /// Kullanıcıyı yönlendirecek aksiyon butonu metni (opsiyonel).
  final String? actionLabel;

  /// Aksiyon butonuna tıklandığında çalışacak fonksiyon.
  final VoidCallback? onAction;

  const AppEmptyState({
    super.key,
    required this.title,
    this.description,
    this.icon = Icons.inbox_outlined,
    this.actionLabel,
    this.onAction,
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
            // İkon kapsayıcı dairesel arka plan
            Container(
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: const BoxDecoration(
                color: AppColors.surfaceVariant,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 48, color: AppColors.muted),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTypography.titleLarge,
            ),
            if (description != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                description!,
                textAlign: TextAlign.center,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.muted,
                ),
              ),
            ],
            // Opsiyonel aksiyon butonu (örn. "Filtreleri Temizle", "Araç Ekle")
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: AppSpacing.xl),
              AppButton(label: actionLabel!, onPressed: onAction, width: 200),
            ],
          ],
        ),
      ),
    );
  }
}
