
---
name: architecture-and-scaffold
description: Yeni feature/modül/ekran oluştururken, klasör yerleşimi veya katman bağımlılığı düzenlenirken kullan.
---

# architecture-and-scaffold

## Hedef
Feature-first MVVM ve açık bağımlılık yönü; yalnızca ihtiyaç duyulan dosyalar.

## Uygulama
1. Feature adını `snake_case` seç; `features/<name>/` altına domain (entities, repositories, usecases), data (models, datasources, repositories), presentation (controllers, views, widgets) gerektiği kadar ekle.
2. View kullanıcı girdisini controller'a iletir; controller `ChangeNotifier` ile immutable ekran durumu taşır; iş kuralı domain; persistence data'da.
3. Controller doğrudan disk/API/mock listesi değiştirmez. Repository interface domain'de, adapter data'da; Provider wiring `app/di/app_providers.dart`.
4. Model/entity ayrımı: entity saf domain; data model serialization / mapping. Domain `flutter/material.dart` import etmez.
5. Cross-feature erişimde başkasının `presentation/` ya da `data/` katmanını import etme. Feature bağımlılıkları domain interface veya core servis sözleşmesi üzerinden çözülür.
6. Genel widget sadece gerçekten domain-bağımsızsa `core/widgets`; tek feature'a özelse feature'ın `presentation/widgets` klasöründe.
7. Yeni route, provider ve gerekli testleri aynı değişiklikte ekle.

## Kontrol
- [ ] UI'da business logic yok
- [ ] Feature'lar arası illegal import yok
- [ ] Dependency injection tek merkezde
- [ ] Yeni klasör/dosya boş placeholder değil
- [ ] Test edilmesi gereken business rule kapsandı
