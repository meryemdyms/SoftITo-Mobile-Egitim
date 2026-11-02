/// Uygulama genelinde fırlatılan özel hata sınıflarının temel soyut sınıfı.
abstract class AppException implements Exception {
  /// Kullanıcıya veya loglara yansıtılacak anlaşılır hata mesajı.
  final String message;

  const AppException(this.message);

  @override
  String toString() => message;
}

/// Kimlik doğrulama, oturum açma veya kayıt işlemleri sırasında oluşan hatalar.
class AuthException extends AppException {
  const AuthException(super.message);
}

/// Rezervasyon oluşturma, tarih çakışması, ehliyet veya yaş kısıtlaması hataları.
class BookingException extends AppException {
  const BookingException(super.message);
}

/// Talep edilen bir kaydın (araç, firma, rezervasyon vb.) bulunamaması hatası.
class NotFoundException extends AppException {
  const NotFoundException(super.message);
}

/// Yetkisiz işlem veya başka kullanıcının verisine müdahale edilmeye çalışıldığında fırlatılan hata.
class PermissionDeniedException extends AppException {
  const PermissionDeniedException([
    super.message = 'Bu işlem için yetkiniz bulunmamaktadır.',
  ]);
}

/// Form veya iş kuralı veri doğrulama hataları.
class ValidationException extends AppException {
  const ValidationException(super.message);
}
