abstract class AppException implements Exception {
  final String message;
  const AppException(this.message);

  @override
  String toString() => message;
}

class AuthException extends AppException {
  const AuthException(super.message);
}

class BookingException extends AppException {
  const BookingException(super.message);
}

class NotFoundException extends AppException {
  const NotFoundException(super.message);
}

class PermissionDeniedException extends AppException {
  const PermissionDeniedException([
    super.message = 'Bu işlem için yetkiniz bulunmamaktadır.',
  ]);
}

class ValidationException extends AppException {
  const ValidationException(super.message);
}
