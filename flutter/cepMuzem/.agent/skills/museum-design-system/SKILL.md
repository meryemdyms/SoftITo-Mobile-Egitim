
---
name: museum-design-system
description: Cep Müzem için yeni ekran, widget, tema, animasyon, renk, tipografi veya görsel tasarım oluştururken ve mevcut UI düzenlenirken mutlaka kullan.
---

# Museum Design System — V1

## 1. Kesin Tasarım Kimliği

Tasarım konsepti: Yaşayan Müze

Cep Müzem tarihi bir müzenin atmosferini
modern bir mobil uygulama ile birleştirir.

Hedeflenen his:
- Tarihi
- Sıcak
- Zarif
- Sakin
- Sanatsal
- Zamansız
- Keşif odaklı

Görsel ilham:
- Tarihi müze salonları
- Traverten ve kireç taşı
- Parşömen kataloglar
- Bronz sergi etiketleri
- Ceviz ahşap
- Klasik eser çerçeveleri
- Arşiv koleksiyonları

Uygulama karanlık veya aşırı süslü olmamalıdır.

## 2. Kesin Renk Paleti

Ana arka plan:
#F6F1E7 — Ivory

Kart yüzeyi:
#FFFCF7 — Museum White

İkincil yüzey:
#EDE2D0 — Parchment

Kenarlık:
#C9BBA5 — Museum Stone

Ana metin ve CTA:
#332C27 — Deep Walnut

Vurgu:
#8B6B43 — Antique Bronze

İkincil vurgu:
#69715D — Archive Olive

Sınırlı dikkat rengi:
#AA6753 — Terracotta

İkincil metin:
#695F56

Semantik hata, başarı ve uyarı renkleri
erişilebilir kontrastla merkezi temada tanımlanır.

## 3. Renk Kullanım Oranları

Yaklaşık:
- %65 açık fildişi
- %25 parşömen ve beyaz yüzey
- %10 bronz, ceviz ve zeytin detay

Büyük koyu bloklardan kaçınılır.

Fotoğrafların orijinal renkleri korunur.

Bronz detaylar sürekli değil, seçili alanlarda kullanılır.

## 4. Tipografi

Başlık fontu:
Cormorant Garamond

Gövde fontu:
Inter

Türkçe karakterler kontrol edilir.

Fontlar sağlanamıyorsa geçici sistem fallback
kullanılır ve eksiklik raporlanır.

Yazı ölçekleri:

- Sayfa başlığı: 28sp
- Bölüm başlığı: 22sp
- Kart başlığı: 18sp
- Gövde: 15sp
- Yardımcı: 12sp

Metin ölçeklendirmesi desteklenir.

Uzun açıklamalarda okunabilir sans-serif kullanılır.

## 5. Ölçüler

Screen horizontal padding: 20dp

Spacing:
4, 8, 12, 16, 24, 32

Card radius: 16dp

Button radius: 12dp

Bottom sheet üst radius: 24dp

Dokunma alanı:
En az 44x44 logical pixel

## 6. İkonografi

Tek ikon ailesi:
Material Symbols

Temel ikonlar:
- Home
- Map
- Add
- Museum
- Bookmark
- Heart
- Comment
- Bell
- User
- Settings
- Lock
- Play
- Pause

Rastgele emoji veya farklı ikon setleri kullanılmaz.

## 7. Ana Sayfa Tasarımı

Ana sayfa özgün bir dijital sergi kataloğudur.

- Büyük müze kapakları
- Dengeli katalog bölümleri
- Müze isimleri
- Kısa hikâye açıklamaları
- Müze sahipleri
- Sade kaydetme işlemleri

Büyük sergi kartları ve gerektiğinde
iki sütunlu katalog görünümü kullanılabilir.

Pinterest masonry düzeni kopyalanmaz.

Instagram gönderi akışı kopyalanmaz.

Beğeni ve takipçi sayıları ön plana çıkarılmaz.

## 8. Müze Kartı

İçerik:
- Kapak görseli
- Müze adı
- Kısa açıklama
- Müze sahibi
- Kaydetme ikonu

Görsel:
- Büyük ve net
- Oranları korunmuş
- Gereksiz filtre uygulanmamış

Kart:
- Museum White yüzey
- Museum Stone ince border
- 16dp radius
- Dengeli iç boşluk
- Çok hafif gölge kullanılabilir

## 9. Profil Ekranı

Profil bir kişisel küratör alanı gibi tasarlanır.

- Profil fotoğrafı
- Kullanıcı adı
- İkincil düzeyde takipçi bilgileri
- Müzelerim
- Kaydettiklerim

Müze koleksiyonları ana görsel unsurdur.

## 10. Müze Oluşturma

Oluşturma adımları anlaşılır şekilde gösterilir.

- Müze bilgileri
- Oda seçimi
- Eser ekleme
- Eser yerleşimi
- Konum
- Önizleme
- Yayınlama

Oda şablonları görsel küçük önizlemelerle sunulur.

Kaydedilmemiş taslak için "Kaydedildi" denmez.

## 11. 2D Müze Odası

- Sıcak taş duvar
- Açık sergi yüzeyleri
- Ceviz veya taş zemin hissi
- İnce eser çerçeveleri
- Küçük eser etiketleri
- Yumuşak aydınlatma hissi

Dekorasyon eserlerin incelenmesini engellemez.

Eser üzerine dokunulunca detay paneli açılır.

## 12. Eser Detay Paneli

Panel alttan açılır.

İçerik:
- Eser adı
- Görseller
- Açıklama
- Varsa sesli not oynatıcısı

Üst köşeler 24dp radius kullanır.

Panel kapatma ve ses durdurma işlemleri çalışır.

## 13. Harita Tasarımı

- Ziyaret edilmiş: Archive Olive
- Keşfedilecek: Antique Bronze

Pinler yalnızca renklerle ayrıştırılmaz.
Farklı ikon veya şekil de kullanılır.

Harita okunabilirliği korunur.

## 14. Bildirim Ekranı

Sakin katalog listesi görünümü.

- Küçük profil görseli
- Bildirim açıklaması
- Zaman bilgisi
- Okunmamış durumu için küçük işaret
- Takip isteği yönetim butonları

Büyük uyarı kutuları ve baskıcı rozetler kullanılmaz.

## 15. Butonlar

Primary:
- Walnut arka plan
- Açık metin
- 12dp radius

Secondary:
- Açık yüzey
- Walnut metin
- İnce kenarlık

Disabled:
- Erişilebilir şekilde pasif

Her buton gerçek işlem gerçekleştirmelidir.

## 16. Animasyonlar

Süre:
180–280ms

Kullanım:
- Fade
- Hafif slide
- Bottom sheet geçişleri
- Eser seçim vurgusu

Sürekli dönen, dikkat dağıtan animasyonlar yoktur.

Reduced motion desteği sağlanır.

## 17. Flutter Tema Yönetimi

Renkler:
app/theme/

Tipografi:
app/theme/

Spacing ve radius:
Merkezi token sistemi

Widget dosyalarında rastgele hex kullanılmaz.

Ortak bileşenler:
- MuseumCard
- MuseumSectionHeader
- ArchiveButton
- MuseumEmptyState
- ArtworkSheet

## 18. Erişilebilirlik

- SafeArea kullanılır.
- Kontrast kontrol edilir.
- Büyük yazı ölçeği desteklenir.
- Ekran okuyucu açıklamaları bulunur.
- Klavye taşmaları önlenir.
- Android ve iOS boyutlarına uyulur.
- Renk tek başına durum göstergesi değildir.

## 19. Yasaklar

- Yeni renk paleti oluşturmak
- Yeni font seçmek
- Pinterest veya Instagram arayüzünü kopyalamak
- Aşırı gradient kullanmak
- Gereksiz glassmorphism kullanmak
- Her ekrana farklı tasarım dili uygulamak
- İşlevsiz görsel kontroller eklemek
- Sürekli animasyonlarla dikkati dağıtmak

## 20. Kabul Kriterleri

- Tüm ekranlar aynı görsel dili kullanır.
- Tarihi müze atmosferi korunur.
- Tasarım modern ve aydınlıktır.
- Metinler okunabilirdir.
- Bütün görünür kontroller çalışır.
- Android ve iOS uyumludur.
