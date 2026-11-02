import 'package:flutter/material.dart';

/// [BuildContext] nesnesine doğrudan tema, boyut ve SnackBar gibi sıkça kullanılan
/// özelliklere hızlı ve temiz erişim sağlayan extension (yardımcı uzantılar).
extension ContextExtensions on BuildContext {
  /// Geçerli temanın tamamına erişim sağlar (`Theme.of(context)`).
  ThemeData get theme => Theme.of(this);

  /// Geçerli temanın renk şemasına pratik erişim (`Theme.of(context).colorScheme`).
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// Geçerli temanın tipografi (yazı tipi) stillerine erişim (`Theme.of(context).textTheme`).
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Cihaz ekranı ve ortam bilgileri (`MediaQuery.of(context)`).
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// Ekran genişliği (piksel cinsinden).
  double get screenWidth => MediaQuery.of(this).size.width;

  /// Ekran yüksekliği (piksel cinsinden).
  double get screenHeight => MediaQuery.of(this).size.height;

  /// Kullanıcıya bildirim veya hata mesajı göstermek için yüzen (floating) SnackBar açar.
  /// [isError] true ise hata rengi (error), false ise birincil tema rengi (primary) kullanılır.
  void showSnackBar(String message, {bool isError = false}) {
    // Varsa mevcut açık olan SnackBar'ı hemen gizler
    ScaffoldMessenger.of(this).hideCurrentSnackBar();
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? colorScheme.error : colorScheme.primary,
        behavior: SnackBarBehavior.floating, // Ekranın altından havada asılı durur
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Yuvarlatılmış köşeler
        ),
      ),
    );
  }
}

