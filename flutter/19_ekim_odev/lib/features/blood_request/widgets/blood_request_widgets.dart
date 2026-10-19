import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/extensions/date_extensions.dart';
import '../models/blood_request_model.dart';

/// Aciliyet durumunu görselleştiren rozet
class UrgencyBadge extends StatelessWidget {
  const UrgencyBadge({super.key, required this.urgency});

  final String urgency;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isVeryUrgent = urgency == 'Çok Acil';
    final isUrgent = urgency == 'Acil';

    final badgeColor = isVeryUrgent
        ? colorScheme.error
        : (isUrgent ? colorScheme.tertiary : colorScheme.secondary);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: badgeColor.withValues(alpha: 0.4)),
      ),
      child: Text(
        urgency,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: badgeColor,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}

/// Kan gruplarına göre yatay filtre çubuğu
class BloodGroupFilterBar extends StatelessWidget {
  const BloodGroupFilterBar({
    super.key,
    required this.selectedGroup,
    required this.onGroupSelected,
  });

  final String? selectedGroup;
  final ValueChanged<String?> onGroupSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          FilterChip(
            label: const Text('Tümü'),
            selected: selectedGroup == null,
            onSelected: (_) => onGroupSelected(null),
          ),
          const SizedBox(width: 8),
          ...AppConstants.bloodGroups.map((group) {
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: FilterChip(
                label: Text(group),
                selected: selectedGroup == group,
                onSelected: (_) => onGroupSelected(group),
              ),
            );
          }),
        ],
      ),
    );
  }
}

/// Kan çağrısı kartı üst başlık bölümü
class _BloodRequestCardHeader extends StatelessWidget {
  const _BloodRequestCardHeader({required this.request});

  final BloodRequest request;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: colorScheme.primary,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            request.bloodGroup,
            style: textTheme.titleMedium?.copyWith(
              color: colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                request.hospitalName,
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                '${request.city} • ${request.createdAt.toShortDate()}',
                style: textTheme.bodySmall,
              ),
            ],
          ),
        ),
        UrgencyBadge(urgency: request.urgency),
      ],
    );
  }
}

/// Kan çağrısı ilerleme ve bağışçı buton bölümü
class _BloodRequestCardFooter extends StatelessWidget {
  const _BloodRequestCardFooter({
    required this.request,
    required this.onSupport,
  });

  final BloodRequest request;
  final VoidCallback onSupport;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${request.unitsCollected} / ${request.unitsNeeded} Ünite Toplandı',
                style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              LinearProgressIndicator(
                value: request.progressPercentage,
                minHeight: 6,
                borderRadius: BorderRadius.circular(3),
                backgroundColor: colorScheme.outline.withValues(alpha: 0.2),
                color: request.isFulfilled ? colorScheme.secondary : colorScheme.primary,
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        FilledButton.tonal(
          onPressed: request.isFulfilled ? null : onSupport,
          child: Text(request.isFulfilled ? 'Tamamlandı' : 'Bağışçıyım'),
        ),
      ],
    );
  }
}

/// Kan çağrısı tekil kart widget'ı
class BloodRequestCard extends StatelessWidget {
  const BloodRequestCard({
    super.key,
    required this.request,
    required this.onSupport,
  });

  final BloodRequest request;
  final VoidCallback onSupport;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _BloodRequestCardHeader(request: request),
            const SizedBox(height: 12),
            _BloodRequestCardFooter(
              request: request,
              onSupport: onSupport,
            ),
          ],
        ),
      ),
    );
  }
}

class _CreateRequestHeader extends StatelessWidget {
  const _CreateRequestHeader();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Text(
      'Acil Kan Çağrısı Başlat',
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.primary,
          ),
    );
  }
}

/// Yeni kan çağrısı oluşturma form modalı
class CreateRequestBottomSheet extends StatefulWidget {
  const CreateRequestBottomSheet({
    super.key,
    required this.onSubmit,
  });

  final void Function({
    required String patientName,
    required String bloodGroup,
    required String hospitalName,
    required String city,
    required int unitsNeeded,
    required String urgency,
  }) onSubmit;

  @override
  State<CreateRequestBottomSheet> createState() => _CreateRequestBottomSheetState();
}

class _CreateRequestBottomSheetState extends State<CreateRequestBottomSheet> {
  final _hospitalController = TextEditingController();
  final _cityController = TextEditingController();
  final _unitsController = TextEditingController(text: '2');
  String _selectedBloodGroup = 'A+';
  String _selectedUrgency = 'Acil';

  @override
  void dispose() {
    _hospitalController.dispose();
    _cityController.dispose();
    _unitsController.dispose();
    super.dispose();
  }

  void _submit() {
    final hospital = _hospitalController.text.trim();
    final city = _cityController.text.trim();
    final units = int.tryParse(_unitsController.text) ?? 1;

    if (hospital.isEmpty || city.isEmpty) {
      context.showSnackBar('Lütfen hastane ve şehir bilgilerini giriniz.', isError: true);
      return;
    }

    widget.onSubmit(
      patientName: 'İhtiyaç Sahibi',
      bloodGroup: _selectedBloodGroup,
      hospitalName: hospital,
      city: city,
      unitsNeeded: units,
      urgency: _selectedUrgency,
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _CreateRequestHeader(),
            const SizedBox(height: 16),
            TextField(
              controller: _hospitalController,
              decoration: const InputDecoration(
                labelText: 'Hastane Adı',
                prefixIcon: Icon(Icons.local_hospital_outlined),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _cityController,
              decoration: const InputDecoration(
                labelText: 'Şehir',
                prefixIcon: Icon(Icons.location_city_outlined),
              ),
            ),
            const SizedBox(height: 12),
            _buildDropdowns(),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _submit,
              icon: const Icon(Icons.campaign),
              label: const Text('Çağrıyı Yayınla'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdowns() {
    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<String>(
            initialValue: _selectedBloodGroup,
            decoration: const InputDecoration(labelText: 'Kan Grubu'),
            items: AppConstants.bloodGroups
                .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                .toList(),
            onChanged: (val) {
              if (val != null) setState(() => _selectedBloodGroup = val);
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: DropdownButtonFormField<String>(
            initialValue: _selectedUrgency,
            decoration: const InputDecoration(labelText: 'Aciliyet'),
            items: AppConstants.urgencyLevels
                .map((u) => DropdownMenuItem(value: u, child: Text(u)))
                .toList(),
            onChanged: (val) {
              if (val != null) setState(() => _selectedUrgency = val);
            },
          ),
        ),
      ],
    );
  }
}
