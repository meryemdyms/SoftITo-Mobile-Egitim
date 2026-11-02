import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_dimensions.dart';
import '../../../app/theme/app_typography.dart';
import '../../../shared/repositories/museum_repository.dart';
import '../../../shared/widgets/museum_card.dart';
import '../../../shared/widgets/museum_empty_state.dart';
import '../../auth/viewmodels/auth_viewmodel.dart';
import '../viewmodels/explore_viewmodel.dart';

/// Cep Müzem — Keşfet Ekranı (ExploreView)
///
/// project.md Madde 8 gereksinimleri:
/// - Dijital sergi kataloğu şeklinde tasarlanır (Pinterest veya Instagram feed'i kopyalanmaz).
/// - Sağ üstteki zil simgesinden bildirimler açılır.
/// - Takip edilenlerin müzeleri ve popüler müzeler kurallara göre listelenir.
/// - Demo modunda açıkça kullanıcıya bilgi verilir.
class ExploreView extends StatelessWidget {
  const ExploreView({super.key});

  @override
  Widget build(BuildContext context) {
    // Repository ve oturum bilgisi Provider üzerinden alınır
    final museumRepo = Provider.of<MuseumRepository>(context, listen: false);
    final authVm = Provider.of<AuthViewModel>(context);

    // ExploreViewModel bu view'a özel ChangeNotifierProvider ile oluşturulur
    return ChangeNotifierProvider(
      create: (_) => ExploreViewModel(
        repository: museumRepo,
        currentUserId: authVm.currentUser?.id,
      ),
      child: const _ExploreContent(),
    );
  }
}

/// Keşfet ekranının ana gövde ve arayüz bileşeni
class _ExploreContent extends StatelessWidget {
  const _ExploreContent();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ExploreViewModel>();

    return Scaffold(
      appBar: AppBar(
        // Üst başlıkta uygulama amblemi ve adı yer alır
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: AppColors.parchment,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.museum,
                color: AppColors.antiqueBronze,
                size: 20,
              ),
            ),
            const SizedBox(width: AppDimensions.space12),
            Text('Cep Müzem', style: AppTypography.pageTitle),
          ],
        ),
        actions: [
          // Sağ üstteki bildirim zili butonu (Kesin kural: bildirimler buradan açılır)
          IconButton(
            tooltip: 'Bildirimler',
            icon: const Icon(Icons.notifications_none_outlined, size: 24),
            onPressed: () {
              context.push('/notifications');
            },
          ),
          const SizedBox(width: AppDimensions.space8),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Demo Bildirim Bandı: Firebase bağlanmadığında açıkça belirtilir (AGENTS.md kuralı)
            if (!vm.isFirebaseConfigured)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.horizontalPadding,
                  vertical: AppDimensions.space8,
                ),
                decoration: const BoxDecoration(
                  color: AppColors.parchment,
                  border: Border(
                    bottom: BorderSide(
                      color: AppColors.museumStone,
                      width: 0.8,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      size: 16,
                      color: AppColors.antiqueBronze,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'DEMO MODU: Firebase henüz yapılandırılmadı. Örnek küratör sergileri görüntüleniyor.',
                        style: AppTypography.caption.copyWith(
                          fontSize: 11,
                          color: AppColors.deepWalnut,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // Sergi Kataloğu İçerik Akışı
            Expanded(child: _buildBody(context, vm)),
          ],
        ),
      ),
    );
  }

  /// Duruma göre (yükleniyor, hata, boş, liste) içerik gövdesini oluşturur
  Widget _buildBody(BuildContext context, ExploreViewModel vm) {
    // 1. Yükleniyor Durumu
    if (vm.state == ExploreState.loading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.antiqueBronze),
      );
    }

    // 2. Hata Durumu
    if (vm.state == ExploreState.error) {
      return MuseumEmptyState(
        title: 'Sergiler Yüklenemedi',
        message: vm.errorMessage ?? 'Akış yüklenirken bir problem oluştu.',
        icon: Icons.refresh,
        actionLabel: 'Tekrar Dene',
        onAction: vm.loadFeed,
      );
    }

    // 3. Boş Durum
    if (vm.museums.isEmpty) {
      return MuseumEmptyState(
        title: 'Henüz Sergi Yok',
        message:
            'Koleksiyonunuza ilk müzeyi ekleyerek sergi kataloğunu başlatın.',
        icon: Icons.museum_outlined,
        actionLabel: 'Yenile',
        onAction: vm.loadFeed,
      );
    }

    // 4. Dolu Sergi Kataloğu Listesi (Yenileme çekmeli)
    return RefreshIndicator(
      onRefresh: vm.loadFeed,
      color: AppColors.antiqueBronze,
      backgroundColor: AppColors.museumWhite,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.horizontalPadding,
          vertical: AppDimensions.space16,
        ),
        itemCount: vm.museums.length + 1,
        separatorBuilder: (context, index) =>
            const SizedBox(height: AppDimensions.space20),
        itemBuilder: (context, index) {
          // Listenin en başındaki katalog başlık bölümü
          if (index == 0) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dijital Sergi Kataloğu',
                  style: AppTypography.sectionTitle,
                ),
                const SizedBox(height: 4),
                Text(
                  'Küratörlerin anıları, sanat koleksiyonları ve özel sergileri.',
                  style: AppTypography.bodySecondary,
                ),
                const SizedBox(height: AppDimensions.space8),
              ],
            );
          }

          // Müze Kartı Bileşeni
          final museum = vm.museums[index - 1];
          return MuseumCard(
            museum: museum,
            onTap: () {
              // Tıklanan müzenin detay / 2D simülasyon ekranına git
              context.push('/museum/${museum.id}');
            },
            onToggleSave: () {
              // Kaydetme durumunu tersine çevir
              vm.toggleSaveMuseum(museum.id);
            },
          );
        },
      ),
    );
  }
}

