import 'package:flutter/foundation.dart';

import '../../../shared/models/museum_item_model.dart';
import '../../../shared/models/museum_model.dart';
import '../../../shared/models/museum_scene_model.dart';
import '../../../shared/models/social_models.dart';
import '../../../shared/repositories/museum_repository.dart';

enum DetailState { loading, loaded, error }

class MuseumDetailViewModel extends ChangeNotifier {
  final MuseumRepository repository;
  final String museumId;
  final String? currentUserId;

  DetailState _state = DetailState.loading;
  MuseumModel? _museum;
  MuseumSceneModel? _scene;
  List<MuseumCommentModel> _comments = [];
  MuseumItemModel? _selectedItem;
  String? _errorMessage;
  bool _isActionInProgress = false;

  MuseumDetailViewModel({
    required this.repository,
    required this.museumId,
    this.currentUserId,
  }) {
    loadDetails();
  }

  DetailState get state => _state;
  MuseumModel? get museum => _museum;
  MuseumSceneModel? get scene => _scene;
  List<MuseumCommentModel> get comments => _comments;
  MuseumItemModel? get selectedItem => _selectedItem;
  String? get errorMessage => _errorMessage;
  bool get isActionInProgress => _isActionInProgress;

  Future<void> loadDetails() async {
    _state = DetailState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final fetchedMuseum = await repository.getMuseumById(
        museumId,
        currentUserId: currentUserId,
      );
      if (fetchedMuseum == null) {
        _state = DetailState.error;
        _errorMessage = 'Müze bulunamadı veya erişim yetkiniz yok.';
        notifyListeners();
        return;
      }

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

  void selectItem(MuseumItemModel item) {
    _selectedItem = item;
    notifyListeners();
  }

  void clearSelection() {
    _selectedItem = null;
    notifyListeners();
  }

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
      _comments.insert(0, newComment);
      _museum = _museum!.copyWith(commentCount: _museum!.commentCount + 1);
      notifyListeners();
      return true;
    } catch (_) {
      return false;
    }
  }
}
