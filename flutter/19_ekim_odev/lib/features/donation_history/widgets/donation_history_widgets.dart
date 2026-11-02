import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/extensions/date_extensions.dart';
import '../models/donation_history_model.dart';

/// Bağış türünü (Tam Kan, Trombosit, Plazma) renkli ve belirgin gösteren etiket (badge).
class DonationTypeBadge extends StatelessWidget {
  const DonationTypeBadge({super.key, required this.donationType});

  /// Bağış türü metni
  final String donationType;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isWholeBlood = donationType == 'Tam Kan';
    final isPlatelet = donationType == 'Trombosit';

    // Tür bazlı renk seçimi (Tam Kan: Birincil Kırmızı, Trombosit: Kehribar/Turuncu, Plazma: Deniz Yeşili)
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

/// Bağış kartının merkez metin içeriği (Hastane adı, tarih, geçen gün ve ek notlar).
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
        // Hastane adı ve bağış türü rozeti
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
        // Türkçe formatlanmış bağış tarihi ve kaç gün önce yapıldığı
        Text(
          '${record.date.toFormattedTurkish()} (${record.date.daysAgo()} gün önce)',
          style: textTheme.bodySmall?.copyWith(color: colorScheme.outline),
        ),
        // Varsa kullanıcı notu
        if (record.notes.isNotEmpty) ...[
          const SizedBox(height: 6),
          Text(record.notes, style: textTheme.bodySmall),
        ],
      ],
    );
  }
}

/// Tekil bağış geçmişi kaydını gösteren kart bileşeni.
class DonationRecordCard extends StatelessWidget {
  const DonationRecordCard({
    super.key,
    required this.record,
    required this.onDelete,
  });

  /// Görüntülenecek bağış kaydı
  final DonationRecord record;

  /// Kayıt silindiğinde çalışacak fonksiyon
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
            // Kan damlası dairesel ikonu
            CircleAvatar(
              radius: 20,
              backgroundColor: colorScheme.primary.withValues(alpha: 0.1),
              child: Icon(Icons.water_drop, color: colorScheme.primary),
            ),
            const SizedBox(width: 14),
            // Bağış bilgileri
            Expanded(child: _DonationCardContent(record: record)),
            // Silme butonu
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

/// Henüz hiç bağış kaydı bulunmadığında gösterilen boş durum (Empty State) widget'ı.
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

/// Yeni bir kan bağışı kaydetmek için açılan alt form modalı (BottomSheet).
class AddDonationBottomSheet extends StatefulWidget {
  const AddDonationBottomSheet({super.key, required this.onSubmit});

  /// Form tamamlandığında bağış bilgilerini controller'a aktaran callback
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

  /// Tarih seçici diyalog penceresini açar (Gelecek tarihler seçilemez).
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

  /// Formu doğrular ve yeni bağışı kaydeder.
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
      // Klavye açıldığında formun yukarı kaydırılması için insets padding
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
            // Bağış merkezi veya hastane adı
            TextField(
              controller: _hospitalController,
              decoration: const InputDecoration(
                labelText: 'Bağış Merkezi / Hastane',
                prefixIcon: Icon(Icons.location_city_outlined),
              ),
            ),
            const SizedBox(height: 12),
            // Tür seçimi ve tarih belirleme satırı
            _buildTypeAndDateRow(),
            const SizedBox(height: 12),
            // Not alanı
            TextField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Notlar (Opsiyonel)',
                prefixIcon: Icon(Icons.edit_note),
              ),
            ),
            const SizedBox(height: 16),
            // Kaydet butonu
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

  /// Bağış türü Dropdown'u ile Tarih seçici butonunu içeren satır.
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

