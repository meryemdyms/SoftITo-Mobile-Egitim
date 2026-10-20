
---
name: forms-and-validation
description: Giriş/kayıt, araç CRUD, arama ve rezervasyon formları; validasyon, focus, dialog, hata mesajlarında kullan.
---

# forms-and-validation

## Kurallar
- `Form` + `GlobalKey<FormState>` veya controller state doğrulaması; validator UI'da biçim, domain'de business invariant kontrol eder.
- Her input label, hint, accessibility semantiği, hata metni ve uygun keyboardType/textInputAction alır.
- E-posta/telefon/yıl/tarih/sayı/koordinat validasyonları tutarlı utility'lerden gelir. Şifre girişinde maskeleme; loglama yok.
- Submit tek seferlik/disable while loading; hatalarda kullanıcı verisi kaybolmaz.
- Date/time picker geçmiş tarihleri kısıtlar; tarih sıralaması ve yerel zaman gösterimi tutarlı.
- Silme/iptal, oturum kapatma gibi yıkıcı eylemler için confirm dialog; bilgi için snackbar; iş akışını bloklayan hatalarda dialog.
- Şifre/ehliyet için gerçek kişi test verisi kullanma; demo uyarısı göster.

## Kontrol
İlk açılış/boş değer, hatalı alan, focus sırası, klavye kapanması, retry, loading, double submit, erişilebilir hata bildirimi test edilir.
