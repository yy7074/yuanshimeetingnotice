import 'package:flutter/services.dart';

import '../models/event_model.dart';
import '../models/session_model.dart';
import '../models/speaker_model.dart';
import '../models/user_model.dart';

class DataService {
  static const apscvir2026EventId = '20262026-0611-4614-8614-000000029839';
  static const _apscvirDetailedProgramAsset =
      'assets/apscvir2026/site/pages/1814797-detailed-program.html';
  static final DateTime _apscvirStartDate = DateTime(2026, 6, 11);
  static List<SessionModel>? _cachedDetailedSessions;

  // Local fallback user for offline/dev auth only.
  static const demoUser = UserModel(
    id: 'user_001',
    email: 'demo@apscvir.org',
    nameEn: 'APSCVIR Delegate',
    nameZh: 'APSCVIR Delegate',
    titleEn: 'Conference Attendee',
    titleZh: 'Conference Attendee',
    organizationEn: 'APSCVIR 2026',
    organizationZh: 'APSCVIR 2026',
    avatarUrl: '',
    role: UserRole.vip,
  );

  static final List<EventModel> events = [
    EventModel(
      id: apscvir2026EventId,
      titleEn:
          '20th Annual Scientific Meeting of Asia Pacific Society of Cardiovascular and Interventional Radiology',
      titleZh:
          '20th Annual Scientific Meeting of Asia Pacific Society of Cardiovascular and Interventional Radiology',
      descriptionEn:
          'Official APSCVIR 2026 meeting information for Suzhou, including registration, program, venue, and attendee services. Faculty and detailed agenda content should be checked on the official website.',
      descriptionZh:
          'Official APSCVIR 2026 meeting information for Suzhou, including registration, program, venue, and attendee services.',
      locationEn:
          'Suzhou International Expo Centre, 688 E. Suzhou Avenue, Suzhou Industrial Park, Suzhou, Jiangsu Province, China',
      locationZh:
          'Suzhou International Expo Centre, 688 E. Suzhou Avenue, Suzhou Industrial Park, Suzhou, Jiangsu Province, China',
      imageUrl:
          'http://139.129.23.105:3201/uploads/events/apscvir-2026-meeting.png',
      startDate: DateTime(2026, 6, 11),
      endDate: DateTime(2026, 6, 14),
      organizerEn: 'APSCVIR 2026 Organizing Committee',
      organizerZh: 'APSCVIR 2026 Organizing Committee',
      tags: ['APSCVIR', 'Interventional Radiology', 'Cardiovascular', 'Suzhou'],
      isFeatured: true,
      currentAttendees: 0,
      maxAttendees: 0,
    ),
  ];

  static final List<SpeakerModel> speakers = [];

  static List<SessionModel> getSessions(String eventId) {
    if (eventId != apscvir2026EventId) return [];
    return List.unmodifiable(_apscvir2026ProgramAtGlanceSessions);
  }

  static Future<List<SessionModel>> getDetailedSessions(String eventId) async {
    if (eventId != apscvir2026EventId) return [];
    final cached = _cachedDetailedSessions;
    if (cached != null) return cached;

    try {
      final html = await rootBundle.loadString(_apscvirDetailedProgramAsset);
      final parsed = _parseDetailedProgram(html);
      if (parsed.isNotEmpty) {
        _cachedDetailedSessions = parsed;
        return parsed;
      }
    } catch (_) {}

    final fallback = getSessions(eventId);
    _cachedDetailedSessions = fallback;
    return fallback;
  }

  static final List<SessionModel> _apscvir2026ProgramAtGlanceSessions = [
    _session(
      id: '1199392',
      day: 11,
      dayIndex: 0,
      room: 'A1-A101',
      start: '14:00',
      end: '15:30',
      title: 'EVAR and TEVAR 1',
      speakerName:
          'Robert Morgan, Wei Guo, Andrew Holden, Shi-Jie Xin, Yukihisa Ogawa, Rui Feng',
    ),
    _session(
      id: '1199393',
      day: 11,
      dayIndex: 0,
      room: 'A1-A101',
      start: '15:30',
      end: '17:00',
      title: 'EVAR and TEVAR 2',
      speakerName:
          'Jeon Yong Sun, Wei-Guo Fu, KIANG HIONG TAY, Qing-Sheng Lu, Bulent Arslan, Joon Ho Kwon',
    ),
    _session(
      id: '1232395',
      day: 11,
      dayIndex: 0,
      room: 'A1-A102',
      start: '16:00',
      end: '18:00',
      title: 'Advisory board of IR',
      type: SessionType.workshop,
    ),
    _session(
      id: '1232399',
      day: 11,
      dayIndex: 0,
      room: 'A1-A104',
      start: '14:00',
      end: '16:00',
      title: 'Y-90 proctor meeting',
      type: SessionType.workshop,
    ),
    _session(
      id: '1220644',
      day: 11,
      dayIndex: 0,
      room: 'A1-A108',
      start: '14:00',
      end: '15:05',
      title: 'Executive Master of Interventional Radiology 1',
      type: SessionType.workshop,
      speakerName:
          'Gao-Jun Teng, Qing-Quan Zu, Mao Yang, Hao-Chen Wang, Meng-Xuan Zuo, Fu-An Wang',
    ),
    _session(
      id: '1220645',
      day: 11,
      dayIndex: 0,
      room: 'A1-A108',
      start: '15:05',
      end: '16:05',
      title: 'Executive Master of Interventional Radiology 2',
      type: SessionType.workshop,
      speakerName:
          'Rui An, Song-Nan Zhang, Jin-Long Yan, Lei Li, Li-Yun Zheng, Hui Zeng',
    ),
    _session(
      id: '1220646',
      day: 11,
      dayIndex: 0,
      room: 'A1-A108',
      start: '16:05',
      end: '17:05',
      title: 'Executive Master of Interventional Radiology 3',
      type: SessionType.workshop,
      speakerName: 'Ning Ai, Li-Nan Yin, Yong-Hui Xia, Jin-Peng Li, Wei Gao',
    ),
    _session(
      id: '1277553',
      day: 11,
      dayIndex: 0,
      room: 'A1-A108',
      start: '17:05',
      end: '18:10',
      title: 'Executive Master of Interventional Radiology 4',
      type: SessionType.workshop,
      speakerName: 'Yang Zhao, Jian Zhang, Tuo-Xuan Jin, Hai-Peng Yu',
    ),
    _session(
      id: '1212741',
      day: 11,
      dayIndex: 0,
      room: 'A1-A109',
      start: '14:00',
      end: '15:30',
      title: 'Committee Meeting',
    ),
    _session(
      id: '1212740',
      day: 11,
      dayIndex: 0,
      room: 'A1-A109',
      start: '15:30',
      end: '17:00',
      title: 'ISMIO China Session',
    ),
    _session(
      id: '1212737',
      day: 11,
      dayIndex: 0,
      room: 'A1-A110',
      start: '14:00',
      end: '15:30',
      title: 'Passing the Torch Mentoring Program',
      type: SessionType.workshop,
      speakerName:
          'Ho-Young Song, Hang Yuan, Nan Jiang, Jian Li, Jin-Rong Qu, Rui-Fang Ni',
    ),
    _session(
      id: '1212742',
      day: 11,
      dayIndex: 0,
      room: 'A1-A110',
      start: '15:30',
      end: '18:00',
      title: 'Interventional Oncology Book Compilation',
      type: SessionType.workshop,
    ),
  ];

  static List<SessionModel> _parseDetailedProgram(String html) {
    final sessions = <SessionModel>[];
    var currentDate = _apscvirStartDate;
    var currentRoom = '';

    final markerPattern = RegExp(
      r'<div class="program-style-time"[\s\S]*?</div>|'
      r'<div class="program-style-place"[^>]*>[\s\S]*?</div>|'
      r'<div class="program-style-title[\s\S]*?<div class="program-style-line"',
    );

    for (final match in markerPattern.allMatches(html)) {
      final marker = match.group(0) ?? '';

      if (marker.contains('program-style-time')) {
        final dateMatch = RegExp(r'(\d{4})-(\d{2})-(\d{2})').firstMatch(marker);
        if (dateMatch != null) {
          currentDate = DateTime(
            int.parse(dateMatch.group(1)!),
            int.parse(dateMatch.group(2)!),
            int.parse(dateMatch.group(3)!),
          );
        }
        continue;
      }

      if (marker.contains('program-style-place')) {
        final room = _cleanHtmlText(marker);
        if (room.isNotEmpty) currentRoom = room;
        continue;
      }

      final timeText = _cleanHtmlText(
        RegExp(
              r'<div class="title-time">\s*([^<]+?)\s*</div>',
            ).firstMatch(marker)?.group(1) ??
            '',
      );
      final rangeMatch = RegExp(
        r'(\d{2}:\d{2})\s*-\s*(\d{2}:\d{2})',
      ).firstMatch(timeText);
      if (rangeMatch == null) continue;

      final titleArea =
          RegExp(
            r'<div class="title-name">([\s\S]*?)</div>',
          ).firstMatch(marker)?.group(1) ??
          '';
      final title = RegExp(r'<p>([\s\S]*?)</p>')
          .allMatches(titleArea)
          .map((m) => _cleanHtmlText(m.group(1) ?? ''))
          .firstWhere((value) => value.isNotEmpty, orElse: () => '');
      if (title.isEmpty || currentRoom.isEmpty) continue;

      final start = _timeOnDate(currentDate, rangeMatch.group(1)!);
      final end = _timeOnDate(currentDate, rangeMatch.group(2)!);
      final dayIndex = DateTime(
        currentDate.year,
        currentDate.month,
        currentDate.day,
      ).difference(_apscvirStartDate).inDays;

      sessions.add(
        SessionModel(
          id:
              'apscvir-2026-${_dateId(currentDate)}-${_slug(currentRoom)}-'
              '${rangeMatch.group(1)!.replaceAll(':', '')}-${_slug(title)}',
          eventId: apscvir2026EventId,
          titleEn: title,
          titleZh: title,
          descriptionEn: 'APSCVIR 2026 Detailed Program session.',
          descriptionZh: 'APSCVIR 2026 Detailed Program session.',
          roomEn: currentRoom,
          roomZh: currentRoom,
          startTime: start,
          endTime: end.isAfter(start)
              ? end
              : start.add(const Duration(hours: 1)),
          type: _sessionTypeFor(title),
          dayIndex: dayIndex,
          speakerName: 'APSCVIR Faculty',
          speakerTitleEn: 'APSCVIR 2026',
          speakerTitleZh: 'APSCVIR 2026',
        ),
      );
    }

    return sessions;
  }

  static SessionModel _session({
    required String id,
    required int day,
    required int dayIndex,
    required String room,
    required String start,
    required String end,
    required String title,
    SessionType type = SessionType.panel,
    String speakerName = 'APSCVIR Faculty',
  }) {
    return SessionModel(
      id: 'apscvir-2026-$id',
      eventId: apscvir2026EventId,
      titleEn: title,
      titleZh: title,
      descriptionEn: 'APSCVIR 2026 scientific program session.',
      descriptionZh: 'APSCVIR 2026 scientific program session.',
      roomEn: room,
      roomZh: room,
      startTime: _timeOnDate(DateTime(2026, 6, day), start),
      endTime: _timeOnDate(DateTime(2026, 6, day), end),
      type: type,
      dayIndex: dayIndex,
      speakerName: speakerName,
      speakerTitleEn: 'APSCVIR 2026',
      speakerTitleZh: 'APSCVIR 2026',
    );
  }

  static DateTime _timeOnDate(DateTime date, String time) {
    final parts = time.split(':');
    return DateTime(
      date.year,
      date.month,
      date.day,
      int.parse(parts[0]),
      int.parse(parts[1]),
    );
  }

  static SessionType _sessionTypeFor(String title) {
    final lower = title.toLowerCase();
    if (lower.contains('break') || lower.contains('poster')) {
      return SessionType.breakTime;
    }
    if (lower.contains('keynote') || lower.contains('ceremony')) {
      return SessionType.keynote;
    }
    if (lower.contains('oral presentation') || lower.contains('abstract')) {
      return SessionType.researchPaper;
    }
    if (lower.contains('workshop') ||
        lower.contains('proctor') ||
        lower.contains('master') ||
        lower.contains('symposium')) {
      return SessionType.workshop;
    }
    return SessionType.panel;
  }

  static String _cleanHtmlText(String value) {
    return value
        .replaceAll(RegExp(r'<!--[\s\S]*?-->'), ' ')
        .replaceAll(RegExp(r'<[^>]+>'), ' ')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  static String _dateId(DateTime date) {
    return '${date.year}${date.month.toString().padLeft(2, '0')}'
        '${date.day.toString().padLeft(2, '0')}';
  }

  static String _slug(String value) {
    final slug = value
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'^-+|-+$'), '');
    return slug.isEmpty ? 'session' : slug;
  }
}
