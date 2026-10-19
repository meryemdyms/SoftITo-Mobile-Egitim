import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/extensions/context_extensions.dart';
import '../models/water_tracker_model.dart';

/// Günlük su tüketim geçmişi listesini gösteren modüler bileşen.
class WaterHistorySection extends StatelessWidget {
  final List<WaterLogItem> logs;
  final VoidCallback onUndo;

  const WaterHistorySection({
    super.key,
    required this.logs,
    required this.onUndo,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context),
        const SizedBox(height: 12),
        if (logs.isEmpty) _buildEmptyState(context) else _buildList(context),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Bugünkü Kayıtlar',
          style: context.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        if (logs.isNotEmpty)
          TextButton.icon(
            onPressed: onUndo,
            style: TextButton.styleFrom(foregroundColor: AppColors.neonRose),
            icon: const Icon(Icons.undo_rounded, size: 16),
            label: const Text('Geri Al', style: TextStyle(fontWeight: FontWeight.w600)),
          ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: context.cardBorderColor),
      ),
      child: Center(
        child: Text(
          'Henüz su tüketimi girilmedi.',
          style: context.textTheme.bodyMedium,
        ),
      ),
    );
  }

  Widget _buildList(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: logs.length > 5 ? 5 : logs.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final log = logs[index];
        final timeStr =
            '${log.timestamp.hour.toString().padLeft(2, '0')}:${log.timestamp.minute.toString().padLeft(2, '0')}';
        final subColor = context.colorScheme.onSurface.withAlpha(160);

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: context.surfaceColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: context.cardBorderColor),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: context.primaryAccent.withAlpha(25),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.water_drop_rounded, color: context.primaryAccent, size: 18),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '+${log.amountMl} ml Su',
                    style: context.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ],
              ),
              Text(
                timeStr,
                style: context.textTheme.bodyMedium?.copyWith(
                      color: subColor,
                    ),
              ),
            ],
          ),
        );
      },
    );
  }
}
