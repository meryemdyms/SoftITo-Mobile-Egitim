import '../models/museum_item_model.dart';
import '../models/museum_model.dart';
import '../models/museum_scene_model.dart';
import '../models/room_template_model.dart';
import '../models/social_models.dart';
import 'museum_repository.dart';

/// Firebase yapılandırılana kadar kullanılan DEMO Museum Repository.
/// project.md ve AGENTS.md kurallarındaki popülerlik ve keşfet sıralama mantığını
/// birebir ve deterministik olarak uygular.
class MockMuseumRepository implements MuseumRepository {
  @override
  bool get isFirebaseConfigured => false;

  final Set<String> _savedMuseumIds = {'museum_001'};
  final Set<String> _likedMuseumIds = {};
  final List<MuseumCommentModel> _comments = [];

  // Demo takip ilişkileri (currentUserId -> followedUserIds)
  final Map<String, Set<String>> _followingMap = {
    'demo_user_001': {'user_curator_pera', 'user_ceramic_master'},
  };

  late List<MuseumModel> _museums;
  late Map<String, MuseumSceneModel> _scenes;

  MockMuseumRepository() {
    _initDemoData();
  }

  void _initDemoData() {
    final now = DateTime.now();

    _museums = [
      MuseumModel(
        id: 'museum_001',
        ownerId: 'user_curator_pera',
        ownerName: 'Selin Arslan',
        ownerPhotoUrl:
            'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=150',
        title: 'Galata & Eski Pera Belleği',
        description: '19. yüzyıl sonu Pera sokakları, eski tramvay hatları ve Galata esnafının unutulmuş hikâyeleri.',
        coverUrl: 'https://images.unsplash.com/photo-1524231757912-21f4fe3a7200?w=800',
        location: 'Galata, İstanbul',
        status: MuseumStatus.published,
        sceneVersion: 1,
        likeCount: 42,
        commentCount: 8,
        likeCount30d: 28,
        commentCount30d: 6, // Score: 28 + (2*6) = 40
        createdAt: now.subtract(const Duration(days: 45)),
        publishedAt: now.subtract(const Duration(days: 20)),
        updatedAt: now.subtract(const Duration(days: 10)),
        isSavedByCurrentUser: true,
      ),
      MuseumModel(
        id: 'museum_002',
        ownerId: 'user_ceramic_master',
        ownerName: 'Murat İznikli',
        ownerPhotoUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
        title: 'Klasik Çini & Hat Koleksiyonu',
        description: '16. yüzyıl İznik lale ve karanfil motifleri ile tezhipli sülüs hat levhalarından oluşan özel seçki.',
        coverUrl: 'https://images.unsplash.com/photo-1579783900882-c0d3dad7b119?w=800',
        location: 'Süleymaniye, İstanbul',
        status: MuseumStatus.published,
        sceneVersion: 1,
        likeCount: 65,
        commentCount: 14,
        likeCount30d: 45,
        commentCount30d: 12, // Score: 45 + (2*12) = 69
        createdAt: now.subtract(const Duration(days: 30)),
        publishedAt: now.subtract(const Duration(days: 15)),
        updatedAt: now.subtract(const Duration(days: 5)),
        isSavedByCurrentUser: false,
      ),
      MuseumModel(
        id: 'museum_003',
        ownerId: 'user_cappadocia_guide',
        ownerName: 'Elif Göreme',
        ownerPhotoUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150',
        title: 'Kapadokya Kaya Freskleri',
        description: 'Göreme vadisinde saklı kaya kiliselerindeki erken Hristiyanlık freskleri ve taş kabartmalar.',
        coverUrl: 'https://images.unsplash.com/photo-1609137144822-03911c4728f3?w=800',
        location: 'Göreme, Nevşehir',
        status: MuseumStatus.published,
        sceneVersion: 1,
        likeCount: 88,
        commentCount: 22,
        likeCount30d: 60,
        commentCount30d: 20, // Score: 60 + (2*20) = 100
        createdAt: now.subtract(const Duration(days: 25)),
        publishedAt: now.subtract(const Duration(days: 12)),
        updatedAt: now.subtract(const Duration(days: 3)),
        isSavedByCurrentUser: false,
      ),
      MuseumModel(
        id: 'museum_004',
        ownerId: 'user_anatolian_textile',
        ownerName: 'Deniz Yörük',
        ownerPhotoUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150',
        title: 'Anadolu Dokuma Motifleri',
        description: 'Kök boya ile dokunmuş Yörük kilimlerindeki simgelerin dili: Eli belinde, koçboynuzu ve bereket sandığı.',
        coverUrl: 'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?w=800',
        location: 'Konya',
        status: MuseumStatus.published,
        sceneVersion: 1,
        likeCount: 31,
        commentCount: 5,
        likeCount30d: 19,
        commentCount30d: 4, // Score: 19 + (2*4) = 27
        createdAt: now.subtract(const Duration(days: 10)),
        publishedAt: now.subtract(const Duration(days: 8)),
        updatedAt: now.subtract(const Duration(days: 1)),
        isSavedByCurrentUser: false,
      ),
    ];

    // Yorumlar başlangıç verisi
    _comments.addAll([
      MuseumCommentModel(
        id: 'comm_01',
        museumId: 'museum_001',
        authorId: 'user_ceramic_master',
        authorName: 'Murat İznikli',
        text: 'Eski Pera fotoğraflarının detayları muazzam işlenmiş.',
        createdAt: now.subtract(const Duration(days: 2)),
      ),
      MuseumCommentModel(
        id: 'comm_02',
        museumId: 'museum_001',
        authorId: 'user_cappadocia_guide',
        authorName: 'Elif Göreme',
        text: 'Sesli anlatımla birlikte müzenin atmosferi çok sakin ve etkileyici.',
        createdAt: now.subtract(const Duration(days: 1)),
      ),
    ]);

    // 2D Sahneler: V1 Klasik Galeri (4 Eser Yuvası)
    _scenes = {
      'museum_001': _buildGalleryScene(
        museumId: 'museum_001',
        roomName: 'Pera Ana Salonu',
        items: [
          MuseumItemModel(
            id: 'item_101',
            museumId: 'museum_001',
            roomId: 'room_pera_01',
            slotId: 'slot_1',
            title: '1924 Galata Köprüsü Gravürü',
            description: 'Boğaz vapur iskelesi ve köprü üzerindeki yayaların taş baskı gravürü. Pera Müzesi arşivinden esinlenilmiştir.',
            imageUrls: [
              'https://images.unsplash.com/photo-1524231757912-21f4fe3a7200?w=600',
            ],
            audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3', // Simüle sesli rehber
            positionX: 0.20,
            positionY: 0.45,
            sortOrder: 1,
            createdAt: now.subtract(const Duration(days: 20)),
            updatedAt: now.subtract(const Duration(days: 15)),
          ),
          MuseumItemModel(
            id: 'item_102',
            museumId: 'museum_001',
            roomId: 'room_pera_01',
            slotId: 'slot_2',
            title: 'Şirket-i Hayriye Vapur Jetonu',
            description:
                '1910 yılında Boğaziçi hattında kullanılan bronz yolcu jetonu.',
            imageUrls: [
              'https://images.unsplash.com/photo-1588345921523-c2dcdb7f1dcd?w=600',
            ],
            audioUrl: null,
            positionX: 0.40,
            positionY: 0.45,
            sortOrder: 2,
            createdAt: now.subtract(const Duration(days: 20)),
            updatedAt: now.subtract(const Duration(days: 15)),
          ),
          MuseumItemModel(
            id: 'item_103',
            museumId: 'museum_001',
            roomId: 'room_pera_01',
            slotId: 'slot_3',
            title: 'Eski Galata Kulesi Fotoğrafı (1890)',
            description: 'Ahşap çatılı eski restorasyon dönemine ait özgün siyah-beyaz albumin baskı.',
            imageUrls: [
              'https://images.unsplash.com/photo-1541432901042-2d8bd64b4a9b?w=600',
            ],
            audioUrl:
                'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
            positionX: 0.60,
            positionY: 0.45,
            sortOrder: 3,
            createdAt: now.subtract(const Duration(days: 20)),
            updatedAt: now.subtract(const Duration(days: 15)),
          ),
          MuseumItemModel(
            id: 'item_104',
            museumId: 'museum_001',
            roomId: 'room_pera_01',
            slotId: 'slot_4',
            title: 'İstiklal Caddesi Tramvay Bileti',
            description: 'Osmanlıca ve Fransızca çift dilli basılmış ilk elektrikli tramvay bileti koçanı.',
            imageUrls: [
              'https://images.unsplash.com/photo-1568605117036-5fe5e7bab0b7?w=600',
            ],
            audioUrl: null,
            positionX: 0.80,
            positionY: 0.45,
            sortOrder: 4,
            createdAt: now.subtract(const Duration(days: 20)),
            updatedAt: now.subtract(const Duration(days: 15)),
          ),
        ],
      ),
      'museum_002': _buildGalleryScene(
        museumId: 'museum_002',
        roomName: 'İznik Çini Salonu',
        items: [
          MuseumItemModel(
            id: 'item_201',
            museumId: 'museum_002',
            roomId: 'room_cini_01',
            slotId: 'slot_1',
            title: 'Kobalt Mavi Lale Çinisi',
            description:
                '16. yüzyıl saray atölyesi üretimi sır altı boyama çini karo.',
            imageUrls: [
              'https://images.unsplash.com/photo-1579783900882-c0d3dad7b119?w=600',
            ],
            audioUrl:
                'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3',
            positionX: 0.20,
            positionY: 0.45,
            sortOrder: 1,
            createdAt: now.subtract(const Duration(days: 15)),
            updatedAt: now.subtract(const Duration(days: 10)),
          ),
          MuseumItemModel(
            id: 'item_202',
            museumId: 'museum_002',
            roomId: 'room_cini_01',
            slotId: 'slot_2',
            title: 'Sülüs Hat Levhası',
            description: 'Hafız Osman ekolünde kamış kalem ve is mürekkebiyle yazılmış ayet levhası.',
            imageUrls: [
              'https://images.unsplash.com/photo-1582561424760-0321d75e81fa?w=600',
            ],
            audioUrl: null,
            positionX: 0.40,
            positionY: 0.45,
            sortOrder: 2,
            createdAt: now.subtract(const Duration(days: 15)),
            updatedAt: now.subtract(const Duration(days: 10)),
          ),
          MuseumItemModel(
            id: 'item_203',
            museumId: 'museum_002',
            roomId: 'room_cini_01',
            slotId: 'slot_3',
            title: 'Kündekari Sedef Kakma Sandık Kapağı',
            description: 'Geometrik ahşap geçme tekniği ile çivisiz inşa edilmiş ceviz çekmece paneli.',
            imageUrls: [
              'https://images.unsplash.com/photo-1513519245088-0e12902e5a38?w=600',
            ],
            audioUrl: null,
            positionX: 0.60,
            positionY: 0.45,
            sortOrder: 3,
            createdAt: now.subtract(const Duration(days: 15)),
            updatedAt: now.subtract(const Duration(days: 10)),
          ),
          MuseumItemModel(
            id: 'item_204',
            museumId: 'museum_002',
            roomId: 'room_cini_01',
            slotId: 'slot_4',
            title: 'Altın Tezhipli Şemse Deseni',
            description: 'Eski yazma eser cildi üzerinde 24 ayar ezme altınla işlenmiş klasik şemse motifi.',
            imageUrls: [
              'https://images.unsplash.com/photo-1549490349-8643362247b5?w=600',
            ],
            audioUrl:
                'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3',
            positionX: 0.80,
            positionY: 0.45,
            sortOrder: 4,
            createdAt: now.subtract(const Duration(days: 15)),
            updatedAt: now.subtract(const Duration(days: 10)),
          ),
        ],
      ),
    };
  }

  MuseumSceneModel _buildGalleryScene({
    required String museumId,
    required String roomName,
    required List<MuseumItemModel> items,
  }) {
    return MuseumSceneModel(
      museumId: museumId,
      schemaVersion: 1,
      rooms: [
        MuseumRoomModel(
          id: 'room_${museumId}_01',
          museumId: museumId,
          name: roomName,
          templateId: RoomTemplateModel.classicGalleryId,
          sortOrder: 1,
          items: items,
        ),
      ],
    );
  }

  @override
  Future<List<MuseumModel>> getExploreFeed({String? currentUserId}) async {
    await Future.delayed(const Duration(milliseconds: 250));

    // Yalnızca published müzeler
    final publishedMuseums = _museums
        .where((m) => m.status == MuseumStatus.published)
        .toList();

    // Takip edilenler var mı kontrolü
    final followedUserIds = currentUserId != null
        ? (_followingMap[currentUserId] ?? <String>{})
        : <String>{};

    final List<MuseumModel> feed = [];
    final Set<String> addedIds = {};

    if (followedUserIds.isNotEmpty) {
      // 1. Takip edilenlerin müzeleri: en yeniden eskiye
      final followedMuseums =
          publishedMuseums
              .where((m) => followedUserIds.contains(m.ownerId))
              .toList()
            ..sort((a, b) {
              final aDate = a.publishedAt ?? a.createdAt;
              final bDate = b.publishedAt ?? b.createdAt;
              return bDate.compareTo(aDate);
            });

      for (final m in followedMuseums) {
        if (!addedIds.contains(m.id)) {
          feed.add(_enrichMuseum(m));
          addedIds.add(m.id);
        }
      }
    }

    // 2. Ardından popüler müzeler başlar
    // Kesin algoritma: score = likeCount30d + (2 * commentCount30d)
    // Eşitlikte en yeni yayınlanan önce gelir.
    final popularMuseums = publishedMuseums.toList()
      ..sort((a, b) {
        final scoreA = a.popularityScore;
        final scoreB = b.popularityScore;
        if (scoreB != scoreA) {
          return scoreB.compareTo(scoreA);
        }
        final aDate = a.publishedAt ?? a.createdAt;
        final bDate = b.publishedAt ?? b.createdAt;
        return bDate.compareTo(aDate);
      });

    // 3. Tekrarlar elenerek popülerler eklenir
    for (final m in popularMuseums) {
      if (!addedIds.contains(m.id)) {
        feed.add(_enrichMuseum(m));
        addedIds.add(m.id);
      }
    }

    return feed;
  }

  MuseumModel _enrichMuseum(MuseumModel m) {
    return m.copyWith(
      isSavedByCurrentUser: _savedMuseumIds.contains(m.id),
      isLikedByCurrentUser: _likedMuseumIds.contains(m.id),
    );
  }

  @override
  Future<MuseumModel?> getMuseumById(
    String museumId, {
    String? currentUserId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 150));
    try {
      final museum = _museums.firstWhere((m) => m.id == museumId);
      return _enrichMuseum(museum);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<MuseumSceneModel?> getMuseumScene(String museumId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    if (_scenes.containsKey(museumId)) {
      return _scenes[museumId];
    }
    // Varsayılan Klasik Galeri sahnesi oluştur
    final now = DateTime.now();
    return _buildGalleryScene(
      museumId: museumId,
      roomName: 'Ana Galeri Salonu',
      items: [
        MuseumItemModel(
          id: 'item_${museumId}_1',
          museumId: museumId,
          roomId: 'room_default',
          slotId: 'slot_1',
          title: 'Sergi Parçası I',
          description: 'Koleksiyonun ilk seçkin eseri.',
          imageUrls: [
            'https://images.unsplash.com/photo-1579783900882-c0d3dad7b119?w=600',
          ],
          positionX: 0.20,
          positionY: 0.45,
          sortOrder: 1,
          createdAt: now,
          updatedAt: now,
        ),
      ],
    );
  }

  @override
  Future<bool> toggleSaveMuseum({
    required String museumId,
    required String userId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 150));
    final isSaved = _savedMuseumIds.contains(museumId);
    if (isSaved) {
      _savedMuseumIds.remove(museumId);
      return false;
    } else {
      _savedMuseumIds.add(museumId);
      return true;
    }
  }

  @override
  Future<bool> toggleLikeMuseum({
    required String museumId,
    required String userId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 150));
    final index = _museums.indexWhere((m) => m.id == museumId);
    if (index == -1) return false;

    final isLiked = _likedMuseumIds.contains(museumId);
    final museum = _museums[index];

    if (isLiked) {
      _likedMuseumIds.remove(museumId);
      _museums[index] = museum.copyWith(
        likeCount: (museum.likeCount - 1).clamp(0, 999999),
        likeCount30d: (museum.likeCount30d - 1).clamp(0, 999999),
      );
      return false;
    } else {
      _likedMuseumIds.add(museumId);
      _museums[index] = museum.copyWith(
        likeCount: museum.likeCount + 1,
        likeCount30d: museum.likeCount30d + 1,
      );
      return true;
    }
  }

  @override
  Future<MuseumCommentModel> addComment({
    required String museumId,
    required String userId,
    required String userName,
    String? userPhotoUrl,
    required String text,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final trimmed = text.trim();
    if (trimmed.isEmpty) {
      throw Exception('Yorum boş olamaz.');
    }

    final newComment = MuseumCommentModel(
      id: 'comm_${DateTime.now().millisecondsSinceEpoch}',
      museumId: museumId,
      authorId: userId,
      authorName: userName,
      authorPhotoUrl: userPhotoUrl,
      text: trimmed,
      createdAt: DateTime.now(),
    );

    _comments.insert(0, newComment);

    final index = _museums.indexWhere((m) => m.id == museumId);
    if (index != -1) {
      final museum = _museums[index];
      _museums[index] = museum.copyWith(
        commentCount: museum.commentCount + 1,
        commentCount30d: museum.commentCount30d + 1,
      );
    }

    return newComment;
  }

  @override
  Future<List<MuseumCommentModel>> getComments(String museumId) async {
    await Future.delayed(const Duration(milliseconds: 150));
    return _comments.where((c) => c.museumId == museumId).toList();
  }

  @override
  Future<List<MuseumModel>> getSavedMuseums(String userId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _museums
        .where((m) => _savedMuseumIds.contains(m.id))
        .map(_enrichMuseum)
        .toList();
  }

  @override
  Future<List<MuseumModel>> getUserMuseums(String userId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _museums
        .where((m) => m.ownerId == userId)
        .map(_enrichMuseum)
        .toList();
  }
}
