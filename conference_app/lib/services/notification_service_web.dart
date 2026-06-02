import 'package:get/get.dart';

import '../controllers/event_controller.dart';
import 'api_service.dart';
import 'storage_service.dart';

class NotificationService extends GetxService {
  final unreadCount = 0.obs;

  Future<NotificationService> init() async {
    await refreshUnreadCount();
    return this;
  }

  Future<void> registerCurrentPushToken() async {}

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

  Future<void> addEventTag(String eventId) async {}

  Future<void> removeEventTag(String eventId) async {}

  Future<void> setAlias(String userId) async {}

  Future<void> showLocalNotification({
    required String title,
    required String body,
    String? payload,
  }) async {}

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    String? payload,
  }) async {}

  Future<void> scheduleSessionReminder({
    required String sessionId,
    required String titleEn,
    required String titleZh,
    required String roomEn,
    required String roomZh,
    required DateTime startTime,
  }) async {}

  Future<void> scheduleDailyReminder(DateTime date, int sessionCount) async {}

  Future<void> cancelNotification(int id) async {}

  Future<void> cancelAllNotifications() async {}

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
}
