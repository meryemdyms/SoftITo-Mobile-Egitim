import 'package:intl/intl.dart';

/// Parasal değerlerin tamsayı kuruş üzerinden Türk Lirası (₺) formatına dönüştürülmesini sağlayan yardımcı sınıf.
///
/// Proje anayasası gereği parasal işlemler double kullanılmadan tamsayı (int kuruş) cinsinden yönetilir.
class CurrencyFormatter {
  CurrencyFormatter._();

  // Kuruşlu (ondalıklı) gösterim formatlayıcı: 1.500,50 ₺
  static final NumberFormat _formatterWithDecimals = NumberFormat.currency(
    locale: 'tr_TR',
    symbol: '₺',
    decimalDigits: 2,
    customPattern: '#,##0.00 \u00a4',
  );

  // Kuruşsuz (tam sayı) gösterim formatlayıcı: 1.500 ₺
  static final NumberFormat _formatterWithoutDecimals = NumberFormat.currency(
    locale: 'tr_TR',
    symbol: '₺',
    decimalDigits: 0,
    customPattern: '#,##0 \u00a4',
  );

  /// Kuruş değerini (int) biçimlendirilmiş Türk Lirası metnine çevirir.
  ///
  /// Örnek: `150000` kuruş -> "1.500 ₺" veya `showDecimals = true` ise "1.500,00 ₺"
  static String formatKurus(int kurus, {bool showDecimals = false}) {
    final double liras = kurus / 100.0;
    if (showDecimals || kurus % 100 != 0) {
      return _formatterWithDecimals.format(liras);
    }
    return _formatterWithoutDecimals.format(liras);
  }

  /// Lira değerini kuruş cinsine (int) dönüştürür.
  static int liraToKurus(int lira) => lira * 100;
}
