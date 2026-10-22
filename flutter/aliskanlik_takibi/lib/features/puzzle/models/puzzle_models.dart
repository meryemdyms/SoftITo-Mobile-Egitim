enum PuzzleStatus {
  inProgress,
  completed,
  endedIncomplete;

  String get displayName {
    switch (this) {
      case PuzzleStatus.inProgress:
        return 'Devam Ediyor';
      case PuzzleStatus.completed:
        return 'Tamamlandı';
      case PuzzleStatus.endedIncomplete:
        return 'Yarım Kaldı';
    }
  }
}

class ArtworkModel {
  final String id;
  final String title; // Eser adı (süreç tamamlanmadan kullanıcıya gösterilmez)
  final String series; // 'Huzur Serisi', 'Doğa Serisi', 'Sanat Serisi' vb.
  final String description; // Eser hikayesi / ilham mesajı
  final String themeKey; // Çizim/Vektör teması belirteci

  const ArtworkModel({
    required this.id,
    required this.title,
    required this.series,
    required this.description,
    required this.themeKey,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'series': series,
        'description': description,
        'themeKey': themeKey,
      };

  factory ArtworkModel.fromJson(Map<String, dynamic> json) => ArtworkModel(
        id: json['id'] as String,
        title: json['title'] as String,
        series: json['series'] as String,
        description: json['description'] as String,
        themeKey: json['themeKey'] as String,
      );
}

class PuzzlePieceModel {
  final String id;
  final String puzzleId;
  final int pieceIndex; // 0'dan totalPieces - 1'e kadar
  final bool isUnlocked;
  final DateTime? unlockedAt;
  final String? progressDate; // YYYY-MM-DD

  const PuzzlePieceModel({
    required this.id,
    required this.puzzleId,
    required this.pieceIndex,
    this.isUnlocked = false,
    this.unlockedAt,
    this.progressDate,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'puzzleId': puzzleId,
        'pieceIndex': pieceIndex,
        'isUnlocked': isUnlocked,
        'unlockedAt': unlockedAt?.toIso8601String(),
        'progressDate': progressDate,
      };

  factory PuzzlePieceModel.fromJson(Map<String, dynamic> json) =>
      PuzzlePieceModel(
        id: json['id'] as String,
        puzzleId: json['puzzleId'] as String,
        pieceIndex: json['pieceIndex'] as int,
        isUnlocked: json['isUnlocked'] as bool? ?? false,
        unlockedAt: json['unlockedAt'] != null
            ? DateTime.parse(json['unlockedAt'] as String)
            : null,
        progressDate: json['progressDate'] as String?,
      );

  PuzzlePieceModel copyWith({
    String? id,
    String? puzzleId,
    int? pieceIndex,
    bool? isUnlocked,
    DateTime? unlockedAt,
    String? progressDate,
  }) {
    return PuzzlePieceModel(
      id: id ?? this.id,
      puzzleId: puzzleId ?? this.puzzleId,
      pieceIndex: pieceIndex ?? this.pieceIndex,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      progressDate: progressDate ?? this.progressDate,
    );
  }
}

class PuzzleModel {
  final String id;
  final String processId;
  final String artworkId;
  final int totalPieces;
  final int unlockedPieces;
  final List<int> revealOrder; // Önceden karıştırılmış rastgele indeks sırası
  final PuzzleStatus status;

  const PuzzleModel({
    required this.id,
    required this.processId,
    required this.artworkId,
    required this.totalPieces,
    this.unlockedPieces = 0,
    required this.revealOrder,
    this.status = PuzzleStatus.inProgress,
  });

  bool get isFullyCompleted => unlockedPieces >= totalPieces && totalPieces > 0;

  double get completionPercentage {
    if (totalPieces == 0) return 0.0;
    return (unlockedPieces / totalPieces).clamp(0.0, 1.0);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'processId': processId,
        'artworkId': artworkId,
        'totalPieces': totalPieces,
        'unlockedPieces': unlockedPieces,
        'revealOrder': revealOrder,
        'status': status.name,
      };

  factory PuzzleModel.fromJson(Map<String, dynamic> json) => PuzzleModel(
        id: json['id'] as String,
        processId: json['processId'] as String,
        artworkId: json['artworkId'] as String,
        totalPieces: json['totalPieces'] as int,
        unlockedPieces: json['unlockedPieces'] as int? ?? 0,
        revealOrder: (json['revealOrder'] as List<dynamic>?)
                ?.map((e) => e as int)
                .toList() ??
            [],
        status: PuzzleStatus.values.byName(json['status'] as String? ?? 'inProgress'),
      );

  PuzzleModel copyWith({
    String? id,
    String? processId,
    String? artworkId,
    int? totalPieces,
    int? unlockedPieces,
    List<int>? revealOrder,
    PuzzleStatus? status,
  }) {
    return PuzzleModel(
      id: id ?? this.id,
      processId: processId ?? this.processId,
      artworkId: artworkId ?? this.artworkId,
      totalPieces: totalPieces ?? this.totalPieces,
      unlockedPieces: unlockedPieces ?? this.unlockedPieces,
      revealOrder: revealOrder ?? this.revealOrder,
      status: status ?? this.status,
    );
  }
}
