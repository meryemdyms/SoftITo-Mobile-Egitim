import 'package:flutter_test/flutter_test.dart';
import 'package:cep_muzem/features/auth/repositories/mock_auth_repository.dart';

void main() {
  group('MockAuthRepository Testleri', () {
    test('Başlangıçta demo kullanıcısı yüklüdür', () {
      final repo = MockAuthRepository(startWithDemoUser: true);
      expect(repo.currentUser, isNotNull);
      expect(repo.currentUser?.email, equals('demo@cepmuzem.com'));
      expect(repo.isFirebaseConfigured, isFalse);
    });

    test('Geçerli giriş yapıldığında currentUser güncellenir', () async {
      final repo = MockAuthRepository(startWithDemoUser: false);
      expect(repo.currentUser, isNull);

      final user = await repo.signIn(
        email: 'test@cepmuzem.com',
        password: 'password123',
      );

      expect(user.email, equals('test@cepmuzem.com'));
      expect(repo.currentUser?.id, equals(user.id));
    });

    test('Kısa şifre ile giriş reddedilir', () async {
      final repo = MockAuthRepository(startWithDemoUser: false);
      expect(
        () => repo.signIn(email: 'test@cepmuzem.com', password: '123'),
        throwsA(isA<Exception>()),
      );
    });

    test('Oturum kapatıldığında currentUser temizlenir', () async {
      final repo = MockAuthRepository(startWithDemoUser: true);
      expect(repo.currentUser, isNotNull);

      await repo.signOut();
      expect(repo.currentUser, isNull);
    });
  });
}
