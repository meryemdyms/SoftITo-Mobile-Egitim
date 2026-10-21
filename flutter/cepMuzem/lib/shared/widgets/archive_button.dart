import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_dimensions.dart';
import '../../app/theme/app_typography.dart';

enum ArchiveButtonVariant { primary, secondary, outline }

class ArchiveButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
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
    final effectiveOnPressed = isLoading ? null : onPressed;

    Color backgroundColor;
    Color foregroundColor;
    BorderSide? borderSide;

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
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(foregroundColor),
                ),
              )
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
