import '../models/museum_model.dart';
import '../models/museum_scene_model.dart';
import '../models/social_models.dart';

abstract class MuseumRepository {
  /// Keşfet akışını kurallara göre getirir:
  /// Takip edilen varsa önce onların müzeleri (en yeniden eskiye), sonra popüler müzeler.
  /// Tekrarlar elenir.
  Future<List<MuseumModel>> getExploreFeed({String? currentUserId});

  /// ID ile müze getirir
  Future<MuseumModel?> getMuseumById(String museumId, {String? currentUserId});

  /// Müzenin 2D sahne verisini getirir
  Future<MuseumSceneModel?> getMuseumScene(String museumId);

  /// Müzeyi kaydeder veya kaydı kaldırır
  Future<bool> toggleSaveMuseum({
    required String museumId,
    required String userId,
  });

  /// Müzeyi beğenir veya beğeniyi kaldırır
  Future<bool> toggleLikeMuseum({
    required String museumId,
    required String userId,
  });

  /// Müzeye yorum ekler
  Future<MuseumCommentModel> addComment({
    required String museumId,
    required String userId,
    required String userName,
    String? userPhotoUrl,
    required String text,
  });

  /// Müzenin yorumlarını getirir
  Future<List<MuseumCommentModel>> getComments(String museumId);

  /// Kullanıcının kaydettiği müzeleri getirir
  Future<List<MuseumModel>> getSavedMuseums(String userId);

  /// Kullanıcının kendi müzelerini getirir
  Future<List<MuseumModel>> getUserMuseums(String userId);

  /// Gerçek Firebase yapılandırma durumu
  bool get isFirebaseConfigured;
}
