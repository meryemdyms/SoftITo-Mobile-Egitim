import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../auth/services/auth_service.dart';
import '../../auth/views/login_view.dart';

/// Ritmo İlk Kullanım Tanıtım Ekranı (Onboarding View).
///
/// `project.md` 5.4. Bölüm gereksinimlerine göre tasarlanmıştır:
/// Kullanıcıya uygulamanın felsefesini, Gizli Yapboz Sistemini ve
/// Başarı Koleksiyonunu 3 adımlı, estetik bir sayfa geçişi ile tanıtır.
/// Atlama (Skip) ve Başlayalım seçenekleri sunar.
class OnboardingView extends StatefulWidget {
  final AuthService authService;

  const OnboardingView({super.key, required this.authService});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Tanıtım adımları içeriği
  final List<({String title, String desc, IconData icon, Color color})> _pages = [
    (
      title: 'Küçük Adımlar, Büyük Değişimler',
      desc: 'Ritmo ile her gün küçük hedefler belirleyin, düzenli tekrarlarla kalıcı alışkanlıklar kazanın.',
      icon: Icons.spa_rounded,
      color: AppColors.primary,
    ),
    (
      title: 'Gizli Yapboz Sistemi',
      desc: 'Her yeni alışkanlıkta size özel gizli bir eser atanır. Hedefinize ulaştığınız her planlı günde bir parça kazanırsınız.',
      icon: Icons.extension_rounded,
      color: AppColors.secondary,
    ),
    (
      title: 'Kişisel Sanat Galeriniz',
      desc: 'Süreç sonunda tamamlanan yapbozlar Başarı Koleksiyonunuza eklenir. Gelişiminizi estetik ve kalıcı bir ödülle kutlayın.',
      icon: Icons.auto_awesome_rounded,
      color: AppColors.accent,
    ),
  ];

  /// Tanıtımı tamamlandı olarak kaydeder ve giriş ekranına yönlendirir.
  void _finishOnboarding() async {
    await widget.authService.setOnboardingCompleted();
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => LoginView(authService: widget.authService),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Üst Köşe Atlama (Geç) Butonu
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextButton(
                  onPressed: _finishOnboarding,
                  child: const Text('Geç', style: TextStyle(color: AppColors.textSecondary)),
                ),
              ),
            ),

            // Sayfalar (PageView)
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (idx) => setState(() => _currentPage = idx),
                itemBuilder: (context, index) {
                  final p = _pages[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // İllüstrasyon / İkon Rozeti
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: p.color.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Icon(p.icon, size: 54, color: AppColors.primary),
                          ),
                        ),
                        const SizedBox(height: 40),

                        // Başlık
                        Text(
                          p.title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Açıklama Metni
                        Text(
                          p.desc,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 15,
                            height: 1.5,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Alt Kısım: Sayfa Göstergeleri (Dots) ve İleri/Başla Butonu
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Sayfa Gösterge Çizgileri
                  Row(
                    children: List.generate(
                      _pages.length,
                      (i) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.only(right: 6),
                        width: _currentPage == i ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentPage == i ? AppColors.primary : AppColors.border,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),

                  // İlerleme veya Başlama Butonu
                  ElevatedButton(
                    onPressed: () {
                      if (_currentPage < _pages.length - 1) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        _finishOnboarding();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    ),
                    child: Text(_currentPage == _pages.length - 1 ? 'Başlayalım' : 'İleri'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
