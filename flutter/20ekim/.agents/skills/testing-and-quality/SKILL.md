
---
name: testing-and-quality
description: Test yazarken, bug düzeltirken, release hazırlığında, kalite kontrol veya regresyon incelemesinde kullan.
---

# testing-and-quality

## Piramit
- Unit: date interval, booking state machine, pricing, campaign eligibility, form validators, owner permission.
- Repository: mock CRUD, deterministik seed, update/transaction, allowed data visibility.
- Widget: role UI, form validation, states, navigation, accessibility.
- Integration: guest→login→rent, firm adds car→customer search, cancelled booking→available.

## Standart
- Arrange/Act/Assert, stabil sahte saat (`Clock` interface), deterministik fixtures; gerçek API/network/konum çağrısı testlerde yok.
- Başarı/boş/hata/loading için screen state gözden geçir.
- `dart format .`, `flutter analyze`, `flutter test`; komut veya test çalışmazsa raporla.
- Bug fix için başarısızlığı tekrar eden regression testini önceliklendir.
- Acceptance criteria kullanıcı davranışıyla yazılır; kod var diye özellik bitmiş sayılmaz.
