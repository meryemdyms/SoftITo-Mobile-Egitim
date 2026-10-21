
---
name: museum-scene-2d
description: 2D müze simülasyonu, sahne renderer, eser konumları, hotspot etkileşimleri ve eser seçimi sırasında kullan.
---

# 2D Müze Simülasyonu

## Kesin Karar

V1 yalnızca 2D etkileşimli müze içerir.

3D yalnızca gelecekteki mimari genişleme noktasıdır.

## Renderer

MuseumSceneRenderer
→ TwoDMuseumRenderer

İçerik modelleri:
- MuseumScene
- MuseumRoom
- MuseumItem

Renderer'dan bağımsız tutulur.

## Oda Yapısı

- Hazır oda şablonları
- Sıcak taş duvar
- Eser çerçeveleri
- Sergi etiketleri
- Tanımlanmış yerleşim yuvaları

## Koordinat

positionX ve positionY:
0.0–1.0 normalize koordinat sistemi.

Farklı ekran boyutlarına uyarlanır.

Dokunma alanları minimum 44x44 logical px olur.

## Eser Etkileşimi

1. Kullanıcı esere dokunur.
2. Doğru eser seçilir.
3. Eser detay paneli açılır.
4. Görsel ve açıklama gösterilir.
5. Varsa sesli not oynatılır.
6. Panel kapatılabilir.

## Hata Yönetimi

- Eksik eser
- Hatalı görsel
- Ses dosyası hatası
- Erişim engeli
- Ağ bağlantısı hatası

## Yasaklar

- Sahte 3D düğmesi
- Serbest kamera kontrolü
- Kapsam dışı oda
- Eser verilerini UI içine sabitlemek
- İşlevsiz eser noktası

## Test

- Oda yükleme
- Eser seçme
- Panel kapatma
- Ses durumu
- Farklı ekran ölçüleri
- Gizli müze erişimi
