class AnalysisReportModel {
  final String id;
  final String processId;
  final String habitId;
  final String habitName;
  final int plannedDays;
  final int successfulDays;
  final int missedDays;
  final double dayCompletionRate; // Başarılı gün / planlı gün (%)
  final double totalTargetProgress;
  final double totalActualProgress;
  final double amountCompletionRate; // Toplam yapılan / toplam hedef (%)
  final int longestStreak;
  final int currentStreak;
  final int unlockedPieces;
  final int totalPieces;
  final DateTime generatedAt;

  const AnalysisReportModel({
    required this.id,
    required this.processId,
    required this.habitId,
    required this.habitName,
    required this.plannedDays,
    required this.successfulDays,
    required this.missedDays,
    required this.dayCompletionRate,
    required this.totalTargetProgress,
    required this.totalActualProgress,
    required this.amountCompletionRate,
    required this.longestStreak,
    required this.currentStreak,
    required this.unlockedPieces,
    required this.totalPieces,
    required this.generatedAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'processId': processId,
        'habitId': habitId,
        'habitName': habitName,
        'plannedDays': plannedDays,
        'successfulDays': successfulDays,
        'missedDays': missedDays,
        'dayCompletionRate': dayCompletionRate,
        'totalTargetProgress': totalTargetProgress,
        'totalActualProgress': totalActualProgress,
        'amountCompletionRate': amountCompletionRate,
        'longestStreak': longestStreak,
        'currentStreak': currentStreak,
        'unlockedPieces': unlockedPieces,
        'totalPieces': totalPieces,
        'generatedAt': generatedAt.toIso8601String(),
      };

  factory AnalysisReportModel.fromJson(Map<String, dynamic> json) =>
      AnalysisReportModel(
        id: json['id'] as String,
        processId: json['processId'] as String,
        habitId: json['habitId'] as String? ?? '',
        habitName: json['habitName'] as String? ?? '',
        plannedDays: json['plannedDays'] as int,
        successfulDays: json['successfulDays'] as int,
        missedDays: json['missedDays'] as int? ?? 0,
        dayCompletionRate: (json['dayCompletionRate'] as num).toDouble(),
        totalTargetProgress: (json['totalTargetProgress'] as num).toDouble(),
        totalActualProgress: (json['totalActualProgress'] as num).toDouble(),
        amountCompletionRate: (json['amountCompletionRate'] as num).toDouble(),
        longestStreak: json['longestStreak'] as int,
        currentStreak: json['currentStreak'] as int? ?? 0,
        unlockedPieces: json['unlockedPieces'] as int? ?? 0,
        totalPieces: json['totalPieces'] as int? ?? 0,
        generatedAt: DateTime.parse(json['generatedAt'] as String),
      );
}
