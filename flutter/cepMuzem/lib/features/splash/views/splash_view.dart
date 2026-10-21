import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_dimensions.dart';
import '../../../app/theme/app_typography.dart';
import '../../auth/viewmodels/auth_viewmodel.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();

    // Oturum kontrolü ve yönlendirme
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAuthAndNavigate();
    });
  }

  Future<void> _checkAuthAndNavigate() async {
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;

    final authVm = Provider.of<AuthViewModel>(context, listen: false);
    if (authVm.isAuthenticated) {
      context.go('/explore');
    } else {
      context.go('/login');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ivory,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  color: AppColors.museumWhite,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.museumStone, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.deepWalnut.withValues(alpha: 0.08),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.museum_outlined,
                  size: 46,
                  color: AppColors.antiqueBronze,
                ),
              ),
              const SizedBox(height: AppDimensions.space20),
              Text(
                'Cep Müzem',
                style: AppTypography.pageTitle.copyWith(
                  fontSize: 32,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: AppDimensions.space8),
              Text(
                'Kişisel Dijital Müzeniz',
                style: AppTypography.caption.copyWith(
                  letterSpacing: 1.2,
                  color: AppColors.secondaryText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
