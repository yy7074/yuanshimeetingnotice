import '../models/event_model.dart';
import '../models/session_model.dart';
import '../models/speaker_model.dart';
import '../models/user_model.dart';
import 'apscvir_site_service.dart';

class DataService {
  static const apscvir2026EventId = '20262026-0611-4614-8614-000000029839';
  static final DateTime _apscvirStartDate = DateTime(2026, 6, 11);
  static List<SessionModel>? _cachedDetailedSessions;
  static List<SessionModel>? _cachedProgramTasks;

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
          'https://admin.apscvir.top/uploads/events/apscvir-2026-meeting.png',
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
      final html = await ApscvirSiteService.loadAssetString(
        ApscvirSiteService.detailedProgramAsset,
      );
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

  static Future<List<SessionModel>> getProgramTasks(String eventId) async {
    if (eventId != apscvir2026EventId) return [];
    final cached = _cachedProgramTasks;
    if (cached != null) return cached;

    try {
      final html = await ApscvirSiteService.loadAssetString(
        ApscvirSiteService.detailedProgramAsset,
      );
      final parsed = _parseDetailedProgramData(html).tasks;
      _cachedProgramTasks = parsed;
      return parsed;
    } catch (_) {
      _cachedProgramTasks = const [];
      return const [];
    }
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
    return _parseDetailedProgramData(html).sessions;
  }

  static _DetailedProgramData _parseDetailedProgramData(String html) {
    final sessions = <SessionModel>[];
    final tasks = <SessionModel>[];
    var currentDate = _apscvirStartDate;
    var currentRoom = '';

    final markers = <_ProgramMarker>[
      for (final match in RegExp(
        r'<div class="program-style-time"[\s\S]*?</div>',
      ).allMatches(html))
        _ProgramMarker(match.start, match.end, _ProgramMarkerType.date),
      for (final match in RegExp(
        r'<div class="program-style-place"[^>]*>[\s\S]*?</div>',
      ).allMatches(html))
        _ProgramMarker(match.start, match.end, _ProgramMarkerType.room),
      for (final match in RegExp(
        r'<div class="program-style-title\b[^>]*>',
      ).allMatches(html))
        _ProgramMarker(match.start, match.end, _ProgramMarkerType.session),
    ]..sort((a, b) => a.start.compareTo(b.start));

    for (var i = 0; i < markers.length; i += 1) {
      final marker = markers[i];
      final markerHtml = html.substring(marker.start, marker.end);

      if (marker.type == _ProgramMarkerType.date) {
        final dateMatch = RegExp(
          r'(\d{4})-(\d{2})-(\d{2})',
        ).firstMatch(markerHtml);
        if (dateMatch != null) {
          currentDate = DateTime(
            int.parse(dateMatch.group(1)!),
            int.parse(dateMatch.group(2)!),
            int.parse(dateMatch.group(3)!),
          );
        }
        continue;
      }

      if (marker.type == _ProgramMarkerType.room) {
        final room = _cleanHtmlText(markerHtml);
        if (room.isNotEmpty) currentRoom = room;
        continue;
      }

      final sectionEnd = i + 1 < markers.length
          ? markers[i + 1].start
          : html.length;
      final section = html.substring(marker.start, sectionEnd);
      final timeText = _cleanHtmlText(
        RegExp(
              r'<div class="title-time">\s*([^<]+?)\s*</div>',
            ).firstMatch(section)?.group(1) ??
            '',
      );
      final rangeMatch = RegExp(
        r'(\d{2}:\d{2})\s*-\s*(\d{2}:\d{2})',
      ).firstMatch(timeText);
      if (rangeMatch == null) continue;

      final titleArea =
          RegExp(
            r'<div class="title-name">([\s\S]*?)</div>',
          ).firstMatch(section)?.group(1) ??
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
      final sessionId =
          'apscvir-2026-${_dateId(currentDate)}-${_slug(currentRoom)}-'
          '${rangeMatch.group(1)!.replaceAll(':', '')}-${_slug(title)}';
      final people = _parseSessionPeople(section);
      final contentTasks = _parseContentTasks(
        section: section,
        sessionId: sessionId,
        parentTitle: title,
        currentRoom: currentRoom,
        currentDate: currentDate,
        parentStart: start,
        parentEnd: end.isAfter(start)
            ? end
            : start.add(const Duration(hours: 1)),
        dayIndex: dayIndex,
      );
      final peopleTasks = _buildPeopleTasks(
        people: people,
        sessionId: sessionId,
        parentTitle: title,
        currentRoom: currentRoom,
        start: start,
        end: end.isAfter(start) ? end : start.add(const Duration(hours: 1)),
        dayIndex: dayIndex,
      );
      final facultyNames = <String>{};
      for (final person in people) {
        if (person.name.isNotEmpty) facultyNames.add(person.name);
      }
      for (final task in contentTasks) {
        if (task.speakerName.isNotEmpty) facultyNames.add(task.speakerName);
      }

      sessions.add(
        SessionModel(
          id: sessionId,
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
          speakerName: facultyNames.isEmpty
              ? 'APSCVIR Faculty'
              : facultyNames.join(', '),
          speakerTitleEn: 'APSCVIR 2026',
          speakerTitleZh: 'APSCVIR 2026',
        ),
      );
      tasks.addAll(peopleTasks);
      tasks.addAll(contentTasks);
    }

    return _DetailedProgramData(sessions: sessions, tasks: tasks);
  }

  static List<_ProgramPerson> _parseSessionPeople(String section) {
    final peopleBlock =
        RegExp(
          r'<div class="program-style-people">([\s\S]*?)<div class="program-style-line">',
        ).firstMatch(section)?.group(1) ??
        '';
    if (peopleBlock.isEmpty) return const [];

    final result = <_ProgramPerson>[];
    final pipStarts = RegExp(
      r'<div class="pip-content"[\s\S]*?>',
    ).allMatches(peopleBlock).map((match) => match.start).toList();
    final blocks = pipStarts.isEmpty
        ? <String>[peopleBlock]
        : [
            for (var i = 0; i < pipStarts.length; i += 1)
              peopleBlock.substring(
                pipStarts[i],
                i + 1 < pipStarts.length
                    ? pipStarts[i + 1]
                    : peopleBlock.length,
              ),
          ];

    for (final block in blocks) {
      final roleText = _cleanHtmlText(
        RegExp(
              r'<span[^>]*>\s*([^<：:]+)[：:]\s*</span>',
            ).firstMatch(block)?.group(1) ??
            '',
      );
      final role = roleText.isEmpty ? 'Faculty' : roleText;
      for (final anchorMatch in RegExp(
        r'<a\b[^>]*>[\s\S]*?</a>',
      ).allMatches(block)) {
        final anchor = anchorMatch.group(0) ?? '';
        final name = _extractAnchorName(anchor);
        if (!_isProgramPersonName(name)) continue;
        final fullText = _cleanHtmlText(anchor);
        final organization = fullText.startsWith(name)
            ? fullText.substring(name.length).trim()
            : '';
        result.add(
          _ProgramPerson(role: role, name: name, organization: organization),
        );
      }
    }

    return result;
  }

  static List<SessionModel> _buildPeopleTasks({
    required List<_ProgramPerson> people,
    required String sessionId,
    required String parentTitle,
    required String currentRoom,
    required DateTime start,
    required DateTime end,
    required int dayIndex,
  }) {
    return [
      for (final person in people)
        SessionModel(
          id: '$sessionId-${_slug(person.role)}-${_slug(person.name)}',
          eventId: apscvir2026EventId,
          titleEn: parentTitle,
          titleZh: parentTitle,
          descriptionEn: parentTitle,
          descriptionZh: parentTitle,
          roomEn: currentRoom,
          roomZh: currentRoom,
          startTime: start,
          endTime: end,
          type: _sessionTypeFor(parentTitle),
          speakerName: person.name,
          speakerTitleEn: person.organization,
          speakerTitleZh: person.organization,
          dayIndex: dayIndex,
          taskRole: person.role,
          taskPersonName: person.name,
          parentSessionTitle: parentTitle,
        ),
    ];
  }

  static List<SessionModel> _parseContentTasks({
    required String section,
    required String sessionId,
    required String parentTitle,
    required String currentRoom,
    required DateTime currentDate,
    required DateTime parentStart,
    required DateTime parentEnd,
    required int dayIndex,
  }) {
    final wrapperStarts = RegExp(
      r'<div class="program-style-content-wrapper">',
    ).allMatches(section).map((match) => match.start).toList();
    if (wrapperStarts.isEmpty) return const [];

    final tasks = <SessionModel>[];
    for (var i = 0; i < wrapperStarts.length; i += 1) {
      final start = wrapperStarts[i];
      final end = i + 1 < wrapperStarts.length
          ? wrapperStarts[i + 1]
          : section.length;
      final wrapper = section.substring(start, end);
      final timeText = _cleanHtmlText(
        RegExp(
              r'<div class="time common">([\s\S]*?)</div>',
            ).firstMatch(wrapper)?.group(1) ??
            '',
      );
      final topic = _cleanHtmlText(
        RegExp(
              r'<div class="type">[\s\S]*?<p>([\s\S]*?)</p>',
            ).firstMatch(wrapper)?.group(1) ??
            '',
      );
      final anchor =
          RegExp(r'<a\b[^>]*>[\s\S]*?</a>').firstMatch(wrapper)?.group(0) ?? '';
      final rawSpeaker = _extractAnchorName(anchor);
      final speaker = _isProgramPersonName(rawSpeaker) ? rawSpeaker : '';
      final organization = _cleanHtmlText(
        RegExp(
              r'<span class="td-org">([\s\S]*?)</span>',
            ).firstMatch(wrapper)?.group(1) ??
            '',
      );
      if (topic.isEmpty && speaker.isEmpty) continue;

      final range = RegExp(
        r'(\d{2}:\d{2})\s*-\s*(\d{2}:\d{2})',
      ).firstMatch(timeText);
      final taskStart = range == null
          ? parentStart
          : _timeOnDate(currentDate, range.group(1)!);
      final parsedEnd = range == null
          ? parentEnd
          : _timeOnDate(currentDate, range.group(2)!);
      final taskEnd = parsedEnd.isAfter(taskStart)
          ? parsedEnd
          : taskStart.add(const Duration(minutes: 8));
      final title = topic.isEmpty ? parentTitle : topic;

      tasks.add(
        SessionModel(
          id:
              '$sessionId-talk-${timeText.replaceAll(':', '').replaceAll('-', '')}-'
              '${_slug(speaker)}-${_slug(title)}',
          eventId: apscvir2026EventId,
          titleEn: title,
          titleZh: title,
          descriptionEn: parentTitle,
          descriptionZh: parentTitle,
          roomEn: currentRoom,
          roomZh: currentRoom,
          startTime: taskStart,
          endTime: taskEnd,
          type: _sessionTypeFor(title),
          speakerName: speaker,
          speakerTitleEn: organization,
          speakerTitleZh: organization,
          dayIndex: dayIndex,
          taskRole: speaker.isEmpty ? 'Agenda' : 'Speaker',
          taskPersonName: speaker,
          parentSessionTitle: parentTitle,
        ),
      );
    }

    return tasks;
  }

  static String _extractAnchorName(String anchorHtml) {
    if (anchorHtml.isEmpty) return '';
    final raw = anchorHtml.replaceAll(RegExp(r'<!--[\s\S]*?-->'), '<!--');
    final match = RegExp(
      r'<a\b[^>]*>\s*([^<]+?)\s*(?:<!--|</a>)',
    ).firstMatch(raw);
    if (match != null) return _cleanHtmlText(match.group(1) ?? '');
    return _cleanHtmlText(anchorHtml);
  }

  static bool _isProgramPersonName(String value) {
    final normalized = _normalizeProgramPersonMarker(value);
    if (normalized.isEmpty) return false;
    return normalized != 'all';
  }

  static String _normalizeProgramPersonMarker(String value) {
    final folded = value.toLowerCase().replaceAll(RegExp(r'[àáâãäåāăą]'), 'a');
    return folded.replaceAll(RegExp(r'[^a-z0-9\u4e00-\u9fa5]+'), '');
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
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'")
        .replaceAll('&rsquo;', "'")
        .replaceAll('&lsquo;', "'")
        .replaceAll('&ldquo;', '"')
        .replaceAll('&rdquo;', '"')
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

class _DetailedProgramData {
  final List<SessionModel> sessions;
  final List<SessionModel> tasks;

  const _DetailedProgramData({required this.sessions, required this.tasks});
}

class _ProgramMarker {
  final int start;
  final int end;
  final _ProgramMarkerType type;

  const _ProgramMarker(this.start, this.end, this.type);
}

enum _ProgramMarkerType { date, room, session }

class _ProgramPerson {
  final String role;
  final String name;
  final String organization;

  const _ProgramPerson({
    required this.role,
    required this.name,
    required this.organization,
  });
}
