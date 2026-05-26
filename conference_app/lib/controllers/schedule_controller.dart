import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
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
  final expertTaskSessions = <SessionModel>[].obs;
  final taskSearchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    savedSessionIds.value = _storage.savedSessionIds;
    _initializeSchedule();
  }

  Future<void> _initializeSchedule() async {
    final initialEventIds = _storage.subscribedEventIds.toList();
    await refreshSessions();
    await syncJoinedEventSchedules(eventIds: initialEventIds);
  }

  Future<void> refreshSessions() async {
    final storage = Get.find<StorageService>();
    final eventIds = {
      DataService.apscvir2026EventId,
      ...storage.subscribedEventIds,
    };
    final sessions = <SessionModel>[];

    for (final eventId in eventIds) {
      sessions.addAll(await _fetchSessionsForEvent(eventId));
    }
    allSessions.value = _dedupeSessions(sessions);
    expertTaskSessions.value = await DataService.getProgramTasks(
      DataService.apscvir2026EventId,
    );
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
    final notifService = Get.isRegistered<NotificationService>()
        ? Get.find<NotificationService>()
        : null;
    if (isSaved(sessionId)) {
      await _storage.removeSession(sessionId);
      savedSessionIds.remove(sessionId);
      await notifService?.cancelNotification(sessionId.hashCode.abs() % 100000);
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

  Future<void> toggleSessionModel(SessionModel session) async {
    if (!allSessions.any((item) => item.id == session.id)) {
      allSessions.add(session);
    }

    if (!_storage.subscribedEventIds.contains(session.eventId)) {
      await _storage.subscribeEvent(session.eventId);
    }

    await toggleSession(session.id);
    await refreshSessions();
  }

  Future<bool?> _showConflictDialog(
    SessionModel session,
    List<SessionModel> conflicts,
  ) {
    final isZh = Get.locale?.languageCode == '__zh_disabled__';
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
              isZh ? 'Schedule Conflict' : 'Schedule Conflict',
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
                  ? '"${session.titleEn}" conflicts with:'
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
              isZh ? 'Add anyway?' : 'Add anyway?',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text(isZh ? 'Cancel' : 'Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: Text(
              isZh ? 'Add Anyway' : 'Add Anyway',
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

    if (!_storage.subscribedEventIds.contains(eventId)) {
      await _storage.subscribeEvent(eventId);
    }

    final updatedIds = savedSessionIds.toList();
    final updatedIdSet = updatedIds.toSet();
    final sessionsToSchedule = <SessionModel>[];

    for (final session in sessions) {
      if (updatedIdSet.add(session.id)) {
        updatedIds.add(session.id);
        sessionsToSchedule.add(session);
      }
    }

    if (sessionsToSchedule.isNotEmpty) {
      savedSessionIds.value = updatedIds;
      await _storage.setSavedSessionIds(updatedIds);
      for (final session in sessionsToSchedule) {
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
    final updatedIds = savedSessionIds.toList();
    final updatedIdSet = updatedIds.toSet();
    final sessionsToSchedule = <SessionModel>[];
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
        if (updatedIdSet.add(session.id)) {
          updatedIds.add(session.id);
          sessionsToSchedule.add(session);
          changed = true;
        }
      }

      await _storage.markScheduleEventHydrated(eventId);
    }

    if (changed) {
      savedSessionIds.value = updatedIds;
      await _storage.setSavedSessionIds(updatedIds);
      for (final session in sessionsToSchedule) {
        await _scheduleReminder(session);
      }
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
    final sessions = mySessions
        .where((s) => s.dayIndex == selectedDayIndex.value)
        .toList();
    if (sessions.isNotEmpty) {
      return sessions..sort((a, b) => a.startTime.compareTo(b.startTime));
    }

    final days = availableDays;
    final selectedIndex = selectedDayIndex.value;
    if (selectedIndex >= 0 && selectedIndex < days.length) {
      final day = days[selectedIndex];
      return mySessions
          .where(
            (s) =>
                s.startTime.year == day.year &&
                s.startTime.month == day.month &&
                s.startTime.day == day.day,
          )
          .toList()
        ..sort((a, b) => a.startTime.compareTo(b.startTime));
    }

    return sessions;
  }

  List<DateTime> get availableDays {
    final days = <DateTime>{};
    for (final s in mySessions) {
      days.add(DateTime(s.startTime.year, s.startTime.month, s.startTime.day));
    }
    final list = days.toList()..sort();
    return list;
  }

  List<SessionModel> get displayedTaskSessions {
    final query = taskSearchQuery.value.trim();
    final savedSchedule = allSavedSessions;
    final source = savedSchedule.isNotEmpty
        ? savedSchedule
        : _currentUserTaskSessions(expertTaskSessions.toList());
    final sessions = query.isEmpty
        ? source
        : source.where((session) => _matchesTaskQuery(session, query)).toList();
    sessions.sort((a, b) {
      final timeCompare = a.startTime.compareTo(b.startTime);
      if (timeCompare != 0) return timeCompare;
      return a.roomEn.compareTo(b.roomEn);
    });
    return sessions;
  }

  List<SessionModel> get taskSessionsForSelectedDay {
    final sessions = displayedTaskSessions
        .where((s) => s.dayIndex == selectedDayIndex.value)
        .toList();
    if (sessions.isNotEmpty) {
      return sessions..sort((a, b) => a.startTime.compareTo(b.startTime));
    }

    final days = availableTaskDays;
    final selectedIndex = selectedDayIndex.value;
    if (selectedIndex >= 0 && selectedIndex < days.length) {
      final day = days[selectedIndex];
      return displayedTaskSessions
          .where(
            (s) =>
                s.startTime.year == day.year &&
                s.startTime.month == day.month &&
                s.startTime.day == day.day,
          )
          .toList()
        ..sort((a, b) => a.startTime.compareTo(b.startTime));
    }

    return sessions;
  }

  List<DateTime> get availableTaskDays {
    final days = <DateTime>{};
    for (final session in displayedTaskSessions) {
      days.add(
        DateTime(
          session.startTime.year,
          session.startTime.month,
          session.startTime.day,
        ),
      );
    }
    final list = days.toList()..sort();
    return list;
  }

  /// Last-name token (e.g. "Teng" from "Gaojun Teng") used to auto-filter
  /// the logged-in expert's personal task list. Null when no user is signed in
  /// or the English name does not yield a usable surname token.
  String? get currentUserLastNameKey {
    if (!Get.isRegistered<AuthController>()) return null;
    final user = Get.find<AuthController>().currentUser.value;
    if (user == null) return null;
    return _lastNameToken(user.nameEn);
  }

  /// Surname as it appears on screen (e.g. "Teng" \u2014 preserves hyphenation
  /// and original casing). Falls back to Chinese name when English is empty.
  String get currentUserLastNameDisplay {
    if (!Get.isRegistered<AuthController>()) return '';
    final user = Get.find<AuthController>().currentUser.value;
    if (user == null) return '';
    final trimmedEn = user.nameEn.trim();
    if (trimmedEn.isNotEmpty) {
      final tokens = trimmedEn.split(RegExp(r'\s+'));
      if (tokens.isNotEmpty) return tokens.last;
    }
    return user.nameZh.trim();
  }

  List<SessionModel> _currentUserTaskSessions(List<SessionModel> source) {
    if (!Get.isRegistered<AuthController>()) return const [];
    final user = Get.find<AuthController>().currentUser.value;
    if (user == null) return const [];

    final lastName = _lastNameToken(user.nameEn);
    final fullKeys = <String>{
      _normalizePersonName(user.nameEn),
      _normalizePersonName(user.email.split('@').first),
    }..removeWhere((v) => v.length < 3 || v == 'apscvirdelegate');
    final zhName = user.nameZh.trim();

    if (lastName == null && fullKeys.isEmpty && zhName.isEmpty) return const [];

    return source.where((session) {
      final rawNames = [
        session.taskPersonName,
        session.speakerName,
      ].where((name) => name.trim().isNotEmpty);
      for (final raw in rawNames) {
        if (zhName.isNotEmpty && raw.contains(zhName)) return true;

        final tokens = raw
            .split(RegExp(r'[,\uff0c;\uff1b/]'))
            .expand((part) => part.split(RegExp(r'\s+')))
            .map(_normalizePersonName)
            .where((token) => token.isNotEmpty)
            .toSet();
        if (lastName != null && tokens.contains(lastName)) return true;

        // Substring fallback so test/legacy accounts (e.g. only nameEn)
        // continue to match even when the surname token is unusual.
        for (final candidate in raw.split(RegExp(r'[,\uff0c;\uff1b/]'))) {
          final normalized = _normalizePersonName(candidate);
          if (normalized.isEmpty) continue;
          for (final key in fullKeys) {
            if (normalized == key ||
                normalized.contains(key) ||
                key.contains(normalized)) {
              return true;
            }
          }
        }
      }
      return false;
    }).toList();
  }

  bool _matchesTaskQuery(SessionModel session, String query) {
    final q = query.toLowerCase();
    return [
      session.titleEn,
      session.titleZh,
      session.parentSessionTitle,
      session.descriptionEn,
      session.descriptionZh,
      session.speakerName,
      session.taskPersonName,
      session.speakerTitleEn,
      session.speakerTitleZh,
      session.roomEn,
      session.roomZh,
      session.taskRole,
      session.timeRangeStr,
    ].any((value) => value.toLowerCase().contains(q));
  }

  String? _lastNameToken(String nameEn) {
    final trimmed = nameEn.trim();
    if (trimmed.isEmpty) return null;
    final tokens = trimmed.split(RegExp(r'\s+'));
    if (tokens.isEmpty) return null;
    final last = _normalizePersonName(tokens.last);
    return last.length >= 2 ? last : null;
  }

  String _normalizePersonName(String value) {
    return value.toLowerCase().replaceAll(
      RegExp(r'[^a-z0-9\u4e00-\u9fa5]+'),
      '',
    );
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
    if (eventId == DataService.apscvir2026EventId) {
      final localSessions = await DataService.getDetailedSessions(eventId);
      if (localSessions.isNotEmpty) {
        return localSessions;
      }
    }

    try {
      final api = Get.find<ApiService>();
      final res = await api.getSessions(eventId);
      if (res.statusCode == 200 && res.body is List) {
        final sessions = (res.body as List)
            .map((s) => _parseSession(s))
            .toList();
        if (sessions.isNotEmpty) {
          return sessions;
        }
      }
    } catch (_) {}
    return DataService.getSessions(eventId);
  }

  List<SessionModel> _dedupeSessions(List<SessionModel> sessions) {
    final seen = <String>{};
    final result = <SessionModel>[];
    for (final session in sessions) {
      if (seen.add(session.id)) {
        result.add(session);
      }
    }
    return result;
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
    DateTime parseDate(dynamic value) =>
        DateTime.tryParse(value?.toString() ?? '')?.toLocal() ?? DateTime.now();
    final typeValue = (json['type'] as String? ?? '')
        .replaceAll('_', '')
        .toLowerCase();

    return SessionModel(
      id: json['id'] ?? '',
      eventId: json['eventId'] ?? '',
      titleEn: json['titleEn'] ?? '',
      titleZh: json['titleZh'] ?? '',
      descriptionEn: json['descriptionEn'] ?? '',
      descriptionZh: json['descriptionZh'] ?? '',
      roomEn: json['roomEn'] ?? '',
      roomZh: json['roomZh'] ?? '',
      startTime: parseDate(json['startTime']),
      endTime: parseDate(json['endTime']),
      type: SessionType.values.firstWhere(
        (t) => t.name.toLowerCase() == typeValue,
        orElse: () => SessionType.keynote,
      ),
      dayIndex: json['dayIndex'] ?? 0,
      speakerId: json['speakerId'] ?? speaker?['id'] ?? '',
      speakerName: json['speakerName'] ?? speaker?['nameEn'] ?? '',
      speakerTitleEn: json['speakerTitleEn'] ?? speaker?['titleEn'] ?? '',
      speakerTitleZh: json['speakerTitleZh'] ?? speaker?['titleZh'] ?? '',
      speakerAvatarUrl: json['speakerAvatarUrl'] ?? speaker?['avatarUrl'] ?? '',
      taskRole: json['taskRole'] ?? '',
      taskPersonName: json['taskPersonName'] ?? '',
      parentSessionTitle: json['parentSessionTitle'] ?? '',
    );
  }
}
