import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:susadim/core/constants/app_colors.dart';
import 'package:susadim/core/theme/app_theme.dart';
import 'package:susadim/features/dashboard/view/dashboard_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.obsidianSurface,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const SusadimApp());
}

class SusadimApp extends StatelessWidget {
  const SusadimApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Susadım',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const DashboardView(),
    );
  }
}
