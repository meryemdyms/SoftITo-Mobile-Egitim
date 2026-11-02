import 'package:flutter/material.dart';
import '../../features/auth/services/auth_service.dart';
import '../../features/collection/repositories/collection_repository.dart';
import '../../features/habits/controllers/habit_controller.dart';
import '../../features/habits/repositories/habit_repository.dart';
import '../../features/progress/controllers/analytics_controller.dart';
import '../../features/puzzle/repositories/artwork_repository.dart';
import 'storage_service.dart';

/// Ritmo Merkezi Uygulama Bağımlılık ve Durum Kapsamı (Dependency Injection Scope).
///
/// Flutter'ın yerel [InheritedWidget] mekanizmasını kullanarak, uygulama genelindeki
/// tüm servisleri, depoları (repository) ve kontrolcüleri (controller)
/// widget ağacına yayar. Böylece üçüncü parti karmaşık kütüphanelere ihtiyaç duymadan
/// temiz, test edilebilir ve merkezi bir bağımlılık erişimi sağlanır.
class AppScope extends InheritedWidget {
  /// Kalıcı yerel depolama servisi
  final StorageService storageService;

  /// Kimlik doğrulama ve kullanıcı oturumu yönetim servisi
  final AuthService authService;

  /// Alışkanlık, takvim ve süreç verilerine erişim sağlayan depo
  final HabitRepository habitRepository;

  /// Tamamlanan ve yarım kalan eserlerin koleksiyon deposu
  final CollectionRepository collectionRepository;

  /// Küratörlü gizli görsel havuzunu yöneten sanat eseri deposu
  final ArtworkRepository artworkRepository;

  /// Alışkanlık iş mantığı, günlük ilerleme ve yapboz açma kontrolcüsü
  final HabitController habitController;

  /// Süreç sonu ve haftalık gelişim analizlerini hesaplayan kontrolcü
  final AnalyticsController analyticsController;

  const AppScope({
    super.key,
    required this.storageService,
    required this.authService,
    required this.habitRepository,
    required this.collectionRepository,
    required this.artworkRepository,
    required this.habitController,
    required this.analyticsController,
    required super.child,
  });

  /// Widget ağacının herhangi bir noktasından [BuildContext] ile [AppScope] örneğine erişim sağlar.
  ///
  /// Örnek kullanım:
  /// ```dart
  /// final habitController = AppScope.of(context).habitController;
  /// ```
  static AppScope of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'Widget ağacında AppScope bulunamadı. Widget AppScope altında olmalıdır.');
    return scope!;
  }

  /// Servis referansları uygulama boyunca sabit kaldığı ve state güncellemeleri
  /// [ChangeNotifier] kontrolcüleri üzerinden dinlendiği için yeniden çizim tetiklemez.
  @override
  bool updateShouldNotify(covariant AppScope oldWidget) => false;
}
