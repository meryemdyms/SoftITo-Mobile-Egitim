import 'package:flutter/material.dart';
import '../../features/auth/services/auth_service.dart';
import '../../features/collection/repositories/collection_repository.dart';
import '../../features/habits/controllers/habit_controller.dart';
import '../../features/habits/repositories/habit_repository.dart';
import '../../features/progress/controllers/analytics_controller.dart';
import '../../features/puzzle/repositories/artwork_repository.dart';
import 'storage_service.dart';

/// Ritmo Merkezi Uygulama Bağımlılık ve State Kapsamı
class AppScope extends InheritedWidget {
  final StorageService storageService;
  final AuthService authService;
  final HabitRepository habitRepository;
  final CollectionRepository collectionRepository;
  final ArtworkRepository artworkRepository;
  final HabitController habitController;
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

  static AppScope of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope bulunamadı');
    return scope!;
  }

  @override
  bool updateShouldNotify(covariant AppScope oldWidget) => false;
}
