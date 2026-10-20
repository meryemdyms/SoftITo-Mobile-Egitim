import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/utils/validation_utils.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../controllers/auth_controller.dart';

class CompanyRegisterView extends StatefulWidget {
  const CompanyRegisterView({super.key});

  @override
  State<CompanyRegisterView> createState() => _CompanyRegisterViewState();
}

class _CompanyRegisterViewState extends State<CompanyRegisterView> {
  final _formKey = GlobalKey<FormState>();

  final _companyNameController = TextEditingController();
  final _contactNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _addressController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _companyNameController.dispose();
    _contactNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _addressController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authCtrl = context.watch<AuthController>();

    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBar(title: const Text('Firma Kaydı')),
      body: SingleChildScrollView(
        padding: AppSpacing.edgeInsetsLg,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Firma Bilgileri', style: AppTypography.titleMedium),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                label: 'Firma / Şirket Ünvanı',
                hint: 'Örn: Yıldız Filo Araç Kiralama',
                controller: _companyNameController,
                validator: (v) =>
                    ValidationUtils.validateMinLength(v, 2, 'Firma Adı'),
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                label: 'Yetkili Adı Soyadı',
                hint: 'Örn: Selim Yıldız',
                controller: _contactNameController,
                validator: (v) =>
                    ValidationUtils.validateMinLength(v, 2, 'Yetkili Adı'),
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                label: 'Kurumsal E-posta',
                hint: 'info@yildizfilo.com',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: ValidationUtils.validateEmail,
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                label: 'İletişim Telefonu',
                hint: '0216 444 0000',
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                validator: ValidationUtils.validatePhone,
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                label: 'Şifre',
                hint: '••••••••',
                controller: _passwordController,
                obscureText: true,
                validator: (v) =>
                    ValidationUtils.validateMinLength(v, 4, 'Şifre'),
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                label: 'Ofis Adresi',
                hint: 'İlçe, İl ve Açık Adres',
                controller: _addressController,
                maxLines: 2,
                validator: (v) =>
                    ValidationUtils.validateMinLength(v, 5, 'Adres'),
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                label: 'Firma Açıklaması',
                hint: 'Filo ve hizmet detaylarınız...',
                controller: _descriptionController,
                maxLines: 3,
                validator: (v) =>
                    ValidationUtils.validateMinLength(v, 10, 'Açıklama'),
              ),
              const SizedBox(height: AppSpacing.xxl),

              // Submit
              AppButton(
                label: 'Firma Hesabını Oluştur',
                isLoading: authCtrl.isLoading,
                onPressed: () => _handleSubmit(context, authCtrl),
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleSubmit(
    BuildContext context,
    AuthController authCtrl,
  ) async {
    if (!_formKey.currentState!.validate()) return;

    final success = await authCtrl.registerCompany(
      companyName: _companyNameController.text,
      contactName: _contactNameController.text,
      email: _emailController.text,
      phone: _phoneController.text,
      password: _passwordController.text,
      address: _addressController.text,
      description: _descriptionController.text,
    );

    if (success && mounted) {
      AppSnackbar.showSuccess(context, 'Firma kaydınız başarıyla oluşturuldu.');
      context.go('/company/dashboard');
    } else if (mounted && authCtrl.errorMessage != null) {
      AppSnackbar.showError(context, authCtrl.errorMessage!);
    }
  }
}
