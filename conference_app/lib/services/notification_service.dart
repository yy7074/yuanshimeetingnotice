import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
import 'package:jpush_flutter/jpush_interface.dart';
import 'package:get/get.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;
import 'api_service.dart';
import 'storage_service.dart';
import '../controllers/event_controller.dart';

class NotificationService extends GetxService {
  // Configure via: flutter run --dart-define=JPUSH_APP_KEY=xxxxx --dart-define=JPUSH_CHANNEL=developer-default
  // (keep parity with android/app/build.gradle.kts manifest placeholders)
  static const String _jpushAppKey = String.fromEnvironment(
    'JPUSH_APP_KEY',
    defaultValue: '02e01a729d7313df5fc5150c',
  );
  static const String _jpushChannel = String.fromEnvironment(
    'JPUSH_CHANNEL',
    defaultValue: 'developer-default',
  );

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  JPushFlutterInterface? _jpush;
  String? _lastRegistrationId;
  final unreadCount = 0.obs;

  Future<NotificationService> init() async {
    try {
      tz_data.initializeTimeZones();

      // Initialize local notifications
      const androidSettings = AndroidInitializationSettings(
        '@mipmap/ic_launcher',
      );
      const iosSettings = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      await _localNotifications.initialize(
        settings: const InitializationSettings(
          android: androidSettings,
          iOS: iosSettings,
        ),
        onDidReceiveNotificationResponse: _onLocalNotificationTap,
      );

      final androidPlugin = _localNotifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      await androidPlugin?.createNotificationChannel(
        const AndroidNotificationChannel(
          'conference_notifications',
          'Conference Notifications',
          description: 'Notifications for conference events',
          importance: Importance.high,
        ),
      );
      await androidPlugin?.requestNotificationsPermission();
    } catch (e) {
      debugPrint('Local notifications init failed: $e');
    }

    // Initialize JPush only when an AppKey is provided at build time.
    if (_jpushAppKey.isEmpty) {
      debugPrint(
        'JPush disabled: JPUSH_APP_KEY not set (pass via --dart-define).',
      );
    } else {
      try {
        _jpush = JPush.newJPush();
        await _initJPush();
      } catch (e) {
        debugPrint('JPush init failed: $e');
      }
    }

    await refreshUnreadCount();

    return this;
  }

  Future<void> _initJPush() async {
    final jpush = _jpush;
    if (jpush == null) return;
    try {
      jpush.addEventHandler(
        onReceiveNotification: (Map<String, dynamic> message) async {
          debugPrint('JPush received: $message');
          refreshUnreadCount();
        },
        onOpenNotification: (Map<String, dynamic> message) async {
          debugPrint('JPush opened: $message');
          _handleNotificationTap(message);
        },
        onReceiveMessage: (Map<String, dynamic> message) async {
          final title = message['title'] ?? '';
          final body = message['alert'] ?? message['message'] ?? '';
          if (title.isNotEmpty || body.isNotEmpty) {
            showLocalNotification(title: title, body: body);
          }
          refreshUnreadCount();
        },
      );

      jpush.setup(
        appKey: _jpushAppKey,
        channel: _jpushChannel,
        production: !kDebugMode,
        debug: kDebugMode,
      );

      // Use timeout to prevent hanging when AppKey is invalid
      try {
        final rid = await jpush.getRegistrationID().timeout(
          const Duration(seconds: 5),
        );
        if (rid.isNotEmpty) {
          _lastRegistrationId = rid;
          debugPrint('JPush Registration ID: $rid');
          _registerPushToken(rid);
        }
      } catch (_) {
        debugPrint('JPush getRegistrationID timed out');
      }

      if (Platform.isIOS) {
        jpush.applyPushAuthority();
      }
    } catch (e) {
      debugPrint('JPush init skipped: $e');
    }
  }

  Future<void> _registerPushToken(String token) async {
    try {
      final api = Get.find<ApiService>();
      await api.registerPushToken(token);
    } catch (_) {}
  }

  Future<void> registerCurrentPushToken() async {
    final token = _lastRegistrationId;
    if (token == null || token.isEmpty) return;
    await _registerPushToken(token);
  }

  Future<void> openNotification(Map<String, dynamic> notification) async {
    final type = notification['type'] as String? ?? '';
    final eventId = notification['eventId'] as String? ?? '';
    final targetUrl = notification['targetUrl'] as String? ?? '';
    await _navigateByNotification(
      type: type,
      eventId: eventId,
      targetUrl: targetUrl,
    );
  }

  Future<void> _handleNotificationTap(Map<String, dynamic> message) async {
    final extras = _toStringKeyMap(message['extras']);
    final nestedExtras = _toStringKeyMap(extras['cn.jpush.android.EXTRA']);
    final payload = <String, dynamic>{...extras, ...nestedExtras};
    final type = _firstNonEmpty(
      _stringValue(payload, 'type'),
      _stringValue(message, 'type'),
    );
    final eventId = _firstNonEmpty(
      _stringValue(payload, 'eventId'),
      _stringValue(message, 'eventId'),
    );
    final targetUrl = _firstNonEmpty(
      _stringValue(payload, 'targetUrl'),
      _stringValue(message, 'targetUrl'),
    );
    await _navigateByNotification(
      type: type,
      eventId: eventId,
      targetUrl: targetUrl,
    );
  }

  Map<String, dynamic> _toStringKeyMap(dynamic value) {
    if (value is! Map) return {};
    return value.map((key, value) => MapEntry(key.toString(), value));
  }

  String _stringValue(Map<String, dynamic> data, String key) {
    final value = data[key];
    return value == null ? '' : value.toString();
  }

  String _firstNonEmpty(String primary, String fallback) =>
      primary.isNotEmpty ? primary : fallback;

  Future<void> _navigateToEvent(String eventId, {int initialTab = 0}) async {
    try {
      final eventCtrl = Get.find<EventController>();
      if (!eventCtrl.allEvents.any((event) => event.id == eventId)) {
        await eventCtrl.loadEvents();
      }
      await eventCtrl.selectEvent(eventId);
      await Get.toNamed(
        '/event_agenda',
        arguments: {'eventId': eventId, 'initialTab': initialTab},
      );
    } catch (_) {
      await Get.toNamed('/notifications');
    }
  }

  Future<void> _onLocalNotificationTap(NotificationResponse response) async {
    if (response.payload != null) {
      try {
        final data = jsonDecode(response.payload!);
        final type = data['type'] as String? ?? '';
        final eventId = data['eventId'] as String? ?? '';
        final targetUrl = data['targetUrl'] as String? ?? '';
        await _navigateByNotification(
          type: type,
          eventId: eventId,
          targetUrl: targetUrl,
        );
      } catch (_) {
        await Get.toNamed('/notifications');
      }
    }
  }

  Future<void> _navigateByNotification({
    required String type,
    required String eventId,
    String targetUrl = '',
  }) async {
    if (targetUrl.isNotEmpty &&
        Get.routeTree.matchRoute(targetUrl).route != null) {
      await Get.toNamed(targetUrl);
      return;
    }

    switch (type) {
      case 'schedule_reminder':
      case 'daily_reminder':
        await Get.toNamed('/my_schedule');
        break;
      case 'event_update':
        if (eventId.isNotEmpty) {
          await _navigateToEvent(eventId, initialTab: 0);
        } else {
          await Get.toNamed('/event_portal');
        }
        break;
      case 'material_update':
        if (eventId.isNotEmpty) {
          await _navigateToEvent(eventId, initialTab: 3);
        } else {
          await Get.toNamed('/notifications');
        }
        break;
      case 'check_in_success':
        await Get.toNamed('/digital_check_in');
        break;
      default:
        await Get.toNamed('/notifications');
    }
  }

  // JPush tag management (for event-based push targeting)
  Future<void> addEventTag(String eventId) async {
    try {
      await _jpush?.addTags(['event_$eventId']);
    } catch (_) {}
  }

  Future<void> removeEventTag(String eventId) async {
    try {
      await _jpush?.deleteTags(['event_$eventId']);
    } catch (_) {}
  }

  Future<void> setAlias(String userId) async {
    try {
      await _jpush?.setAlias(userId);
    } catch (_) {}
  }

  // === Local Notifications ===

  Future<void> showLocalNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    await _localNotifications.show(
      id: DateTime.now().millisecondsSinceEpoch % 100000,
      title: title,
      body: body,
      payload: payload,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'conference_notifications',
          'Conference Notifications',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
    );
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    String? payload,
  }) async {
    final tzTime = tz.TZDateTime.from(scheduledTime, tz.local);
    if (tzTime.isBefore(tz.TZDateTime.now(tz.local))) return;

    await _localNotifications.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: tzTime,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'schedule_reminders',
          'Schedule Reminders',
          importance: Importance.max,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      payload: payload,
    );
  }

  /// Local reminder 15 minutes before a session starts.
  Future<void> scheduleSessionReminder({
    required String sessionId,
    required String titleEn,
    required String titleZh,
    required String roomEn,
    required String roomZh,
    required DateTime startTime,
  }) async {
    final isZh = Get.locale?.languageCode == '__zh_disabled__';
    await scheduleNotification(
      id: sessionId.hashCode.abs() % 100000,
      title: isZh ? 'Session Starting Soon' : 'Session Starting Soon',
      body: isZh
          ? '"$titleEn" starts in 15 minutes at $roomEn'
          : '"$titleEn" starts in 15 minutes at $roomEn',
      scheduledTime: startTime.subtract(const Duration(minutes: 15)),
      payload: jsonEncode({
        'type': 'schedule_reminder',
        'sessionId': sessionId,
      }),
    );
  }

  /// Daily schedule summary reminder at 9:00.
  Future<void> scheduleDailyReminder(DateTime date, int sessionCount) async {
    final isZh = Get.locale?.languageCode == '__zh_disabled__';
    await scheduleNotification(
      id: date.hashCode.abs() % 100000 + 90000,
      title: isZh ? 'Today\'s Schedule' : "Today's Schedule",
      body: isZh
          ? 'You have $sessionCount sessions today.'
          : 'You have $sessionCount sessions today.',
      scheduledTime: DateTime(date.year, date.month, date.day, 9, 0),
      payload: jsonEncode({'type': 'daily_reminder'}),
    );
  }

  Future<void> cancelNotification(int id) async =>
      _localNotifications.cancel(id: id);
  Future<void> cancelAllNotifications() async =>
      _localNotifications.cancelAll();

  // === Server sync ===

  Future<void> refreshUnreadCount() async {
    try {
      final api = Get.find<ApiService>();
      final res = await api.getUnreadNotificationCount();
      if (res.statusCode == 200) {
        unreadCount.value = res.body['unreadCount'] ?? 0;
      }
    } catch (_) {}
  }

  Future<void> updatePushSettings(bool enabled) async {
    final storage = Get.find<StorageService>();
    await storage.setPushEnabled(enabled);
    try {
      final api = Get.find<ApiService>();
      await api.updatePushSettings(enabled);
    } catch (_) {}
  }
}
