import '../../../core/services/storage_service.dart';
import '../models/collection_models.dart';

/// Ritmo Başarı Koleksiyonu Deposu (Collection Repository).
///
/// `project.md` 10. Bölüm (Başarı Koleksiyonu) kurallarına göre:
/// Kullanıcının süreçleri sonucunda elde ettiği tamamlanmış sanat eserlerini
/// ve yarım kalan hikâyelerini yerel depoda kalıcı olarak saklar ve filtreler.
class CollectionRepository {
  final StorageService storage;

  CollectionRepository({required this.storage});

  StorageService get _storage => storage;

  static const String _keyCollection = 'ritmo_collection';

  /// Koleksiyondaki tüm kayıtlı öğeleri listeden çeker.
  List<CollectionItemModel> getAllItems() {
    final list = _storage.getJsonList(_keyCollection) ?? [];
    return list.map((e) => CollectionItemModel.fromJson(e)).toList();
  }

  /// Sadece tüm parçaları eksiksiz kazanılmış tamamlanan eserleri döner.
  List<CollectionItemModel> getCompletedArtworks() {
    return getAllItems()
        .where((item) => item.category == CollectionCategory.completedArtwork)
        .toList();
  }

  /// Süresi dolan veya eksik kalan süreçlerin parçalarını döner (Yarım Kalan Hikâyeler).
  List<CollectionItemModel> getUnfinishedStories() {
    return getAllItems()
        .where((item) => item.category == CollectionCategory.unfinishedStory)
        .toList();
  }

  /// Koleksiyona yeni bir eser ekler veya mevcut sürece ait kaydı günceller.
  Future<void> addItem(CollectionItemModel item) async {
    final items = getAllItems();
    final index = items.indexWhere((i) => i.id == item.id || (i.processId == item.processId));
    if (index != -1) {
      items[index] = item;
    } else {
      items.add(item);
    }
    await _storage.setJsonList(_keyCollection, items.map((e) => e.toJson()).toList());
  }

  /// Tüm koleksiyon listesini doğrudan yerel depoya kaydeder.
  Future<void> saveAll(List<CollectionItemModel> items) async {
    await _storage.setJsonList(_keyCollection, items.map((e) => e.toJson()).toList());
  }
}
