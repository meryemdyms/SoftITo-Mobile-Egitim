import 'package:flutter/material.dart';
import 'package:susadim/core/constants/app_colors.dart';
import 'package:susadim/features/workout/models/workout_entry.dart';

/// Yeni bir antrenman/egzersiz kaydı oluşturmak için açılan modal alt sayfa (Bottom Sheet).
///
/// Kullanıcıdan:
/// - Egzersiz adı (Title)
/// - Süre (Duration in minutes)
/// - Yakılan tahmini kalori (Calories in kcal)
/// - Efor yoğunluğu (Intensity: Hafif, Orta, Yoğun)
/// bilgilerini toplar ve onaylandığında [onAdd] fonksiyonunu tetikler.
class WorkoutAddModal extends StatefulWidget {
  const WorkoutAddModal({required this.onAdd, super.key});

  /// Form başarıyla doğrulandığında ve kaydedildiğinde çağrılan fonksiyon
  final void Function({
    required String title,
    required int durationMinutes,
    required int caloriesBurned,
    required WorkoutIntensity intensity,
  }) onAdd;

  @override
  State<WorkoutAddModal> createState() => _WorkoutAddModalState();
}

class _WorkoutAddModalState extends State<WorkoutAddModal> {
  // Metin giriş alanlarını (TextField) yöneten kontrolcüler
  final TextEditingController _titleController =
      TextEditingController(text: 'Fitness & Ağırlık');
  final TextEditingController _durationController =
      TextEditingController(text: '45');
  final TextEditingController _caloriesController =
      TextEditingController(text: '320');

  // Seçili olan antrenman yoğunluğu (varsayılan: Orta)
  WorkoutIntensity _intensity = WorkoutIntensity.medium;

  @override
  void dispose() {
    // Bellek sızıntılarını (Memory Leak) önlemek için StatefulWidget sonlandığında
    // TextEditingController nesneleri mutlaka dispose edilmelidir.
    _titleController.dispose();
    _durationController.dispose();
    _caloriesController.dispose();
    super.dispose();
  }

  /// Form alanlarını doğrular ve geçerliyse yeni kaydı controller'a iletir
  void _submit() {
    final title = _titleController.text.trim();
    // Metin değerlerini güvenli bir şekilde sayıya dönüştürür (geçersizse 0 döner)
    final duration = int.tryParse(_durationController.text) ?? 0;
    final calories = int.tryParse(_caloriesController.text) ?? 0;

    // Alanların geçerli (dolu ve pozitif sayı) olup olmadığı denetlenir
    if (title.isNotEmpty && duration > 0 && calories > 0) {
      widget.onAdd(
        title: title,
        durationMinutes: duration,
        caloriesBurned: calories,
        intensity: _intensity,
      );
      // Kayıt tamamlandıktan sonra modal alt sayfayı kapatır
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        // Klavye açıldığında formun klavye arkasında kalmasını önlemek için
        // klavye yüksekliği kadar dinamik alt boşluk (padding) eklenir.
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        left: 20,
        right: 20,
        top: 20,
      ),
      decoration: const BoxDecoration(
        color: AppColors.obsidianSurface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Sadece içerik kadar alan kaplar
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Modal başlığı ve kapatma butonu
          const _ModalHeader(),
          const SizedBox(height: 16),

          // Egzersiz adı giriş alanı
          _InputField(
            controller: _titleController,
            label: 'Egzersiz Adı',
            hint: 'Örn. Koşu, Ağırlık',
          ),
          const SizedBox(height: 12),

          // Süre ve Kalori alanlarının yan yana yer aldığı satır
          _DurationAndCaloriesRow(
            durationCtrl: _durationController,
            caloriesCtrl: _caloriesController,
          ),
          const SizedBox(height: 14),

          // Yoğunluk seviyesi seçim çipleri (Hafif / Orta / Yoğun)
          _IntensitySelector(
            selected: _intensity,
            onChanged: (val) => setState(() => _intensity = val),
          ),
          const SizedBox(height: 20),

          // Egzersizi kaydet butonu
          ElevatedButton(
            onPressed: _submit,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.neonLime,
              foregroundColor: AppColors.obsidianBackground,
            ),
            child: const Text('Egzersizi Kaydet'),
          ),
        ],
      ),
    );
  }
}

/// Modal başlığını ve kapatma çarpı butonunu içeren başlık satırı
class _ModalHeader extends StatelessWidget {
  const _ModalHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Yeni Egzersiz Ekle',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
        ),
        IconButton(
          icon: const Icon(Icons.close, color: AppColors.textMuted),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}

/// Standart koyu temalı metin giriş alanı (TextField) bileşeni
class _InputField extends StatelessWidget {
  const _InputField({
    required this.controller,
    required this.label,
    required this.hint,
  });

  final TextEditingController controller;
  final String label;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: AppColors.textPrimary),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.textSecondary),
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.textMuted),
        filled: true,
        fillColor: AppColors.obsidianCard,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.obsidianBorder),
        ),
      ),
    );
  }
}

/// Süre ve Kalori sayısal giriş alanlarını yan yana dizen satır
class _DurationAndCaloriesRow extends StatelessWidget {
  const _DurationAndCaloriesRow({
    required this.durationCtrl,
    required this.caloriesCtrl,
  });

  final TextEditingController durationCtrl;
  final TextEditingController caloriesCtrl;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Süre (dakika) giriş alanı
        Expanded(
          child: TextField(
            controller: durationCtrl,
            keyboardType: TextInputType.number, // Yalnızca sayısal klavye açar
            style: const TextStyle(color: AppColors.textPrimary),
            decoration: InputDecoration(
              labelText: 'Süre (dk)',
              filled: true,
              fillColor: AppColors.obsidianCard,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AppColors.obsidianBorder),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),

        // Kalori (kcal) giriş alanı
        Expanded(
          child: TextField(
            controller: caloriesCtrl,
            keyboardType: TextInputType.number, // Yalnızca sayısal klavye açar
            style: const TextStyle(color: AppColors.textPrimary),
            decoration: InputDecoration(
              labelText: 'Kalori (kcal)',
              filled: true,
              fillColor: AppColors.obsidianCard,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AppColors.obsidianBorder),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Egzersiz yoğunluk seviyesini (Hafif, Orta, Yoğun) seçtiren ChoiceChip çip grubu
class _IntensitySelector extends StatelessWidget {
  const _IntensitySelector({
    required this.selected,
    required this.onChanged,
  });

  final WorkoutIntensity selected;
  final ValueChanged<WorkoutIntensity> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: WorkoutIntensity.values.map((intensity) {
        final isSelected = intensity == selected;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ChoiceChip(
              label: Center(child: Text(intensity.displayName)),
              selected: isSelected,
              onSelected: (_) => onChanged(intensity),
              selectedColor: AppColors.neonLime.withValues(alpha: 0.25),
              labelStyle: TextStyle(
                color: isSelected ? AppColors.neonLime : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        );
      }).toList(growable: false),
    );
  }
}
