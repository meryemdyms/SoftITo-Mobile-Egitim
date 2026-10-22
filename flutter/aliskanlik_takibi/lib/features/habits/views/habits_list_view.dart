import 'package:flutter/material.dart';
import '../../../core/services/app_scope.dart';
import '../../../core/theme/app_colors.dart';
import '../models/habit_models.dart';
import 'create_habit_view.dart';
import 'habit_detail_view.dart';

class HabitsListView extends StatefulWidget {
  const HabitsListView({super.key});

  @override
  State<HabitsListView> createState() => _HabitsListViewState();
}

class _HabitsListViewState extends State<HabitsListView> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appScope = AppScope.of(context);
    final habitController = appScope.habitController;

    return AnimatedBuilder(
      animation: habitController,
      builder: (context, _) {
        final activeList = habitController.activeHabits;
        final archivedList = habitController.habits
            .where((h) => h.status == HabitStatus.archived || h.status == HabitStatus.paused)
            .toList();

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: const Text('Alışkanlıklarım'),
            bottom: TabBar(
              controller: _tabController,
              indicatorColor: AppColors.primary,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textMuted,
              tabs: [
                Tab(text: 'Aktif (${activeList.length})'),
                Tab(text: 'Arşiv (${archivedList.length})'),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildHabitsList(activeList, isArchived: false),
              _buildHabitsList(archivedList, isArchived: true),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHabitsList(List<HabitModel> list, {required bool isArchived}) {
    if (list.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isArchived ? Icons.archive_outlined : Icons.checklist_rounded,
                size: 56,
                color: AppColors.border,
              ),
              const SizedBox(height: 16),
              Text(
                isArchived ? 'Arşivlenmiş alışkanlık yok' : 'Henüz aktif bir alışkanlığınız yok',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.primary),
              ),
              const SizedBox(height: 8),
              Text(
                isArchived
                    ? 'Tamamladığınız veya duraklattığınız alışkanlıklar burada listelenir.'
                    : 'Yeni bir hedef ekleyerek ilk yapbozunuza başlayın.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
              if (!isArchived) ...[
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const CreateHabitView()),
                    );
                  },
                  child: const Text('Alışkanlık Ekle'),
                ),
              ],
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      itemCount: list.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, i) {
        final habit = list[i];
        return _buildCard(habit, isArchived: isArchived);
      },
    );
  }

  Widget _buildCard(HabitModel habit, {required bool isArchived}) {
    final appScope = AppScope.of(context);
    final schedule = appScope.habitController.getSchedule(habit.id);
    final process = appScope.habitController.getActiveProcess(habit.id);
    final puzzle = process != null ? appScope.habitController.getPuzzleForProcess(process.id) : null;
    final streakInfo = appScope.habitController.calculateStreak(habit.id);

    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => HabitDetailView(habit: habit)),
        );
      },
      borderRadius: BorderRadius.circular(20),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Color(habit.colorValue).withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.check_circle_outline_rounded,
                        color: Color(habit.colorValue),
                        size: 26,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          habit.category,
                          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          habit.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isArchived)
                    IconButton(
                      icon: const Icon(Icons.unarchive_outlined, color: AppColors.primary),
                      tooltip: 'Geri Yükle',
                      onPressed: () async {
                        await appScope.habitController.updateHabitStatus(habit.id, HabitStatus.active);
                      },
                    ),
                ],
              ),
              const SizedBox(height: 14),
              const Divider(height: 1, thickness: 1, color: AppColors.border),
              const SizedBox(height: 12),

              // Alt Bilgiler: Hedef, Streak, Yapboz
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Hedef: ${schedule?.targetValue.toInt() ?? 1} ${habit.unit}',
                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.local_fire_department_rounded, size: 16, color: AppColors.warning),
                      const SizedBox(width: 4),
                      Text(
                        '${streakInfo.currentStreak} gün seri',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary),
                      ),
                    ],
                  ),
                  if (puzzle != null)
                    Row(
                      children: [
                        const Icon(Icons.extension_rounded, size: 16, color: AppColors.primary),
                        const SizedBox(width: 4),
                        Text(
                          '${puzzle.unlockedPieces}/${puzzle.totalPieces}',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary),
                        ),
                      ],
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
