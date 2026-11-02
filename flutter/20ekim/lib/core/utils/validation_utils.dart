/// Form alanları için ortak giriş doğrulama (validation) kuralları.
class ValidationUtils {
  ValidationUtils._();

  /// Zorunlu alan kontrolü. Boş veya sadece boşluktan oluşan girdileri reddeder.
  static String? validateRequired(
    String? value, [
    String fieldName = 'Bu alan',
  ]) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName zorunludur.';
    }
    return null;
  }

  /// E-posta format doğrulaması (RFC uyumlu standart desen).
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'E-posta adresi zorunludur.';
    }
    final emailRegex = RegExp(r'^[\w\.\-]+@[\w\-]+(\.[a-zA-Z]{2,})+$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Geçerli bir e-posta adresi giriniz.';
    }
    return null;
  }

  /// Telefon numarası doğrulama (en az 10 rakam gerektirir).
  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Telefon numarası zorunludur.';
    }
    final cleanPhone = value.replaceAll(RegExp(r'\D'), '');
    if (cleanPhone.length < 10) {
      return 'Telefon numarası en az 10 hane olmalıdır.';
    }
    return null;
  }

  /// Minimum karakter uzunluğu kontrolü.
  static String? validateMinLength(
    String? value,
    int minLength, [
    String fieldName = 'Bu alan',
  ]) {
    if (value == null || value.trim().length < minLength) {
      return '$fieldName en az $minLength karakter olmalıdır.';
    }
    return null;
  }

  /// Pozitif tam sayı kontrolü (günlük ücret, yıl, yaş vb. için).
  static String? validatePositiveNumber(
    String? value, [
    String fieldName = 'Sayı',
  ]) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName zorunludur.';
    }
    final num = int.tryParse(value.trim());
    if (num == null || num <= 0) {
      return '$fieldName pozitif bir sayı olmalıdır.';
    }
    return null;
  }
}
