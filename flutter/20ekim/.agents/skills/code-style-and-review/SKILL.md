
---
name: code-style-and-review
description: Kod düzenleme, refactor, isimlendirme, performans, review veya pull-request tesliminde kullan.
---

# code-style-and-review

## Kod ilkeleri
- Dart standardı: `snake_case` dosyalar, `PascalCase` sınıflar, `camelCase` üyeler. Public API kısa DartDoc; açıklama neden'e odaklı.
- `const` mümkün olan yerde; async `BuildContext` kullanımı `mounted` guard ile; `ChangeNotifier.dispose`, TextEditingController dispose.
- Widget `build` içinde IO/asenkron işlem, disk okuma, ağır dönüşüm yapılmaz.
- UI'da magic color/spacing ya da API'ye doğrudan erişim yok; domain test edilebilir Flutter bağımsız.
- Büyük widget/method bölünür; sayfa-özel widget ilgili feature dizininde. Sırf satır sayısı için gereksiz abstraction yapılmaz.
- `debugPrint` hassas veriyi yazmaz; typed failure, try/catch ve kullanıcı mesajı ayrıdır.
- Performans: yalnız gereken Provider consumer rebuild, lazy listeler, görüntü placeholder, gereksiz tekrar sorgusu yok.

## İş teslim formatı
1. Değişen dosyaların özeti
2. Neden bu katmanlar etkilendi
3. Çalıştırılan test/analyze sonucu
4. Bilinen sınırlama ve sonraki kararlar
