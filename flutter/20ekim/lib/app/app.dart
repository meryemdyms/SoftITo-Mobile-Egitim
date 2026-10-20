import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../core/constants/app_constants.dart';
import '../features/auth/presentation/controllers/auth_controller.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';

class CarRentalApp extends StatefulWidget {
  const CarRentalApp({super.key});

  @override
  State<CarRentalApp> createState() => _CarRentalAppState();
}

class _CarRentalAppState extends State<CarRentalApp> {
  GoRouter? _router;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final authCtrl = context.read<AuthController>();
    _router ??= AppRouter.createRouter(authCtrl);
  }

  @override
  Widget build(BuildContext context) {
    if (_router == null) {
      return const SizedBox.shrink();
    }

    return MaterialApp.router(
      title: AppConstants.appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: _router,
      locale: const Locale('tr', 'TR'),
      supportedLocales: const [Locale('tr', 'TR'), Locale('en', 'US')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
