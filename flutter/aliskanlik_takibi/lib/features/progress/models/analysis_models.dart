/// Ritmo Gelişim ve Süreç Analiz Rapor Modeli.
///
/// `project.md` 9.2. Bölüm (Süreç Sonu Analizi) ve 14. Bölüm (AnalysisReport) kurallarına göre:
///
/// Önemli İş Kuralı:
/// "Gün tamamlama oranı ile miktar başarı oranı farklı hesaplanır."
/// - [dayCompletionRate]: Başarılı olunan gün sayısının planlanan gün sayısına oranıdır (%80 gibi).
/// - [amountCompletionRate]: Gerçekleştirilen toplam miktarın (ör. 520 sayfa) hedeflenen toplam miktara (ör. 600 sayfa) oranıdır (%86.7 gibi).
class AnalysisReportModel {
  /// Raporun benzersiz kimliği
  final String id;

  /// İncelenen sürecin kimliği
  final String processId;

  /// Alışkanlığın kimliği
  final String habitId;

  /// Alışkanlığın adı
  final String habitName;

  /// Planlanan toplam gün sayısı
  final int plannedDays;

  /// Hedefe ulaşılan başarılı gün sayısı
  final int successfulDays;

  /// Planlanmış olmasına rağmen hedefe ulaşılamayan eksik gün sayısı
  final int missedDays;

  /// Gün tamamlama başarı yüzdesi (Başarılı Gün / Planlanan Gün * 100)
  final double dayCompletionRate;

  /// Süreç boyunca hedeflenen toplam miktar (Örn: 30 gün * 20 sayfa = 600 sayfa)
  final double totalTargetProgress;

  /// Süreç boyunca kullanıcının fiilen gerçekleştirdiği toplam miktar (Örn: 520 sayfa)
  final double totalActualProgress;

  /// Miktar başarı yüzdesi (Gerçekleşen Miktar / Toplam Hedef Miktar * 100)
  final double amountCompletionRate;

  /// Bu süreçte ulaşılan en uzun seri rekoru
  final int longestStreak;

  /// Süreç sonundaki veya anlık kesintisiz seri
  final int currentStreak;

  /// Süreçte kazanılan yapboz parça sayısı
  final int unlockedPieces;

  /// Yapbozun toplam parça sayısı
  final int totalPieces;

  /// Raporun üretildiği zaman damgası
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
