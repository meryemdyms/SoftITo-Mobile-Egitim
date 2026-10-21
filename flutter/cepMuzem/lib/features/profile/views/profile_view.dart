import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_dimensions.dart';
import '../../../app/theme/app_typography.dart';
import '../../../shared/models/museum_model.dart';
import '../../../shared/repositories/museum_repository.dart';
import '../../../shared/widgets/museum_card.dart';
import '../../../shared/widgets/museum_empty_state.dart';
import '../../auth/viewmodels/auth_viewmodel.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<MuseumModel> _savedMuseums = [];
  List<MuseumModel> _userMuseums = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadProfileData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadProfileData() async {
    final authVm = Provider.of<AuthViewModel>(context, listen: false);
    final museumRepo = Provider.of<MuseumRepository>(context, listen: false);
    final userId = authVm.currentUser?.id ?? 'demo_user_001';

    final saved = await museumRepo.getSavedMuseums(userId);
    final mine = await museumRepo.getUserMuseums(userId);

    if (mounted) {
      setState(() {
        _savedMuseums = saved;
        _userMuseums = mine;
        _isLoading = false;
      });
    }
  }

  Future<void> _handleSignOut(BuildContext context) async {
    final authVm = Provider.of<AuthViewModel>(context, listen: false);
    await authVm.signOut();
    if (context.mounted) {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authVm = context.watch<AuthViewModel>();
    final user = authVm.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Küratör Profili', style: AppTypography.pageTitle),
        actions: [
          IconButton(
            tooltip: 'Oturumu Kapat',
            icon: const Icon(Icons.logout, color: AppColors.deepWalnut),
            onPressed: () => _handleSignOut(context),
          ),
          const SizedBox(width: AppDimensions.space8),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Profil Başlık Kartı
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.horizontalPadding,
                vertical: AppDimensions.space16,
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: AppColors.parchment,
                    backgroundImage: user?.photoUrl != null
                        ? NetworkImage(user!.photoUrl!)
                        : null,
                    child: user?.photoUrl == null
                        ? const Icon(
                            Icons.person,
                            size: 36,
                            color: AppColors.deepWalnut,
                          )
                        : null,
                  ),
                  const SizedBox(width: AppDimensions.space16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.fullName ?? 'Küratör',
                          style: AppTypography.pageTitle.copyWith(fontSize: 22),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          user?.email ?? 'demo@cepmuzem.com',
                          style: AppTypography.caption,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              '${user?.followerCount ?? 0} Takipçi',
                              style: AppTypography.caption.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Text(
                              '${user?.followingCount ?? 0} Takip Edilen',
                              style: AppTypography.caption.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Tab Bar
            TabBar(
              controller: _tabController,
              indicatorColor: AppColors.deepWalnut,
              labelColor: AppColors.deepWalnut,
              unselectedLabelColor: AppColors.secondaryText,
              labelStyle: AppTypography.caption.copyWith(
                fontWeight: FontWeight.w600,
              ),
              tabs: const [
                Tab(text: 'Kaydettiklerim'),
                Tab(text: 'Müzelerim'),
              ],
            ),

            // Tab View
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.antiqueBronze,
                      ),
                    )
                  : TabBarView(
                      controller: _tabController,
                      children: [
                        // Kaydettiklerim Tabı
                        _savedMuseums.isEmpty
                            ? const MuseumEmptyState(
                                title: 'Kaydedilen Müze Yok',
                                message: 'Beğendiğiniz sergileri yer imine ekleyerek burada saklayabilirsiniz.',
                                icon: Icons.bookmark_border,
                              )
                            : ListView.separated(
                                padding: const EdgeInsets.all(
                                  AppDimensions.horizontalPadding,
                                ),
                                itemCount: _savedMuseums.length,
                                separatorBuilder: (context, index) =>
                                    const SizedBox(
                                      height: AppDimensions.space16,
                                    ),
                                itemBuilder: (context, index) {
                                  final museum = _savedMuseums[index];
                                  return MuseumCard(
                                    museum: museum,
                                    onTap: () =>
                                        context.push('/museum/${museum.id}'),
                                    onToggleSave: () async {
                                      final repo =
                                          Provider.of<MuseumRepository>(
                                            context,
                                            listen: false,
                                          );
                                      await repo.toggleSaveMuseum(
                                        museumId: museum.id,
                                        userId: user?.id ?? 'demo_user_001',
                                      );
                                      _loadProfileData();
                                    },
                                  );
                                },
                              ),

                        // Müzelerim Tabı
                        _userMuseums.isEmpty
                            ? MuseumEmptyState(
                                title: 'Henüz Müze Oluşturulmadı',
                                message: 'Kendi kişisel koleksiyonunuzu oluşturarak ilk dijital serginizi açın.',
                                icon: Icons.museum_outlined,
                                actionLabel: 'Müze Oluştur',
                                onAction: () => context.go('/create'),
                              )
                            : ListView.separated(
                                padding: const EdgeInsets.all(
                                  AppDimensions.horizontalPadding,
                                ),
                                itemCount: _userMuseums.length,
                                separatorBuilder: (context, index) =>
                                    const SizedBox(
                                      height: AppDimensions.space16,
                                    ),
                                itemBuilder: (context, index) {
                                  final museum = _userMuseums[index];
                                  return MuseumCard(
                                    museum: museum,
                                    onTap: () =>
                                        context.push('/museum/${museum.id}'),
                                    onToggleSave: () {},
                                  );
                                },
                              ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
