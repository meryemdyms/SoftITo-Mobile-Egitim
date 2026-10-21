
---
name: profile-privacy
description: Kendi ve diğer kullanıcı profilleri, profil düzenleme, gizli hesaplar, takip izinleri, Müzelerim ve Kaydettiklerim için kullan.
---

# Profil ve Gizlilik

## Kendi Profilim

- Profil fotoğrafı
- Ad soyad
- Takipçi sayısı
- Takip edilen sayısı
- Müzelerim
- Kaydettiklerim
- Profil düzenleme
- Gizlilik ayarları
- Çıkış

## Diğer Kullanıcı Profili

- Profil fotoğrafı
- Ad soyad
- Takipçi bilgileri
- Takip et/takibi bırak
- Erişilebilir müzeler

## Hesap Gizliliği

Hesap türleri:
- Açık
- Gizli

Açık hesap:
Doğrudan takip edilir.

Gizli hesap:
- Takip isteği gönderilir.
- Hesap sahibi onaylayabilir.
- Hesap sahibi reddedebilir.
- Yalnızca onaylı takipçiler müzeleri görebilir.

## Müzelerim

Kullanıcının oluşturduğu müzeler gösterilir.

Sahiplik doğrulanarak:
- Düzenleme
- Arşivleme
- Silme

## Kaydettiklerim

- Kaydedilen müzeler gösterilir.
- Kayıt kaldırılabilir.
- Gizlilik değiştiğinde erişim tekrar kontrol edilir.
- Kaydetmek erişim hakkı oluşturmaz.

## Güvenlik

- Firestore Rules uygulanır.
- Storage Rules uygulanır.
- Gizli medya yetkisiz görüntülenemez.
- Gizlilik yalnızca UI'da uygulanmaz.

## Test

- Profil düzenleme
- Açık hesap
- Gizli hesap
- Takip isteği
- Onay/ret
- Takipten çıkma
- Kaydedilen müze erişimi
