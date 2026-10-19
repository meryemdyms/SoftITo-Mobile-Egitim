---
name: flutter-feature-scaffold
description: Yeni ekran, modül, sekme veya feature eklerken kullan. lib/features/<ad>/ altında controllers, models, views, widgets yapısını ValueNotifier tabanlı iskeletle oluşturur. Var olan bir ekranı düzenlerken kullanma.
---

# Yeni Feature Aç

## Ne zaman kullanılır

Kullan:
- "Yeni ekran ekle", "bağış geçmişi ekranı oluştur"
- "Yeni modül / sekme / feature aç"

Kullanma:
- Var olan ekranı düzenlerken
- Sadece tek bir widget eklerken
- Bug düzeltirken

## Kurallar

Genel kurallar için `project.md` geçerlidir (ValueNotifier, const, 40 satır, tema renkleri, kişisel veri).
Bu skill'e özgü kural: 4 katman her zaman ayrı dosyalarda açılır.

## Hedef yapı

```text
lib/features/<feature_adı>/
├── controllers/<feature_adı>_controller.dart
├── models/<feature_adı>_model.dart
├── views/<feature_adı>_view.dart
└── widgets/<feature_adı>_widgets.dart
```

## Adımlar

1. Yukarıdaki klasör ve dosyaları oluştur.
2. **Model:** değişmez (immutable) veri sınıfı, `copyWith` ile.
3. **Controller:** durumu `ValueNotifier` ile tut, `dispose()` ekle.
4. **View:** `ValueListenableBuilder` ile controller'ı dinle. `StatefulWidget` sadece controller'ın `initState`/`dispose` yaşam döngüsü için kullanılır.
5. **Widgets:** `build` 40 satırı geçerse parçalara ayır, statik olanlara `const` ver.

## Bitti sayılır, eğer

- `flutter analyze` 0 uyarı, 0 hata
- Hiçbir `build` metodu 40 satırı geçmiyor
- Controller `dispose()` ediliyor
- Hard-coded renk yok