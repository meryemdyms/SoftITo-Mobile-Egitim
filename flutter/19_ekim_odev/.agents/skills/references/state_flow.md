# State Akışı ve Mimari Prensipler

## 1. Veri ve Durum Akışı
1. **Model:** `immutable` veri tutar, `copyWith` metoduna sahiptir.
2. **Controller:** İş mantığını barındırır, durumu `ValueNotifier<T>` ile dışa açar, `dispose` ile kaynakları serbest bırakır.
3. **View:** `StatefulWidget` olup yalnızca controller'ın `initState` ve `dispose` yaşam döngüsünü kontrol eder. Sayfa `ValueListenableBuilder` ile yeniden çizilir (`setState` kullanılmaz).
4. **Widgets:** Küçük ve modüler widget bileşenleridir. Her `build` metodu en fazla 40 satır olmalıdır. Statik öğeler `const` tanımlanır.

## 2. Renk ve Tema Standartları
- Hard-coded renkler (örneğin `Colors.red` veya `Color(0xFF...)`) widget içinde yazılmaz.
- `Theme.of(context).colorScheme` ve tema yardımcıları kullanılır.
- Tema yönetimi `ValueNotifier<ThemeMode>` ile reaktif olarak sağlanır.
