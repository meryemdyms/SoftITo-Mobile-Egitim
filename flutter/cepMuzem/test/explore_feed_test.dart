import 'package:flutter_test/flutter_test.dart';
import 'package:cep_muzem/shared/models/museum_model.dart';
import 'package:cep_muzem/shared/repositories/mock_museum_repository.dart';

void main() {
  group('Popülerlik Skoru ve Keşfet Sıralama Testleri', () {
    test('Kesin Algoritma: score = likeCount30d + (2 * commentCount30d)', () {
      final now = DateTime.now();
      final museum = MuseumModel(
        id: 'test_m1',
        ownerId: 'owner_1',
        title: 'Test Müzesi',
        description: 'Açıklama',
        coverUrl: '',
        status: MuseumStatus.published,
        likeCount30d: 10,
        commentCount30d: 5,
        createdAt: now,
        updatedAt: now,
      );

      // 10 + (2 * 5) = 20
      expect(museum.popularityScore, equals(20));
    });

    test('Takip edilenlerin müzeleri önce gelir, ardından popülerler başlar ve tekrarlar elenir', () async {
      final repository = MockMuseumRepository();
      // 'demo_user_001' kullanıcısı 'user_curator_pera' ve 'user_ceramic_master' hesaplarını takip ediyor
      final feed = await repository.getExploreFeed(
        currentUserId: 'demo_user_001',
      );

      expect(feed.isNotEmpty, isTrue);

      // Feed içinde tekrarlanan ID olmamalıdır
      final ids = feed.map((m) => m.id).toList();
      final uniqueIds = ids.toSet().toList();
      expect(ids.length, equals(uniqueIds.length));

      // İlk öğeler takip edilenlerin müzeleri olmalı
      expect(
        feed[0].ownerId,
        anyOf('user_curator_pera', 'user_ceramic_master'),
      );
    });

    test(
      'Takip edilen hesap yoksa akış popülerlik puanına göre sıralanır',
      () async {
        final repository = MockMuseumRepository();
        final feed = await repository.getExploreFeed(
          currentUserId: 'unfollowed_user',
        );

        expect(feed.length, greaterThanOrEqualTo(2));
        // İlk öğenin popülerlik puanı ikinciden büyük veya eşit olmalıdır
        expect(
          feed[0].popularityScore,
          greaterThanOrEqualTo(feed[1].popularityScore),
        );
      },
    );
  });
}
