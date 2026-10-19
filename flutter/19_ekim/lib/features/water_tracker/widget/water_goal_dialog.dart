import 'package:flutter/material.dart';
import 'package:susadim/core/constants/app_colors.dart';

class WaterGoalDialog extends StatelessWidget {
  const WaterGoalDialog({
    required this.totalMl,
    required this.goalMl,
    super.key,
  });

  final int totalMl;
  final int goalMl;

  static Future<void> show(
    BuildContext context, {
    required int totalMl,
    required int goalMl,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => WaterGoalDialog(totalMl: totalMl, goalMl: goalMl),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        decoration: BoxDecoration(
          color: AppColors.obsidianSurface,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: AppColors.neonCyan, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: AppColors.neonCyan.withValues(alpha: 0.18),
              blurRadius: 24,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const _TrophyIcon(),
            const SizedBox(height: 18),
            const _DialogTitle(),
            const SizedBox(height: 10),
            _DialogMessage(totalMl: totalMl, goalMl: goalMl),
            const SizedBox(height: 24),
            _ConfirmButton(onPressed: () => Navigator.of(context).pop()),
          ],
        ),
      ),
    );
  }
}

class _TrophyIcon extends StatelessWidget {
  const _TrophyIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 76,
      height: 76,
      decoration: BoxDecoration(
        color: AppColors.neonCyan.withValues(alpha: 0.15),
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.neonCyan, width: 2),
      ),
      child: const Icon(
        Icons.emoji_events_rounded,
        color: AppColors.neonCyan,
        size: 42,
      ),
    );
  }
}

class _DialogTitle extends StatelessWidget {
  const _DialogTitle();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Tebrikler! 🎉',
          style: theme.textTheme.headlineMedium?.copyWith(
            color: AppColors.neonCyan,
            fontWeight: FontWeight.w800,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          'Günlük Su Hedefine Ulaştın',
          style: theme.textTheme.titleMedium?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _DialogMessage extends StatelessWidget {
  const _DialogMessage({required this.totalMl, required this.goalMl});

  final int totalMl;
  final int goalMl;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      'Bugün hedeflenen $goalMl ml su miktarını $totalMl ml ile başarıyla tamamladın. Harika bir iş başardın!',
      style: theme.textTheme.bodyMedium?.copyWith(
        color: AppColors.textSecondary,
        height: 1.4,
      ),
      textAlign: TextAlign.center,
    );
  }
}

class _ConfirmButton extends StatelessWidget {
  const _ConfirmButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.neonCyan,
          foregroundColor: AppColors.obsidianBackground,
        ),
        child: const Text('Harika! Devam Et'),
      ),
    );
  }
}
