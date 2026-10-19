import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// BuildContext için tema, dinamik renkler ve ekran boyutuna hızlı erişim uzantıları.
extension ContextExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  bool get isDarkMode => theme.brightness == Brightness.dark;

  Color get cardBorderColor =>
      isDarkMode ? AppColors.darkCardBorder : AppColors.lightCardBorder;
  Color get surfaceElevatedColor =>
      isDarkMode ? AppColors.darkSurfaceElevated : AppColors.lightSurfaceElevated;
  Color get surfaceColor => colorScheme.surface;
  Color get primaryAccent => colorScheme.primary;

  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;
  EdgeInsets get padding => MediaQuery.paddingOf(this);
}
