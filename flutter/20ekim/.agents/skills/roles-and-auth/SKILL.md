
---
name: roles-and-auth
description: Misafir/müşteri/firma kayıt-giriş, oturum, yetki kontrolü, profil verisi veya girişten geri dönüş istendiğinde kullan.
---

# roles-and-auth

## Kurallar
- Guest = null session; User rolü sadece `customer` veya `company`. `Company.ownerUserId` sahipliği belirler.
- Login ekranında müşteri/firma hesapları ayrılır; login sonrası role göre doğru shell açılır.
- Misafir Search, Vehicle, Company, Campaign, Map görebilir; booking/customer-profile ve firma yönetimi korumalıdır.
- Korumalı aksiyon login'e gönderiyorsa `returnTo` güvenli uygulama içi route olarak tutulur, başarıda geri dönülür; role uymayan rota reddedilir.
- Demo hesaplar yalnızca sahte veri ile çalışır. Üretim kimlik doğrulaması, şifre saklama güvenliği ve çok cihazlı oturum iddia edilmez.
- Demo kayıt formu müşteri: ad/soyad, e-posta, telefon, doğum tarihi, ehliyet sınıfı/tarihi (ehliyet numarası gerçek olamaz). Firma: ad, yetkili, e-posta, telefon, adres/konum, açıklama.
- Role değişimi oturum sıfırlama/yeniden yönlendirme yapar; back stack ile eski rolün sayfalarına erişilmez.
- UI gizlemek yeterli değil; her repository işlemi `actorUserId`, `role` ve ownership doğrular.

## Testler
Guest `Kirala` → login → aynı araç, firma `customer` rotasına giremez, müşteri firma CRUD yapamaz, logout eski korumalı rotayı açmaz.
