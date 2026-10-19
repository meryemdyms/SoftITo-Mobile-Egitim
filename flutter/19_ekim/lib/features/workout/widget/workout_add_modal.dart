import 'package:flutter/material.dart';
import 'package:susadim/core/constants/app_colors.dart';
import 'package:susadim/features/workout/models/workout_entry.dart';

class WorkoutAddModal extends StatefulWidget {
  const WorkoutAddModal({required this.onAdd, super.key});

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
  final TextEditingController _titleController =
      TextEditingController(text: 'Fitness & Ağırlık');
  final TextEditingController _durationController =
      TextEditingController(text: '45');
  final TextEditingController _caloriesController =
      TextEditingController(text: '320');
  WorkoutIntensity _intensity = WorkoutIntensity.medium;

  @override
  void dispose() {
    _titleController.dispose();
    _durationController.dispose();
    _caloriesController.dispose();
    super.dispose();
  }

  void _submit() {
    final title = _titleController.text.trim();
    final duration = int.tryParse(_durationController.text) ?? 0;
    final calories = int.tryParse(_caloriesController.text) ?? 0;
    if (title.isNotEmpty && duration > 0 && calories > 0) {
      widget.onAdd(
        title: title,
        durationMinutes: duration,
        caloriesBurned: calories,
        intensity: _intensity,
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
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
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _ModalHeader(),
          const SizedBox(height: 16),
          _InputField(
            controller: _titleController,
            label: 'Egzersiz Adı',
            hint: 'Örn. Koşu, Ağırlık',
          ),
          const SizedBox(height: 12),
          _DurationAndCaloriesRow(
            durationCtrl: _durationController,
            caloriesCtrl: _caloriesController,
          ),
          const SizedBox(height: 14),
          _IntensitySelector(
            selected: _intensity,
            onChanged: (val) => setState(() => _intensity = val),
          ),
          const SizedBox(height: 20),
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
        Expanded(
          child: TextField(
            controller: durationCtrl,
            keyboardType: TextInputType.number,
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
        Expanded(
          child: TextField(
            controller: caloriesCtrl,
            keyboardType: TextInputType.number,
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
