import 'package:flutter/material.dart';
import 'package:susadim/core/constants/app_colors.dart';
import 'package:susadim/features/water_tracker/controller/water_tracker_controller.dart';
import 'package:susadim/features/water_tracker/widget/water_gauge_card.dart';
import 'package:susadim/features/water_tracker/widget/water_log_tile.dart';
import 'package:susadim/features/water_tracker/widget/water_metrics_row.dart';
import 'package:susadim/features/water_tracker/widget/water_quick_actions.dart';

class WaterTrackerView extends StatelessWidget {
  const WaterTrackerView({required this.controller, super.key});

  final WaterTrackerController controller;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          children: [
            WaterGaugeCard(controller: controller),
            const SizedBox(height: 14),
            WaterMetricsRow(controller: controller),
            const SizedBox(height: 20),
            WaterQuickActions(controller: controller),
            const SizedBox(height: 20),
            _RecentLogsHeader(onReset: controller.reset),
            const SizedBox(height: 8),
            _LogsList(controller: controller),
          ],
        );
      },
    );
  }
}

class _RecentLogsHeader extends StatelessWidget {
  const _RecentLogsHeader({required this.onReset});

  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            'Bugünkü Kayıtlar',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        TextButton(
          onPressed: onReset,
          child: const Text('Sıfırla', style: TextStyle(color: AppColors.textMuted)),
        ),
      ],
    );
  }
}

class _LogsList extends StatelessWidget {
  const _LogsList({required this.controller});

  final WaterTrackerController controller;

  @override
  Widget build(BuildContext context) {
    if (controller.logs.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: Text(
            'Henüz su kaydı eklenmedi.',
            style: TextStyle(color: AppColors.textMuted),
          ),
        ),
      );
    }

    return Column(
      children: controller.logs.map((log) {
        return WaterLogTile(
          key: ValueKey(log.id),
          log: log,
          onDelete: () => controller.removeLog(log.id),
        );
      }).toList(growable: false),
    );
  }
}
