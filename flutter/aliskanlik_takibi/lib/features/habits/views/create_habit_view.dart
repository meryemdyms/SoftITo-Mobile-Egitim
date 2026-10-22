import 'package:flutter/material.dart';
import '../../../core/services/app_scope.dart';
import '../../../core/theme/app_colors.dart';
import '../models/habit_models.dart';

class CreateHabitView extends StatefulWidget {
  const CreateHabitView({super.key});

  @override
  State<CreateHabitView> createState() => _CreateHabitViewState();
}

class _CreateHabitViewState extends State<CreateHabitView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _targetValueController = TextEditingController(text: '1');
  final _unitController = TextEditingController(text: 'kez');

  String _selectedCategory = 'Kişisel Gelişim';
  String _selectedIcon = 'book';
  int _selectedColorValue = 0xFF344E41;
  MeasurementType _selectedMeasurementType = MeasurementType.boolean;
  FrequencyType _selectedFrequency = FrequencyType.everyday;
  final List<int> _selectedDays = [1, 2, 3, 4, 5, 6, 7];
  int _selectedDurationDays = 30; // 21, 30, 60, 90, 0 (süresiz)
  TimeOfDay _reminderTime = const TimeOfDay(hour: 9, minute: 0);
  bool _enableReminder = false;
  bool _isLoading = false;

  final List<String> _categories = [
    'Kişisel Gelişim',
    'Spor & Fitness',
    'Sağlık & Beslenme',
    'Eğitim & Odak',
    'Farkındalık & Huzur',
    'Günlük Rutinler',
  ];

  final List<({String key, IconData icon})> _icons = [
    (key: 'book', icon: Icons.menu_book_rounded),
    (key: 'water', icon: Icons.water_drop_rounded),
    (key: 'run', icon: Icons.directions_run_rounded),
    (key: 'meditate', icon: Icons.self_improvement_rounded),
    (key: 'study', icon: Icons.laptop_chromebook_rounded),
    (key: 'sleep', icon: Icons.bedtime_rounded),
    (key: 'brush', icon: Icons.brush_rounded),
    (key: 'music', icon: Icons.music_note_rounded),
  ];

  final List<int> _colors = [
    0xFF344E41,
    0xFFA3B899,
    0xFFE8CDA9,
    0xFFD9A6A0,
    0xFF3D6B51,
    0xFF4C7B8B,
    0xFFD49B42,
    0xFF8F5C86,
  ];

  // Hazır Alışkanlık Önerileri (project.md Bölüm 12)
  final List<({
    String name,
    String category,
    String icon,
    MeasurementType mType,
    double target,
    String unit,
  })> _templates = [
    (
      name: 'Günde 20 Sayfa Kitap Oku',
      category: 'Kişisel Gelişim',
      icon: 'book',
      mType: MeasurementType.quantity,
      target: 20,
      unit: 'sayfa',
    ),
    (
      name: 'Günde 2 Litre Su İç',
      category: 'Sağlık & Beslenme',
      icon: 'water',
      mType: MeasurementType.quantity,
      target: 2000,
      unit: 'ml',
    ),
    (
      name: '30 Dakika Yürüyüş Yap',
      category: 'Spor & Fitness',
      icon: 'run',
      mType: MeasurementType.duration,
      target: 30,
      unit: 'dk',
    ),
    (
      name: '10 Dakika Meditasyon',
      category: 'Farkındalık & Huzur',
      icon: 'meditate',
      mType: MeasurementType.duration,
      target: 10,
      unit: 'dk',
    ),
    (
      name: '45 Dakika Odaklanarak Çalış',
      category: 'Eğitim & Odak',
      icon: 'study',
      mType: MeasurementType.duration,
      target: 45,
      unit: 'dk',
    ),
  ];

  void _applyTemplate(({
    String name,
    String category,
    String icon,
    MeasurementType mType,
    double target,
    String unit,
  }) t) {
    setState(() {
      _nameController.text = t.name;
      _selectedCategory = t.category;
      _selectedIcon = t.icon;
      _selectedMeasurementType = t.mType;
      _targetValueController.text = t.target.toInt().toString();
      _unitController.text = t.unit;
    });
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final appScope = AppScope.of(context);
    final userId = appScope.authService.currentUser?.id ?? 'demo_user';
    final targetValue = double.tryParse(_targetValueController.text) ?? 1.0;

    final now = DateTime.now();
    final endDate = _selectedDurationDays > 0
        ? now.add(Duration(days: _selectedDurationDays - 1))
        : null;

    final reminderStr = _enableReminder
        ? '${_reminderTime.hour.toString().padLeft(2, '0')}:${_reminderTime.minute.toString().padLeft(2, '0')}'
        : null;

    await appScope.habitController.addHabit(
      userId: userId,
      name: _nameController.text.trim(),
      category: _selectedCategory,
      icon: _selectedIcon,
      colorValue: _selectedColorValue,
      measurementType: _selectedMeasurementType,
      unit: _unitController.text.trim(),
      frequency: _selectedFrequency,
      selectedDays: _selectedDays,
      targetValue: targetValue,
      startDate: now,
      endDate: endDate,
      reminderTime: reminderStr,
    );

    setState(() => _isLoading = false);

    if (mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Alışkanlık ve gizli yapboz süreci başarıyla başlatıldı!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Yeni Alışkanlık'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Hazır Şablonlar Başlığı
                const Text(
                  'Önerilen Alışkanlıklar',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.primary),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 38,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _templates.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 8),
                    itemBuilder: (context, i) {
                      final t = _templates[i];
                      return ActionChip(
                        label: Text(t.name),
                        backgroundColor: AppColors.cardBg,
                        side: const BorderSide(color: AppColors.border),
                        labelStyle: const TextStyle(fontSize: 12, color: AppColors.textPrimary),
                        onPressed: () => _applyTemplate(t),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),

                // Alışkanlık Adı
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Alışkanlık Adı',
                    hintText: 'Örn: Kitap Okumak',
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Lütfen bir isim belirleyin' : null,
                ),
                const SizedBox(height: 16),

                // Kategori
                DropdownButtonFormField<String>(
                  initialValue: _selectedCategory,
                  decoration: const InputDecoration(labelText: 'Kategori'),
                  items: _categories
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (v) => setState(() => _selectedCategory = v ?? _selectedCategory),
                ),
                const SizedBox(height: 20),

                // İkon ve Renk Seçimi
                const Text('İkon ve Renk', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.primary)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: _icons.length,
                          separatorBuilder: (_, _) => const SizedBox(width: 8),
                          itemBuilder: (context, i) {
                            final ic = _icons[i];
                            final isSel = _selectedIcon == ic.key;
                            return InkWell(
                              onTap: () => setState(() => _selectedIcon = ic.key),
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: isSel ? AppColors.primary : AppColors.cardBg,
                                  border: Border.all(color: isSel ? AppColors.primary : AppColors.border),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  ic.icon,
                                  color: isSel ? Colors.white : AppColors.primary,
                                  size: 22,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 40,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _colors.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 8),
                    itemBuilder: (context, i) {
                      final cVal = _colors[i];
                      final isSel = _selectedColorValue == cVal;
                      return InkWell(
                        onTap: () => setState(() => _selectedColorValue = cVal),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Color(cVal),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSel ? AppColors.primary : Colors.transparent,
                              width: 2.5,
                            ),
                          ),
                          child: isSel ? const Icon(Icons.check, size: 18, color: Colors.white) : null,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),

                // Hedef Türü (Evet/Hayır, Miktar, Süre)
                const Text('Hedef Türü', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.primary)),
                const SizedBox(height: 8),
                SegmentedButton<MeasurementType>(
                  segments: const [
                    ButtonSegment(value: MeasurementType.boolean, label: Text('Evet/Hayır')),
                    ButtonSegment(value: MeasurementType.quantity, label: Text('Miktar')),
                    ButtonSegment(value: MeasurementType.duration, label: Text('Süre')),
                  ],
                  selected: {_selectedMeasurementType},
                  onSelectionChanged: (set) {
                    setState(() {
                      _selectedMeasurementType = set.first;
                      if (_selectedMeasurementType == MeasurementType.boolean) {
                        _targetValueController.text = '1';
                        _unitController.text = 'kez';
                      } else if (_selectedMeasurementType == MeasurementType.duration) {
                        _targetValueController.text = '30';
                        _unitController.text = 'dk';
                      } else {
                        _targetValueController.text = '20';
                        _unitController.text = 'sayfa';
                      }
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Hedef Miktarı ve Birim (Evet/Hayır değilse)
                if (_selectedMeasurementType != MeasurementType.boolean) ...[
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          controller: _targetValueController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'Günlük Hedef Miktarı'),
                          validator: (v) => (double.tryParse(v ?? '') == null || double.parse(v!) <= 0)
                              ? 'Geçerli bir sayı giriniz'
                              : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _unitController,
                          decoration: const InputDecoration(labelText: 'Birim'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],

                // Tekrar Sıklığı (Her gün, Hafta içi, Özel günler)
                const Text('Tekrar Sıklığı', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.primary)),
                const SizedBox(height: 8),
                SegmentedButton<FrequencyType>(
                  segments: const [
                    ButtonSegment(value: FrequencyType.everyday, label: Text('Her gün')),
                    ButtonSegment(value: FrequencyType.weekdays, label: Text('Hafta içi')),
                    ButtonSegment(value: FrequencyType.customDays, label: Text('Seçilen')),
                  ],
                  selected: {_selectedFrequency},
                  onSelectionChanged: (set) => setState(() => _selectedFrequency = set.first),
                ),
                const SizedBox(height: 16),

                // Süreç Uzunluğu (project.md: 21, 30, 60, 90 gün veya Süresiz)
                const Text('Süreç Uzunluğu (Yapboz Parça Sayısı)', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.primary)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [21, 30, 60, 90, 0].map((days) {
                    final label = days == 0 ? 'Süresiz (30 Günlük Dönem)' : '$days Gün';
                    final isSel = _selectedDurationDays == days;
                    return ChoiceChip(
                      label: Text(label),
                      selected: isSel,
                      onSelected: (_) => setState(() => _selectedDurationDays = days),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),

                // Hatırlatıcı / Bildirim Saati
                SwitchListTile(
                  title: const Text('Günlük Hatırlatıcı', style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(
                    _enableReminder
                        ? 'Her gün ${_reminderTime.format(context)} saatinde hatırlatılacak'
                        : 'Hatırlatıcı kapalı',
                  ),
                  value: _enableReminder,
                  onChanged: (val) async {
                    setState(() => _enableReminder = val);
                    if (val) {
                      final picked = await showTimePicker(
                        context: context,
                        initialTime: _reminderTime,
                      );
                      if (picked != null) {
                        setState(() => _reminderTime = picked);
                      }
                    }
                  },
                ),
                const SizedBox(height: 28),

                // Oluştur Butonu
                ElevatedButton(
                  onPressed: _isLoading ? null : _handleSave,
                  child: _isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Text('Alışkanlığı ve Yapbozu Başlat'),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
