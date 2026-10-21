import 'package:flutter_test/flutter_test.dart';
import 'package:cep_muzem/shared/models/room_template_model.dart';

void main() {
  group('2D Oda Şablonları Testleri', () {
    test('V1 Tam olarak 3 kesin oda şablonu içerir', () {
      expect(RoomTemplateModel.allTemplates.length, equals(3));
      expect(
        RoomTemplateModel.allTemplates.map((t) => t.id),
        containsAll([
          RoomTemplateModel.classicGalleryId,
          RoomTemplateModel.stoneCorridorId,
          RoomTemplateModel.archiveHallId,
        ]),
      );
    });

    test('Klasik Galeri tam olarak 4 eser yuvası içerir', () {
      final gallery = RoomTemplateModel.classicGallery;
      expect(gallery.slotDefinitions.length, equals(4));
    });

    test(
      'Bütün slot koordinatları 0.0 ile 1.0 arasında normalize edilmiştir',
      () {
        for (final template in RoomTemplateModel.allTemplates) {
          for (final slot in template.slotDefinitions) {
            expect(slot.defaultX, inInclusiveRange(0.0, 1.0));
            expect(slot.defaultY, inInclusiveRange(0.0, 1.0));
          }
        }
      },
    );
  });
}
