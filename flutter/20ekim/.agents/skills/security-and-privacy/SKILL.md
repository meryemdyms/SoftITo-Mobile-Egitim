
---
name: security-and-privacy
description: Rol sınırları, auth, veri saklama, kişisel bilgi, hassas log, kullanıcı izni veya güvenlik değerlendirmesinde kullan.
---

# security-and-privacy

## Demo güvenlik sınırları
- Backend yok: client-side auth ve rol yönetimi üretim güvenlik sınırı değildir. Gerçek ödeme ve gerçek ehliyet doğrulaması asla taklit edilip gerçek gibi sunulmaz.
- Kullanıcıdan gerçek şifre/ehliyet/kart/vergi/kimlik bilgisi toplamamayı tercih et; yalnız fixture/test içerik kullan.
- Şifre ve ehliyet numarasını düz metin diske yazma; debug print, analytics ve exception'a hassas alan ekleme.
- Gerçek verinin işlenmesi istenirse güvenli backend/şifreli storage/erişim yetkisi/retention/KVKK için ayrı karar aşaması aç.
- Company ownership ve customer identity tüm data mutation/read operasyonlarında doğrulanır; UI guard yeterli sayılmaz.
- Konum izni yalnız gerektiği anda, gerekçe açık; denied akışında uygulama kullanılabilir kalır.
- Demo reset / veri temizleme için açık aksiyon sağla; raporlarda güvenlik sınırlamalarını belirt.
