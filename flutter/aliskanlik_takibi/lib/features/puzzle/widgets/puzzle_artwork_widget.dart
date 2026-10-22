import 'dart:math';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../models/puzzle_models.dart';
import 'artwork_painter.dart';

/// Gizli Yapboz Izgara Görünümü
/// Görsel güvenliğini tam uygular: Kapalı parçalarda görsel hiçbir şekilde render edilmez.
class PuzzleArtworkWidget extends StatelessWidget {
  final ArtworkModel artwork;
  final PuzzleModel puzzle;
  final List<PuzzlePieceModel> pieces;
  final bool showArtworkTitle; // Sadece tamamlandıysa true
  final VoidCallback? onPieceTapped;

  const PuzzleArtworkWidget({
    super.key,
    required this.artwork,
    required this.puzzle,
    required this.pieces,
    this.showArtworkTitle = false,
    this.onPieceTapped,
  });

  /// Parça sayısına göre ideal grid sütun ve satır sayısını hesaplar
  static ({int cols, int rows}) calculateGrid(int totalPieces) {
    if (totalPieces <= 0) return (cols: 1, rows: 1);
    if (totalPieces <= 6) return (cols: 3, rows: 2);
    if (totalPieces <= 12) return (cols: 4, rows: 3);
    if (totalPieces <= 21) return (cols: 7, rows: 3);
    if (totalPieces <= 30) return (cols: 6, rows: 5);
    if (totalPieces <= 60) return (cols: 10, rows: 6);
    if (totalPieces <= 90) return (cols: 10, rows: 9);

    final sqrtVal = sqrt(totalPieces).ceil();
    return (cols: sqrtVal, rows: (totalPieces / sqrtVal).ceil());
  }

  @override
  Widget build(BuildContext context) {
    final grid = calculateGrid(puzzle.totalPieces);
    final cols = grid.cols;
    final rows = grid.rows;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border, width: 2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Yapboz Başlığı / Seri Bilgisi
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: AppColors.cardBg,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.extension_rounded, size: 18, color: AppColors.primary),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        showArtworkTitle ? artwork.title : 'Gizli Yapboz (${artwork.series})',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                      Text(
                        '${puzzle.unlockedPieces} / ${puzzle.totalPieces} Parça Keşfedildi',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '%${(puzzle.completionPercentage * 100).toInt()}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1, color: AppColors.border),

          // Yapboz Kanvası & Izgara
          AspectRatio(
            aspectRatio: 1.15,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                final height = constraints.maxHeight;
                final pieceWidth = width / cols;
                final pieceHeight = height / rows;

                return Stack(
                  children: [
                    // Arka planda parça ızgarası
                    for (int r = 0; r < rows; r++)
                      for (int c = 0; c < cols; c++) ...[
                        _buildPieceCell(
                          col: c,
                          row: r,
                          cols: cols,
                          rows: rows,
                          totalWidth: width,
                          totalHeight: height,
                          pieceWidth: pieceWidth,
                          pieceHeight: pieceHeight,
                        ),
                      ],
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPieceCell({
    required int col,
    required int row,
    required int cols,
    required int rows,
    required double totalWidth,
    required double totalHeight,
    required double pieceWidth,
    required double pieceHeight,
  }) {
    final index = row * cols + col;

    // Eğer grid boyutu toplam parça sayısından fazlaysa boş bırak
    if (index >= puzzle.totalPieces) {
      return Positioned(
        left: col * pieceWidth,
        top: row * pieceHeight,
        width: pieceWidth,
        height: pieceHeight,
        child: Container(color: AppColors.surfaceVariant.withValues(alpha: 0.4)),
      );
    }

    final piece = pieces.firstWhere(
      (p) => p.pieceIndex == index,
      orElse: () => PuzzlePieceModel(
        id: '',
        puzzleId: puzzle.id,
        pieceIndex: index,
        isUnlocked: false,
      ),
    );

    final isUnlocked = piece.isUnlocked || puzzle.isFullyCompleted;

    return Positioned(
      left: col * pieceWidth,
      top: row * pieceHeight,
      width: pieceWidth,
      height: pieceHeight,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: isUnlocked ? AppColors.surface.withValues(alpha: 0.3) : AppColors.border,
            width: 0.5,
          ),
        ),
        child: isUnlocked
            ? ClipRect(
                child: OverflowBox(
                  maxWidth: totalWidth,
                  maxHeight: totalHeight,
                  alignment: Alignment(
                    cols > 1 ? -1.0 + (col / (cols - 1)) * 2.0 : 0.0,
                    rows > 1 ? -1.0 + (row / (rows - 1)) * 2.0 : 0.0,
                  ),
                  child: CustomPaint(
                    size: Size(totalWidth, totalHeight),
                    painter: ArtworkPainter(themeKey: artwork.themeKey),
                  ),
                ),
              )
            : Container(
                color: AppColors.surfaceVariant,
                child: Center(
                  child: Icon(
                    Icons.lock_outline_rounded,
                    size: min(pieceWidth, pieceHeight) * 0.35,
                    color: AppColors.textMuted.withValues(alpha: 0.6),
                  ),
                ),
              ),
      ),
    );
  }
}
