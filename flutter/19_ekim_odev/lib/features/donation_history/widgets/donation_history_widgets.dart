import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/extensions/date_extensions.dart';
import '../models/donation_history_model.dart';

/// Bağış türünü gösteren renkli etiket
class DonationTypeBadge extends StatelessWidget {
  const DonationTypeBadge({super.key, required this.donationType});

  final String donationType;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isWholeBlood = donationType == 'Tam Kan';
    final isPlatelet = donationType == 'Trombosit';

    final badgeColor = isWholeBlood
        ? colorScheme.primary
        : (isPlatelet ? colorScheme.tertiary : colorScheme.secondary);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: badgeColor.withValues(alpha: 0.3)),
      ),
      child: Text(
        donationType,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: badgeColor,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}

class _DonationCardContent extends StatelessWidget {
  const _DonationCardContent({required this.record});

  final DonationRecord record;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                record.hospitalName,
                style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            DonationTypeBadge(donationType: record.donationType),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          '${record.date.toFormattedTurkish()} (${record.date.daysAgo()} gün önce)',
          style: textTheme.bodySmall?.copyWith(color: colorScheme.outline),
        ),
        if (record.notes.isNotEmpty) ...[
          const SizedBox(height: 6),
          Text(record.notes, style: textTheme.bodySmall),
        ],
      ],
    );
  }
}

/// Tekil bağış geçmişi kartı
class DonationRecordCard extends StatelessWidget {
  const DonationRecordCard({
    super.key,
    required this.record,
    required this.onDelete,
  });

  final DonationRecord record;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: colorScheme.primary.withValues(alpha: 0.1),
              child: Icon(Icons.water_drop, color: colorScheme.primary),
            ),
            const SizedBox(width: 14),
            Expanded(child: _DonationCardContent(record: record)),
            IconButton(
              icon: Icon(Icons.delete_outline, color: colorScheme.error, size: 20),
              onPressed: onDelete,
              tooltip: 'Kaydı Sil',
            ),
          ],
        ),
      ),
    );
  }
}

/// Boş bağış listesi görünümü
class DonationEmptyView extends StatelessWidget {
  const DonationEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bloodtype_outlined, size: 64, color: colorScheme.outline),
            const SizedBox(height: 16),
            Text(
              'Henüz Bağış Kaydı Bulunmuyor',
              style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Yaptığınız kan ve trombosit bağışlarını ekleyerek takip edebilirsiniz.',
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(color: colorScheme.outline),
            ),
          ],
        ),
      ),
    );
  }
}

/// Yeni bağış kaydetme modalı
class AddDonationBottomSheet extends StatefulWidget {
  const AddDonationBottomSheet({super.key, required this.onSubmit});

  final void Function({
    required DateTime date,
    required String hospitalName,
    required String city,
    required String donationType,
    int units,
    String notes,
  }) onSubmit;

  @override
  State<AddDonationBottomSheet> createState() => _AddDonationBottomSheetState();
}

class _AddDonationBottomSheetState extends State<AddDonationBottomSheet> {
  final _hospitalController = TextEditingController();
  final _cityController = TextEditingController(text: 'İstanbul');
  final _notesController = TextEditingController();
  String _selectedType = 'Tam Kan';
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _hospitalController.dispose();
    _cityController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  void _submit() {
    final hospital = _hospitalController.text.trim();
    final city = _cityController.text.trim();

    if (hospital.isEmpty) {
      context.showSnackBar('Lütfen bağış merkezini veya hastaneyi giriniz.', isError: true);
      return;
    }

    widget.onSubmit(
      date: _selectedDate,
      hospitalName: hospital,
      city: city,
      donationType: _selectedType,
      notes: _notesController.text.trim(),
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
            Text(
              'Yeni Bağış Kaydı Ekle',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _hospitalController,
              decoration: const InputDecoration(
                labelText: 'Bağış Merkezi / Hastane',
                prefixIcon: Icon(Icons.location_city_outlined),
              ),
            ),
            const SizedBox(height: 12),
            _buildTypeAndDateRow(),
            const SizedBox(height: 12),
            TextField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Notlar (Opsiyonel)',
                prefixIcon: Icon(Icons.edit_note),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _submit,
              icon: const Icon(Icons.save_outlined),
              label: const Text('Bağışı Kaydet'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeAndDateRow() {
    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<String>(
            initialValue: _selectedType,
            decoration: const InputDecoration(labelText: 'Tür'),
            items: AppConstants.donationTypes
                .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                .toList(),
            onChanged: (val) {
              if (val != null) setState(() => _selectedType = val);
            },
          ),
        ),
        const SizedBox(width: 12),
        OutlinedButton.icon(
          onPressed: _pickDate,
          icon: const Icon(Icons.calendar_today, size: 18),
          label: Text(_selectedDate.toShortDate()),
        ),
      ],
    );
  }
}
