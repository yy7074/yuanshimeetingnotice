import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/session_model.dart';
import '../services/api_service.dart';
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
    _initializeSchedule();
  }

  Future<void> _initializeSchedule() async {
    await refreshSessions();
    await syncJoinedEventSchedules();
  }

  Future<void> refreshSessions() async {
    final storage = Get.find<StorageService>();
    final eventIds = storage.subscribedEventIds;
    final sessions = <SessionModel>[];

    for (final eventId in eventIds) {
      sessions.addAll(await _fetchSessionsForEvent(eventId));
    }
    allSessions.value = sessions;
  }

  bool isSaved(String sessionId) => savedSessionIds.contains(sessionId);

  /// Check if a session conflicts with any saved session
  List<SessionModel> getConflicts(SessionModel session) {
    return mySessions
        .where(
          (s) =>
              s.id != session.id &&
              s.dayIndex == session.dayIndex &&
              s.startTime.isBefore(session.endTime) &&
              s.endTime.isAfter(session.startTime),
        )
        .toList();
  }

  Future<void> toggleSession(String sessionId) async {
    final notifService = Get.find<NotificationService>();
    if (isSaved(sessionId)) {
      await _storage.removeSession(sessionId);
      savedSessionIds.remove(sessionId);
      await notifService.cancelNotification(sessionId.hashCode.abs() % 100000);
    } else {
      final session = allSessions.firstWhereOrNull((s) => s.id == sessionId);
      if (session != null) {
        final conflicts = getConflicts(session);
        if (conflicts.isNotEmpty) {
          final confirmed = await _showConflictDialog(session, conflicts);
          if (confirmed != true) return;
        }
      }
      await _storage.saveSession(sessionId);
      savedSessionIds.add(sessionId);
      if (session != null) {
        await _scheduleReminder(session);
      }
    }
  }

  Future<bool?> _showConflictDialog(
    SessionModel session,
    List<SessionModel> conflicts,
  ) {
    final isZh = Get.locale?.languageCode == 'zh';
    final conflictNames = conflicts
        .map((c) => isZh ? c.titleZh : c.titleEn)
        .join('\n• ');
    return Get.dialog<bool>(
      AlertDialog(
        title: Row(
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: Colors.orange,
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              isZh ? '日程冲突' : 'Schedule Conflict',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isZh
                  ? '"${session.titleZh}" 与以下议程时间冲突：'
                  : '"${session.titleEn}" conflicts with:',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            Text(
              '• $conflictNames',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 12),
            Text(
              isZh ? '是否仍要添加？' : 'Add anyway?',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text(isZh ? '取消' : 'Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: Text(
              isZh ? '仍然添加' : 'Add Anyway',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> addAllSessionsFromEvent(String eventId) async {
    final sessions = await _fetchSessionsForEvent(eventId);
    if (sessions.isEmpty) {
      return false;
    }

    for (final session in sessions) {
      if (!isSaved(session.id)) {
        await _storage.saveSession(session.id);
        savedSessionIds.add(session.id);
        await _scheduleReminder(session);
      }
    }
    await _storage.markScheduleEventHydrated(eventId);
    await refreshSessions();
    await _scheduleDailyReminders();
    return true;
  }

  Future<void> syncJoinedEventSchedules({Iterable<String>? eventIds}) async {
    final targetEventIds = (eventIds ?? _storage.subscribedEventIds).toList();
    final hydratedIds = _storage.hydratedScheduleEventIds.toSet();
    var changed = false;

    for (final eventId in targetEventIds) {
      if (hydratedIds.contains(eventId)) {
        continue;
      }

      final sessions = await _fetchSessionsForEvent(eventId);
      if (sessions.isEmpty) {
        continue;
      }

      for (final session in sessions) {
        if (!isSaved(session.id)) {
          await _storage.saveSession(session.id);
          savedSessionIds.add(session.id);
          await _scheduleReminder(session);
          changed = true;
        }
      }

      await _storage.markScheduleEventHydrated(eventId);
    }

    if (changed) {
      await refreshSessions();
      await _scheduleDailyReminders();
    }
  }

  Future<void> removeSessionsFromEvent(String eventId) async {
    final sessions = await _fetchSessionsForEvent(eventId);
    if (sessions.isEmpty) {
      await _storage.unmarkScheduleEventHydrated(eventId);
      await refreshSessions();
      return;
    }

    final sessionIdsToRemove = sessions.map((session) => session.id).toSet();
    final remainingSessionIds = savedSessionIds
        .where((id) => !sessionIdsToRemove.contains(id))
        .toList();

    for (final session in sessions) {
      if (savedSessionIds.contains(session.id)) {
        try {
          final notifService = Get.find<NotificationService>();
          await notifService.cancelNotification(
            session.id.hashCode.abs() % 100000,
          );
        } catch (_) {}
      }
    }

    savedSessionIds.value = remainingSessionIds;
    await _storage.setSavedSessionIds(remainingSessionIds);
    await _storage.unmarkScheduleEventHydrated(eventId);
    await refreshSessions();
    await _scheduleDailyReminders();
  }

  List<SessionModel> get mySessions {
    if (savedSessionIds.isEmpty) return [];
    return allSessions.where((s) => savedSessionIds.contains(s.id)).toList();
  }

  List<SessionModel> get allSavedSessions {
    return allSessions.where((s) => savedSessionIds.contains(s.id)).toList()
      ..sort((a, b) => a.startTime.compareTo(b.startTime));
  }

  List<SessionModel> get sessionsForSelectedDay {
    return mySessions
        .where((s) => s.dayIndex == selectedDayIndex.value)
        .toList()
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

  Future<List<SessionModel>> _fetchSessionsForEvent(String eventId) async {
    try {
      final api = Get.find<ApiService>();
      final res = await api.getSessions(eventId);
      if (res.statusCode == 200 && res.body is List) {
        return (res.body as List).map((s) => _parseSession(s)).toList();
      }
    } catch (_) {}
    return [];
  }

  Future<void> _scheduleDailyReminders() async {
    try {
      final notifService = Get.find<NotificationService>();
      final days = availableDays;
      for (final day in days) {
        final sessionsOnDay = mySessions
            .where(
              (s) =>
                  s.startTime.year == day.year &&
                  s.startTime.month == day.month &&
                  s.startTime.day == day.day,
            )
            .length;
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
        (t) =>
            t.name == json['type'] ||
            t.name == (json['type'] as String?)?.replaceAll('_', ''),
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
