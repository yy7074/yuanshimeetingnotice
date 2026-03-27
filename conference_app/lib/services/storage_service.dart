import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService extends GetxService {
  late SharedPreferences _prefs;

  Future<StorageService> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  // Auth
  String? get savedEmail => _prefs.getString('saved_email');
  bool get rememberMe => _prefs.getBool('remember_me') ?? false;
  String? get authToken => _prefs.getString('auth_token');

  Future<void> saveLoginInfo(String email, bool remember) async {
    await _prefs.setString('saved_email', email);
    await _prefs.setBool('remember_me', remember);
  }

  Future<void> saveAuthToken(String token) async {
    await _prefs.setString('auth_token', token);
  }

  Future<void> clearAuth() async {
    await _prefs.remove('auth_token');
  }

  // Subscribed Events
  List<String> get subscribedEventIds {
    final raw = _prefs.getString('subscribed_events');
    if (raw == null) return [];
    return List<String>.from(jsonDecode(raw));
  }

  Future<void> subscribeEvent(String eventId) async {
    final ids = subscribedEventIds;
    if (!ids.contains(eventId)) {
      ids.add(eventId);
      await _prefs.setString('subscribed_events', jsonEncode(ids));
    }
  }

  Future<void> unsubscribeEvent(String eventId) async {
    final ids = subscribedEventIds;
    ids.remove(eventId);
    await _prefs.setString('subscribed_events', jsonEncode(ids));
  }

  // My Schedule (saved session IDs)
  List<String> get savedSessionIds {
    final raw = _prefs.getString('saved_sessions');
    if (raw == null) return [];
    return List<String>.from(jsonDecode(raw));
  }

  Future<void> saveSession(String sessionId) async {
    final ids = savedSessionIds;
    if (!ids.contains(sessionId)) {
      ids.add(sessionId);
      await _prefs.setString('saved_sessions', jsonEncode(ids));
    }
  }

  Future<void> removeSession(String sessionId) async {
    final ids = savedSessionIds;
    ids.remove(sessionId);
    await _prefs.setString('saved_sessions', jsonEncode(ids));
  }

  // Language
  String get languageCode => _prefs.getString('language') ?? 'zh';

  Future<void> saveLanguage(String code) async {
    await _prefs.setString('language', code);
  }

  // Push notifications
  bool get pushEnabled => _prefs.getBool('push_enabled') ?? true;

  Future<void> setPushEnabled(bool enabled) async {
    await _prefs.setBool('push_enabled', enabled);
  }
}
