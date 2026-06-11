import 'dart:async';

import 'package:get/get.dart';
import '../models/event_model.dart';
import '../models/session_model.dart';
import '../utils/pinyin_search.dart';
import 'schedule_controller.dart';
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
  final filterTimeRange = Rx<String?>(
    null,
  ); // 'upcoming', 'past', 'this_month', 'next_month'
  final filterLocation = Rx<String?>(null); // location string to match
  final filterTag = Rx<String?>(null); // tag to match
  final sortMode = 'upcoming_first'.obs; // 'upcoming_first' or 'newest_first'

  // Get unique locations from all events for filter options
  List<String> get availableLocations {
    final locations = <String>{};
    for (final e in allEvents) {
      if (e.locationEn.isNotEmpty) locations.add(e.locationEn);
    }
    return locations.toList()..sort();
  }

  // Get unique tags from all events for filter options
  List<String> get availableTags {
    final tags = <String>{};
    for (final e in allEvents) {
      tags.addAll(e.tags);
    }
    return tags.toList()..sort();
  }

  bool get hasActiveFilters =>
      filterTimeRange.value != null ||
      filterLocation.value != null ||
      filterTag.value != null;

  void clearFilters() {
    filterTimeRange.value = null;
    filterLocation.value = null;
    filterTag.value = null;
  }

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
        final events = (res.body as List).map((e) => _parseEvent(e)).toList();
        allEvents.value = _mergeEvents(events, DataService.events);
        isLoading.value = false;
        return;
      }
    } catch (_) {}
    allEvents.value = DataService.events;
    isLoading.value = false;
  }

  Future<void> loadMyEvents() async {
    try {
      final api = Get.find<ApiService>();
      final res = await api.getMyEvents();
      if (res.statusCode == 200 && res.body is List) {
        final apiEventIds = (res.body as List)
            .map((e) => e['id'] as String)
            .toList();
        final localEventIds = _storage.subscribedEventIds
            .where(_supportsOfflineEvent)
            .toList();
        final eventIds = {...apiEventIds, ...localEventIds}.toList();
        subscribedEventIds.value = eventIds;
        await _storage.setSubscribedEventIds(eventIds);
        unawaited(
          _syncLocalSubscriptionsToServer(
            api,
            localEventIds: localEventIds,
            apiEventIds: apiEventIds,
          ),
        );
        if (Get.isRegistered<ScheduleController>()) {
          final scheduleCtrl = Get.find<ScheduleController>();
          await scheduleCtrl.refreshSessions();
          await scheduleCtrl.syncJoinedEventSchedules(eventIds: eventIds);
        }
        return;
      }
    } catch (_) {}
    subscribedEventIds.value = _storage.subscribedEventIds;
  }

  List<EventModel> get filteredEvents {
    var events = allEvents.toList();

    // Search filter matches raw text plus pinyin/initials for legacy fields.
    if (searchQuery.value.isNotEmpty) {
      final q = searchQuery.value.toLowerCase();
      events = events
          .where(
            (e) => matchesPinyin(q, [
              e.titleEn,
              e.titleZh,
              e.locationEn,
              e.locationZh,
              e.organizerEn,
              e.organizerZh,
              ...e.tags,
            ]),
          )
          .toList();
    }

    // Time range filter
    if (filterTimeRange.value != null) {
      final now = DateTime.now();
      switch (filterTimeRange.value) {
        case 'upcoming':
          events = events.where((e) => e.startDate.isAfter(now)).toList();
          break;
        case 'past':
          events = events.where((e) => e.endDate.isBefore(now)).toList();
          break;
        case 'this_month':
          events = events
              .where(
                (e) =>
                    e.startDate.month == now.month &&
                    e.startDate.year == now.year,
              )
              .toList();
          break;
        case 'next_month':
          final nextMonth = now.month == 12 ? 1 : now.month + 1;
          final nextYear = now.month == 12 ? now.year + 1 : now.year;
          events = events
              .where(
                (e) =>
                    e.startDate.month == nextMonth &&
                    e.startDate.year == nextYear,
              )
              .toList();
          break;
      }
    }

    // Location filter
    if (filterLocation.value != null) {
      final loc = filterLocation.value!.toLowerCase();
      events = events
          .where(
            (e) =>
                e.locationEn.toLowerCase().contains(loc) ||
                e.locationZh.contains(filterLocation.value!),
          )
          .toList();
    }

    // Tag filter
    if (filterTag.value != null) {
      events = events
          .where(
            (e) => e.tags.any(
              (t) => t.toLowerCase() == filterTag.value!.toLowerCase(),
            ),
          )
          .toList();
    }

    // Sort
    if (sortMode.value == 'upcoming_first') {
      events.sort((a, b) {
        final now = DateTime.now();
        final aFuture = a.startDate.isAfter(now);
        final bFuture = b.startDate.isAfter(now);
        if (aFuture && !bFuture) return -1;
        if (!aFuture && bFuture) return 1;
        return a.startDate.compareTo(b.startDate);
      });
    } else {
      events.sort((a, b) => b.startDate.compareTo(a.startDate));
    }

    return events;
  }

  List<EventModel> get myEvents {
    return allEvents.where((e) => subscribedEventIds.contains(e.id)).toList();
  }

  bool isSubscribed(String eventId) => subscribedEventIds.contains(eventId);

  Future<bool> toggleSubscription(String eventId) async {
    final notifService = Get.find<NotificationService>();
    final scheduleCtrl = Get.isRegistered<ScheduleController>()
        ? Get.find<ScheduleController>()
        : null;
    final wasSubscribed = isSubscribed(eventId);

    if (wasSubscribed) {
      subscribedEventIds.remove(eventId);
      await _storage.unsubscribeEvent(eventId);
      notifService.removeEventTag(eventId);
    } else {
      subscribedEventIds.add(eventId);
      await _storage.subscribeEvent(eventId);
      notifService.addEventTag(eventId);
    }

    try {
      final api = Get.find<ApiService>();
      if (wasSubscribed) {
        await api.unsubscribeEvent(eventId);
        unawaited(_syncScheduleAfterUnsubscribe(scheduleCtrl, eventId));
      } else {
        await api.subscribeEvent(eventId);
        unawaited(_syncScheduleAfterSubscribe(scheduleCtrl, eventId));
      }
      return true;
    } catch (_) {
      if (_supportsOfflineEvent(eventId)) {
        if (wasSubscribed) {
          unawaited(_syncScheduleAfterUnsubscribe(scheduleCtrl, eventId));
        } else {
          unawaited(_syncScheduleAfterSubscribe(scheduleCtrl, eventId));
        }
        return true;
      }

      if (wasSubscribed) {
        subscribedEventIds.add(eventId);
        await _storage.subscribeEvent(eventId);
        notifService.addEventTag(eventId);
      } else {
        subscribedEventIds.remove(eventId);
        await _storage.unsubscribeEvent(eventId);
        notifService.removeEventTag(eventId);
      }
      return false;
    }
  }

  Future<void> _syncScheduleAfterSubscribe(
    ScheduleController? scheduleCtrl,
    String eventId,
  ) async {
    try {
      await scheduleCtrl?.refreshSessions();
    } catch (_) {}
  }

  Future<void> _syncScheduleAfterUnsubscribe(
    ScheduleController? scheduleCtrl,
    String eventId,
  ) async {
    try {
      await scheduleCtrl?.refreshSessions();
    } catch (_) {}
  }

  Future<void> _syncLocalSubscriptionsToServer(
    ApiService api, {
    required Iterable<String> localEventIds,
    required Iterable<String> apiEventIds,
  }) async {
    final remoteIds = apiEventIds.toSet();
    for (final eventId in localEventIds) {
      if (eventId.isEmpty || remoteIds.contains(eventId)) continue;
      try {
        await api.subscribeEvent(eventId);
      } catch (_) {}
    }
  }

  Future<void> selectEvent(String eventId) async {
    selectedEventId.value = eventId;
    final localSessions = await DataService.getDetailedSessions(eventId);
    if (localSessions.isNotEmpty) {
      sessions.value = localSessions;
      return;
    }

    try {
      final api = Get.find<ApiService>();
      final res = await api.getSessions(eventId);
      if (res.statusCode == 200 && res.body is List) {
        final parsedSessions = (res.body as List)
            .map((s) => _parseSession(s))
            .toList();
        if (parsedSessions.isNotEmpty) {
          sessions.value = parsedSessions;
          return;
        }
      }
    } catch (_) {}
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
    DateTime parseDate(dynamic value) =>
        DateTime.tryParse(value?.toString() ?? '')?.toLocal() ?? DateTime.now();

    return EventModel(
      id: json['id'] ?? '',
      titleEn: json['titleEn'] ?? '',
      titleZh: json['titleZh'] ?? '',
      descriptionEn: json['descriptionEn'] ?? '',
      descriptionZh: json['descriptionZh'] ?? '',
      locationEn: json['locationEn'] ?? '',
      locationZh: json['locationZh'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      startDate: parseDate(json['startDate']),
      endDate: parseDate(json['endDate']),
      organizerEn: json['organizerEn'] ?? '',
      organizerZh: json['organizerZh'] ?? '',
      tags: json['tags'] != null ? List<String>.from(json['tags']) : [],
      isFeatured: json['isFeatured'] ?? false,
      maxAttendees: json['maxAttendees'] ?? 0,
      currentAttendees: json['currentAttendees'] ?? 0,
      status: json['status'] ?? 'published',
    );
  }

  List<EventModel> _mergeEvents(
    List<EventModel> primary,
    List<EventModel> fallback,
  ) {
    final result = <EventModel>[];
    final seenIds = <String>{};

    for (final event in [...primary, ...fallback]) {
      if (event.id.isEmpty || seenIds.contains(event.id)) continue;
      seenIds.add(event.id);
      result.add(event);
    }

    return result;
  }

  bool _supportsOfflineEvent(String eventId) {
    return DataService.events.any((event) => event.id == eventId);
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
    );
  }
}
