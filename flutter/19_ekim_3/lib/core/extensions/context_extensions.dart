import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// BuildContext için tema, dinamik renkler ve ekran boyutuna hızlı erişim uzantıları (Extensions).
/// Bu uzantılar `Theme.of(context)` ve `MediaQuery` çağrılarını sadeleştirerek kodun okunabilirliğini artırır.
extension ContextExtensions on BuildContext {
  // Temel Tema ve Tipografi Kısayolları
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  bool get isDarkMode => theme.brightness == Brightness.dark;

  // Aktif temanın parlaklığına (Brightness) göre dinamik kart kenarlığı ve yükseltilmiş yüzey rengi
  Color get cardBorderColor =>
      isDarkMode ? AppColors.darkCardBorder : AppColors.lightCardBorder;
  Color get surfaceElevatedColor =>
      isDarkMode ? AppColors.darkSurfaceElevated : AppColors.lightSurfaceElevated;
  Color get surfaceColor => colorScheme.surface;
  Color get primaryAccent => colorScheme.primary;

  // Flutter 3.10+ Performans Optimizasyonu:
  // MediaQuery.of(context) tüm ekran değişikliklerini dinlerken, sizeOf ve paddingOf
  // yalnızca ilgili özellik değiştiğinde widget'ı yeniden oluşturur (rebuild).
  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;
  EdgeInsets get padding => MediaQuery.paddingOf(this);
}
