import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_dimensions.dart';
import '../../../app/theme/app_typography.dart';
import '../../../shared/widgets/archive_button.dart';
import '../viewmodels/auth_viewmodel.dart';

/// Cep Müzem — Küratör Giriş Ekranı (LoginView)
///
/// project.md Madde 7 gereksinimleri doğrultusunda:
/// - E-posta ve şifre ile giriş imkânı sunar.
/// - Form validasyonu (boş kontrolü, e-posta formatı, min 6 karakter) yapar.
/// - AuthViewModel aracılığıyla oturum açar ve başarılı olunca Keşfet akışına yönlendirir.
class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  /// Form doğrulama anahtarı
  final _formKey = GlobalKey<FormState>();

  /// Hızlı test için varsayılan demo e-posta ile doldurulan metin denetleyicisi
  final _emailController = TextEditingController(text: 'demo@cepmuzem.com');

  /// Hızlı test için varsayılan demo şifre ile doldurulan metin denetleyicisi
  final _passwordController = TextEditingController(text: '123456');

  /// Şifre gizleme / gösterme durumu
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Giriş butonuna basıldığında tetiklenen oturum açma metodu
  Future<void> _handleLogin() async {
    // Form validasyonu başarısız ise işleme devam edilmez
    if (!_formKey.currentState!.validate()) return;

    final authVm = Provider.of<AuthViewModel>(context, listen: false);
    final success = await authVm.signIn(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );

    // Giriş başarılı ve widget hâlâ ekrandaysa Keşfet sayfasına yönlendirilir
    if (success && mounted) {
      context.go('/explore');
    }
  }

  @override
  Widget build(BuildContext context) {
    // ViewModel durumunu (yükleniyor, hata vb.) dinlemek için watch kullanılır
    final authVm = context.watch<AuthViewModel>();

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.horizontalPadding,
              vertical: AppDimensions.space24,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 1. Müze Logosu / Simgesi
                  Center(
                    child: Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: AppColors.parchment,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.museumStone),
                      ),
                      child: const Icon(
                        Icons.museum,
                        size: 34,
                        color: AppColors.antiqueBronze,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.space16),

                  // 2. Karşılama Başlığı ve Açıklama
                  Text(
                    'Küratör Girişi',
                    style: AppTypography.pageTitle,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppDimensions.space8),
                  Text(
                    'Müzenizi ve sergilerinizi yönetmek için oturum açın.',
                    style: AppTypography.bodySecondary,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppDimensions.space32),

                  // 3. Varsa Hata Bildirimi Kutusu (Terracotta tonu ile sakin uyarı)
                  if (authVm.errorMessage != null) ...[
                    Container(
                      padding: const EdgeInsets.all(AppDimensions.space12),
                      decoration: BoxDecoration(
                        color: AppColors.terracotta.withValues(alpha: 0.1),
                        borderRadius: AppDimensions.buttonBorderRadius,
                        border: Border.all(
                          color: AppColors.terracotta.withValues(alpha: 0.4),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: AppColors.terracotta,
                            size: 20,
                          ),
                          const SizedBox(width: AppDimensions.space8),
                          Expanded(
                            child: Text(
                              authVm.errorMessage!,
                              style: AppTypography.caption.copyWith(
                                color: AppColors.terracotta,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppDimensions.space16),
                  ],

                  // 4. E-posta Giriş Alanı
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'E-posta Adresi',
                      prefixIcon: Icon(
                        Icons.email_outlined,
                        color: AppColors.secondaryText,
                      ),
                    ),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'E-posta adresi giriniz.';
                      }
                      if (!val.contains('@')) {
                        return 'Geçerli bir e-posta giriniz.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppDimensions.space16),

                  // 5. Şifre Giriş Alanı (Görünürlük geçişli)
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: 'Şifre',
                      prefixIcon: const Icon(
                        Icons.lock_outline,
                        color: AppColors.secondaryText,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: AppColors.secondaryText,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'Şifre giriniz.';
                      }
                      if (val.length < 6) {
                        return 'Şifre en az 6 karakter olmalıdır.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppDimensions.space24),

                  // 6. Giriş Yap Aksiyon Butonu
                  ArchiveButton(
                    label: 'Giriş Yap',
                    isLoading: authVm.isLoading,
                    onPressed: _handleLogin,
                  ),
                  const SizedBox(height: AppDimensions.space16),

                  // 7. Yeni Küratör Kaydı Yönlendirmesi
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Henüz hesabınız yok mu?',
                        style: AppTypography.bodySecondary,
                      ),
                      TextButton(
                        onPressed: () {
                          context.push('/register');
                        },
                        child: const Text('Kayıt Ol'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

