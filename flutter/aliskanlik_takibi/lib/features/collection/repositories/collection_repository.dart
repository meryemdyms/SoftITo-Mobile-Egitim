import '../../../core/services/storage_service.dart';
import '../models/collection_models.dart';

/// Ritmo Başarı Koleksiyonu Deposu
class CollectionRepository {
  final StorageService storage;

  CollectionRepository({required this.storage});

  StorageService get _storage => storage;

  static const String _keyCollection = 'ritmo_collection';

  List<CollectionItemModel> getAllItems() {
    final list = _storage.getJsonList(_keyCollection) ?? [];
    return list.map((e) => CollectionItemModel.fromJson(e)).toList();
  }

  List<CollectionItemModel> getCompletedArtworks() {
    return getAllItems()
        .where((item) => item.category == CollectionCategory.completedArtwork)
        .toList();
  }

  List<CollectionItemModel> getUnfinishedStories() {
    return getAllItems()
        .where((item) => item.category == CollectionCategory.unfinishedStory)
        .toList();
  }

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

  Future<void> saveAll(List<CollectionItemModel> items) async {
    await _storage.setJsonList(_keyCollection, items.map((e) => e.toJson()).toList());
  }
}
