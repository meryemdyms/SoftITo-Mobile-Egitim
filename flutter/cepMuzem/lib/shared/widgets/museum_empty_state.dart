import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_dimensions.dart';
import '../../app/theme/app_typography.dart';
import 'archive_button.dart';

class MuseumEmptyState extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  const MuseumEmptyState({
    super.key,
    required this.title,
    required this.message,
    this.icon = Icons.museum_outlined,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.space24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                color: AppColors.parchment,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 32, color: AppColors.antiqueBronze),
            ),
            const SizedBox(height: AppDimensions.space16),
            Text(
              title,
              style: AppTypography.sectionTitle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.space8),
            Text(
              message,
              style: AppTypography.bodySecondary,
              textAlign: TextAlign.center,
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: AppDimensions.space20),
              ArchiveButton(
                label: actionLabel!,
                onPressed: onAction,
                variant: ArchiveButtonVariant.secondary,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class MuseumSectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? trailing;

  const MuseumSectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.space12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.sectionTitle),
                if (subtitle != null) ...[
                  const SizedBox(height: AppDimensions.space4),
                  Text(subtitle!, style: AppTypography.caption),
                ],
              ],
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}
