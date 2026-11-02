/// Başarı Koleksiyonu Öğe Kategorisi.
///
/// `project.md` 10. Bölüm (Başarı Koleksiyonu) kurallarına göre:
/// Klasik bronz/gümüş/altın rozet sistemi yerine yapboz eserleri kullanılır.
/// İki ana bölüm bulunur:
/// - [completedArtwork]: Tamamlanan Eserler (Tüm parçaları eksiksiz açılan görseller)
/// - [unfinishedStory]: Yarım Kalan Hikâyeler (Süresi biten veya duraklatılan eksik yapbozlar)
enum CollectionCategory {
  /// Eksiksiz kazanılmış sanat eserleri
  completedArtwork,

  /// Eksik kalan ancak kazanılan parçaları korunan süreçler
  unfinishedStory,
}

/// Başarı Koleksiyonu Parça ve Eser Kayıt Modeli.
///
/// `project.md` 14. Bölüm (Veri Modelleri - CollectionItem) kurallarına göre:
/// Kullanıcının kazandığı tamamlanmış eserleri veya yarım kalan süreçlerini
/// görsel kimliği ([artworkId]), alışkanlık adı ([habitName]), açılan parça sayısı
/// ve tamamlanma oranıyla birlikte saklar.
class CollectionItemModel {
  /// Koleksiyon öğesinin benzersiz kimliği
  final String id;

  /// Eserin sahibi kullanıcının kimliği
  final String userId;

  /// Bağlı yapbozun kimliği
  final String puzzleId;

  /// Bağlı alışkanlık sürecinin kimliği
  final String processId;

  /// Sanat eseri kataloğundaki eserin kimliği (Örn: 'art_forest')
  final String artworkId;

  /// Bu eserin kazanıldığı alışkanlığın adı
  final String habitName;

  /// Koleksiyon kategorisi ([CollectionCategory.completedArtwork] veya [CollectionCategory.unfinishedStory])
  final CollectionCategory category;

  /// Yapbozun tamamlanma yüzdesi (0.0 ile 1.0 arasında, tamamlananlarda 1.0)
  final double completionRate;

  /// Kullanıcının bu eserde açmayı başardığı parça sayısı
  final int unlockedPieces;

  /// Yapbozun toplam parça sayısı
  final int totalPieces;

  /// Koleksiyona eklendiği tarih
  final DateTime collectedAt;

  const CollectionItemModel({
    required this.id,
    required this.userId,
    required this.puzzleId,
    required this.processId,
    required this.artworkId,
    required this.habitName,
    required this.category,
    required this.completionRate,
    required this.unlockedPieces,
    required this.totalPieces,
    required this.collectedAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'puzzleId': puzzleId,
        'processId': processId,
        'artworkId': artworkId,
        'habitName': habitName,
        'category': category.name,
        'completionRate': completionRate,
        'unlockedPieces': unlockedPieces,
        'totalPieces': totalPieces,
        'collectedAt': collectedAt.toIso8601String(),
      };

  factory CollectionItemModel.fromJson(Map<String, dynamic> json) =>
      CollectionItemModel(
        id: json['id'] as String,
        userId: json['userId'] as String,
        puzzleId: json['puzzleId'] as String,
        processId: json['processId'] as String,
        artworkId: json['artworkId'] as String,
        habitName: json['habitName'] as String,
        category: CollectionCategory.values.byName(json['category'] as String),
        completionRate: (json['completionRate'] as num).toDouble(),
        unlockedPieces: json['unlockedPieces'] as int,
        totalPieces: json['totalPieces'] as int,
        collectedAt: DateTime.parse(json['collectedAt'] as String),
      );
}
