---
name: flutter-feature-scaffold
description: >-
  Flutter projelerinde feature bazlı modüler kod yazmak için standart klasör yapısını oluşturur.
  ValueNotifier state mimarisini, Clean UI/Controller/Model katman ayrımını ve birim test iskeletini
  proje prensiplerine tam uyumlu şekilde üretir ve yönlendirir.
---

# Flutter Feature Scaffold (Modüler Ekran İskeleti)

Bu yetenek, projede yeni bir ekran ya da işlev modülü açarken Clean UI, reaktif State ve modüler mimari kurallarına tam uyulmasını garanti altına alır.

---

## 📌 Temel Kurallar ve Kırmızı Çizgiler

1. **Asla Tek Dosyada Toplama:**
   - UI Katmanı (`views/<feature>_view.dart`)
   - Durum ve İş Mantığı Katmanı (`controllers/<feature>_controller.dart`)
   - Veri Modeli Katmanı (`models/<feature>_model.dart`)
   - Atomik Bileşenler Katmanı (`widgets/<feature>_widgets.dart`)
   dosyaları bağımsız olarak açılmalıdır.

2. **Reaktif State Yönetimi (`ValueNotifier`):**
   - Sayfa düzeyinde ağır `setState` kesinlikle **KULLANILMAYACAKTIR**.
   - Basit, verimli ve reaktif durumlar için Flutter çekirdek API'si olan `ValueNotifier` ve `ValueListenableBuilder` kullanılmalıdır.
   - Doğrudan devasa `StatefulWidget` ağaçları yazarak re-render maliyeti artırılmamalıdır.
   - Detaylı akış diyagramı ve prensipler için: [state_flow.md](file:///Users/d1-14/Desktop/SoftITo-Mobile-Egitim/flutter/19_ekim_3/.agents/skills/references/state_flow.md)

3. **`const` Constructor Zorunluluğu:**
   - Statik tüm widget'larda `const` kullanımı zorunludur.

4. **40 Satır Kuralı:**
   - 40 satırı geçen `build` metotları yasaktır. Parçalanarak `widgets/` altındaki özel bileşenlere taşınmalıdır.

5. **Otomasyon Scripti:**
   - Yeni bir modül iskeletini tek komutla oluşturmak için [generate_feature.sh](file:///Users/d1-14/Desktop/SoftITo-Mobile-Egitim/flutter/19_ekim_3/.agents/skills/script/generate_feature.sh) çalıştırılabilir.

---

## 📁 Standart Modül Klasör Yapısı

Hedeflenen modül adları (örneğin: `water_tracker` veya `workout`) için `lib/features/<feature_name>/` altında aşağıdaki yapı kurulur:

```text
lib/features/<feature_name>/
├── controllers/
│   └── <feature_name>_controller.dart
├── models/
│   └── <feature_name>_model.dart
├── views/
│   └── <feature_name>_view.dart
└── widgets/
    └── <feature_name>_widgets.dart
```

---

## 🚀 Adım Adım Uygulama Akışı

### Adım 1: Klasör Yapısını Oluştur

Dilerseniz terminalden otomasyon scriptini çalıştırın:
```bash
./.agents/skills/script/generate_feature.sh water_tracker
```

Veya manuel olarak `lib/features/<feature_name>/` altında `controllers`, `models`, `views`, `widgets` klasörlerini oluşturun.

---

### Adım 2: Model Dosyasını Yaz (`models/<feature_name>_model.dart`)

Değişmez (immutable) veri yapısını, `copyWith`, `fromJson` ve `toJson` metotlarıyla kurun:

```dart
class WaterTrackerModel {
  final int currentWaterMl;
  final int dailyGoalMl;
  final DateTime lastUpdated;

  const WaterTrackerModel({
    required this.currentWaterMl,
    required this.dailyGoalMl,
    required this.lastUpdated,
  });

  double get progressRatio =>
      dailyGoalMl == 0 ? 0.0 : (currentWaterMl / dailyGoalMl).clamp(0.0, 1.0);

  bool get isGoalReached => currentWaterMl >= dailyGoalMl;

  WaterTrackerModel copyWith({
    int? currentWaterMl,
    int? dailyGoalMl,
    DateTime? lastUpdated,
  }) {
    return WaterTrackerModel(
      currentWaterMl: currentWaterMl ?? this.currentWaterMl,
      dailyGoalMl: dailyGoalMl ?? this.dailyGoalMl,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  factory WaterTrackerModel.fromJson(Map<String, dynamic> json) {
    return WaterTrackerModel(
      currentWaterMl: json['currentWaterMl'] as int? ?? 0,
      dailyGoalMl: json['dailyGoalMl'] as int? ?? 2000,
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentWaterMl': currentWaterMl,
      'dailyGoalMl': dailyGoalMl,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }
}
```

---

### Adım 3: Controller Dosyasını Yaz (`controllers/<feature_name>_controller.dart`)

İş mantığını ve reaktif durumları `ValueNotifier` ile yönetin, bellek temizliği için `dispose()` ekleyin:

```dart
import 'package:flutter/foundation.dart';
import '../models/water_tracker_model.dart';

class WaterTrackerController {
  late final ValueNotifier<WaterTrackerModel> state;

  WaterTrackerController({int initialGoal = 2000}) {
    state = ValueNotifier<WaterTrackerModel>(
      WaterTrackerModel(
        currentWaterMl: 0,
        dailyGoalMl: initialGoal,
        lastUpdated: DateTime.now(),
      ),
    );
  }

  void addWater([int amountMl = 250]) {
    state.value = state.value.copyWith(
      currentWaterMl: state.value.currentWaterMl + amountMl,
      lastUpdated: DateTime.now(),
    );
  }

  void resetWater() {
    state.value = state.value.copyWith(
      currentWaterMl: 0,
      lastUpdated: DateTime.now(),
    );
  }

  void setDailyGoal(int goalMl) {
    if (goalMl <= 0) return;
    state.value = state.value.copyWith(dailyGoalMl: goalMl);
  }

  void dispose() {
    state.dispose();
  }
}
```

---

### Adım 4: View Dosyasını Yaz (`views/<feature_name>_view.dart`)

`StatelessWidget` veya controller yaşam döngüsünü yöneten hafif bir yapı ile UI katmanını oluşturun:

```dart
import 'package:flutter/material.dart';
import '../controllers/water_tracker_controller.dart';
import '../models/water_tracker_model.dart';
import '../widgets/water_tracker_widgets.dart';

class WaterTrackerView extends StatefulWidget {
  const WaterTrackerView({super.key});

  @override
  State<WaterTrackerView> createState() => _WaterTrackerViewState();
}

class _WaterTrackerViewState extends State<WaterTrackerView> {
  late final WaterTrackerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WaterTrackerController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Su Takibi (Susadım)'),
        centerTitle: true,
      ),
      body: ValueListenableBuilder<WaterTrackerModel>(
        valueListenable: _controller.state,
        builder: (context, data, _) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                WaterProgressCard(data: data),
                const SizedBox(height: 24),
                WaterQuickActions(
                  onAdd250: () => _controller.addWater(250),
                  onAdd500: () => _controller.addWater(500),
                  onReset: _controller.resetWater,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
```

---

### Adım 5: Modüler Widget'ları Oluştur (`widgets/<feature_name>_widgets.dart`)

40 satırı geçmeyen, `const` destekli atomik bileşenler oluşturun:

```dart
import 'package:flutter/material.dart';
import '../models/water_tracker_model.dart';

class WaterProgressCard extends StatelessWidget {
  final WaterTrackerModel data;

  const WaterProgressCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final percent = (data.progressRatio * 100).toInt();

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              '${data.currentWaterMl} / ${data.dailyGoalMl} ml',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: data.progressRatio,
              minHeight: 12,
              borderRadius: BorderRadius.circular(6),
            ),
            const SizedBox(height: 8),
            Text(
              data.isGoalReached ? '🎉 Tebrikler! Günlük hedefe ulaştın.' : '%$percent Tamamlandı',
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class WaterQuickActions extends StatelessWidget {
  final VoidCallback onAdd250;
  final VoidCallback onAdd500;
  final VoidCallback onReset;

  const WaterQuickActions({
    super.key,
    required this.onAdd250,
    required this.onAdd500,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        FilledButton.tonal(
          onPressed: onAdd250,
          child: const Text('+250 ml'),
        ),
        FilledButton.tonal(
          onPressed: onAdd500,
          child: const Text('+500 ml'),
        ),
        OutlinedButton(
          onPressed: onReset,
          child: const Text('Sıfırla'),
        ),
      ],
    );
  }
}
```

---

## 📚 Kaynaklar ve İlgili Dosyalar

- **Tam Çalışan Kod Örneği:** [sample_screen.dart](file:///Users/d1-14/Desktop/SoftITo-Mobile-Egitim/flutter/19_ekim_3/.agents/skills/examples/sample_screen.dart)
- **State Akış Referans Kılavuzu:** [state_flow.md](file:///Users/d1-14/Desktop/SoftITo-Mobile-Egitim/flutter/19_ekim_3/.agents/skills/references/state_flow.md)
- **Otomatik Kod Üretim Scripti:** [generate_feature.sh](file:///Users/d1-14/Desktop/SoftITo-Mobile-Egitim/flutter/19_ekim_3/.agents/skills/script/generate_feature.sh)
- **Proje Standartları Dokümanı:** [project.md](file:///Users/d1-14/Desktop/SoftITo-Mobile-Egitim/flutter/19_ekim_3/project.md)

---

## ❓ Sık Sorulan Sorular (SSS)

### Soru 1: Hangi durumlarda bu yeteneği kullanmalıyım?
**Cevap:** Projeye yeni bir ekran, sekme (tab) veya işlev modülü eklerken standartlara tam uyumlu bir altyapı kurmak için kullanılmalıdır.

### Soru 2: Neden sayfa düzeyinde `setState` yerine `ValueNotifier` tercih edilmelidir?
**Cevap:** `setState` tüm ekran ağacını baştan oluştururken, `ValueNotifier` + `ValueListenableBuilder` yalnızca o değere bağlı hedef widget'ı yeniden çizer. Bu da 60/120 FPS akıcılığı sağlar ve kodun test edilebilirliğini artırır.

### Soru 3: Harici bir state paketi (Bloc/Provider/Riverpod) ekleyebilir miyim?
**Cevap:** Hayır. Proje kılavuzunda (`project.md`) belirtildiği üzere, önceden onay alınmadan harici ağır state paketleri eklenemez. Flutter'ın yerel çekirdek API'leri esastır.
