import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app/router/app_router.dart';
import 'app/theme/app_theme.dart';
import 'features/auth/repositories/auth_repository.dart';
import 'features/auth/repositories/mock_auth_repository.dart';
import 'features/auth/viewmodels/auth_viewmodel.dart';
import 'shared/repositories/mock_museum_repository.dart';
import 'shared/repositories/museum_repository.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase projesi yapılandırılmadığı sürece kurallara uygun olarak
  // ayrı DEMO repository implementasyonları açıkça kullanılır.
  final authRepository = MockAuthRepository(startWithDemoUser: true);
  final museumRepository = MockMuseumRepository();

  runApp(
    CepMuzemApp(
      authRepository: authRepository,
      museumRepository: museumRepository,
    ),
  );
}

class CepMuzemApp extends StatefulWidget {
  final AuthRepository authRepository;
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
  late final AuthViewModel _authViewModel;
  late final AppRouter _appRouter;

  @override
  void initState() {
    super.initState();
    _authViewModel = AuthViewModel(authRepository: widget.authRepository);
    _appRouter = AppRouter(authViewModel: _authViewModel);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthRepository>.value(value: widget.authRepository),
        Provider<MuseumRepository>.value(value: widget.museumRepository),
        ChangeNotifierProvider<AuthViewModel>.value(value: _authViewModel),
      ],
      child: MaterialApp.router(
        title: 'Cep Müzem',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        routerConfig: _appRouter.router,
      ),
    );
  }
}
