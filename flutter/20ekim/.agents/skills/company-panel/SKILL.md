
---
name: company-panel
description: Firma dashboard, araç CRUD, rezervasyon yönetimi, kampanya veya vitrin düzenlemesi için kullan.
---

# company-panel

## Yetki
Aktör rolü `company` ve ownerUserId ilgili firmaya bağlı olmalı. Ekran, controller ve repository seviyelerinde ownership doğrula.

## Modüller
- Dashboard: bugünkü teslim/iade, aktif kiralama, yaklaşan rezervasyon ve sayı kartları.
- Vehicles: ekle/güncelle/pasife al, fotoğraflar, min yaş/ehliyet, bloke tarih aralıkları. Mevcut rezervasyonu sessizce silme.
- Reservations: firma filtresi, `confirmed -> active -> completed`; yalnızca confirmed iptal. Geçersiz aksiyonu disable + anlaşılır hata.
- Campaigns: yalnız firmanın kendi kampanyası, tarih/yüzde doğrulaması.
- Storefront: logo, açıklama, telefon, adres, enlem-boylam, çalışma saatleri düzenlemesi.

## UX
Destructive aksiyonlar onay diyaloğu ister; kaydetmede loading, tekrar tıklama engeli, başarı/hata geri bildirimi. Demo ödeme yapıldığı iddia edilmez.

## Test
Başka şirket kaydını görüntüleme/düzenleme reddi, CRUD validasyonları, statü geçişleri, pasif araçların müşteri sonuçlarından kalkması.
