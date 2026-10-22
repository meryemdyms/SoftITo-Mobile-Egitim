import 'package:flutter/material.dart';
import '../../../core/services/app_scope.dart';
import '../../../core/theme/app_colors.dart';
import '../../auth/views/login_view.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final appScope = AppScope.of(context);
    final user = appScope.authService.currentUser;
    final habitController = appScope.habitController;
    final collectionRepo = appScope.collectionRepository;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Profil'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Kullanıcı Kartı
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            (user?.firstName.isNotEmpty ?? false)
                                ? user!.firstName[0].toUpperCase()
                                : 'R',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: AppColors.accent,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user?.fullName ?? 'Ritmo Kullanıcısı',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              user?.email ?? 'demo@ritmo.app',
                              style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Genel Başarı İstatistikleri
              const Text(
                'Başarı Özeti',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.primary),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      title: 'Aktif Alışkanlık',
                      value: '${habitController.activeHabits.length}',
                      icon: Icons.checklist_rounded,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildStatCard(
                      title: 'Kazanılan Eser',
                      value: '${collectionRepo.getCompletedArtworks().length}',
                      icon: Icons.palette_outlined,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Bildirimler ve Ayarlar Bölümü
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.notifications_outlined, color: AppColors.primary),
                      title: const Text('Bildirim Tercihleri', style: TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: const Text('Alışkanlık hatırlatıcılarını yönet'),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Bildirim izinleri ve saatleri aktif olarak ayarlanabilir.')),
                        );
                      },
                    ),
                    const Divider(height: 1, thickness: 1, color: AppColors.border),
                    ListTile(
                      leading: const Icon(Icons.info_outline_rounded, color: AppColors.primary),
                      title: const Text('Ritmo Hakkında', style: TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: const Text('Sürüm 1.0.0 — Küçük adımlar, büyük değişimler'),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Çıkış Yap Butonu
              OutlinedButton.icon(
                onPressed: () async {
                  await appScope.authService.logout();
                  if (context.mounted) {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (_) => LoginView(authService: appScope.authService),
                      ),
                      (route) => false,
                    );
                  }
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  side: const BorderSide(color: AppColors.error),
                ),
                icon: const Icon(Icons.logout_rounded),
                label: const Text('Demo Oturumunu Kapat'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppColors.primary, size: 22),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.primary),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
