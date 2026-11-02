import 'package:flutter/foundation.dart';

import '../../../shared/models/museum_item_model.dart';
import '../../../shared/models/museum_model.dart';
import '../../../shared/models/museum_scene_model.dart';
import '../../../shared/models/social_models.dart';
import '../../../shared/repositories/museum_repository.dart';

/// Müze detay ekranının durumları
enum DetailState {
  /// Müze ve sahne verileri yükleniyor
  loading,

  /// Veriler başarıyla yüklendi
  loaded,

  /// Müze bulunamadı veya yüklenirken hata oluştu
  error,
}

/// Cep Müzem — Müze Detayı ve 2D Deneyimi ViewModel (MuseumDetailViewModel)
///
/// project.md Madde 9 gereksinimleri:
/// - Müze künyesi, 2D sahne ve oda verisi yüklenir.
/// - Seçilen eserin alt paneli (ArtworkSheet) açılması için item seçimi yönetilir.
/// - Beğeni ve kaydetme aksiyonları tek dokunuşla güncellenir.
/// - Yorumlar listelenir ve boş olmayan yeni ziyaretçi notu eklenebilir.
class MuseumDetailViewModel extends ChangeNotifier {
  /// Veri katmanı repository arabirimi
  final MuseumRepository repository;

  /// Görüntülenen müzenin benzersiz kimliği
  final String museumId;

  /// Aktif oturum açmış kullanıcının kimliği
  final String? currentUserId;

  /// Mevcut arayüz durumu
  DetailState _state = DetailState.loading;

  /// Müze künye bilgisi
  MuseumModel? _museum;

  /// Müzenin 2D oda ve eser yerleşimlerini içeren sahne modeli
  MuseumSceneModel? _scene;

  /// Müzeye bırakılmış ziyaretçi yorumları
  List<MuseumCommentModel> _comments = [];

  /// 2D sahnede seçilmiş olan eser (detay paneli açıldığında doldurulur)
  MuseumItemModel? _selectedItem;

  /// Varsa hata açıklaması
  String? _errorMessage;

  /// Beğeni ve kaydetme gibi eşzamanlı istekleri engellemek için işlem kilidi
  bool _isActionInProgress = false;

  /// MuseumDetailViewModel yapıcısı; müze detaylarını ve 2D sahneyi yükler
  MuseumDetailViewModel({
    required this.repository,
    required this.museumId,
    this.currentUserId,
  }) {
    loadDetails();
  }

  // Dışa açık getter'lar
  DetailState get state => _state;
  MuseumModel? get museum => _museum;
  MuseumSceneModel? get scene => _scene;
  List<MuseumCommentModel> get comments => _comments;
  MuseumItemModel? get selectedItem => _selectedItem;
  String? get errorMessage => _errorMessage;
  bool get isActionInProgress => _isActionInProgress;

  /// Müze künyesini, 2D sahne odalarını ve ziyaretçi yorumlarını paralel olarak çeker
  Future<void> loadDetails() async {
    _state = DetailState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      // 1. Müze ana verisini çek
      final fetchedMuseum = await repository.getMuseumById(
        museumId,
        currentUserId: currentUserId,
      );

      // Müze bulunamadıysa veya yetki yoksa hata ver
      if (fetchedMuseum == null) {
        _state = DetailState.error;
        _errorMessage = 'Müze bulunamadı veya erişim yetkiniz yok.';
        notifyListeners();
        return;
      }

      // 2. 2D sahne ve yorum verilerini çek
      final fetchedScene = await repository.getMuseumScene(museumId);
      final fetchedComments = await repository.getComments(museumId);

      _museum = fetchedMuseum;
      _scene = fetchedScene;
      _comments = fetchedComments;
      _state = DetailState.loaded;
    } catch (e) {
      _state = DetailState.error;
      _errorMessage = 'Müze yüklenirken hata oluştu: ${e.toString()}';
    } finally {
      notifyListeners();
    }
  }

  /// 2D sahnede bir esere dokunulduğunda seçili eseri kaydeder
  void selectItem(MuseumItemModel item) {
    _selectedItem = item;
    notifyListeners();
  }

  /// Eser alt paneli kapandığında seçimi temizler
  void clearSelection() {
    _selectedItem = null;
    notifyListeners();
  }

  /// Müzeyi kaydeder veya yer imini kaldırır (project.md Madde 13)
  Future<void> toggleSave() async {
    if (_museum == null || currentUserId == null || _isActionInProgress) return;
    _isActionInProgress = true;
    notifyListeners();

    try {
      final isSaved = await repository.toggleSaveMuseum(
        museumId: museumId,
        userId: currentUserId!,
      );
      _museum = _museum!.copyWith(isSavedByCurrentUser: isSaved);
    } catch (_) {
      // Hata durumunda state korunur
    } finally {
      _isActionInProgress = false;
      notifyListeners();
    }
  }

  /// Müzeyi beğenir veya beğeniyi geri çeker (project.md Madde 13)
  Future<void> toggleLike() async {
    if (_museum == null || currentUserId == null || _isActionInProgress) return;
    _isActionInProgress = true;
    notifyListeners();

    try {
      final isLiked = await repository.toggleLikeMuseum(
        museumId: museumId,
        userId: currentUserId!,
      );
      final newLikeCount = isLiked
          ? _museum!.likeCount + 1
          : (_museum!.likeCount - 1).clamp(0, 999999);
      _museum = _museum!.copyWith(
        isLikedByCurrentUser: isLiked,
        likeCount: newLikeCount,
      );
    } catch (_) {
      // Hata durumunda state korunur
    } finally {
      _isActionInProgress = false;
      notifyListeners();
    }
  }

  /// Müzeye yeni ziyaretçi notu / yorum gönderir (boş yorum kabul edilmez)
  Future<bool> sendComment({
    required String userName,
    required String text,
  }) async {
    if (_museum == null || currentUserId == null || text.trim().isEmpty) {
      return false;
    }

    try {
      final newComment = await repository.addComment(
        museumId: museumId,
        userId: currentUserId!,
        userName: userName,
        text: text.trim(),
      );
      // Yeni yorumu listenin en başına ekle ve yorum sayacını arttır
      _comments.insert(0, newComment);
      _museum = _museum!.copyWith(commentCount: _museum!.commentCount + 1);
      notifyListeners();
      return true;
    } catch (_) {
      return false;
    }
  }
}

