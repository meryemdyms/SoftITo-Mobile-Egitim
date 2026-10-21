
---
name: authentication
description: Kayıt, giriş, Firebase Auth, çıkış ve oturum yönetiminde kullan.
---

# Authentication

## Kayıt

Zorunlu alanlar:
- Ad
- Soyad
- E-posta
- Şifre

## Giriş

- E-posta
- Şifre

Ad ve soyad giriş sırasında tekrar istenmez.

## Altyapı

Firebase Authentication kullanılır.

Firebase Auth UID ile kullanıcı profili
Firestore üzerinde ilişkilendirilir.

## Kurallar

- Form alanları doğrulanır.
- E-posta biçimi kontrol edilir.
- Şifre açık metin olarak saklanmaz.
- Başarısız işlemler kullanıcıya bildirilir.
- Loading durumu gösterilir.
- Birden fazla giriş isteği önlenir.
- Oturum uygulama açılışında kontrol edilir.
- Çıkış işlemi gerçek oturumu sonlandırır.
- Yetkisiz sayfalara route guard uygulanır.

## Demo Modu

Firebase yapılandırması yoksa ayrı MockAuthRepository
kullanılabilir.

Demo hesap gerçek Firebase hesabı gibi gösterilemez.

## Test

- Boş form
- Geçerli kayıt
- Hatalı e-posta
- Yanlış şifre
- Oturum korunması
- Çıkış
