import 'package:flutter/material.dart';
import '../../../core/services/app_scope.dart';
import '../../../core/theme/app_colors.dart';
import '../../puzzle/views/puzzle_detail_view.dart';
import '../../puzzle/widgets/puzzle_artwork_widget.dart';
import '../models/habit_models.dart';

class HabitDetailView extends StatefulWidget {
  final HabitModel habit;

  const HabitDetailView({super.key, required this.habit});

  @override
  State<HabitDetailView> createState() => _HabitDetailViewState();
}

class _HabitDetailViewState extends State<HabitDetailView> {
  final TextEditingController _customValueController = TextEditingController();

  @override
  void dispose() {
    _customValueController.dispose();
    super.dispose();
  }

  void _recordQuickProgress(double value) async {
    final appScope = AppScope.of(context);
    final isDone = await appScope.habitController.recordProgress(
      habitId: widget.habit.id,
      actualValue: value,
    );

    if (mounted) {
      if (isDone) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tebrikler! Günlük hedef tamamlandı ve yeni bir yapboz parçası açıldı! 🧩'),
            backgroundColor: AppColors.success,
          ),
        );
      }
      setState(() {});
    }
  }

  void _showAddCustomProgressDialog(HabitScheduleModel schedule, DailyProgressModel? currentProgress) {
    _customValueController.text = (currentProgress?.actualValue ?? 0).toInt().toString();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('${widget.habit.name} — İlerleme Girişi'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hedef: ${schedule.targetValue.toInt()} ${widget.habit.unit}',
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _customValueController,
              keyboardType: TextInputType.number,
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'Bugünkü İlerleme (${widget.habit.unit})',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              final val = double.tryParse(_customValueController.text);
              if (val != null) {
                Navigator.of(ctx).pop();
                _recordQuickProgress(val);
              }
            },
            child: const Text('Kaydet'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appScope = AppScope.of(context);
    final schedule = appScope.habitController.getSchedule(widget.habit.id);
    final process = appScope.habitController.getActiveProcess(widget.habit.id);
    final puzzle = process != null ? appScope.habitController.getPuzzleForProcess(process.id) : null;
    final pieces = puzzle != null ? appScope.habitController.getPiecesForPuzzle(puzzle.id) : <dynamic>[];
    final artwork = puzzle != null ? appScope.artworkRepository.getById(puzzle.artworkId) : null;
    final todayProgress = appScope.habitController.getTodayProgress(widget.habit.id);
    final streakInfo = appScope.habitController.calculateStreak(widget.habit.id);

    final isCompletedToday = todayProgress?.isCompleted ?? false;
    final currentVal = todayProgress?.actualValue ?? 0.0;
    final targetVal = schedule?.targetValue ?? 1.0;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(widget.habit.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.archive_outlined),
            tooltip: 'Alışkanlığı Arşivle',
            onPressed: () async {
              await appScope.habitController.updateHabitStatus(widget.habit.id, HabitStatus.archived);
              if (context.mounted) {
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Alışkanlık Özet Kartı
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: Color(widget.habit.colorValue).withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.check_circle_outline_rounded,
                            color: Color(widget.habit.colorValue),
                            size: 32,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.habit.category,
                              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.habit.name,
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.primary),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Hedef: ${targetVal.toInt()} ${widget.habit.unit} / gün',
                              style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Günlük İlerleme Kaydı Bölümü
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Bugünkü İlerleme',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.primary),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: isCompletedToday ? AppColors.success.withValues(alpha: 0.15) : AppColors.surfaceVariant,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              isCompletedToday ? 'Tamamlandı' : 'Bekliyor',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: isCompletedToday ? AppColors.success : AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // İlerleme Çubuğu
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: (currentVal / targetVal).clamp(0.0, 1.0),
                          minHeight: 12,
                          backgroundColor: AppColors.surfaceVariant,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            isCompletedToday ? AppColors.success : AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${currentVal.toInt()} / ${targetVal.toInt()} ${widget.habit.unit}',
                        style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 16),

                      // Hızlı İşlem Butonları
                      if (widget.habit.measurementType == MeasurementType.boolean) ...[
                        ElevatedButton.icon(
                          onPressed: () => _recordQuickProgress(isCompletedToday ? 0.0 : 1.0),
                          icon: Icon(isCompletedToday ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded),
                          label: Text(isCompletedToday ? 'Tamamlandı Olarak İşaretlendi' : 'Bugün Tamamlandı Olarak İşaretle'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isCompletedToday ? AppColors.success : AppColors.primary,
                          ),
                        ),
                      ] else ...[
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  final newVal = (currentVal + 1).clamp(0.0, 9999.0);
                                  _recordQuickProgress(newVal);
                                },
                                icon: const Icon(Icons.add_rounded),
                                label: Text('+1 ${widget.habit.unit}'),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () => _showAddCustomProgressDialog(schedule!, todayProgress),
                                icon: const Icon(Icons.edit_note_rounded),
                                label: const Text('Miktar Gir'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Streak ve İstatistik Kartı
              Row(
                children: [
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.local_fire_department_rounded, color: AppColors.warning, size: 20),
                                SizedBox(width: 6),
                                Text('Mevcut Seri', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${streakInfo.currentStreak} Gün',
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.primary),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.emoji_events_outlined, color: AppColors.primary, size: 20),
                                SizedBox(width: 6),
                                Text('En Uzun Seri', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${streakInfo.longestStreak} Gün',
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.primary),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Gizli Yapboz Önizleme Başlığı
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Gizli Yapboz Durumu',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.primary),
                  ),
                  if (puzzle != null && artwork != null)
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => PuzzleDetailView(
                              puzzle: puzzle,
                              artwork: artwork,
                              habitName: widget.habit.name,
                            ),
                          ),
                        );
                      },
                      child: const Text('Büyüt'),
                    ),
                ],
              ),
              const SizedBox(height: 10),

              if (puzzle != null && artwork != null) ...[
                PuzzleArtworkWidget(
                  artwork: artwork,
                  puzzle: puzzle,
                  pieces: pieces.cast(),
                  showArtworkTitle: puzzle.isFullyCompleted,
                ),
              ],
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
