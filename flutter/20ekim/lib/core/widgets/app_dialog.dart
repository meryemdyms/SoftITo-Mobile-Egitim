import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';
import 'app_button.dart';

class AppDialog {
  AppDialog._();

  static Future<bool?> showConfirm(
    BuildContext context, {
    required String title,
    required String message,
    String confirmLabel = 'Onayla',
    String cancelLabel = 'Vazgeç',
    bool isDestructive = false,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.radiusLg),
        title: Text(title, style: AppTypography.titleLarge),
        content: Text(
          message,
          style: AppTypography.bodyMedium.copyWith(color: AppColors.muted),
        ),
        actionsPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: AppButton(
                  label: cancelLabel,
                  variant: AppButtonVariant.secondary,
                  onPressed: () => Navigator.of(ctx).pop(false),
                  height: 40,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: AppButton(
                  label: confirmLabel,
                  variant: isDestructive
                      ? AppButtonVariant.destructive
                      : AppButtonVariant.primary,
                  onPressed: () => Navigator.of(ctx).pop(true),
                  height: 40,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
