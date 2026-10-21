import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_dimensions.dart';
import '../../../app/theme/app_typography.dart';
import '../../../shared/models/museum_item_model.dart';
import '../../../shared/repositories/museum_repository.dart';
import '../../../shared/widgets/museum_empty_state.dart';
import '../../auth/viewmodels/auth_viewmodel.dart';
import '../../museum_scene/widgets/two_d_museum_renderer.dart';
import '../viewmodels/museum_detail_viewmodel.dart';
import '../widgets/artwork_sheet.dart';

class MuseumDetailView extends StatelessWidget {
  final String museumId;

  const MuseumDetailView({super.key, required this.museumId});

  @override
  Widget build(BuildContext context) {
    final museumRepo = Provider.of<MuseumRepository>(context, listen: false);
    final authVm = Provider.of<AuthViewModel>(context, listen: false);

    return ChangeNotifierProvider(
      create: (_) => MuseumDetailViewModel(
        repository: museumRepo,
        museumId: museumId,
        currentUserId: authVm.currentUser?.id,
      ),
      child: const _MuseumDetailContent(),
    );
  }
}

class _MuseumDetailContent extends StatefulWidget {
  const _MuseumDetailContent();

  @override
  State<_MuseumDetailContent> createState() => _MuseumDetailContentState();
}

class _MuseumDetailContentState extends State<_MuseumDetailContent> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _onItemTapped(
    BuildContext context,
    MuseumDetailViewModel vm,
    MuseumItemModel item,
  ) {
    vm.selectItem(item);
    ArtworkSheet.show(context, item).then((_) {
      vm.clearSelection();
    });
  }

  void _submitComment(MuseumDetailViewModel vm) {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    final authVm = Provider.of<AuthViewModel>(context, listen: false);
    final userName = authVm.currentUser?.fullName ?? 'Küratör';

    vm.sendComment(userName: userName, text: text).then((success) {
      if (success && mounted) {
        _commentController.clear();
        FocusManager.instance.primaryFocus?.unfocus();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<MuseumDetailViewModel>();

    if (vm.state == DetailState.loading) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Müze Detayı',
            style: AppTypography.pageTitle.copyWith(fontSize: 22),
          ),
        ),
        body: const Center(
          child: CircularProgressIndicator(color: AppColors.antiqueBronze),
        ),
      );
    }

    if (vm.state == DetailState.error || vm.museum == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Müze Detayı',
            style: AppTypography.pageTitle.copyWith(fontSize: 22),
          ),
        ),
        body: MuseumEmptyState(
          title: 'Müze Yüklenemedi',
          message: vm.errorMessage ?? 'İstenen müzeye şu anda ulaşılamıyor.',
          icon: Icons.error_outline,
          actionLabel: 'Tekrar Dene',
          onAction: vm.loadDetails,
        ),
      );
    }

    final museum = vm.museum!;
    final room = vm.scene?.rooms.isNotEmpty == true
        ? vm.scene!.rooms.first
        : null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          museum.title,
          style: AppTypography.pageTitle.copyWith(fontSize: 22),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            tooltip: museum.isSavedByCurrentUser ? 'Kaydı Kaldır' : 'Kaydet',
            icon: Icon(
              museum.isSavedByCurrentUser
                  ? Icons.bookmark
                  : Icons.bookmark_border,
              color: museum.isSavedByCurrentUser
                  ? AppColors.antiqueBronze
                  : AppColors.deepWalnut,
            ),
            onPressed: vm.toggleSave,
          ),
          const SizedBox(width: AppDimensions.space8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.horizontalPadding,
            vertical: AppDimensions.space12,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 2D Simülasyon Sahnesi
              if (room != null) ...[
                Text(
                  'Müze Odası — 2D Sergi Alanı',
                  style: AppTypography.sectionTitle.copyWith(fontSize: 18),
                ),
                const SizedBox(height: 4),
                Text(
                  'Eserlerin detayını incelemek için çerçevelere dokunun.',
                  style: AppTypography.caption,
                ),
                const SizedBox(height: AppDimensions.space12),
                TwoDMuseumRenderer(
                  room: room,
                  selectedItem: vm.selectedItem,
                  onItemTap: (item) => _onItemTapped(context, vm, item),
                ),
                const SizedBox(height: AppDimensions.space20),
              ],

              // Müze Künyesi
              Container(
                padding: const EdgeInsets.all(AppDimensions.space16),
                decoration: BoxDecoration(
                  color: AppColors.museumWhite,
                  borderRadius: AppDimensions.cardBorderRadius,
                  border: Border.all(color: AppColors.museumStone),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: AppColors.parchment,
                          backgroundImage: museum.ownerPhotoUrl != null
                              ? NetworkImage(museum.ownerPhotoUrl!)
                              : null,
                          child: museum.ownerPhotoUrl == null
                              ? const Icon(
                                  Icons.person,
                                  color: AppColors.deepWalnut,
                                )
                              : null,
                        ),
                        const SizedBox(width: AppDimensions.space12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                museum.ownerName ?? 'Küratör',
                                style: AppTypography.caption.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.deepWalnut,
                                  fontSize: 13,
                                ),
                              ),
                              if (museum.location != null)
                                Text(
                                  museum.location!,
                                  style: AppTypography.caption,
                                ),
                            ],
                          ),
                        ),
                        // Beğeni Butonu
                        IconButton(
                          tooltip: museum.isLikedByCurrentUser
                              ? 'Beğeniyi Kaldır'
                              : 'Beğen',
                          icon: Icon(
                            museum.isLikedByCurrentUser
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: museum.isLikedByCurrentUser
                                ? AppColors.terracotta
                                : AppColors.deepWalnut,
                          ),
                          onPressed: vm.toggleLike,
                        ),
                        Text(
                          '${museum.likeCount}',
                          style: AppTypography.caption.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.space12),
                    const Divider(height: 1, color: AppColors.museumStone),
                    const SizedBox(height: AppDimensions.space12),
                    Text(museum.description, style: AppTypography.body),
                  ],
                ),
              ),

              const SizedBox(height: AppDimensions.space24),

              // Yorumlar Bölümü
              Row(
                children: [
                  Text(
                    'Ziyaretçi Notları (${vm.comments.length})',
                    style: AppTypography.sectionTitle.copyWith(fontSize: 18),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.space12),

              // Yorum Yazma Formu
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      decoration: const InputDecoration(
                        hintText: 'Bir not veya izlenim bırakın...',
                      ),
                      maxLines: 1,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _submitComment(vm),
                    ),
                  ),
                  const SizedBox(width: AppDimensions.space8),
                  Container(
                    width: AppDimensions.minTouchTarget,
                    height: AppDimensions.minTouchTarget,
                    decoration: const BoxDecoration(
                      color: AppColors.deepWalnut,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_upward,
                        color: AppColors.museumWhite,
                        size: 20,
                      ),
                      onPressed: () => _submitComment(vm),
                      tooltip: 'Gönder',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppDimensions.space16),

              // Yorumlar Listesi
              if (vm.comments.isEmpty)
                Container(
                  padding: const EdgeInsets.all(AppDimensions.space16),
                  alignment: Alignment.center,
                  child: Text(
                    'Henüz not eklenmemiş. İlk ziyaretçi notunu siz bırakın.',
                    style: AppTypography.caption,
                  ),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: vm.comments.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: AppDimensions.space8),
                  itemBuilder: (context, index) {
                    final comment = vm.comments[index];
                    return Container(
                      padding: const EdgeInsets.all(AppDimensions.space12),
                      decoration: BoxDecoration(
                        color: AppColors.museumWhite,
                        borderRadius: AppDimensions.buttonBorderRadius,
                        border: Border.all(
                          color: AppColors.museumStone.withValues(alpha: 0.6),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                comment.authorName,
                                style: AppTypography.caption.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.deepWalnut,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                '${comment.createdAt.day}.${comment.createdAt.month}.${comment.createdAt.year}',
                                style: AppTypography.caption.copyWith(
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            comment.text,
                            style: AppTypography.body.copyWith(fontSize: 14),
                          ),
                        ],
                      ),
                    );
                  },
                ),

              const SizedBox(height: AppDimensions.space32),
            ],
          ),
        ),
      ),
    );
  }
}
