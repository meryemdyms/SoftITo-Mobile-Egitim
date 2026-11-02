import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Ritmo Yerel Veri Saklama Servisi.
///
/// [SharedPreferences] üzerine inşa edilmiş, JSON nesneleri ve listeleri
/// güvenli bir şekilde serileştiren ve yerel diskte kalıcı tutan servis sınıfıdır.
/// Singleton desenini uygular ve birim testler için sahte (mock) tercihler atanmasını destekler.
class StorageService {
  static StorageService? _instance;
  static SharedPreferences? _prefs;

  // Singleton yapıcı
  StorageService._();

  /// Servisin tekil örneğini (singleton) asenkron olarak döner.
  /// İlk çağrıda [SharedPreferences.getInstance] çalıştırılır.
  static Future<StorageService> getInstance() async {
    if (_instance == null) {
      _instance = StorageService._();
      _prefs = await SharedPreferences.getInstance();
    }
    return _instance!;
  }

  /// Birim testlerde gerçek disk erişimi yerine sahte (mock) hafıza
  /// kullanılabilmesi için SharedPreferences örneğini dışarıdan enjekte eder.
  static void setMockPreferences(SharedPreferences prefs) {
    _instance = StorageService._();
    _prefs = prefs;
  }

  // ==========================================
  // TEMEL DİZE VE MANTIKSAL DEĞER İŞLEMLERİ
  // ==========================================

  /// Belirtilen anahtara ([key]) ait metin değerini döner. Bulunamazsa null döner.
  String? getString(String key) => _prefs?.getString(key);

  /// Belirtilen anahtara metin ([value]) değerini kaydeder.
  Future<bool> setString(String key, String value) async {
    return (await _prefs?.setString(key, value)) ?? false;
  }

  /// Belirtilen anahtara ait mantıksal (boolean) değeri döner.
  bool? getBool(String key) => _prefs?.getBool(key);

  /// Belirtilen anahtara mantıksal (boolean) değer kaydeder.
  Future<bool> setBool(String key, bool value) async {
    return (await _prefs?.setBool(key, value)) ?? false;
  }

  // ==========================================
  // JSON HARİTA VE LİSTE İŞLEMLERİ
  // ==========================================

  /// Belirtilen anahtardaki JSON dizesini ayrıştırarak [Map<String, dynamic>] olarak döner.
  /// Veri yoksa veya JSON formatı bozuksa null döner (hata fırlatmaz).
  Map<String, dynamic>? getJson(String key) {
    final raw = getString(key);
    if (raw == null || raw.isEmpty) return null;
    try {
      return jsonDecode(raw) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  /// Bir harita (Map) nesnesini JSON dizesine dönüştürerek diske kaydeder.
  Future<bool> setJson(String key, Map<String, dynamic> data) async {
    return setString(key, jsonEncode(data));
  }

  /// Belirtilen anahtardaki JSON dizesini ayrıştırarak [List<Map<String, dynamic>>] döner.
  /// Alışkanlıklar, yapboz parçaları ve günlük kayıtlar gibi liste verilerinde kullanılır.
  List<Map<String, dynamic>>? getJsonList(String key) {
    final raw = getString(key);
    if (raw == null || raw.isEmpty) return null;
    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    } catch (_) {
      return null;
    }
  }

  /// JSON haritalarından oluşan bir listeyi metin formatında serileştirip kaydeder.
  Future<bool> setJsonList(String key, List<Map<String, dynamic>> list) async {
    return setString(key, jsonEncode(list));
  }

  // ==========================================
  // SİLME VE TEMİZLEME İŞLEMLERİ
  // ==========================================

  /// Belirtilen anahtarı ve karşılık gelen veriyi yerel depodan siler.
  Future<bool> remove(String key) async {
    return (await _prefs?.remove(key)) ?? false;
  }

  /// Depodaki tüm anahtar ve değerleri tamamen sıfırlar.
  Future<bool> clear() async {
    return (await _prefs?.clear()) ?? false;
  }
}
