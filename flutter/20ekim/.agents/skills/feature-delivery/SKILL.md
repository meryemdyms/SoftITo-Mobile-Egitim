
---
name: feature-delivery
description: Kullanıcı yeni bir özelliği uçtan uca eklememi istediğinde bu koordinatör skill ile ilgili domain skilllerini birlikte kullan.
---

# feature-delivery

## İş sırası
1. `project.md` ve `AGENTS.md` oku; istek için kapsam, rol, giriş/çıkış ekranı, değişen entity, repository, kabul kriterlerini çıkar.
2. İlgili domain skill'lerini de aç: auth, booking, maps, campaigns vb. Bu koordinatör diğer skill'lerin yerine geçmez.
3. Küçük teslimat planı yap; dosyaları feature-first yerleştir; router/DI/theme kayıtlarını unutma.
4. UI akışını loading/empty/error ve validasyonla tamamla; demo seed ve rollback senaryolarını düşün.
5. Unit/widget ve gerekiyorsa integration testleri yaz; format/analyze/test çalıştır.
6. Kullanıcıya ne yapıldığını, hangi dosyaların değiştiğini ve bilinçli ertelenen işleri bildir.

## Bitiş kriteri
Feature rol sınırlarını ihlal etmez, mock üzerinden gerçekten çalışır, atıl placeholder kalmaz, proje ve skill kurallarıyla çelişmez.
