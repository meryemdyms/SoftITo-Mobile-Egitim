import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_dialog.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../controllers/customer_profile_controller.dart';

class CustomerProfileView extends StatefulWidget {
  const CustomerProfileView({super.key});

  @override
  State<CustomerProfileView> createState() => _CustomerProfileViewState();
}

class _CustomerProfileViewState extends State<CustomerProfileView> {
  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  void _loadProfile() {
    final authCtrl = context.read<AuthController>();
    if (authCtrl.currentUser != null) {
      context.read<CustomerProfileController>().loadProfile(
        authCtrl.currentUser!.id,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authCtrl = context.watch<AuthController>();
    final profileCtrl = context.watch<CustomerProfileController>();

    if (!authCtrl.isAuthenticated) {
      return Scaffold(
        appBar: AppBar(title: const Text('Profilim')),
        body: Center(
          child: Padding(
            padding: AppSpacing.edgeInsetsLg,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.person_outline_rounded,
                  size: 64,
                  color: AppColors.muted,
                ),
                const SizedBox(height: AppSpacing.md),
                Text('Misafir Kullanıcı', style: AppTypography.titleLarge),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Rezervasyon yapmak ve işlemlerinizi takip etmek için giriş yapın veya yeni hesap oluşturun.',
                  textAlign: TextAlign.center,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.muted,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                AppButton(
                  label: 'Giriş Yap',
                  onPressed: () => context.push('/auth/login'),
                ),
                const SizedBox(height: AppSpacing.sm),
                AppButton(
                  label: 'Yeni Müşteri Kaydı',
                  variant: AppButtonVariant.outline,
                  onPressed: () => context.push('/auth/register-customer'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (profileCtrl.isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Profilim')),
        body: const AppLoading(message: 'Profil bilgileri yükleniyor...'),
      );
    }

    final user = authCtrl.currentUser!;
    final profile = profileCtrl.profile;

    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBar(
        title: const Text('Profilim'),
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
      body: SingleChildScrollView(
        padding: AppSpacing.edgeInsetsLg,
        child: Column(
          children: [
            // User Avatar & Name Card
            Container(
              width: double.infinity,
              padding: AppSpacing.edgeInsetsXl,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: AppRadius.radiusLg,
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    child: Text(
                      user.name.isNotEmpty ? user.name[0].toUpperCase() : 'M',
                      style: AppTypography.displayMedium.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(user.name, style: AppTypography.titleLarge),
                  const SizedBox(height: 4),
                  Text(user.email, style: AppTypography.bodySmall),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: AppRadius.radiusFull,
                    ),
                    child: Text(
                      user.role.label,
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Profile Details
            Container(
              padding: AppSpacing.edgeInsetsLg,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: AppRadius.radiusLg,
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Kişisel Bilgiler', style: AppTypography.titleMedium),
                  const SizedBox(height: AppSpacing.md),
                  _buildProfileRow('Telefon', user.phone),
                  const Divider(color: AppColors.border),
                  if (profile != null) ...[
                    _buildProfileRow(
                      'Doğum Tarihi',
                      DateFormatter.formatDate(profile.birthDate),
                    ),
                    const Divider(color: AppColors.border),
                    _buildProfileRow('Ehliyet Sınıfı', profile.licenceClass),
                    const Divider(color: AppColors.border),
                    _buildProfileRow(
                      'Ehliyet Veriliş Tarihi',
                      DateFormatter.formatDate(profile.issueDate),
                    ),
                    const Divider(color: AppColors.border),
                    _buildProfileRow(
                      'Sürücü Yaşı',
                      '${profile.ageAt(DateTime.now())} Yaş',
                    ),
                    const Divider(color: AppColors.border),
                    _buildProfileRow(
                      'Ehliyet Süresi',
                      '${profile.licenceYearsAt(DateTime.now())} Yıl',
                    ),
                  ] else ...[
                    Text(
                      'Profil detayları bulunamadı.',
                      style: AppTypography.bodySmall,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Logout Button
            AppButton(
              label: 'Oturumu Kapat',
              variant: AppButtonVariant.outline,
              icon: Icons.logout_rounded,
              onPressed: () => _handleLogout(context, authCtrl),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTypography.bodyMedium.copyWith(color: AppColors.muted),
          ),
          Text(value, style: AppTypography.labelLarge),
        ],
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
      message: 'Hesabınızdan çıkış yapmak istediğinize emin misiniz?',
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
