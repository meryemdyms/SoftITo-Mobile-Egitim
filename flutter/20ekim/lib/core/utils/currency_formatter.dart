import 'package:intl/intl.dart';

class CurrencyFormatter {
  CurrencyFormatter._();

  static final NumberFormat _formatterWithDecimals = NumberFormat.currency(
    locale: 'tr_TR',
    symbol: '₺',
    decimalDigits: 2,
    customPattern: '#,##0.00 \u00a4',
  );

  static final NumberFormat _formatterWithoutDecimals = NumberFormat.currency(
    locale: 'tr_TR',
    symbol: '₺',
    decimalDigits: 0,
    customPattern: '#,##0 \u00a4',
  );

  /// Formats currency from kuruş (int) to formatted Turkish Lira.
  /// Example: 150000 kurus -> "1.500 ₺" or "1.500,00 ₺"
  static String formatKurus(int kurus, {bool showDecimals = false}) {
    final double liras = kurus / 100.0;
    if (showDecimals || kurus % 100 != 0) {
      return _formatterWithDecimals.format(liras);
    }
    return _formatterWithoutDecimals.format(liras);
  }

  /// Converts Lira to Kurus (int)
  static int liraToKurus(int lira) => lira * 100;
}
