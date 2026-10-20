import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/utils/validation_utils.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../controllers/auth_controller.dart';

class CustomerRegisterView extends StatefulWidget {
  const CustomerRegisterView({super.key});

  @override
  State<CustomerRegisterView> createState() => _CustomerRegisterViewState();
}

class _CustomerRegisterViewState extends State<CustomerRegisterView> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _licenceNumberController = TextEditingController(text: 'TR-1029384');
  String _licenceClass = 'B';
  DateTime _birthDate = DateTime(1998, 4, 12);
  DateTime _issueDate = DateTime(2019, 5, 20);

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _licenceNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authCtrl = context.watch<AuthController>();

    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBar(title: const Text('Müşteri Kaydı')),
      body: SingleChildScrollView(
        padding: AppSpacing.edgeInsetsLg,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Kişisel Bilgiler', style: AppTypography.titleMedium),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                label: 'Ad Soyad',
                hint: 'Örn: Ahmet Yılmaz',
                controller: _nameController,
                validator: (v) =>
                    ValidationUtils.validateMinLength(v, 2, 'Ad Soyad'),
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                label: 'E-posta Adresi',
                hint: 'ornek@eposta.com',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: ValidationUtils.validateEmail,
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                label: 'Telefon Numarası',
                hint: '0555 123 4567',
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
              const SizedBox(height: AppSpacing.lg),

              // Birth date picker
              Text('Doğum Tarihi', style: AppTypography.labelLarge),
              const SizedBox(height: AppSpacing.xs),
              InkWell(
                onTap: _pickBirthDate,
                borderRadius: AppRadius.radiusMd,
                child: Container(
                  padding: AppSpacing.edgeInsetsMd,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: AppRadius.radiusMd,
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormatter.formatDate(_birthDate),
                        style: AppTypography.bodyMedium,
                      ),
                      const Icon(
                        Icons.calendar_today_rounded,
                        size: 18,
                        color: AppColors.muted,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Driving Licence Info
              Text(
                'Ehliyet Bilgileri (Demo)',
                style: AppTypography.titleMedium,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Lütfen gerçek kimlik veya ehliyet numaranızı girmeyiniz.',
                style: AppTypography.bodySmall.copyWith(color: AppColors.muted),
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                label: 'Demo Belge Numarası',
                controller: _licenceNumberController,
                validator: (v) =>
                    ValidationUtils.validateRequired(v, 'Belge Numarası'),
              ),
              const SizedBox(height: AppSpacing.md),

              // Licence Class dropdown
              Text('Ehliyet Sınıfı', style: AppTypography.labelLarge),
              const SizedBox(height: AppSpacing.xs),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: AppRadius.radiusMd,
                  border: Border.all(color: AppColors.border),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _licenceClass,
                    isExpanded: true,
                    items: const [
                      DropdownMenuItem(
                        value: 'B',
                        child: Text('B Sınıfı (Otomobil)'),
                      ),
                      DropdownMenuItem(
                        value: 'A2',
                        child: Text('A2 Sınıfı (Motosiklet)'),
                      ),
                      DropdownMenuItem(
                        value: 'C',
                        child: Text('C Sınıfı (Kamyon)'),
                      ),
                    ],
                    onChanged: (val) {
                      if (val != null) setState(() => _licenceClass = val);
                    },
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // Issue Date Picker
              Text('Ehliyet Veriliş Tarihi', style: AppTypography.labelLarge),
              const SizedBox(height: AppSpacing.xs),
              InkWell(
                onTap: _pickIssueDate,
                borderRadius: AppRadius.radiusMd,
                child: Container(
                  padding: AppSpacing.edgeInsetsMd,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: AppRadius.radiusMd,
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormatter.formatDate(_issueDate),
                        style: AppTypography.bodyMedium,
                      ),
                      const Icon(
                        Icons.calendar_today_rounded,
                        size: 18,
                        color: AppColors.muted,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),

              // Submit
              AppButton(
                label: 'Kaydı Tamamla',
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

  Future<void> _pickBirthDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthDate,
      firstDate: DateTime(1940),
      lastDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
    );
    if (picked != null) setState(() => _birthDate = picked);
  }

  Future<void> _pickIssueDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _issueDate,
      firstDate: DateTime(1960),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _issueDate = picked);
  }

  Future<void> _handleSubmit(
    BuildContext context,
    AuthController authCtrl,
  ) async {
    if (!_formKey.currentState!.validate()) return;

    final success = await authCtrl.registerCustomer(
      name: _nameController.text,
      email: _emailController.text,
      phone: _phoneController.text,
      password: _passwordController.text,
      birthDate: _birthDate,
      drivingLicenceNumber: _licenceNumberController.text,
      licenceClass: _licenceClass,
      issueDate: _issueDate,
    );

    if (success && mounted) {
      AppSnackbar.showSuccess(
        context,
        'Müşteri kaydınız başarıyla oluşturuldu.',
      );
      context.go('/');
    } else if (mounted && authCtrl.errorMessage != null) {
      AppSnackbar.showError(context, authCtrl.errorMessage!);
    }
  }
}
