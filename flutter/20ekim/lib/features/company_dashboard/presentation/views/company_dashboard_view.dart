import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/app_dialog.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../controllers/company_dashboard_controller.dart';

class CompanyDashboardView extends StatefulWidget {
  const CompanyDashboardView({super.key});

  @override
  State<CompanyDashboardView> createState() => _CompanyDashboardViewState();
}

class _CompanyDashboardViewState extends State<CompanyDashboardView> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    final authCtrl = context.read<AuthController>();
    if (authCtrl.currentUser != null) {
      context.read<CompanyDashboardController>().loadDashboardData(
        authCtrl.currentUser!.id,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authCtrl = context.watch<AuthController>();
    final dashboardCtrl = context.watch<CompanyDashboardController>();

    if (dashboardCtrl.isLoading) {
      return const Scaffold(
        body: AppLoading(message: 'Firma yönetim paneli hazırlanıyor...'),
      );
    }

    final company = dashboardCtrl.company;

    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBar(
        title: Text(company?.name ?? 'Firma Paneli'),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.logout_rounded,
              color: AppColors.destructive,
            ),
            tooltip: 'Çıkış Yap',
            onPressed: () => _handleLogout(context, authCtrl),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => _loadData(),
        child: SingleChildScrollView(
          padding: AppSpacing.edgeInsetsLg,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Banner
              Container(
                padding: AppSpacing.edgeInsetsLg,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.ink, Color(0xFF1E293B)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: AppRadius.radiusLg,
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.white.withOpacity(0.1),
                      child: const Icon(
                        Icons.storefront_rounded,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Firma Yönetim Portalı',
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.primaryLight,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            company?.name ?? 'Firma',
                            style: AppTypography.titleLarge.copyWith(
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Yetkili: ${authCtrl.currentUser?.name}',
                            style: AppTypography.bodySmall.copyWith(
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Operasyonel İstatistikler
              Text(
                'Operasyonel Durum (Bugün)',
                style: AppTypography.titleMedium,
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Bugünkü Teslimat',
                      '${dashboardCtrl.todayPickupsCount}',
                      Icons.key_rounded,
                      AppColors.primary,
                      AppColors.infoBg,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: _buildStatCard(
                      'Bugünkü İade',
                      '${dashboardCtrl.todayReturnsCount}',
                      Icons.assignment_return_rounded,
                      AppColors.warning,
                      AppColors.warningBg,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Aktif Kiralamada',
                      '${dashboardCtrl.activeRentalsCount}',
                      Icons.directions_car_rounded,
                      AppColors.success,
                      AppColors.successBg,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: _buildStatCard(
                      'Bekleyen Onaylı',
                      '${dashboardCtrl.upcomingReservationsCount}',
                      Icons.schedule_rounded,
                      AppColors.ink,
                      AppColors.surfaceVariant,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),

              // Hızlı Modül Yönetimi
              Text('Yönetim Modülleri', style: AppTypography.titleMedium),
              const SizedBox(height: AppSpacing.md),
              _buildNavTile(
                title: 'Araç Filosu Yönetimi',
                subtitle:
                    '${dashboardCtrl.vehicles.length} Araç Kayıtlı • Yeni araç ekle, düzenle, pasife al',
                icon: Icons.directions_car_outlined,
                onTap: () => context.push('/company/vehicles'),
              ),
              const SizedBox(height: AppSpacing.sm),
              _buildNavTile(
                title: 'Rezervasyon İşlemleri',
                subtitle:
                    '${dashboardCtrl.reservations.length} Rezervasyon • Teslim et, iade al veya iptal et',
                icon: Icons.book_online_outlined,
                onTap: () => context.push('/company/reservations'),
              ),
              const SizedBox(height: AppSpacing.sm),
              _buildNavTile(
                title: 'Kampanya Yönetimi',
                subtitle:
                    '${dashboardCtrl.campaigns.length} Kampanya • İndirim tanımla ve yayınla',
                icon: Icons.local_offer_outlined,
                onTap: () => context.push('/company/campaigns'),
              ),
              const SizedBox(height: AppSpacing.sm),
              _buildNavTile(
                title: 'Firma Vitrin & Profil Düzenle',
                subtitle:
                    'İletişim, çalışma saatleri, ofis adresi ve tanıtım metni',
                icon: Icons.store_outlined,
                onTap: () => context.push('/company/profile-editor'),
              ),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
    Color bg,
  ) {
    return Container(
      padding: AppSpacing.edgeInsetsMd,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.radiusMd,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: AppTypography.bodySmall),
              CircleAvatar(
                radius: 14,
                backgroundColor: bg,
                child: Icon(icon, size: 16, color: color),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            value,
            style: AppTypography.displayMedium.copyWith(color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildNavTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.radiusMd,
        border: Border.all(color: AppColors.border),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primary.withOpacity(0.1),
          child: Icon(icon, color: AppColors.primary),
        ),
        title: Text(title, style: AppTypography.labelLarge),
        subtitle: Text(subtitle, style: AppTypography.bodySmall),
        trailing: const Icon(
          Icons.chevron_right_rounded,
          color: AppColors.muted,
        ),
        onTap: onTap,
      ),
    );
  }

  Future<void> _handleLogout(
    BuildContext context,
    AuthController authCtrl,
  ) async {
    final confirmed = await AppDialog.showConfirm(
      context,
      title: 'Çıkış Yap',
      message: 'Firma yönetim panelinden çıkmak istediğinize emin misiniz?',
      confirmLabel: 'Çıkış Yap',
      isDestructive: true,
    );

    if (confirmed == true && mounted) {
      await authCtrl.logout();
      if (mounted) {
        context.go('/');
      }
    }
  }
}
