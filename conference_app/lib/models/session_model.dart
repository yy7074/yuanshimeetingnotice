class SessionModel {
  final String id;
  final String eventId;
  final String titleEn;
  final String titleZh;
  final String descriptionEn;
  final String descriptionZh;
  final String roomEn;
  final String roomZh;
  final DateTime startTime;
  final DateTime endTime;
  final SessionType type;
  final String speakerId;
  final String speakerName;
  final String speakerTitleEn;
  final String speakerTitleZh;
  final String speakerAvatarUrl;
  final int dayIndex;
  final String taskRole;
  final String taskPersonName;
  final String parentSessionTitle;

  const SessionModel({
    required this.id,
    required this.eventId,
    required this.titleEn,
    required this.titleZh,
    this.descriptionEn = '',
    this.descriptionZh = '',
    required this.roomEn,
    required this.roomZh,
    required this.startTime,
    required this.endTime,
    required this.type,
    this.speakerId = '',
    this.speakerName = '',
    this.speakerTitleEn = '',
    this.speakerTitleZh = '',
    this.speakerAvatarUrl = '',
    this.dayIndex = 0,
    this.taskRole = '',
    this.taskPersonName = '',
    this.parentSessionTitle = '',
  });

  String get timeRangeStr {
    String fmt(DateTime dt) =>
        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    return '${fmt(startTime)} - ${fmt(endTime)}';
  }

  String get typeLabel => switch (type) {
    SessionType.keynote => 'KEYNOTE',
    SessionType.researchPaper => 'RESEARCH PAPER',
    SessionType.workshop => 'WORKSHOP',
    SessionType.panel => 'PANEL',
    SessionType.breakTime => 'BREAK',
  };
}

enum SessionType { keynote, researchPaper, workshop, panel, breakTime }
