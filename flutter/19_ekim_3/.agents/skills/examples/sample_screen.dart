// ---------------------------------------------------------------------------
// Susadım v1 - Örnek Referans Ekranı (flutter-feature-scaffold)
// ---------------------------------------------------------------------------
// Bu dosya, projede geliştirilecek tüm ekranlar için örnek teşkil eden
// Clean UI, Reaktif State (ValueNotifier) ve Modüler Widget yapısını içerir.
//
// Prensipler:
// 1. Model: Değişmez (Immutable), copyWith, serialization.
// 2. Controller: ValueNotifier tabanlı iş mantığı ve dispose yönetimi.
// 3. View: Yalnızca UI yerleşimi ve ValueListenableBuilder ile reaktif dinleme.
// 4. Widgets: 40 satır altı, const constructor'lı modüler bileşenler.
// ---------------------------------------------------------------------------

import 'package:flutter/material.dart';

// ===========================================================================
// 1. MODEL KATMANI (models/sample_water_model.dart)
// ===========================================================================

@immutable
class SampleWaterModel {
  final int currentWaterMl;
  final int dailyGoalMl;
  final List<int> intakeHistory;
  final DateTime lastUpdated;

  const SampleWaterModel({
    required this.currentWaterMl,
    required this.dailyGoalMl,
    required this.intakeHistory,
    required this.lastUpdated,
  });

  /// Günlük ilerleme oranını döner (0.0 - 1.0 aralığında sınırlandırılmıştır)
  double get progressRatio {
    if (dailyGoalMl <= 0) return 0.0;
    return (currentWaterMl / dailyGoalMl).clamp(0.0, 1.0);
  }

  /// Kalan su miktarını döner (ml)
  int get remainingWaterMl =>
      (dailyGoalMl - currentWaterMl).clamp(0, dailyGoalMl);

  /// Günlük hedefe ulaşılıp ulaşılmadığı
  bool get isGoalReached => currentWaterMl >= dailyGoalMl;

  /// Yüzdelik ilerleme tam sayısı
  int get progressPercentage => (progressRatio * 100).toInt();

  /// Değişmezliği koruyarak yeni bir kopya oluşturur
  SampleWaterModel copyWith({
    int? currentWaterMl,
    int? dailyGoalMl,
    List<int>? intakeHistory,
    DateTime? lastUpdated,
  }) {
    return SampleWaterModel(
      currentWaterMl: currentWaterMl ?? this.currentWaterMl,
      dailyGoalMl: dailyGoalMl ?? this.dailyGoalMl,
      intakeHistory: intakeHistory ?? this.intakeHistory,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  /// JSON dönüşüm fabrikası
  factory SampleWaterModel.fromJson(Map<String, dynamic> json) {
    return SampleWaterModel(
      currentWaterMl: json['currentWaterMl'] as int? ?? 0,
      dailyGoalMl: json['dailyGoalMl'] as int? ?? 2000,
      intakeHistory: (json['intakeHistory'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          const <int>[],
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'] as String)
          : DateTime.now(),
    );
  }

  /// JSON çıktısı üretir
  Map<String, dynamic> toJson() {
    return {
      'currentWaterMl': currentWaterMl,
      'dailyGoalMl': dailyGoalMl,
      'intakeHistory': intakeHistory,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }
}

// ===========================================================================
// 2. CONTROLLER KATMANI (controllers/sample_water_controller.dart)
// ===========================================================================

class SampleWaterController {
  late final ValueNotifier<SampleWaterModel> state;

  SampleWaterController({int initialDailyGoal = 2500}) {
    state = ValueNotifier<SampleWaterModel>(
      SampleWaterModel(
        currentWaterMl: 0,
        dailyGoalMl: initialDailyGoal,
        intakeHistory: const <int>[],
        lastUpdated: DateTime.now(),
      ),
    );
  }

  /// Belirtilen miktarda su ekler ve geçmişe kaydeder
  void addWater(int amountMl) {
    if (amountMl <= 0) return;

    final current = state.value;
    final updatedHistory = List<int>.from(current.intakeHistory)..add(amountMl);

    state.value = current.copyWith(
      currentWaterMl: current.currentWaterMl + amountMl,
      intakeHistory: updatedHistory,
      lastUpdated: DateTime.now(),
    );
  }

  /// Son su ekleme işlemini geri alır
  void undoLast() {
    final current = state.value;
    if (current.intakeHistory.isEmpty) return;

    final updatedHistory = List<int>.from(current.intakeHistory);
    final lastAdded = updatedHistory.removeLast();

    state.value = current.copyWith(
      currentWaterMl: (current.currentWaterMl - lastAdded).clamp(0, 50000),
      intakeHistory: updatedHistory,
      lastUpdated: DateTime.now(),
    );
  }

  /// Günlük su tüketimini sıfırlar
  void reset() {
    final current = state.value;
    state.value = current.copyWith(
      currentWaterMl: 0,
      intakeHistory: const <int>[],
      lastUpdated: DateTime.now(),
    );
  }

  /// Yeni günlük hedef belirler
  void updateDailyGoal(int newGoalMl) {
    if (newGoalMl <= 0) return;
    state.value = state.value.copyWith(
      dailyGoalMl: newGoalMl,
      lastUpdated: DateTime.now(),
    );
  }

  /// Bellek sızıntılarını önlemek için dinleyiciyi kapatır
  void dispose() {
    state.dispose();
  }
}

// ===========================================================================
// 3. VIEW KATMANI (views/sample_water_view.dart)
// ===========================================================================

class SampleWaterView extends StatefulWidget {
  const SampleWaterView({super.key});

  @override
  State<SampleWaterView> createState() => _SampleWaterViewState();
}

class _SampleWaterViewState extends State<SampleWaterView> {
  late final SampleWaterController _controller;

  @override
  void initState() {
    super.initState();
    // Controller ekranla birlikte başlatılır
    _controller = SampleWaterController();
  }

  @override
  void dispose() {
    // Controller bellekten temizlenir
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Susadım - Günlük Su Takibi'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Sıfırla',
            onPressed: _controller.reset,
          ),
        ],
      ),
      body: SafeArea(
        child: ValueListenableBuilder<SampleWaterModel>(
          valueListenable: _controller.state,
          builder: (context, data, _) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SampleWaterProgressCard(data: data),
                  const SizedBox(height: 20),
                  SampleQuickActionGrid(onAddAmount: _controller.addWater),
                  const SizedBox(height: 20),
                  SampleControlBar(
                    canUndo: data.intakeHistory.isNotEmpty,
                    onUndo: _controller.undoLast,
                    onReset: _controller.reset,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// ===========================================================================
// 4. ATOMİK WIDGET'LAR (widgets/sample_water_widgets.dart)
// Her widget 40 satır kuralına ve const prensibine tam uygundur.
// ===========================================================================

/// İlerleme kartı: Dairesel gösterge ve ml durum bilgisi
class SampleWaterProgressCard extends StatelessWidget {
  final SampleWaterModel data;

  const SampleWaterProgressCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            SizedBox(
              width: 140,
              height: 140,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CircularProgressIndicator(
                    value: data.progressRatio,
                    strokeWidth: 12,
                    strokeCap: StrokeCap.round,
                    backgroundColor: colorScheme.surfaceContainerHighest,
                    color: colorScheme.primary,
                  ),
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '%${data.progressPercentage}',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                          ),
                        ),
                        Text('Hedef', style: theme.textTheme.labelMedium),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '${data.currentWaterMl} / ${data.dailyGoalMl} ml',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              data.isGoalReached
                  ? '🎉 Günlük hedefinize ulaştınız!'
                  : 'Kalan: ${data.remainingWaterMl} ml',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: data.isGoalReached
                    ? Colors.greenAccent
                    : colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Hızlı su ekleme butonları ızgarası
class SampleQuickActionGrid extends StatelessWidget {
  final void Function(int amount) onAddAmount;

  const SampleQuickActionGrid({super.key, required this.onAddAmount});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hızlı Ekle',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _QuickAddButton(
                amount: 200,
                label: '1 Bardak',
                icon: Icons.local_drink_outlined,
                onTap: () => onAddAmount(200),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _QuickAddButton(
                amount: 330,
                label: 'Küçük Şişe',
                icon: Icons.water_drop_outlined,
                onTap: () => onAddAmount(330),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _QuickAddButton(
                amount: 500,
                label: 'Büyük Şişe',
                icon: Icons.fitness_center_outlined,
                onTap: () => onAddAmount(500),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Atomik hızlı ekleme butonu
class _QuickAddButton extends StatelessWidget {
  final int amount;
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _QuickAddButton({
    required this.amount,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      onPressed: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 22),
          const SizedBox(height: 6),
          Text(
            '+$amount ml',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(label, style: const TextStyle(fontSize: 11)),
        ],
      ),
    );
  }
}

/// Alt kontrol çubuğu: Geri alma ve sıfırlama
class SampleControlBar extends StatelessWidget {
  final bool canUndo;
  final VoidCallback onUndo;
  final VoidCallback onReset;

  const SampleControlBar({
    super.key,
    required this.canUndo,
    required this.onUndo,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton.icon(
          onPressed: canUndo ? onUndo : null,
          icon: const Icon(Icons.undo),
          label: const Text('Son İşlemi Geri Al'),
        ),
        TextButton.icon(
          onPressed: onReset,
          icon: const Icon(Icons.delete_outline),
          label: const Text('Sıfırla'),
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.error,
          ),
        ),
      ],
    );
  }
}
