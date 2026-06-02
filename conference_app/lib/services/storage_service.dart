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

  Future<void> clearAccountData() async {
    await _prefs.remove('auth_token');
    await _prefs.remove('saved_email');
    await _prefs.remove('remember_me');
    await _prefs.remove('subscribed_events');
    await _prefs.remove('saved_sessions');
    await _prefs.remove('hydrated_schedule_events');
    await _prefs.remove('push_enabled');
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

  Future<void> setSubscribedEventIds(List<String> eventIds) async {
    await _prefs.setString('subscribed_events', jsonEncode(eventIds));
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

  Future<void> setSavedSessionIds(List<String> sessionIds) async {
    await _prefs.setString('saved_sessions', jsonEncode(sessionIds));
  }

  // Schedule hydration state for joined events
  List<String> get hydratedScheduleEventIds {
    final raw = _prefs.getString('hydrated_schedule_events');
    if (raw == null) return [];
    return List<String>.from(jsonDecode(raw));
  }

  Future<void> markScheduleEventHydrated(String eventId) async {
    final ids = hydratedScheduleEventIds;
    if (!ids.contains(eventId)) {
      ids.add(eventId);
      await _prefs.setString('hydrated_schedule_events', jsonEncode(ids));
    }
  }

  Future<void> unmarkScheduleEventHydrated(String eventId) async {
    final ids = hydratedScheduleEventIds;
    ids.remove(eventId);
    await _prefs.setString('hydrated_schedule_events', jsonEncode(ids));
  }

  // Language
  String get languageCode => _prefs.getString('language') ?? 'en';

  Future<void> saveLanguage(String code) async {
    await _prefs.setString('language', code);
  }

  // Push notifications
  bool get pushEnabled => _prefs.getBool('push_enabled') ?? true;

  Future<void> setPushEnabled(bool enabled) async {
    await _prefs.setBool('push_enabled', enabled);
  }

  // APSCVIR synced content cache
  String? get apscvirManifestCache =>
      _prefs.getString('apscvir_content_manifest');

  Future<void> saveApscvirManifestCache(String raw) async {
    await _prefs.setString('apscvir_content_manifest', raw);
  }

  String? apscvirHtmlCache(String assetPath) =>
      _prefs.getString('apscvir_content_html::$assetPath');

  Future<void> saveApscvirHtmlCache(String assetPath, String raw) async {
    await _prefs.setString('apscvir_content_html::$assetPath', raw);
  }
}
