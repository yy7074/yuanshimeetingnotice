import 'package:get/get.dart';
import '../models/session_model.dart';
import '../services/data_service.dart';
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
    _loadAllSavedSessions();
  }

  void _loadAllSavedSessions() {
    // Load sessions from all subscribed events
    final storage = Get.find<StorageService>();
    final eventIds = storage.subscribedEventIds;
    final sessions = <SessionModel>[];
    for (final eventId in eventIds) {
      sessions.addAll(DataService.getSessions(eventId));
    }
    allSessions.value = sessions;
  }

  void refreshSessions() {
    _loadAllSavedSessions();
  }

  bool isSaved(String sessionId) => savedSessionIds.contains(sessionId);

  Future<void> toggleSession(String sessionId) async {
    if (isSaved(sessionId)) {
      await _storage.removeSession(sessionId);
      savedSessionIds.remove(sessionId);
    } else {
      await _storage.saveSession(sessionId);
      savedSessionIds.add(sessionId);
    }
  }

  Future<void> addAllSessionsFromEvent(String eventId) async {
    final sessions = DataService.getSessions(eventId);
    for (final session in sessions) {
      if (!isSaved(session.id)) {
        await _storage.saveSession(session.id);
        savedSessionIds.add(session.id);
      }
    }
    refreshSessions();
  }

  List<SessionModel> get mySessions {
    if (savedSessionIds.isEmpty) return [];
    return allSessions.where((s) => savedSessionIds.contains(s.id)).toList();
  }

  List<SessionModel> get sessionsForSelectedDay {
    return mySessions.where((s) => s.dayIndex == selectedDayIndex.value).toList()
      ..sort((a, b) => a.startTime.compareTo(b.startTime));
  }

  // Get unique days from saved sessions
  List<DateTime> get availableDays {
    final days = <DateTime>{};
    for (final s in mySessions) {
      days.add(DateTime(s.startTime.year, s.startTime.month, s.startTime.day));
    }
    final list = days.toList()..sort();
    return list;
  }
}
