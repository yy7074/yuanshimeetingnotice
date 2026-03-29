import 'package:get/get.dart';
import '../models/session_model.dart';
import '../services/api_service.dart';
import '../services/data_service.dart';
import '../services/notification_service.dart';
import '../services/storage_service.dart';

class ScheduleController extends GetxController {
  final StorageService _storage = Get.find<StorageService>();

  final savedSessionIds = <String>[].obs;
  final selectedDayIndex = 0.obs;
  final allSessions = <SessionModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    savedSessionIds.value = _storage.savedSessionIds;
    refreshSessions();
  }

  Future<void> refreshSessions() async {
    final storage = Get.find<StorageService>();
    final eventIds = storage.subscribedEventIds;
    final sessions = <SessionModel>[];

    for (final eventId in eventIds) {
      try {
        final api = Get.find<ApiService>();
        final res = await api.getSessions(eventId);
        if (res.statusCode == 200 && res.body is List) {
          sessions.addAll((res.body as List).map((s) => _parseSession(s)));
          continue;
        }
      } catch (_) {}
      // Fallback
      sessions.addAll(DataService.getSessions(eventId));
    }
    allSessions.value = sessions;
  }

  bool isSaved(String sessionId) => savedSessionIds.contains(sessionId);

  Future<void> toggleSession(String sessionId) async {
    final notifService = Get.find<NotificationService>();
    if (isSaved(sessionId)) {
      await _storage.removeSession(sessionId);
      savedSessionIds.remove(sessionId);
      // Cancel reminder
      await notifService.cancelNotification(sessionId.hashCode.abs() % 100000);
    } else {
      await _storage.saveSession(sessionId);
      savedSessionIds.add(sessionId);
      // Schedule reminder for this session
      final session = allSessions.firstWhereOrNull((s) => s.id == sessionId);
      if (session != null) {
        await _scheduleReminder(session);
      }
    }
  }

  Future<void> addAllSessionsFromEvent(String eventId) async {
    List<SessionModel> sessions;
    try {
      final api = Get.find<ApiService>();
      final res = await api.getSessions(eventId);
      if (res.statusCode == 200 && res.body is List) {
        sessions = (res.body as List).map((s) => _parseSession(s)).toList();
      } else {
        sessions = DataService.getSessions(eventId);
      }
    } catch (_) {
      sessions = DataService.getSessions(eventId);
    }

    for (final session in sessions) {
      if (!isSaved(session.id)) {
        await _storage.saveSession(session.id);
        savedSessionIds.add(session.id);
        await _scheduleReminder(session);
      }
    }
    await refreshSessions();
    await _scheduleDailyReminders();
  }

  List<SessionModel> get mySessions {
    if (savedSessionIds.isEmpty) return [];
    return allSessions.where((s) => savedSessionIds.contains(s.id)).toList();
  }

  List<SessionModel> get sessionsForSelectedDay {
    return mySessions.where((s) => s.dayIndex == selectedDayIndex.value).toList()
      ..sort((a, b) => a.startTime.compareTo(b.startTime));
  }

  List<DateTime> get availableDays {
    final days = <DateTime>{};
    for (final s in mySessions) {
      days.add(DateTime(s.startTime.year, s.startTime.month, s.startTime.day));
    }
    final list = days.toList()..sort();
    return list;
  }

  Future<void> _scheduleReminder(SessionModel session) async {
    try {
      final notifService = Get.find<NotificationService>();
      await notifService.scheduleSessionReminder(
        sessionId: session.id,
        titleEn: session.titleEn,
        titleZh: session.titleZh,
        roomEn: session.roomEn,
        roomZh: session.roomZh,
        startTime: session.startTime,
      );
    } catch (_) {}
  }

  Future<void> _scheduleDailyReminders() async {
    try {
      final notifService = Get.find<NotificationService>();
      final days = availableDays;
      for (final day in days) {
        final sessionsOnDay = mySessions.where((s) =>
          s.startTime.year == day.year &&
          s.startTime.month == day.month &&
          s.startTime.day == day.day
        ).length;
        if (sessionsOnDay > 0) {
          await notifService.scheduleDailyReminder(day, sessionsOnDay);
        }
      }
    } catch (_) {}
  }

  SessionModel _parseSession(Map<String, dynamic> json) {
    final speaker = json['speaker'] as Map<String, dynamic>?;
    return SessionModel(
      id: json['id'] ?? '',
      eventId: json['eventId'] ?? '',
      titleEn: json['titleEn'] ?? '',
      titleZh: json['titleZh'] ?? '',
      descriptionEn: json['descriptionEn'] ?? '',
      descriptionZh: json['descriptionZh'] ?? '',
      roomEn: json['roomEn'] ?? '',
      roomZh: json['roomZh'] ?? '',
      startTime: DateTime.tryParse(json['startTime'] ?? '') ?? DateTime.now(),
      endTime: DateTime.tryParse(json['endTime'] ?? '') ?? DateTime.now(),
      type: SessionType.values.firstWhere(
        (t) => t.name == json['type'] || t.name == (json['type'] as String?)?.replaceAll('_', ''),
        orElse: () => SessionType.keynote,
      ),
      dayIndex: json['dayIndex'] ?? 0,
      speakerId: json['speakerId'] ?? speaker?['id'] ?? '',
      speakerName: json['speakerName'] ?? speaker?['nameEn'] ?? '',
      speakerTitleEn: json['speakerTitleEn'] ?? speaker?['titleEn'] ?? '',
      speakerTitleZh: json['speakerTitleZh'] ?? speaker?['titleZh'] ?? '',
      speakerAvatarUrl: json['speakerAvatarUrl'] ?? speaker?['avatarUrl'] ?? '',
    );
  }
}
