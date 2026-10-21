
---
name: firebase-repositories
description: Firebase Auth, Firestore, Storage, repository implementasyonları, mock veri, güvenlik ve kalıcılık işlemlerinde kullan.
---

# Firebase ve Repository

## Kesin Teknolojiler

- Firebase Authentication
- Cloud Firestore
- Firebase Storage

Gerçek bağlantı Firebase projesi yapılandırması
yapıldıktan sonra etkinleştirilir.

## Veri Akışı

View
→ ViewModel
→ Repository Interface
→ Repository Implementation
→ Firebase Data Source

## Kurallar

- UI doğrudan Firebase kullanmaz.
- Repository interface ve implementation ayrılır.
- Firebase ve mock implementasyonları ayrıdır.
- İşlemler test edilebilir olmalıdır.
- Hatalar yönetilir.
- Kalıcılık doğrulanır.

## Güvenlik

- Auth UID kullanılır.
- ownerId kontrol edilir.
- Onaylı takip ilişkileri doğrulanır.
- Firestore Security Rules uygulanır.
- Storage Security Rules uygulanır.
- Gizli içerikler herkese açık URL ile sunulmaz.
- Yetkisiz okuma/yazma engellenir.

## Sayaç ve İlişkiler

- Atomik işlem veya transaction kullanılır.
- Çift beğeni önlenir.
- Çift kayıt önlenir.
- Takip sayaçları tutarlı kalır.
- Silme ve veri temizleme işlemleri yönetilir.

## Demo Modu

Firebase yapılandırması yoksa
MockRepository kullanılabilir.

- Demo modu gerçek veri olarak gösterilmez.
- Firebase entegrasyonu tamamlandı denmez.
- Gerçek kullanıcı hesapları taklit edilmez.

## Yasaklar

- Hardcoded gerçek kullanıcı bilgileri
- Açık metin şifre saklama
- Yetkisiz veri erişimi
- Gizli medya için kalıcı herkese açık bağlantı
- Sahte kalıcılık
- Onaysız backend değişimi

## Test

- CRUD
- Sahiplik
- Gizli hesap
- Gizli medya
- Çift beğeni
- Ağ hatası
- Mock/Firebase davranışı
- Yetkisiz okuma ve yazma
