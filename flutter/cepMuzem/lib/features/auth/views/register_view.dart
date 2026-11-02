import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_dimensions.dart';
import '../../../app/theme/app_typography.dart';
import '../../../shared/widgets/archive_button.dart';
import '../viewmodels/auth_viewmodel.dart';

/// Cep Müzem — Yeni Küratör Kayıt Ekranı (RegisterView)
///
/// project.md Madde 7 kurallarına göre:
/// - Ad, Soyad, E-posta ve Şifre (en az 6 karakter) zorunlu alanlardır.
/// - AuthViewModel aracılığıyla hesap oluşturur ve başarılı olunca Keşfet akışına yönlendirir.
class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  /// Form doğrulama anahtarı
  final _formKey = GlobalKey<FormState>();

  /// Ad alanı metin denetleyicisi
  final _firstNameController = TextEditingController();

  /// Soyad alanı metin denetleyicisi
  final _lastNameController = TextEditingController();

  /// E-posta alanı metin denetleyicisi
  final _emailController = TextEditingController();

  /// Şifre alanı metin denetleyicisi
  final _passwordController = TextEditingController();

  /// Şifre gizleme / gösterme durumu
  bool _obscurePassword = true;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Kayıt ol butonuna basıldığında tetiklenen hesap oluşturma metodu
  Future<void> _handleRegister() async {
    // Form doğrulanamazsa devam edilmez
    if (!_formKey.currentState!.validate()) return;

    final authVm = Provider.of<AuthViewModel>(context, listen: false);
    final success = await authVm.signUp(
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );

    // Kayıt başarılı olduğunda ana akışa yönlendirilir
    if (success && mounted) {
      context.go('/explore');
    }
  }

  @override
  Widget build(BuildContext context) {
    // AuthViewModel dinlenerek hata ve yüklenme durumları takip edilir
    final authVm = context.watch<AuthViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Küratör Kaydı',
          style: AppTypography.pageTitle.copyWith(fontSize: 22),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.horizontalPadding,
              vertical: AppDimensions.space16,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 1. Başlık ve Karşılama Metni
                  Text(
                    'Yeni Küratör Hesabı',
                    style: AppTypography.sectionTitle,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppDimensions.space8),
                  Text(
                    'Kendi sergi alanınızı oluşturmak ve anılarınızı sergilemek için kaydolun.',
                    style: AppTypography.bodySecondary,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppDimensions.space24),

                  // 2. Varsa Hata Bildirim Kutusu
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
                      child: Text(
                        authVm.errorMessage!,
                        style: AppTypography.caption.copyWith(
                          color: AppColors.terracotta,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppDimensions.space16),
                  ],

                  // 3. Ad ve Soyad Alanları (Yan yana iki sütun)
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _firstNameController,
                          decoration: const InputDecoration(labelText: 'Ad'),
                          validator: (val) => val == null || val.trim().isEmpty
                              ? 'Ad zorunludur'
                              : null,
                        ),
                      ),
                      const SizedBox(width: AppDimensions.space12),
                      Expanded(
                        child: TextFormField(
                          controller: _lastNameController,
                          decoration: const InputDecoration(labelText: 'Soyad'),
                          validator: (val) => val == null || val.trim().isEmpty
                              ? 'Soyad zorunludur'
                              : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.space16),

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

                  // 5. Şifre Giriş Alanı
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

                  // 6. Kaydı Tamamla Aksiyon Butonu
                  ArchiveButton(
                    label: 'Kaydı Tamamla',
                    isLoading: authVm.isLoading,
                    onPressed: _handleRegister,
                  ),
                  const SizedBox(height: AppDimensions.space16),

                  // 7. Zaten Hesabım Var (Giriş Yap) Yönlendirmesi
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Zaten bir hesabınız var mı?',
                        style: AppTypography.bodySecondary,
                      ),
                      TextButton(
                        onPressed: () {
                          context.pop();
                        },
                        child: const Text('Giriş Yap'),
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

