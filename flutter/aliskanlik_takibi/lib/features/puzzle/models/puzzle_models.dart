/// Gizli yapbozun anlık tamamlanma durumu.
enum PuzzleStatus {
  /// Parçalar açılmaya devam ediyor
  inProgress,

  /// Tüm parçalar başarıyla açıldı, eser ortaya çıktı
  completed,

  /// Süreç süresi bitti ancak tüm parçalar açılamadı
  endedIncomplete;

  /// Kullanıcı arayüzünde görüntülenecek Türkçe durum adı
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

/// Küratörlü Sanat Eseri Modeli.
///
/// `project.md` 7. (Gizli Yapboz Sistemi) ve 10. (Başarı Koleksiyonu) kurallarına göre:
/// - Her eserin adı ([title]), ait olduğu serisi ([series]) ve ilham verici hikayesi ([description]) bulunur.
/// - Görsel Güvenliği Kuralı: Eserin adı ve hikayesi, tüm yapboz parçaları açılana kadar kullanıcıya gizli tutulur.
class ArtworkModel {
  /// Eserin benzersiz kimliği (Örn: 'art_forest')
  final String id;

  /// Eserin adı (Süreç başarıyla tamamlanana kadar gizlidir, örn: 'Ormanın Şarkısı')
  final String title;

  /// Eserin ait olduğu koleksiyon serisi (Örn: 'Huzur Serisi', 'Doğa Serisi')
  final String series;

  /// Eserin hikayesi ve ilham verici anlamı
  final String description;

  /// Vektörel çizim motorundaki tema anahtarı (Örn: 'forest', 'starry', 'sunrise', 'lake', 'antique', 'lighthouse')
  final String themeKey;

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

/// Yapbozun Tek Bir Parça Modeli.
///
/// `project.md` 7.2. ve 14. Bölüm (PuzzlePiece) kurallarına göre tanımlanmıştır:
/// Her parça görselin belirli bir koordinatındaki ızgara hücresine karşılık gelir.
class PuzzlePieceModel {
  /// Parçanın benzersiz kimliği
  final String id;

  /// Bağlı olduğu yapbozun kimliği
  final String puzzleId;

  /// Izgaradaki parça sırası (0'dan totalPieces - 1'e kadar)
  final int pieceIndex;

  /// Bu parçanın kullanıcının başarısıyla açılıp açılmadığı
  final bool isUnlocked;

  /// Parçanın açıldığı anın zaman damgası
  final DateTime? unlockedAt;

  /// Parçanın kazanıldığı planlı günün tarihi ('YYYY-MM-DD')
  final String? progressDate;

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

/// Gizli Yapboz Üst Modeli (Puzzle Model).
///
/// `project.md` 7. (Gizli Yapboz Sistemi) ve 14. (Veri Modelleri - Puzzle) kurallarına göre:
/// - Alışkanlık süreciyle ([processId]) ve gizli sanat eseriyle ([artworkId]) eşleşir.
/// - [revealOrder]: Alışkanlık oluşturulurken Fisher-Yates algoritmasıyla karıştırılmış rastgele açılma sırasıdır.
/// - Kullanıcı hedefini tamamladıkça bu sıradaki parça sırasıyla açılır.
class PuzzleModel {
  final String id;
  final String processId;
  final String artworkId;

  /// Toplam parça sayısı (planlı gün sayısına eşittir)
  final int totalPieces;

  /// Kullanıcının şu ana kadar açtığı parça sayısı
  final int unlockedPieces;

  /// Önceden karıştırılmış rastgele parça açılma sırası
  final List<int> revealOrder;

  /// Yapbozun devam ediyor / tamamlandı / yarım kaldı durumu
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

  /// Tüm parçaların eksiksiz açılıp açılmadığını belirler
  bool get isFullyCompleted => unlockedPieces >= totalPieces && totalPieces > 0;

  /// Yapbozun keşfedilme yüzdesi (0.0 ile 1.0 arasında)
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
