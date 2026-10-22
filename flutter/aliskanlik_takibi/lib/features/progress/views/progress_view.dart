import 'dart:math';
import 'package:flutter/material.dart';
import '../../../core/services/app_scope.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/date_helpers.dart';
import '../models/analysis_models.dart';

class ProgressView extends StatelessWidget {
  const ProgressView({super.key});

  @override
  Widget build(BuildContext context) {
    final appScope = AppScope.of(context);
    final habitController = appScope.habitController;
    final analyticsController = appScope.analyticsController;

    return AnimatedBuilder(
      animation: habitController,
      builder: (context, _) {
        final last7Days = analyticsController.getLast7DaysSummary();
        final activeHabits = habitController.activeHabits;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: const Text('Gelişim ve Analiz'),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Haftalık Performans Grafiği Kartı
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Son 7 Günlük Performans',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Günlük tamamlanan alışkanlık oranları',
                            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                          ),
                          const SizedBox(height: 24),

                          // Sade ve Estetik Bar Grafiği (Custom Minimalist Bars)
                          SizedBox(
                            height: 120,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: last7Days.map((item) {
                                final ratio = item.totalPlannedCount > 0
                                    ? (item.completedCount / item.totalPlannedCount).clamp(0.0, 1.0)
                                    : 0.0;
                                final dayStr = DateHelpers.dayShortNames[item.date.weekday];
                                final isToday = DateHelpers.isSameDay(item.date, DateTime.now());

                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      '${item.completedCount}',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: ratio > 0 ? AppColors.primary : AppColors.textMuted,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Container(
                                      width: 22,
                                      height: max(ratio * 70, 6.0),
                                      decoration: BoxDecoration(
                                        color: ratio >= 1.0
                                            ? AppColors.primary
                                            : (ratio > 0 ? AppColors.secondary : AppColors.surfaceVariant),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      dayStr,
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
                                        color: isToday ? AppColors.primary : AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Aktif Süreç Raporları Başlığı
                  const Text(
                    'Aktif Süreç Raporları',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 12),

                  if (activeHabits.isEmpty) ...[
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Center(
                          child: Text(
                            'Henüz analiz edilecek aktif bir süreç bulunmuyor.',
                            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                          ),
                        ),
                      ),
                    ),
                  ] else ...[
                    ...activeHabits.map((habit) {
                      final report = analyticsController.generateReportForHabit(habit.id);
                      return _buildProcessReportCard(report, habit.unit);
                    }),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProcessReportCard(AnalysisReportModel report, String unit) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    report.habitName,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.primary),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '🧩 ${report.unlockedPieces}/${report.totalPieces} Parça',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Kesin İş Kuralı: Gün Başarı Oranı vs Miktar Başarı Oranı Ayrı Gösterimi
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Gün Başarısı',
                            style: TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '%${report.dayCompletionRate.toStringAsFixed(1)}',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.primary),
                          ),
                          Text(
                            '${report.successfulDays} / ${report.plannedDays} Planlı Gün',
                            style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Miktar Başarısı',
                            style: TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '%${report.amountCompletionRate.toStringAsFixed(1)}',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.primary),
                          ),
                          Text(
                            '${report.totalActualProgress.toInt()} / ${report.totalTargetProgress.toInt()} $unit',
                            style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Streak İstatistik Satırı
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.local_fire_department_rounded, size: 16, color: AppColors.warning),
                      const SizedBox(width: 4),
                      Text(
                        'Mevcut Seri: ${report.currentStreak} gün',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                      ),
                    ],
                  ),
                  Text(
                    'En Uzun: ${report.longestStreak} gün',
                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
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
