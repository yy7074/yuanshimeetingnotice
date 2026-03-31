import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
import 'package:jpush_flutter/jpush_interface.dart';
import 'package:get/get.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;
import 'api_service.dart';
import 'storage_service.dart';

class NotificationService extends GetxService {
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  JPushFlutterInterface? _jpush;
  final unreadCount = 0.obs;

  Future<NotificationService> init() async {
    try {
      tz_data.initializeTimeZones();

      // Initialize local notifications
      const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
      const iosSettings = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      await _localNotifications.initialize(
        settings: const InitializationSettings(android: androidSettings, iOS: iosSettings),
        onDidReceiveNotificationResponse: _onLocalNotificationTap,
      );

      final androidPlugin = _localNotifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      await androidPlugin?.createNotificationChannel(const AndroidNotificationChannel(
        'conference_notifications', 'Conference Notifications',
        description: 'Notifications for conference events',
        importance: Importance.high,
      ));
    } catch (e) {
      debugPrint('Local notifications init failed: $e');
    }

    // Initialize JPush (极光推送)
    try {
      _jpush = JPush.newJPush();
      await _initJPush();
    } catch (e) {
      debugPrint('JPush init failed: $e');
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
        appKey: 'YOUR_JPUSH_APP_KEY', // 替换为你的极光推送AppKey
        channel: 'developer-default',
        production: !kDebugMode,
        debug: kDebugMode,
      );

      // Use timeout to prevent hanging when AppKey is invalid
      try {
        final rid = await jpush.getRegistrationID().timeout(const Duration(seconds: 5));
        if (rid.isNotEmpty) {
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

  void _handleNotificationTap(Map<String, dynamic> message) {
    final extras = message['extras'] as Map<String, dynamic>? ?? {};
    final type = extras['type'] as String?;
    if (type == 'schedule_reminder') {
      Get.toNamed('/my_schedule');
    } else {
      Get.toNamed('/notifications');
    }
  }

  void _onLocalNotificationTap(NotificationResponse response) {
    if (response.payload != null) {
      try {
        final data = jsonDecode(response.payload!);
        if (data['type'] == 'schedule_reminder') {
          Get.toNamed('/my_schedule');
        } else {
          Get.toNamed('/notifications');
        }
      } catch (_) {
        Get.toNamed('/notifications');
      }
    }
  }

  // JPush tag management (for event-based push targeting)
  Future<void> addEventTag(String eventId) async {
    try { await _jpush?.addTags(['event_$eventId']); } catch (_) {}
  }

  Future<void> removeEventTag(String eventId) async {
    try { await _jpush?.deleteTags(['event_$eventId']); } catch (_) {}
  }

  Future<void> setAlias(String userId) async {
    try { await _jpush?.setAlias(userId); } catch (_) {}
  }

  // === Local Notifications ===

  Future<void> showLocalNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    await _localNotifications.show(
      id: DateTime.now().millisecondsSinceEpoch % 100000,
      title: title, body: body, payload: payload,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'conference_notifications', 'Conference Notifications',
          importance: Importance.high, priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(presentAlert: true, presentBadge: true, presentSound: true),
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
          'schedule_reminders', 'Schedule Reminders',
          importance: Importance.max, priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(presentAlert: true, presentBadge: true, presentSound: true),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      payload: payload,
    );
  }

  /// 议程开始前15分钟本地提醒
  Future<void> scheduleSessionReminder({
    required String sessionId,
    required String titleEn,
    required String titleZh,
    required String roomEn,
    required String roomZh,
    required DateTime startTime,
  }) async {
    final isZh = Get.locale?.languageCode == 'zh';
    await scheduleNotification(
      id: sessionId.hashCode.abs() % 100000,
      title: isZh ? '议程即将开始' : 'Session Starting Soon',
      body: isZh
          ? '"$titleZh" 将于15分钟后在 $roomZh 开始'
          : '"$titleEn" starts in 15 minutes at $roomEn',
      scheduledTime: startTime.subtract(const Duration(minutes: 15)),
      payload: jsonEncode({'type': 'schedule_reminder', 'sessionId': sessionId}),
    );
  }

  /// 每日9:00日程汇总提醒
  Future<void> scheduleDailyReminder(DateTime date, int sessionCount) async {
    final isZh = Get.locale?.languageCode == 'zh';
    await scheduleNotification(
      id: date.hashCode.abs() % 100000 + 90000,
      title: isZh ? '今日会议日程' : "Today's Schedule",
      body: isZh
          ? '您今天有 $sessionCount 场会议，请查看日程详情'
          : 'You have $sessionCount sessions today.',
      scheduledTime: DateTime(date.year, date.month, date.day, 9, 0),
      payload: jsonEncode({'type': 'daily_reminder'}),
    );
  }

  Future<void> cancelNotification(int id) async => _localNotifications.cancel(id: id);
  Future<void> cancelAllNotifications() async => _localNotifications.cancelAll();

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
