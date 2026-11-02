import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/extensions/date_extensions.dart';
import '../models/blood_request_model.dart';

/// Çağrının aciliyet durumunu (Normal, Acil, Çok Acil) renk kodlu olarak gösteren rozet (badge).
class UrgencyBadge extends StatelessWidget {
  const UrgencyBadge({super.key, required this.urgency});

  /// Görüntülenecek aciliyet seviyesi metni
  final String urgency;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isVeryUrgent = urgency == 'Çok Acil';
    final isUrgent = urgency == 'Acil';

    // Aciliyete göre dinamik renk seçimi (Çok Acil: Hata/Kırmızı, Acil: Turuncu, Normal: İkincil Yeşil)
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

/// Kan gruplarına göre filtreleme sağlayan yatay kaydırılabilir çip (FilterChip) çubuğu.
class BloodGroupFilterBar extends StatelessWidget {
  const BloodGroupFilterBar({
    super.key,
    required this.selectedGroup,
    required this.onGroupSelected,
  });

  /// Seçili kan grubu (null ise 'Tümü' seçilidir)
  final String? selectedGroup;

  /// Kan grubu seçildiğinde tetiklenen geri çağırım
  final ValueChanged<String?> onGroupSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Tüm çağrıları gösteren varsayılan filtre çipi
          FilterChip(
            label: const Text('Tümü'),
            selected: selectedGroup == null,
            onSelected: (_) => onGroupSelected(null),
          ),
          const SizedBox(width: 8),
          // Sabit kan gruplarından dinamik filtre çipleri üretimi
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

/// Kan çağrısı kartının üst başlık bölümü (Kan grubu rozeti, hastane adı, şehir ve aciliyet).
class _BloodRequestCardHeader extends StatelessWidget {
  const _BloodRequestCardHeader({required this.request});

  final BloodRequest request;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        // Belirgin kan grubu kutusu
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
        // Hastane adı, şehir ve oluşturulma tarihi
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
        // Aciliyet rozeti
        UrgencyBadge(urgency: request.urgency),
      ],
    );
  }
}

/// Kan çağrısı kartının alt bölümü: toplanan ünite oranı, ilerleme çubuğu ve destek ol butonu.
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
        // Toplanan ünite bilgisi ve ilerleme göstergesi
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
        // Bağışçı olma butonu (tamamlandıysa devre dışı kalır)
        FilledButton.tonal(
          onPressed: request.isFulfilled ? null : onSupport,
          child: Text(request.isFulfilled ? 'Tamamlandı' : 'Bağışçıyım'),
        ),
      ],
    );
  }
}

/// Tekil bir kan talebini temsil eden ana kart widget'ı.
class BloodRequestCard extends StatelessWidget {
  const BloodRequestCard({
    super.key,
    required this.request,
    required this.onSupport,
  });

  /// Görüntülenecek çağrı verisi
  final BloodRequest request;

  /// 'Bağışçıyım' butonuna tıklandığında çalışacak fonksiyon
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

/// Çağrı oluşturma modalının başlık yazısı.
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

/// Yeni bir acil kan ihtiyacı girişi yapılmasını sağlayan alt modal formu (BottomSheet).
class CreateRequestBottomSheet extends StatefulWidget {
  const CreateRequestBottomSheet({
    super.key,
    required this.onSubmit,
  });

  /// Form onaylandığında yeni çağrı bilgilerini üst katmana ileten callback
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

  /// Form alanlarını doğrular ve geçerliyse yeni çağrıyı gönderip modalı kapatır.
  void _submit() {
    final hospital = _hospitalController.text.trim();
    final city = _cityController.text.trim();
    final units = int.tryParse(_unitsController.text) ?? 1;

    // Gerekli alan kontrolü
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
      // Ekran klavyesi açıldığında formun yukarı kayması için viewInsets.bottom eklenir
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
            // Hastane adı giriş alanı
            TextField(
              controller: _hospitalController,
              decoration: const InputDecoration(
                labelText: 'Hastane Adı',
                prefixIcon: Icon(Icons.local_hospital_outlined),
              ),
            ),
            const SizedBox(height: 12),
            // Şehir giriş alanı
            TextField(
              controller: _cityController,
              decoration: const InputDecoration(
                labelText: 'Şehir',
                prefixIcon: Icon(Icons.location_city_outlined),
              ),
            ),
            const SizedBox(height: 12),
            // Kan grubu ve aciliyet açılır menüleri (Dropdown)
            _buildDropdowns(),
            const SizedBox(height: 16),
            // Gönder butonu
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

  /// Kan grubu ve Aciliyet seçimi için yan yana iki Dropdown oluşturur.
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

