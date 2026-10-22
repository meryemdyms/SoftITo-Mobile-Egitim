import 'package:flutter/material.dart';
import '../../../core/services/app_scope.dart';
import '../../../core/theme/app_colors.dart';
import '../models/puzzle_models.dart';
import '../widgets/puzzle_artwork_widget.dart';

class PuzzleDetailView extends StatelessWidget {
  final PuzzleModel puzzle;
  final ArtworkModel artwork;
  final String habitName;

  const PuzzleDetailView({
    super.key,
    required this.puzzle,
    required this.artwork,
    required this.habitName,
  });

  @override
  Widget build(BuildContext context) {
    final appScope = AppScope.of(context);
    final pieces = appScope.habitController.getPiecesForPuzzle(puzzle.id);
    final isDone = puzzle.isFullyCompleted;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(isDone ? artwork.title : 'Gizli Keşif'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Alışkanlık ve Seri Başlığı
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    artwork.series,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: Text(
                  isDone ? artwork.title : 'Gizemli Sanat Eseri',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Center(
                child: Text(
                  'Alışkanlık: $habitName',
                  style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
                ),
              ),
              const SizedBox(height: 24),

              // Yapboz Kanvası
              PuzzleArtworkWidget(
                artwork: artwork,
                puzzle: puzzle,
                pieces: pieces,
                showArtworkTitle: isDone,
              ),
              const SizedBox(height: 24),

              // İlerleme Durumu veya Kutlama Kartı
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            isDone ? Icons.auto_awesome_rounded : Icons.lock_clock_rounded,
                            color: isDone ? AppColors.warning : AppColors.primary,
                            size: 24,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            isDone ? 'Eser Tamamlandı ve Keşfedildi!' : 'Keşif Devam Ediyor',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        isDone
                            ? artwork.description
                            : 'Her başarılı hedef gününde bu yapbozun rastgele belirlenmiş yeni bir parçası açılır. '
                                'Tüm parçalar tamamlandığında eserin adı ve gizemi gün ışığına çıkar.',
                        style: const TextStyle(fontSize: 14, color: AppColors.textSecondary, height: 1.5),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Açılan: ${puzzle.unlockedPieces} / ${puzzle.totalPieces}',
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primary),
                          ),
                          Text(
                            'Kalan: ${puzzle.totalPieces - puzzle.unlockedPieces} parça',
                            style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
