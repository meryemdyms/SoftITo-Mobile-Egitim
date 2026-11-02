import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app/router/app_router.dart';
import 'app/theme/app_theme.dart';
import 'features/auth/repositories/auth_repository.dart';
import 'features/auth/repositories/mock_auth_repository.dart';
import 'features/auth/viewmodels/auth_viewmodel.dart';
import 'shared/repositories/mock_museum_repository.dart';
import 'shared/repositories/museum_repository.dart';

/// Cep Müzem — Uygulama Başlangıç Noktası (Entry Point)
///
/// Uygulama ilk açıldığında Flutter widget bağlayıcısını hazırlar,
/// mimariye uygun olarak repository bağımlılıklarını kurar ve ana widget'ı başlatır.
void main() {
  // Flutter çerçeve motorunun başlatıldığından emin olunur
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase projesi henüz yapılandırılmadığı sürece mimari kurallara uygun olarak
  // ayrı DEMO repository implementasyonları açıkça ve şeffafça kullanılır.
  // Gerçek Firebase bağlantısı sağlandığında bu nesneler Firebase repository'leri ile değiştirilir.
  final authRepository = MockAuthRepository(startWithDemoUser: true);
  final museumRepository = MockMuseumRepository();

  // Ana uygulama widget'ı başlatılır
  runApp(
    CepMuzemApp(
      authRepository: authRepository,
      museumRepository: museumRepository,
    ),
  );
}

/// [CepMuzemApp], uygulamanın en üst düzey kök widget'ıdır.
///
/// MultiProvider ile bağımlılık enjeksiyonunu (DI) yönetir,
/// tema konfigürasyonunu ve go_router tabanlı navigasyonu bağlar.
class CepMuzemApp extends StatefulWidget {
  /// Kimlik doğrulama işlemleri için kullanılan repository
  final AuthRepository authRepository;

  /// Müze, sergi ve eser işlemleri için kullanılan repository
  final MuseumRepository museumRepository;

  const CepMuzemApp({
    super.key,
    required this.authRepository,
    required this.museumRepository,
  });

  @override
  State<CepMuzemApp> createState() => _CepMuzemAppState();
}

class _CepMuzemAppState extends State<CepMuzemApp> {
  /// Oturum durumunu yöneten ve router yönlendirmelerini tetikleyen ViewModel
  late final AuthViewModel _authViewModel;

  /// go_router tabanlı uygulama rota yapılandırması
  late final AppRouter _appRouter;

  @override
  void initState() {
    super.initState();
    // Repository üzerinden AuthViewModel örneği oluşturulur
    _authViewModel = AuthViewModel(authRepository: widget.authRepository);

    // Rota koruyucuları (guards) ve yönlendirmeler için AuthViewModel rotaya enjekte edilir
    _appRouter = AppRouter(authViewModel: _authViewModel);
  }

  @override
  Widget build(BuildContext context) {
    // MultiProvider ile repository ve ViewModel'ler widget ağacının geneline sağlanır
    return MultiProvider(
      providers: [
        // Repository arabirimleri sağlayıcıya eklenir
        Provider<AuthRepository>.value(value: widget.authRepository),
        Provider<MuseumRepository>.value(value: widget.museumRepository),

        // AuthViewModel değişikliklerini dinleyebilmek için ChangeNotifierProvider kullanılır
        ChangeNotifierProvider<AuthViewModel>.value(value: _authViewModel),
      ],
      // MaterialApp.router ile modern ve bildirimsel navigasyon (go_router) kullanılır
      child: MaterialApp.router(
        title: 'Cep Müzem',
        debugShowCheckedModeBanner: false,
        // Yaşayan Müze tasarım sistemi açık teması uygulanır
        theme: AppTheme.lightTheme,
        // go_router yapılandırması aktarılır
        routerConfig: _appRouter.router,
      ),
    );
  }
}

