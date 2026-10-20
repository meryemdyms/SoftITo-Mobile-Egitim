import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';

enum AppButtonVariant { primary, secondary, outline, destructive }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool isLoading;
  final IconData? icon;
  final double? width;
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
    final bool isEnabled = onPressed != null && !isLoading;

    Color bg;
    Color fg;
    BorderSide? border;

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
