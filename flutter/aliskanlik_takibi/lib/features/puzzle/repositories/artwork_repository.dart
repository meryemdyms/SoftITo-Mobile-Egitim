import 'dart:math';
import '../models/puzzle_models.dart';

/// Ritmo Gizli Sanat Eserleri Kataloğu ve Havuzu (Artwork Repository).
///
/// `project.md` 7.1. (Yapboz Oluşturma) ve 10. (Koleksiyon Serileri) bölümlerine göre:
/// - Huzur Serisi, Düşler Serisi, Doğa Serisi, Sanat Serisi, Şehir Serisi kategorilerinde
///   küratörlü sanat eserleri barındırır.
/// - Her yeni alışkanlık süreci başladığında bu havuzdan rastgele bir gizli eser atanır.
class ArtworkRepository {
  /// Sistemde kayıtlı küratörlü sanat eserleri koleksiyonu
  static const List<ArtworkModel> _curatedArtworks = [
    ArtworkModel(
      id: 'art_forest',
      title: 'Ormanın Şarkısı',
      series: 'Huzur Serisi',
      description: 'Zümrüt yaprakların arasından süzülen dingin ışık huzmeleri ve doğanın melodisi.',
      themeKey: 'forest',
    ),
    ArtworkModel(
      id: 'art_starry',
      title: 'Yıldızlı Düşler',
      series: 'Düşler Serisi',
      description: 'Gecenin sessizliğinde parıldayan takımyıldızları ve sınırsız ufuklar.',
      themeKey: 'starry',
    ),
    ArtworkModel(
      id: 'art_sunrise',
      title: 'Gündoğumu Tepesi',
      series: 'Doğa Serisi',
      description: 'Kızıl dağların ardında yükselen taze güneş ve yepyeni umutlar.',
      themeKey: 'sunrise',
    ),
    ArtworkModel(
      id: 'art_lake',
      title: 'Sessiz Göl Kıyısı',
      series: 'Huzur Serisi',
      description: 'Rüzgarsız suyun aynasında dinlenen dağlar ve içsel sükunet.',
      themeKey: 'lake',
    ),
    ArtworkModel(
      id: 'art_antique',
      title: 'Sarmaşıklı Avlu',
      series: 'Sanat Serisi',
      description: 'Taş kemerler arasından akan serin çeşme ve kadim bir huzur bahçesi.',
      themeKey: 'antique',
    ),
    ArtworkModel(
      id: 'art_lighthouse',
      title: 'Işık Kulesi',
      series: 'Şehir Serisi',
      description: 'Fırtınalı denizlerde doğru istikameti gösteren sarsılmaz bir deniz feneri.',
      themeKey: 'lighthouse',
    ),
  ];

  /// Tüm küratörlü eserlerin listesini döner.
  List<ArtworkModel> getAll() => List.unmodifiable(_curatedArtworks);

  /// Kimliğe ([id]) göre eseri bulur. Bulunamazsa varsayılan olarak ilk eseri döner.
  ArtworkModel getById(String id) {
    return _curatedArtworks.firstWhere(
      (a) => a.id == id,
      orElse: () => _curatedArtworks.first,
    );
  }

  /// Yeni bir alışkanlık süreci oluşturulurken rastgele bir gizli eser seçer.
  /// İsteğe bağlı olarak belirli bir eseri ([excludeId]) hariç tutabilir.
  ArtworkModel getRandomArtwork({String? excludeId}) {
    final pool = excludeId != null
        ? _curatedArtworks.where((a) => a.id != excludeId).toList()
        : _curatedArtworks;
    final rand = Random();
    return pool[rand.nextInt(pool.length)];
  }
}
