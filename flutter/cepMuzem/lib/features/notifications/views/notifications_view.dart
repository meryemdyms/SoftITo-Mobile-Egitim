import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_dimensions.dart';
import '../../../app/theme/app_typography.dart';
import '../../../shared/widgets/museum_empty_state.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    // Örnek bildirimler
    final notifications = [
      {
        'id': 'notif_1',
        'title': 'Murat İznikli müzenizi beğendi',
        'body': '“Galata & Eski Pera Belleği” serginiz bir beğeni aldı.',
        'time': '2 saat önce',
        'isRead': false,
        'museumId': 'museum_001',
      },
      {
        'id': 'notif_2',
        'title': 'Elif Göreme serginize not bıraktı',
        'body': '“Sesli anlatımla birlikte müzenin atmosferi çok sakin...”',
        'time': 'Dün',
        'isRead': true,
        'museumId': 'museum_001',
      },
      {
        'id': 'notif_3',
        'title': 'Yeni bir küratör sizi takip etmeye başladı',
        'body': 'Deniz Yörük sergilerinizi takip listesine ekledi.',
        'time': '3 gün önce',
        'isRead': true,
        'museumId': null,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Bildirimler', style: AppTypography.pageTitle),
      ),
      body: SafeArea(
        child: notifications.isEmpty
            ? const MuseumEmptyState(
                title: 'Bildirim Yok',
                message: 'Sergilerinize gelen ziyaretçi notları ve beğeniler burada listelenecektir.',
                icon: Icons.notifications_none,
              )
            : ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.horizontalPadding,
                  vertical: AppDimensions.space16,
                ),
                itemCount: notifications.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: AppDimensions.space12),
                itemBuilder: (context, index) {
                  final notif = notifications[index];
                  final isRead = notif['isRead'] as bool;
                  final museumId = notif['museumId'] as String?;

                  return InkWell(
                    onTap: () {
                      if (museumId != null) {
                        context.push('/museum/$museumId');
                      }
                    },
                    borderRadius: AppDimensions.buttonBorderRadius,
                    child: Container(
                      padding: const EdgeInsets.all(AppDimensions.space12),
                      decoration: BoxDecoration(
                        color: isRead
                            ? AppColors.museumWhite
                            : AppColors.parchment.withValues(alpha: 0.5),
                        borderRadius: AppDimensions.buttonBorderRadius,
                        border: Border.all(
                          color: isRead
                              ? AppColors.museumStone
                              : AppColors.antiqueBronze.withValues(alpha: 0.6),
                          width: isRead ? 0.8 : 1.2,
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: const BoxDecoration(
                              color: AppColors.parchment,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.notifications_active_outlined,
                              size: 18,
                              color: AppColors.antiqueBronze,
                            ),
                          ),
                          const SizedBox(width: AppDimensions.space12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  notif['title'] as String,
                                  style: AppTypography.caption.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.deepWalnut,
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  notif['body'] as String,
                                  style: AppTypography.bodySecondary.copyWith(
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  notif['time'] as String,
                                  style: AppTypography.caption.copyWith(
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (!isRead)
                            Container(
                              width: 8,
                              height: 8,
                              margin: const EdgeInsets.only(top: 6),
                              decoration: const BoxDecoration(
                                color: AppColors.antiqueBronze,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
