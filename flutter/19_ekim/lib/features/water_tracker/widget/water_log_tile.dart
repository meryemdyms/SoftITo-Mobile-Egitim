import 'package:flutter/material.dart';
import 'package:susadim/core/constants/app_colors.dart';
import 'package:susadim/features/water_tracker/models/water_log.dart';

class WaterLogTile extends StatelessWidget {
  const WaterLogTile({
    required this.log,
    required this.onDelete,
    super.key,
  });

  final WaterLog log;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final timeStr = _formatTime(log.timestamp);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.obsidianCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.obsidianBorder),
      ),
      child: Row(
        children: [
          const Icon(Icons.water_drop_outlined, color: AppColors.neonCyan, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(log.type.displayName, style: theme.textTheme.bodyLarge),
                Text(timeStr, style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
          Text(
            '+${log.amountMl} ml',
            style: const TextStyle(
              color: AppColors.neonCyan,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close_rounded, size: 18, color: AppColors.textMuted),
            onPressed: onDelete,
            tooltip: 'Sil',
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final hour = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
