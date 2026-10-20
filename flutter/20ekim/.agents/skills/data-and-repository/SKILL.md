
---
name: data-and-repository
description: Model/entity, mock veri, repository, local persistence, mapping veya dependency injection değişikliklerinde kullan.
---

# data-and-repository

## Sözleşmeler
- Her veri ihtiyacında önce domain repository interface; in-memory / persisted implementasyon sonra.
- `Vehicle` tek ilan/araç entity. Company/User/CustomerProfile/Reservation/Campaign modellerini `project.md` ile tutarlı tut.
- Stable string id, immutable copyWith/equality veya eşdeğer; date/price serialization tek standart.
- Demo seed kayıtları deterministik id'li olsun; sahte kişiler, konumlar ve araçlar kullanılsın.
- Yerel saklama: ilk kurulum in-memory; kalıcılık gerektiğinde SQLite/Isar gibi **tek** adapter seçimi kullanıcı onayıyla yapılır. Seçim olmadan paket ekleme.
- Auth session ve kullanıcı verileri için demo sınırını belirt; gerçek şifre ve gerçek ehliyet kaydetme.
- Repository erişiminde customerId/companyId kontrolü; sonuçlar typed failure/exception olarak yüzeye çıkarılır.
- UI data source import etmez. Veriyi seed etmek testten ayrıdır.
- Kaydetme/güncelleme mantığında tutarlılık; rezervasyon için ardışık read-then-write race'e karşı aynı cihazda serileştirilmiş işlem/transaction.

## Testler
CRUD, listeleme/filtreleme, mapping, veri tutarlılığı, erişim reddi, app restart davranışı (kalıcılık varsa).
