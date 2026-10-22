
---
name: flutter-architecture
description: Flutter projesinde yeni feature oluştururken, mevcut feature yapısını düzenlerken veya mimari geliştirme yaparken kullan.
---

# Flutter Architecture

## Kurallar

- Feature-first mimari kullan.
- Her feature kendi dosyalarını içermelidir.
- UI, state ve veri erişimini ayır.
- Basit işlemler için gereksiz katman oluşturma.
- Ortak widget ve servisleri `core/` altında topla.
- İş kurallarını widget içinde yazma.
- Null safety, const ve okunabilir Dart kodu kullan.

## Önerilen yapı

lib/
  core/
    theme/
    widgets/
    services/
    utils/

  features/
    feature_name/
      models/
      views/
      widgets/
      controllers/
      repositories/

## State yönetimi

- Başlangıç için ChangeNotifier kullanılabilir.
- State yönetimini controller üzerinden yap.
- Widget yalnızca state'i dinleyip arayüzü oluşturmalıdır.
- State yönetimi yaklaşımını kullanıcı onayı olmadan değiştirme.

## Uygulama

1. İlgili feature'ı belirle.
2. Gerekli dosyaları oluştur.
3. Model, controller ve repository sorumluluklarını ayır.
4. Route ve bağımlılık bağlantılarını tamamla.
5. Analiz ve testleri çalıştır.
