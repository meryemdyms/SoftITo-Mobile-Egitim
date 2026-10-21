
---
name: app-navigation
description: Splash, go_router, alt navigasyon, oturum yönlendirmesi ve ekran geçişlerinde kullan.
---

# Navigasyon

## Teknoloji

go_router kullanılır.

Route tanımları merkezi yönetilir.

## Açılış Akışı

Splash
→ Oturum kontrolü
→ Oturum varsa Keşfet
→ Oturum yoksa Giriş

Kayıt veya giriş başarılıysa Keşfet açılır.

Çıkış işlemi kullanıcıyı giriş ekranına götürür.

## Bottom Navigation

Kesin sıralama:

1. Keşfet
2. Harita
3. Müzeni Oluştur
4. Profil

Bildirimler beşinci sekme değildir.

Ana sayfanın sağ üstündeki zil ikonundan açılır.

## Ekran Geçişleri

- Müze kartı → Müze detayı
- Müze sahibi → Kullanıcı profili
- Harita pini → Yer veya müze detayı
- Bildirim → İlgili içerik
- Kaydedilen müze → Müze detayı
- Profil → Profil düzenleme

## Kurallar

- Oturum gerektiren route'lar korunur.
- Geçersiz ID için hata durumu bulunur.
- Gizli içeriğe yetkisiz erişim engellenir.
- Geri tuşu tutarlı çalışır.
- Gereksiz veya boş sayfa oluşturulmaz.
- Kullanıcı onayı olmadan yeni navigation öğesi eklenmez.

## Test

- Oturumlu açılış
- Oturumsuz açılış
- Giriş ve çıkış
- Bottom navigation
- Geri dönüş
- Geçersiz route
- Yetkisiz erişim
