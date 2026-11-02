import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';

/// Tasarım sistemine uygun köşe yuvarlatmalı, kenarlıklı ve hafif gölgeli kart bileşeni.
///
/// Opsiyonel tıklanabilirlik (`onTap`) ve özel dolgu (`padding`) desteği sunar.
class AppCard extends StatelessWidget {
  /// Kart içinde yer alacak içerik widget'ı.
  final Widget child;

  /// Kartın iç dolgusu (varsayılan: 16px).
  final EdgeInsetsGeometry padding;

  /// Karta tıklandığında çalışacak geri çağrım fonksiyonu (InkWell dalgalanma efekti uygular).
  final VoidCallback? onTap;

  /// Kartın arka plan rengi (varsayılan: AppColors.surface).
  final Color? backgroundColor;

  /// Kartın kenarlık çizgisi.
  final Border? border;

  const AppCard({
    super.key,
    required this.child,
    this.padding = AppSpacing.edgeInsetsLg,
    this.onTap,
    this.backgroundColor,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.surface,
        borderRadius: AppRadius.radiusLg,
        border: border ?? Border.all(color: AppColors.border, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: AppRadius.radiusLg,
        child: InkWell(
          borderRadius: AppRadius.radiusLg,
          onTap: onTap,
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}
