import 'package:get/get.dart';
import '../models/event_model.dart';
import '../models/session_model.dart';
import '../services/api_service.dart';
import '../services/data_service.dart';
import '../services/notification_service.dart';
import '../services/storage_service.dart';

class EventController extends GetxController {
  final StorageService _storage = Get.find<StorageService>();

  final allEvents = <EventModel>[].obs;
  final subscribedEventIds = <String>[].obs;
  final searchQuery = ''.obs;
  final selectedEventId = ''.obs;
  final sessions = <SessionModel>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadEvents();
    loadMyEvents();
  }

  Future<void> loadEvents() async {
    isLoading.value = true;
    try {
      final api = Get.find<ApiService>();
      final res = await api.getEvents();
      if (res.statusCode == 200 && res.body is List) {
        allEvents.value = (res.body as List).map((e) => _parseEvent(e)).toList();
        isLoading.value = false;
        return;
      }
    } catch (_) {}
    // Fallback to local data
    allEvents.value = DataService.events;
    subscribedEventIds.value = _storage.subscribedEventIds;
    isLoading.value = false;
  }

  Future<void> loadMyEvents() async {
    try {
      final api = Get.find<ApiService>();
      final res = await api.getMyEvents();
      if (res.statusCode == 200 && res.body is List) {
        subscribedEventIds.value = (res.body as List).map((e) => e['id'] as String).toList();
        return;
      }
    } catch (_) {}
    subscribedEventIds.value = _storage.subscribedEventIds;
  }

  List<EventModel> get filteredEvents {
    if (searchQuery.value.isEmpty) return allEvents;
    final q = searchQuery.value.toLowerCase();
    return allEvents.where((e) =>
      e.titleEn.toLowerCase().contains(q) ||
      e.titleZh.contains(q) ||
      e.locationEn.toLowerCase().contains(q) ||
      e.locationZh.contains(q) ||
      e.tags.any((t) => t.toLowerCase().contains(q))
    ).toList();
  }

  List<EventModel> get myEvents {
    return allEvents.where((e) => subscribedEventIds.contains(e.id)).toList();
  }

  bool isSubscribed(String eventId) => subscribedEventIds.contains(eventId);

  Future<void> toggleSubscription(String eventId) async {
    final notifService = Get.find<NotificationService>();
    try {
      final api = Get.find<ApiService>();
      if (isSubscribed(eventId)) {
        await api.unsubscribeEvent(eventId);
        subscribedEventIds.remove(eventId);
        await _storage.unsubscribeEvent(eventId);
        notifService.removeEventTag(eventId);
      } else {
        await api.subscribeEvent(eventId);
        subscribedEventIds.add(eventId);
        await _storage.subscribeEvent(eventId);
        notifService.addEventTag(eventId);
      }
    } catch (_) {
      if (isSubscribed(eventId)) {
        subscribedEventIds.remove(eventId);
        await _storage.unsubscribeEvent(eventId);
      } else {
        subscribedEventIds.add(eventId);
        await _storage.subscribeEvent(eventId);
      }
    }
  }

  Future<void> selectEvent(String eventId) async {
    selectedEventId.value = eventId;
    try {
      final api = Get.find<ApiService>();
      final res = await api.getSessions(eventId);
      if (res.statusCode == 200 && res.body is List) {
        sessions.value = (res.body as List).map((s) => _parseSession(s)).toList();
        return;
      }
    } catch (_) {}
    // Fallback
    sessions.value = DataService.getSessions(eventId);
  }

  EventModel? get selectedEvent {
    if (selectedEventId.value.isEmpty) return null;
    return allEvents.firstWhereOrNull((e) => e.id == selectedEventId.value);
  }

  List<SessionModel> getSessionsForDay(int dayIndex) {
    return sessions.where((s) => s.dayIndex == dayIndex).toList()
      ..sort((a, b) => a.startTime.compareTo(b.startTime));
  }

  int get totalDays {
    if (sessions.isEmpty) return 0;
    return sessions.map((s) => s.dayIndex).reduce((a, b) => a > b ? a : b) + 1;
  }

  EventModel _parseEvent(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'] ?? '',
      titleEn: json['titleEn'] ?? '',
      titleZh: json['titleZh'] ?? '',
      descriptionEn: json['descriptionEn'] ?? '',
      descriptionZh: json['descriptionZh'] ?? '',
      locationEn: json['locationEn'] ?? '',
      locationZh: json['locationZh'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      startDate: DateTime.tryParse(json['startDate'] ?? '') ?? DateTime.now(),
      endDate: DateTime.tryParse(json['endDate'] ?? '') ?? DateTime.now(),
      organizerEn: json['organizerEn'] ?? '',
      organizerZh: json['organizerZh'] ?? '',
      tags: json['tags'] != null ? List<String>.from(json['tags']) : [],
      isFeatured: json['isFeatured'] ?? false,
      maxAttendees: json['maxAttendees'] ?? 0,
      currentAttendees: json['currentAttendees'] ?? 0,
    );
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
