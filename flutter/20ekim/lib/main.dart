import 'package:flutter/material.dart';

import 'app/app.dart';
import 'app/di/app_providers.dart';

/// Uygulamanın başlangıç noktası (Entry Point).
///
/// Flutter motorunu başlatır, bağımlılık sağlayıcılarını (`AppProviders`)
/// ve ana uygulama widget'ını (`CarRentalApp`) ayağa kaldırır.
void main() {
  // Flutter binding'lerini native platformla senkronize etmek için başlatır.
  WidgetsFlutterBinding.ensureInitialized();

  // Tüm uygulama hiyerarşisine ChangeNotifier ve Repository bağımlılıklarını sağlayan
  // AppProviders ile CarRentalApp'i çalıştırır.
  runApp(const AppProviders(child: CarRentalApp()));
}
