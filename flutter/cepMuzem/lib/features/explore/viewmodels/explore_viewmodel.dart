import 'package:flutter/foundation.dart';

import '../../../shared/models/museum_model.dart';
import '../../../shared/repositories/museum_repository.dart';

enum ExploreState { loading, loaded, error }

class ExploreViewModel extends ChangeNotifier {
  final MuseumRepository repository;
  final String? currentUserId;

  ExploreState _state = ExploreState.loading;
  List<MuseumModel> _museums = [];
  String? _errorMessage;

  ExploreViewModel({required this.repository, this.currentUserId}) {
    loadFeed();
  }

  ExploreState get state => _state;
  List<MuseumModel> get museums => _museums;
  String? get errorMessage => _errorMessage;
  bool get isFirebaseConfigured => repository.isFirebaseConfigured;

  Future<void> loadFeed() async {
    _state = ExploreState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _museums = await repository.getExploreFeed(currentUserId: currentUserId);
      _state = ExploreState.loaded;
    } catch (e) {
      _state = ExploreState.error;
      _errorMessage = 'Katalog yüklenirken bir hata oluştu: ${e.toString()}';
    } finally {
      notifyListeners();
    }
  }

  Future<void> toggleSaveMuseum(String museumId) async {
    if (currentUserId == null) return;

    try {
      final isSaved = await repository.toggleSaveMuseum(
        museumId: museumId,
        userId: currentUserId!,
      );

      final index = _museums.indexWhere((m) => m.id == museumId);
      if (index != -1) {
        _museums[index] = _museums[index].copyWith(
          isSavedByCurrentUser: isSaved,
        );
        notifyListeners();
      }
    } catch (_) {
      // Hata durumunda state korunur
    }
  }
}
