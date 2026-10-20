
---
name: ui-design-system
description: Tema, renk, Material Design 3 bileşenleri, ortak widget, responsive tasarım veya görsel tutarlılık işlerinde kullan.
---

# ui-design-system

## Design token
`AppColors`, `AppTypography`, `AppSpacing`, `AppRadius`, `AppShadows` (gerekiyorsa) `app/theme/` altında tek kaynak. Tema light-first; dark mode hazırlığı fakat rastgele renk üretme.

Renk başlangıcı: blue `#2563EB`, ink `#0B1220`, canvas `#F8FAFC`, surface `#FFFFFF`, muted `#64748B`.

## Bileşen standardı
- Material 3 `ThemeData(useMaterial3:true)` ve `ColorScheme` tabanlı.
- Generic: AppButton (primary/secondary/outline/destructive, loading/disabled), AppTextField, AppSelect, AppDateTimePicker, AppDialog, AppSnackbar, AppEmptyState, AppErrorView, AppLoading, AppScaffold.
- Domain widget'ları (VehicleCard, BookingSummary) core'a konmaz; ilgili feature'da tutulur.
- Renk/spacing/font boyutları widget dosyalarında magic-number olmaz; sadece zorunlu özel tasarım kararı açıklanır.
- En az 44–48 dp touch target, görsel hiyerarşi, text scaling, kontrast, semantic labels ve focus.
- Kartlar ve UI kopyaları yalnız dekoratif değil; kullanıcı işlemine hizmet eder.

## Teslim
Yeni komponent için state varyantları (normal/loading/error/disabled), örnek kullanım ve widget testini ekle.
