
---
name: flutter-feature-scaffold
description: Yeni ekran, modül, sekme veya feature oluştururken kullan. Tek widget düzeltmelerinde kullanma.
---

# Yeni Feature İskeleti

## Mimari

Feature-first + MVVM.

Hedef klasörler:

lib/features/<feature>/
- models/
- views/
- viewmodels/
- repositories/
- widgets/

Yalnızca gerekli klasörler oluşturulur.

## Kurallar

1. Önce project.md ve AGENTS.md oku.
2. Görevle ilgili skill'leri oku.
3. UI varsa museum-design-system kullan.
4. View yalnızca arayüz ve olay iletimini yapar.
5. ViewModel ChangeNotifier kullanır.
6. Repository interface ve implementation ayrılır.
7. Model, widget state'inden bağımsızdır.
8. Widget içinde doğrudan Firebase çağrısı yapılmaz.
9. Gereksiz usecase/domain katmanı oluşturulmaz.
10. Yeni teknoloji veya paket onaysız eklenmez.
11. Mevcut feature varsa gereksiz yenisi oluşturulmaz.
12. İşlevsiz kontrol oluşturulmaz.

## Tamamlama

- Route kayıtları güncellenir.
- Importlar düzenlenir.
- State/DI bağlantıları yapılır.
- İlgili testler eklenir.
- flutter analyze kontrol edilir.
- Yapılan değişiklikler raporlanır.
