import '../models/museum_model.dart';
import '../models/museum_scene_model.dart';
import '../models/social_models.dart';

/// Cep Müzem — Müze Repository Arabirimi (MuseumRepository)
///
/// MVVM mimarisinde View ve ViewModel'ler doğrudan Firestore veya Storage'a erişmez;
/// veri erişim işlemlerini bu repository kontratı üzerinden gerçekleştirir.
///
/// Görevleri:
/// - Keşfet akışını kesin ürün kurallarına göre sıralama ve tekilleştirme
/// - Müze detayı ve 2D sahne odalarını getirme
/// - Müze beğenme, kaydetme ve yorum ekleme işlemlerini yürütme
/// - Kullanıcının kendi müzelerini ve kaydettiklerini listeleme
abstract class MuseumRepository {
  /// Keşfet akışını kesin ürün kurallarına göre getirir:
  /// 1. Takip edilen hesaplar varsa: Önce onların bütün erişilebilir müzeleri (en yeniden eskiye).
  /// 2. Takip edilenlerin müzeleri bittikten sonra popüler müzeler başlar.
  /// 3. Takip edilen yoksa veya müzesi yoksa popülerler doğrudan başlar.
  /// 4. Aynı müze akış içerisinde asla tekrarlanmaz.
  /// 5. Gizli veya erişilemeyen müzeler popüler akışa dahil edilmez.
  Future<List<MuseumModel>> getExploreFeed({String? currentUserId});

  /// Benzersiz kimliği (ID) ile müze künyesini getirir
  Future<MuseumModel?> getMuseumById(String museumId, {String? currentUserId});

  /// Müzenin 2D sahne odalarını ve eser yuvalarını getirir
  Future<MuseumSceneModel?> getMuseumScene(String museumId);

  /// Müzeyi kaydeder veya yer imini kaldırır (başarılıysa yeni durumu döner)
  Future<bool> toggleSaveMuseum({
    required String museumId,
    required String userId,
  });

  /// Müzeyi beğenir veya beğeniyi kaldırır (başarılıysa yeni durumu döner)
  Future<bool> toggleLikeMuseum({
    required String museumId,
    required String userId,
  });

  /// Müzeye yeni ziyaretçi notu / yorum ekler
  Future<MuseumCommentModel> addComment({
    required String museumId,
    required String userId,
    required String userName,
    String? userPhotoUrl,
    required String text,
  });

  /// Müzenin tüm ziyaretçi yorumlarını getirir
  Future<List<MuseumCommentModel>> getComments(String museumId);

  /// Belirli bir kullanıcının kaydettiği (yer imine eklediği) sergileri getirir
  Future<List<MuseumModel>> getSavedMuseums(String userId);

  /// Belirli bir küratörün kendi oluşturduğu müzeleri getirir
  Future<List<MuseumModel>> getUserMuseums(String userId);

  /// Gerçek Firebase projesinin yapılandırılıp yapılandırılmadığını belirtir
  bool get isFirebaseConfigured;
}

