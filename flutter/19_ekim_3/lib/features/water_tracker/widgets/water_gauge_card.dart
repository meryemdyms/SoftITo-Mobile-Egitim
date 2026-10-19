import 'package:flutter/material.dart';
import '../../../core/extensions/context_extensions.dart';
import '../models/water_tracker_model.dart';

/// Günlük su tüketim oranını gösteren dairesel neon/okyanus gösterge kartı.
class WaterGaugeCard extends StatelessWidget {
  final WaterTrackerModel model;

  const WaterGaugeCard({
    super.key,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    final progress = model.progress;
    final percent = (progress * 100).toInt();

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: context.cardBorderColor),
        boxShadow: [
          BoxShadow(
            color: context.primaryAccent.withAlpha(context.isDarkMode ? 20 : 15),
            blurRadius: 24,
            spreadRadius: 0,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildCircularIndicator(context, progress, percent),
          const SizedBox(height: 20),
          _buildInfoRow(context),
        ],
      ),
    );
  }

  Widget _buildCircularIndicator(BuildContext context, double progress, int percent) {
    return SizedBox(
      height: 180,
      width: 180,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            height: 170,
            width: 170,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 14,
              backgroundColor: context.surfaceElevatedColor,
              valueColor: AlwaysStoppedAnimation<Color>(context.primaryAccent),
              strokeCap: StrokeCap.round,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.water_drop_rounded, color: context.primaryAccent, size: 32),
              const SizedBox(height: 4),
              Text(
                '${model.currentWaterMl} ml',
                style: context.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              Text(
                '%$percent Tamamlandı',
                style: context.textTheme.bodyMedium?.copyWith(
                      color: context.primaryAccent,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatItem(context, 'Hedef', '${model.dailyGoalWaterMl} ml', Icons.flag_rounded),
        Container(width: 1, height: 28, color: context.cardBorderColor),
        _buildStatItem(context, 'Kalan', '${model.remainingMl} ml', Icons.timelapse_rounded),
      ],
    );
  }

  Widget _buildStatItem(BuildContext context, String label, String value, IconData icon) {
    final subColor = context.colorScheme.onSurface.withAlpha(160);

    return Row(
      children: [
        Icon(icon, size: 18, color: subColor),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: context.textTheme.bodyMedium?.copyWith(color: subColor)),
            Text(
              value,
              style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ],
        ),
      ],
    );
  }
}
