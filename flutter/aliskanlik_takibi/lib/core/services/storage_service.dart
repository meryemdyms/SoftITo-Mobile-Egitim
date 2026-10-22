import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Ritmo Yerel Veri Saklama Servisi
class StorageService {
  static StorageService? _instance;
  static SharedPreferences? _prefs;

  StorageService._();

  static Future<StorageService> getInstance() async {
    if (_instance == null) {
      _instance = StorageService._();
      _prefs = await SharedPreferences.getInstance();
    }
    return _instance!;
  }

  /// Test veya mock için prefs enjekte etme
  static void setMockPreferences(SharedPreferences prefs) {
    _instance = StorageService._();
    _prefs = prefs;
  }

  String? getString(String key) => _prefs?.getString(key);

  Future<bool> setString(String key, String value) async {
    return (await _prefs?.setString(key, value)) ?? false;
  }

  bool? getBool(String key) => _prefs?.getBool(key);

  Future<bool> setBool(String key, bool value) async {
    return (await _prefs?.setBool(key, value)) ?? false;
  }

  Map<String, dynamic>? getJson(String key) {
    final raw = getString(key);
    if (raw == null || raw.isEmpty) return null;
    try {
      return jsonDecode(raw) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  Future<bool> setJson(String key, Map<String, dynamic> data) async {
    return setString(key, jsonEncode(data));
  }

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

  Future<bool> setJsonList(String key, List<Map<String, dynamic>> list) async {
    return setString(key, jsonEncode(list));
  }

  Future<bool> remove(String key) async {
    return (await _prefs?.remove(key)) ?? false;
  }

  Future<bool> clear() async {
    return (await _prefs?.clear()) ?? false;
  }
}
