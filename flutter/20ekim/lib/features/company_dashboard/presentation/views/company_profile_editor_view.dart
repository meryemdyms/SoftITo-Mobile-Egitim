import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/utils/validation_utils.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../controllers/company_dashboard_controller.dart';

class CompanyProfileEditorView extends StatefulWidget {
  const CompanyProfileEditorView({super.key});

  @override
  State<CompanyProfileEditorView> createState() =>
      _CompanyProfileEditorViewState();
}

class _CompanyProfileEditorViewState extends State<CompanyProfileEditorView> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameCtrl;
  late TextEditingController _phoneCtrl;
  late TextEditingController _addressCtrl;
  late TextEditingController _hoursCtrl;
  late TextEditingController _descCtrl;

  @override
  void initState() {
    super.initState();
    final company = context.read<CompanyDashboardController>().company;
    _nameCtrl = TextEditingController(text: company?.name ?? '');
    _phoneCtrl = TextEditingController(text: company?.phone ?? '');
    _addressCtrl = TextEditingController(text: company?.address ?? '');
    _hoursCtrl = TextEditingController(text: company?.openingHours ?? '');
    _descCtrl = TextEditingController(text: company?.description ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    _hoursCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dashboardCtrl = context.watch<CompanyDashboardController>();
    final authCtrl = context.watch<AuthController>();

    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBar(title: const Text('Firma Vitrinini Düzenle')),
      body: SingleChildScrollView(
        padding: AppSpacing.edgeInsetsLg,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Müşterilerin Gördüğü Vitrin Bilgileri',
                style: AppTypography.titleMedium,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Bu bilgiler firma vitrini ve araç detay sayfalarında müşterilere gösterilir.',
                style: AppTypography.bodySmall,
              ),
              const SizedBox(height: AppSpacing.lg),

              AppTextField(
                label: 'Firma Adı',
                controller: _nameCtrl,
                validator: (v) =>
                    ValidationUtils.validateMinLength(v, 2, 'Firma Adı'),
              ),
              const SizedBox(height: AppSpacing.md),

              AppTextField(
                label: 'İletişim Telefonu',
                controller: _phoneCtrl,
                keyboardType: TextInputType.phone,
                validator: ValidationUtils.validatePhone,
              ),
              const SizedBox(height: AppSpacing.md),

              AppTextField(
                label: 'Çalışma Saatleri',
                hint: 'Örn: 08:30 - 20:00',
                controller: _hoursCtrl,
                validator: (v) =>
                    ValidationUtils.validateRequired(v, 'Çalışma Saatleri'),
              ),
              const SizedBox(height: AppSpacing.md),

              AppTextField(
                label: 'Açık Adres',
                controller: _addressCtrl,
                maxLines: 2,
                validator: (v) =>
                    ValidationUtils.validateMinLength(v, 5, 'Adres'),
              ),
              const SizedBox(height: AppSpacing.md),

              AppTextField(
                label: 'Firma Tanıtım Açıklaması',
                controller: _descCtrl,
                maxLines: 4,
                validator: (v) =>
                    ValidationUtils.validateMinLength(v, 10, 'Açıklama'),
              ),
              const SizedBox(height: AppSpacing.xl),

              AppButton(
                label: 'Değişiklikleri Kaydet',
                isLoading: dashboardCtrl.isLoading,
                onPressed: () => _handleSave(context, dashboardCtrl, authCtrl),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleSave(
    BuildContext context,
    CompanyDashboardController dashboardCtrl,
    AuthController authCtrl,
  ) async {
    if (!_formKey.currentState!.validate()) return;
    final currentCompany = dashboardCtrl.company;
    final user = authCtrl.currentUser;
    if (currentCompany == null || user == null) return;

    final updated = currentCompany.copyWith(
      name: _nameCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
      address: _addressCtrl.text.trim(),
      openingHours: _hoursCtrl.text.trim(),
      description: _descCtrl.text.trim(),
    );

    final success = await dashboardCtrl.updateCompanyProfile(updated, user.id);
    if (success && mounted) {
      AppSnackbar.showSuccess(context, 'Firma vitrin bilgileri güncellendi.');
      Navigator.pop(context);
    } else if (mounted && dashboardCtrl.errorMessage != null) {
      AppSnackbar.showError(context, dashboardCtrl.errorMessage!);
    }
  }
}
