import 'package:flutter/foundation.dart';

/// Cep Müzem — Eser Yuvası (Slot) Tanımı
///
/// 2D müze odasında bir eserin yerleştirilebileceği normalize koordinatları tanımlar.
@immutable
class SlotDefinition {
  /// Yuvanın benzersiz kimliği (ör. 'slot_1', 'slot_2')
  final String slotId;

  /// Sahne genişliğine göre yatay merkez konumu (0.0 - 1.0 arası normalize)
  final double defaultX;

  /// Sahne yüksekliğine göre dikey merkez konumu (0.0 - 1.0 arası normalize)
  final double defaultY;

  /// Yuvanın kullanıcıya gösterilen etiketi (ör. "1. Sergi Nişi")
  final String label;

  const SlotDefinition({
    required this.slotId,
    required this.defaultX,
    required this.defaultY,
    required this.label,
  });
}

/// Cep Müzem — Kesin Müze Oda Şablonları (RoomTemplateModel)
///
/// AGENTS.md ve project.md Kesin Kuralları:
/// - V1'de tam olarak üç oda şablonu bulunur:
///   1. Klasik Galeri — 4 eser
///   2. Taş Koridor — 6 eser
///   3. Arşiv Salonu — 8 eser
/// - Şablonlar 2D'dir ve belirlenmiş eser yuvaları (slot) içerir.
/// - Agent ve sistem bunların dışında yeni oda şablonu türetmez.
@immutable
class RoomTemplateModel {
  /// Şablonun benzersiz kimliği
  final String id;

  /// Şablonun adı
  final String name;

  /// Arka plan varlık anahtarı
  final String backgroundAsset;

  /// Şablona ait önceden belirlenmiş eser yuvaları listesi
  final List<SlotDefinition> slotDefinitions;

  /// Şablon sürümü
  final int templateVersion;

  const RoomTemplateModel({
    required this.id,
    required this.name,
    required this.backgroundAsset,
    required this.slotDefinitions,
    required this.templateVersion,
  });

  // V1'deki 3 kesin oda şablonu kimlik sabitleri
  /// 1. Şablon: Klasik Galeri (4 Eser)
  static const String classicGalleryId = 'classic_gallery';

  /// 2. Şablon: Taş Koridor (6 Eser)
  static const String stoneCorridorId = 'stone_corridor';

  /// 3. Şablon: Arşiv Salonu (8 Eser)
  static const String archiveHallId = 'archive_hall';

  /// 1. Klasik Galeri Şablonu: Tek sıra halinde 4 eser yuvası
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

  /// 2. Taş Koridor Şablonu: Sol/sağ duvarlar ve orta kaide ile 6 eser yuvası
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

  /// 3. Arşiv Salonu Şablonu: Üst vitrinler ve alt çekmecelerle 8 eser yuvası
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

  /// V1'deki tüm kesin oda şablonlarının listesi (Toplam 3 adet)
  static final List<RoomTemplateModel> allTemplates = [
    classicGallery,
    stoneCorridor,
    archiveHall,
  ];

  /// Şablon kimliğine göre şablon nesnesini getiren yardımcı metot
  static RoomTemplateModel getById(String id) {
    return allTemplates.firstWhere(
      (t) => t.id == id,
      orElse: () => classicGallery,
    );
  }
}

