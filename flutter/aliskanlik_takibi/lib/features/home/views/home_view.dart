import 'package:flutter/material.dart';
import '../../../core/services/app_scope.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/date_helpers.dart';
import '../../habits/models/habit_models.dart';
import '../../habits/views/create_habit_view.dart';
import '../../habits/views/habit_detail_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final List<String> _motivationQuotes = [
    'Her gün bir parça, büyük bir resmi tamamlar.',
    'Küçük adımlar, zamanla dağları aşar.',
    'Bugünkü çaban, gelecekteki huzurunun temelidir.',
    'Ritmini bul, düzenini koru.',
    'Süreklilik mükemmellikten daha değerlidir.',
  ];

  @override
  Widget build(BuildContext context) {
    final appScope = AppScope.of(context);
    final user = appScope.authService.currentUser;
    final habitController = appScope.habitController;

    return AnimatedBuilder(
      animation: habitController,
      builder: (context, _) {
        final todayHabits = habitController.getTodayHabits();
        final completionRatio = habitController.getTodayCompletionRatio();
        final quoteIndex = DateTime.now().day % _motivationQuotes.length;
        final motivation = _motivationQuotes[quoteIndex];

        int maxStreak = 0;
        for (final h in habitController.activeHabits) {
          final sInfo = habitController.calculateStreak(h.id);
          if (sInfo.longestStreak > maxStreak) {
            maxStreak = sInfo.longestStreak;
          }
        }

        final pendingHabits = <HabitModel>[];
        final completedHabits = <HabitModel>[];

        for (final h in todayHabits) {
          final prog = habitController.getTodayProgress(h.id);
          if (prog != null && prog.isCompleted) {
            completedHabits.add(h);
          } else {
            pendingHabits.add(h);
          }
        }

        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: () => habitController.loadAll(),
              color: AppColors.primary,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Karşılama ve Tarih
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              DateHelpers.formatFull(DateTime.now()),
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Merhaba, ${user?.firstName ?? 'Ritmo'} 👋',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                color: AppColors.primary,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(Icons.person_rounded, color: AppColors.primary),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Günlük Motivasyon Kartı
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceVariant.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.format_quote_rounded, color: AppColors.primary, size: 28),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              motivation,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: AppColors.primary,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Günlük Genel İlerleme Özeti Kartı
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Bugünün İlerlemesi',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primary,
                                  ),
                                ),
                                Text(
                                  '%${(completionRatio * 100).toInt()}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: LinearProgressIndicator(
                                value: completionRatio,
                                minHeight: 12,
                                backgroundColor: AppColors.surfaceVariant,
                                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${completedHabits.length} / ${todayHabits.length} Alışkanlık Yapıldı',
                                  style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.local_fire_department_rounded, color: AppColors.warning, size: 18),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Seri: $maxStreak Gün',
                                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primary),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Bugünün Alışkanlıkları Başlığı
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Bugünün Hedefleri',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const CreateHabitView()),
                            );
                          },
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text('Yeni Ekle'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Alışkanlık Yoksa Boş Durum
                    if (todayHabits.isEmpty) ...[
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 36),
                          child: Column(
                            children: [
                              Container(
                                width: 64,
                                height: 64,
                                decoration: BoxDecoration(
                                  color: AppColors.secondary.withValues(alpha: 0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.spa_outlined, color: AppColors.primary, size: 32),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Bugün için planlanmış alışkanlık yok',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.primary),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Yeni bir alışkanlık oluşturun ve ilk gizli yapbozunuzu keşfetmeye başlayın.',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(builder: (_) => const CreateHabitView()),
                                  );
                                },
                                child: const Text('İlk Alışkanlığını Oluştur'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ] else ...[
                      // Bekleyen Alışkanlıklar
                      if (pendingHabits.isNotEmpty) ...[
                        const Text(
                          'Tamamlanacaklar',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 8),
                        ...pendingHabits.map((h) => _buildHabitCard(h, isDone: false)),
                        const SizedBox(height: 16),
                      ],

                      // Tamamlanan Alışkanlıklar
                      if (completedHabits.isNotEmpty) ...[
                        const Text(
                          'Bugün Tamamlananlar ✨',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.success),
                        ),
                        const SizedBox(height: 8),
                        ...completedHabits.map((h) => _buildHabitCard(h, isDone: true)),
                      ],
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHabitCard(HabitModel habit, {required bool isDone}) {
    final appScope = AppScope.of(context);
    final schedule = appScope.habitController.getSchedule(habit.id);
    final progress = appScope.habitController.getTodayProgress(habit.id);
    final target = schedule?.targetValue ?? 1.0;
    final current = progress?.actualValue ?? 0.0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => HabitDetailView(habit: habit)),
          );
        },
        borderRadius: BorderRadius.circular(20),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                // İkon
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Color(habit.colorValue).withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.check_circle_outline_rounded,
                      color: Color(habit.colorValue),
                      size: 24,
                    ),
                  ),
                ),
                const SizedBox(width: 14),

                // Bilgiler
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        habit.name,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: isDone ? AppColors.textSecondary : AppColors.primary,
                          decoration: isDone ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${current.toInt()} / ${target.toInt()} ${habit.unit}',
                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),

                // Tamamlama Kontrolü Butonu
                IconButton(
                  icon: Icon(
                    isDone ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                    color: isDone ? AppColors.success : AppColors.border,
                    size: 28,
                  ),
                  onPressed: () async {
                    final newVal = isDone ? 0.0 : target;
                    await appScope.habitController.recordProgress(
                      habitId: habit.id,
                      actualValue: newVal,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
