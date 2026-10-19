import 'package:flutter/material.dart';
import 'core/theme/theme_controller.dart';
import 'features/blood_request/controllers/blood_request_controller.dart';
import 'features/blood_request/views/blood_request_view.dart';
import 'features/donation_history/controllers/donation_history_controller.dart';
import 'features/donation_history/views/donation_history_view.dart';
import 'features/donation_stats/controllers/donation_stats_controller.dart';
import 'features/donation_stats/views/donation_stats_view.dart';
import 'features/donor_profile/controllers/donor_profile_controller.dart';
import 'features/donor_profile/views/donor_profile_view.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key, required this.themeController});

  final ThemeController themeController;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;
  late final BloodRequestController _bloodRequestController;
  late final DonationHistoryController _donationHistoryController;
  late final DonationStatsController _donationStatsController;
  late final DonorProfileController _donorProfileController;

  @override
  void initState() {
    super.initState();
    _bloodRequestController = BloodRequestController();
    _donorProfileController = DonorProfileController();
    _donationHistoryController = DonationHistoryController(
      onDonationAdded: (record) {
        _donorProfileController.recordDonation(record.date);
        _donationStatsController.calculateStats(
          _donationHistoryController.state.value.records,
        );
      },
    );
    _donationStatsController = DonationStatsController(
      initialRecords: _donationHistoryController.state.value.records,
    );
  }

  @override
  void dispose() {
    _bloodRequestController.dispose();
    _donationHistoryController.dispose();
    _donationStatsController.dispose();
    _donorProfileController.dispose();
    super.dispose();
  }

  void _onDestinationSelected(int index) {
    setState(() => _currentIndex = index);
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return BloodRequestView(controller: _bloodRequestController);
      case 1:
        return DonationHistoryView(controller: _donationHistoryController);
      case 2:
        return DonationStatsView(controller: _donationStatsController);
      case 3:
      default:
        return DonorProfileView(controller: _donorProfileController);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _AppShellAppBar(themeController: widget.themeController),
      body: _buildBody(),
      bottomNavigationBar: _AppShellNavBar(
        currentIndex: _currentIndex,
        onDestinationSelected: _onDestinationSelected,
      ),
    );
  }
}

class _AppShellAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppShellAppBar({required this.themeController});

  final ThemeController themeController;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AppBar(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.water_drop, color: colorScheme.primary),
          const SizedBox(width: 8),
          const Text('Kırmızı Çağrı'),
        ],
      ),
      actions: [
        ValueListenableBuilder<ThemeMode>(
          valueListenable: themeController.themeMode,
          builder: (context, mode, _) {
            final isDark = mode == ThemeMode.dark;
            return IconButton(
              icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
              tooltip: isDark ? 'Aydınlık Tema' : 'Koyu Tema',
              onPressed: themeController.toggleTheme,
            );
          },
        ),
      ],
    );
  }
}

class _AppShellNavBar extends StatelessWidget {
  const _AppShellNavBar({
    required this.currentIndex,
    required this.onDestinationSelected,
  });

  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onDestinationSelected,
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.campaign_outlined),
          selectedIcon: Icon(Icons.campaign),
          label: 'Çağrılar',
        ),
        NavigationDestination(
          icon: Icon(Icons.history_outlined),
          selectedIcon: Icon(Icons.history),
          label: 'Geçmiş',
        ),
        NavigationDestination(
          icon: Icon(Icons.insights_outlined),
          selectedIcon: Icon(Icons.insights),
          label: 'İstatistik',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: 'Profilim',
        ),
      ],
    );
  }
}
