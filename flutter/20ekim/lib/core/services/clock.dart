/// Zaman işlemlerini test edilebilir ve soyut kılmak için kullanılan saat arayüzü.
abstract class Clock {
  /// Şu anki zaman damgasını döndürür.
  DateTime now();
}

/// Gerçek cihaz/sistem saatini döndüren Clock implementasyonu.
class SystemClock implements Clock {
  const SystemClock();

  @override
  DateTime now() => DateTime.now();
}

/// Test senaryolarında zamanı manipüle etmek ve ileri/geri almak için kullanılan yapay saat.
class TestClock implements Clock {
  DateTime _current;

  TestClock(DateTime initialTime) : _current = initialTime;

  @override
  DateTime now() => _current;

  /// Test saatini belirli bir zamana ayarlar.
  void setTime(DateTime time) {
    _current = time;
  }

  /// Test saatini belirtilen süre kadar ileri taşır.
  void advance(Duration duration) {
    _current = _current.add(duration);
  }
}
