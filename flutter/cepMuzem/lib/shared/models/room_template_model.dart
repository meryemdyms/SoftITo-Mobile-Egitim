import 'package:flutter/foundation.dart';

@immutable
class SlotDefinition {
  final String slotId;
  final double defaultX; // 0.0 - 1.0 normalized
  final double defaultY; // 0.0 - 1.0 normalized
  final String label;

  const SlotDefinition({
    required this.slotId,
    required this.defaultX,
    required this.defaultY,
    required this.label,
  });
}

@immutable
class RoomTemplateModel {
  final String id;
  final String name;
  final String backgroundAsset;
  final List<SlotDefinition> slotDefinitions;
  final int templateVersion;

  const RoomTemplateModel({
    required this.id,
    required this.name,
    required this.backgroundAsset,
    required this.slotDefinitions,
    required this.templateVersion,
  });

  /// V1'deki 3 kesin oda şablonu
  static const String classicGalleryId = 'classic_gallery';
  static const String stoneCorridorId = 'stone_corridor';
  static const String archiveHallId = 'archive_hall';

  static final RoomTemplateModel classicGallery = RoomTemplateModel(
    id: classicGalleryId,
    name: 'Klasik Galeri',
    backgroundAsset: 'classic_gallery_bg',
    templateVersion: 1,
    slotDefinitions: const [
      SlotDefinition(
        slotId: 'slot_1',
        defaultX: 0.20,
        defaultY: 0.45,
        label: '1. Sergi Nişi',
      ),
      SlotDefinition(
        slotId: 'slot_2',
        defaultX: 0.40,
        defaultY: 0.45,
        label: '2. Sergi Nişi',
      ),
      SlotDefinition(
        slotId: 'slot_3',
        defaultX: 0.60,
        defaultY: 0.45,
        label: '3. Sergi Nişi',
      ),
      SlotDefinition(
        slotId: 'slot_4',
        defaultX: 0.80,
        defaultY: 0.45,
        label: '4. Sergi Nişi',
      ),
    ],
  );

  static final RoomTemplateModel stoneCorridor = RoomTemplateModel(
    id: stoneCorridorId,
    name: 'Taş Koridor',
    backgroundAsset: 'stone_corridor_bg',
    templateVersion: 1,
    slotDefinitions: const [
      SlotDefinition(
        slotId: 'slot_1',
        defaultX: 0.18,
        defaultY: 0.40,
        label: 'Koridor Sol 1',
      ),
      SlotDefinition(
        slotId: 'slot_2',
        defaultX: 0.35,
        defaultY: 0.40,
        label: 'Koridor Sol 2',
      ),
      SlotDefinition(
        slotId: 'slot_3',
        defaultX: 0.52,
        defaultY: 0.40,
        label: 'Koridor Sol 3',
      ),
      SlotDefinition(
        slotId: 'slot_4',
        defaultX: 0.68,
        defaultY: 0.40,
        label: 'Koridor Sağ 1',
      ),
      SlotDefinition(
        slotId: 'slot_5',
        defaultX: 0.82,
        defaultY: 0.40,
        label: 'Koridor Sağ 2',
      ),
      SlotDefinition(
        slotId: 'slot_6',
        defaultX: 0.50,
        defaultY: 0.70,
        label: 'Koridor Kaide',
      ),
    ],
  );

  static final RoomTemplateModel archiveHall = RoomTemplateModel(
    id: archiveHallId,
    name: 'Arşiv Salonu',
    backgroundAsset: 'archive_hall_bg',
    templateVersion: 1,
    slotDefinitions: const [
      SlotDefinition(
        slotId: 'slot_1',
        defaultX: 0.15,
        defaultY: 0.35,
        label: 'Arşiv Vitrini 1',
      ),
      SlotDefinition(
        slotId: 'slot_2',
        defaultX: 0.38,
        defaultY: 0.35,
        label: 'Arşiv Vitrini 2',
      ),
      SlotDefinition(
        slotId: 'slot_3',
        defaultX: 0.62,
        defaultY: 0.35,
        label: 'Arşiv Vitrini 3',
      ),
      SlotDefinition(
        slotId: 'slot_4',
        defaultX: 0.85,
        defaultY: 0.35,
        label: 'Arşiv Vitrini 4',
      ),
      SlotDefinition(
        slotId: 'slot_5',
        defaultX: 0.20,
        defaultY: 0.65,
        label: 'Arşiv Çekmecesi 1',
      ),
      SlotDefinition(
        slotId: 'slot_6',
        defaultX: 0.40,
        defaultY: 0.65,
        label: 'Arşiv Çekmecesi 2',
      ),
      SlotDefinition(
        slotId: 'slot_7',
        defaultX: 0.60,
        defaultY: 0.65,
        label: 'Arşiv Çekmecesi 3',
      ),
      SlotDefinition(
        slotId: 'slot_8',
        defaultX: 0.80,
        defaultY: 0.65,
        label: 'Arşiv Çekmecesi 4',
      ),
    ],
  );

  static final List<RoomTemplateModel> allTemplates = [
    classicGallery,
    stoneCorridor,
    archiveHall,
  ];

  static RoomTemplateModel getById(String id) {
    return allTemplates.firstWhere(
      (t) => t.id == id,
      orElse: () => classicGallery,
    );
  }
}
