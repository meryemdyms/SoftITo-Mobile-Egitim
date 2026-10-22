enum CollectionCategory {
  completedArtwork, // Tamamlanan Eserler
  unfinishedStory, // Yarım Kalan Hikâyeler
}

class CollectionItemModel {
  final String id;
  final String userId;
  final String puzzleId;
  final String processId;
  final String artworkId;
  final String habitName;
  final CollectionCategory category;
  final double completionRate;
  final int unlockedPieces;
  final int totalPieces;
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
