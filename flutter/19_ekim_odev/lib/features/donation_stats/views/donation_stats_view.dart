import 'package:flutter/material.dart';
import '../controllers/donation_stats_controller.dart';
import '../models/donation_stats_model.dart';
import '../widgets/donation_stats_widgets.dart';

class DonationStatsView extends StatefulWidget {
  const DonationStatsView({super.key, this.controller});

  final DonationStatsController? controller;

  @override
  State<DonationStatsView> createState() => _DonationStatsViewState();
}

class _DonationStatsViewState extends State<DonationStatsView> {
  late final DonationStatsController _controller;
  bool _ownsController = false;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _controller = widget.controller!;
    } else {
      _controller = DonationStatsController();
      _ownsController = true;
    }
  }

  @override
  void dispose() {
    if (_ownsController) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bağış ve Etki İstatistikleri'),
      ),
      body: ValueListenableBuilder<DonationStats>(
        valueListenable: _controller.state,
        builder: (context, stats, _) {
          return ListView(
            padding: const EdgeInsets.symmetric(vertical: 8),
            children: [
              NextDonationCountdownCard(stats: stats),
              Row(
                children: [
                  Expanded(
                    child: StatMetricTile(
                      title: 'Kurtarılan Can',
                      value: '${stats.livesSaved}',
                      icon: Icons.favorite,
                      iconColor: colorScheme.primary,
                    ),
                  ),
                  Expanded(
                    child: StatMetricTile(
                      title: 'Toplam Bağış',
                      value: '${stats.totalDonations}',
                      icon: Icons.volunteer_activism,
                      iconColor: colorScheme.secondary,
                    ),
                  ),
                ],
              ),
              BloodFlowLineChartCard(stats: stats),
            ],
          );
        },
      ),
    );
  }
}
