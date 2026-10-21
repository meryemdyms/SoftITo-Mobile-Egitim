
---
name: social-notifications
description: Takip, beğeni, yorum, müze kaydetme, takip istekleri ve bildirim sisteminde kullan.
---

# Sosyal Etkileşimler ve Bildirimler

## Sosyal Yaklaşım

Cep Müzem sosyal rekabet odaklı değildir.

Sosyal etkileşimler müze deneyimini destekler.

Beğeni ve takipçi sayıları görsel olarak
ön planda tutulmaz.

## Beğeni

- Kullanıcı aynı müzeyi bir kez beğenir.
- Tekrar dokununca beğeni kaldırılır.
- İşlemler kalıcı saklanır.
- Sayaçlar atomik güncellenir.

## Yorum

- Erişilebilir müzelere yorum yapılabilir.
- Boş yorum gönderilemez.
- Yorum müze ve kullanıcıya bağlanır.
- Yetkisiz yorum engellenir.

## Takip

Açık hesap:
Doğrudan takip.

Gizli hesap:
- pending
- accepted
- rejected işlem sonucu

Takip bırakma desteklenir.

## Müze Kaydetme

- Beğeniden bağımsızdır.
- Aynı müze bir kez kaydedilir.
- Kayıt kaldırılabilir.
- Kaydedilenler profilde gösterilir.
- Kaydetme erişim yetkisi vermez.

## Bildirim Türleri

- like
- comment
- follow
- follow_request
- follow_accepted

## Bildirim Ekranı

- Ana sayfadaki zil ikonundan açılır.
- Okunmamış bildirim sayısı gösterilir.
- Bildirimler en yeniden eskiye sıralanır.
- Tek bildirim okundu yapılabilir.
- Tüm bildirimler okundu yapılabilir.
- Takip isteği onaylanabilir.
- Takip isteği reddedilebilir.
- Bildirim ilgili içeriğe yönlendirir.

## Güvenlik

- Kullanıcı yalnızca kendi bildirimlerini görür.
- Kendi eylemleri için bildirim oluşturulmaz.
- Gereksiz tekrar bildirimler önlenir.
- Silinmiş içerikler güvenli ele alınır.
- Gizli müze erişimi bildirim yoluyla aşılamaz.

## V1 Kapsamı

Yalnızca uygulama içi bildirimler.

Push notification sonraki sürümlere bırakılır.

## Test

- Beğen/beğenme
- Yorum oluşturma
- Takip/çıkma
- Takip isteği
- Kaydet/kaldır
- Bildirim okundu
- Gizli içerik erişimi
