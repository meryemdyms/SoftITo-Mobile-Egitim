
---
name: routing-and-navigation
description: Yeni route, tab, bottom navigation, rol koruması, login sonrası geri dönüş veya uygulama açılış yönlendirmesinde kullan.
---

# routing-and-navigation

## İlkeler
- `go_router` merkezî yapı; adlandırılmış route path sabitleri, tek yerde kayıt.
- Guest + customer shell keşif sayfalarını paylaşabilir; firma shell ayrı navigasyon ağacıdır.
- Protected route: oturum yoksa login ve sanitized internal returnTo; yanlış role ise güvenli başlangıç sayfasına redirect.
- Başarılı login'de `returnTo` rol için geçerliyse geri dön; geçersiz veya dış URL ise ignore.
- Logout'ta korumalı back stack'e dönüş imkânsız olsun.
- Nested route'lar için params (`vehicleId`, `companyId`, `reservationId`) tutarlı, bulunamayan entity için NotFound görünümü.
- Widget içinde rastgele route stringleri üretme; go_router transition davranışları kullanıcı odaklı.

## Test
Guest → detail → rent → login → checkout; company cannot open customer checkout; auth expiry/logout; browser/deep link benzeri route açılışı; unknown id.
