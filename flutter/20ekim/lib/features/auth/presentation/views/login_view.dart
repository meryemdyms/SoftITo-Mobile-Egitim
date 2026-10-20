import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/enums/user_role.dart';
import '../../../../core/utils/validation_utils.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../controllers/auth_controller.dart';

class LoginView extends StatefulWidget {
  final String? returnTo;

  const LoginView({super.key, this.returnTo});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  UserRole _selectedRole = UserRole.customer;

  @override
  void initState() {
    super.initState();
    // Default demo email
    _emailController.text = 'customer@demo.com';
    _passwordController.text = 'demo1234';
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _fillDemoCredentials(UserRole role) {
    setState(() {
      _selectedRole = role;
      if (role == UserRole.customer) {
        _emailController.text = 'customer@demo.com';
        _passwordController.text = 'demo1234';
      } else {
        _emailController.text = 'company@demo.com';
        _passwordController.text = 'demo1234';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authCtrl = context.watch<AuthController>();

    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBar(title: const Text('Giriş Yap')),
      body: SingleChildScrollView(
        padding: AppSpacing.edgeInsetsLg,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Disclaimer Notice
              Container(
                padding: AppSpacing.edgeInsetsMd,
                decoration: BoxDecoration(
                  color: AppColors.infoBg,
                  borderRadius: AppRadius.radiusMd,
                  border: Border.all(color: AppColors.info.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.shield_outlined,
                      size: 20,
                      color: AppColors.info,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        AppConstants.demoDisclaimer,
                        style: AppTypography.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Role Segment
              Text('Giriş Türü', style: AppTypography.labelLarge),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  Expanded(
                    child: _buildRoleButton(
                      label: 'Müşteri Girişi',
                      icon: Icons.person_outline_rounded,
                      role: UserRole.customer,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: _buildRoleButton(
                      label: 'Firma Girişi',
                      icon: Icons.storefront_outlined,
                      role: UserRole.company,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),

              // Demo Shortcut Chips
              Row(
                children: [
                  ActionChip(
                    avatar: const Icon(
                      Icons.bolt_rounded,
                      size: 16,
                      color: AppColors.primary,
                    ),
                    label: const Text('Demo Müşteri Doldur'),
                    onPressed: () => _fillDemoCredentials(UserRole.customer),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  ActionChip(
                    avatar: const Icon(
                      Icons.bolt_rounded,
                      size: 16,
                      color: AppColors.warning,
                    ),
                    label: const Text('Demo Firma Doldur'),
                    onPressed: () => _fillDemoCredentials(UserRole.company),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),

              // Form inputs
              AppTextField(
                label: 'E-posta Adresi',
                hint: 'ornek@demo.com',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: ValidationUtils.validateEmail,
                prefixIcon: const Icon(
                  Icons.email_outlined,
                  color: AppColors.muted,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                label: 'Şifre',
                hint: '••••••••',
                controller: _passwordController,
                obscureText: true,
                validator: (val) =>
                    ValidationUtils.validateMinLength(val, 4, 'Şifre'),
                prefixIcon: const Icon(
                  Icons.lock_outline_rounded,
                  color: AppColors.muted,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Submit Button
              AppButton(
                label: 'Giriş Yap',
                isLoading: authCtrl.isLoading,
                onPressed: () => _handleLogin(context, authCtrl),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Registration links
              const Divider(color: AppColors.border),
              const SizedBox(height: AppSpacing.md),
              Center(
                child: Column(
                  children: [
                    TextButton(
                      onPressed: () => context.push('/auth/register-customer'),
                      child: const Text(
                        'Hesabınız yok mu? Müşteri olarak kayıt olun',
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.push('/auth/register-company'),
                      child: const Text(
                        'Araç kiralama firmanız mı var? Firma olarak kaydolun',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleButton({
    required String label,
    required IconData icon,
    required UserRole role,
  }) {
    final isSelected = _selectedRole == role;
    return InkWell(
      onTap: () {
        setState(() => _selectedRole = role);
      },
      borderRadius: AppRadius.radiusMd,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surface,
          borderRadius: AppRadius.radiusMd,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : AppColors.ink,
              size: 22,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTypography.labelLarge.copyWith(
                color: isSelected ? Colors.white : AppColors.ink,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleLogin(
    BuildContext context,
    AuthController authCtrl,
  ) async {
    if (!_formKey.currentState!.validate()) return;

    final success = await authCtrl.login(
      email: _emailController.text,
      password: _passwordController.text,
      role: _selectedRole,
    );

    if (success && mounted) {
      AppSnackbar.showSuccess(context, 'Başarıyla giriş yapıldı.');

      if (_selectedRole == UserRole.company) {
        context.go('/company/dashboard');
      } else {
        // Customer login: if sanitized returnTo exists, navigate back there
        if (widget.returnTo != null && widget.returnTo!.startsWith('/')) {
          context.go(widget.returnTo!);
        } else {
          context.go('/');
        }
      }
    } else if (mounted && authCtrl.errorMessage != null) {
      AppSnackbar.showError(context, authCtrl.errorMessage!);
    }
  }
}
