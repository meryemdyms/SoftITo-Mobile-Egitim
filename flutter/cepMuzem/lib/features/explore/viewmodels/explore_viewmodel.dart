import 'package:flutter/foundation.dart';

import '../../../shared/models/museum_model.dart';
import '../../../shared/repositories/museum_repository.dart';

/// Keşfet akışının arayüz durumları
enum ExploreState {
  /// Akış verileri yükleniyor
  loading,

  /// Veriler başarıyla yüklendi
  loaded,

  /// Veri çekilirken hata oluştu
  error,
}

/// Cep Müzem — Sergi Keşfet Akışı ViewModel (ExploreViewModel)
///
/// project.md ve AGENTS.md Kesin Ürün Kararları:
/// - Takip edilen kullanıcı varsa önce onların tüm erişilebilir müzeleri (en yeniden eskiye).
/// - Takip edilenlerin müzeleri bittikten sonra popülerler başlar.
/// - Takip edilen yoksa popülerler doğrudan başlar.
/// - Aynı müze akış içerisinde tekrarlanmaz.
/// - Beğeni ve kaydetme durumları yerel olarak güncellenir.
class ExploreViewModel extends ChangeNotifier {
  /// Veri katmanı repository arabirimi
  final MuseumRepository repository;

  /// Giriş yapmış mevcut kullanıcının ID'si (takip ve kaydetme filtreleri için)
  final String? currentUserId;

  /// Mevcut akış durumu
  ExploreState _state = ExploreState.loading;

  /// Ekrandaki sıralı müze listesi
  List<MuseumModel> _museums = [];

  /// Varsa hata mesajı
  String? _errorMessage;

  /// ExploreViewModel yapıcısı; başlatıldığında akışı yükler
  ExploreViewModel({required this.repository, this.currentUserId}) {
    loadFeed();
  }

  // Dışa açık durum getter'ları
  ExploreState get state => _state;
  List<MuseumModel> get museums => _museums;
  String? get errorMessage => _errorMessage;

  /// Repository'nin gerçek Firebase'e bağlı olup olmadığını bildirir (demo uyarısı için)
  bool get isFirebaseConfigured => repository.isFirebaseConfigured;

  /// Keşfet akışını repository üzerinden kurallara uygun olarak yükler
  Future<void> loadFeed() async {
    _state = ExploreState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      // Repository kurallara göre takip edilenler + popülerler sıralamasını yapar
      _museums = await repository.getExploreFeed(currentUserId: currentUserId);
      _state = ExploreState.loaded;
    } catch (e) {
      _state = ExploreState.error;
      _errorMessage = 'Katalog yüklenirken bir hata oluştu: ${e.toString()}';
    } finally {
      notifyListeners();
    }
  }

  /// Bir müzenin kaydedilme (bookmark) durumunu değiştirir
  Future<void> toggleSaveMuseum(String museumId) async {
    if (currentUserId == null) return;

    try {
      final isSaved = await repository.toggleSaveMuseum(
        museumId: museumId,
        userId: currentUserId!,
      );

      // UI listesindeki ilgili kartın durumunu anında güncelle
      final index = _museums.indexWhere((m) => m.id == museumId);
      if (index != -1) {
        _museums[index] = _museums[index].copyWith(
          isSavedByCurrentUser: isSaved,
        );
        notifyListeners();
      }
    } catch (_) {
      // Hata durumunda mevcut durum korunur
    }
  }
}

