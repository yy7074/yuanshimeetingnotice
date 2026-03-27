import 'package:get/get.dart';
import '../models/event_model.dart';
import '../models/session_model.dart';
import '../services/data_service.dart';
import '../services/storage_service.dart';

class EventController extends GetxController {
  final StorageService _storage = Get.find<StorageService>();

  final allEvents = <EventModel>[].obs;
  final subscribedEventIds = <String>[].obs;
  final searchQuery = ''.obs;
  final selectedEventId = ''.obs;
  final sessions = <SessionModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadEvents();
    subscribedEventIds.value = _storage.subscribedEventIds;
  }

  void loadEvents() {
    allEvents.value = DataService.events;
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
    if (isSubscribed(eventId)) {
      await _storage.unsubscribeEvent(eventId);
      subscribedEventIds.remove(eventId);
    } else {
      await _storage.subscribeEvent(eventId);
      subscribedEventIds.add(eventId);
    }
  }

  void selectEvent(String eventId) {
    selectedEventId.value = eventId;
    sessions.value = DataService.getSessions(eventId);
  }

  EventModel? get selectedEvent {
    if (selectedEventId.value.isEmpty) return null;
    return allEvents.firstWhereOrNull((e) => e.id == selectedEventId.value);
  }

  List<SessionModel> getSessionsForDay(int dayIndex) {
    return sessions.where((s) => s.dayIndex == dayIndex).toList();
  }

  int get totalDays {
    if (sessions.isEmpty) return 0;
    return sessions.map((s) => s.dayIndex).reduce((a, b) => a > b ? a : b) + 1;
  }
}
