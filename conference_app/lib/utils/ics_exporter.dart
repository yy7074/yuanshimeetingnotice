import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../models/session_model.dart';

/// Build a minimal RFC 5545 iCalendar payload for a list of sessions.
/// Times are emitted as UTC (Z suffix) so any calendar client can import them.
class IcsExporter {
  static String build(
    List<SessionModel> sessions, {
    required bool isZh,
    String calendarName = 'APSCVIR My Schedule',
  }) {
    final buf = StringBuffer();
    buf.writeln('BEGIN:VCALENDAR');
    buf.writeln('VERSION:2.0');
    buf.writeln('PRODID:-//APSCVIR//Conference App//EN');
    buf.writeln('CALSCALE:GREGORIAN');
    buf.writeln('METHOD:PUBLISH');
    buf.writeln('X-WR-CALNAME:${_escape(calendarName)}');
    final now = _formatUtc(DateTime.now().toUtc());
    for (final session in sessions) {
      final title = isZh ? session.titleZh : session.titleEn;
      final description = isZh ? session.descriptionZh : session.descriptionEn;
      final location = isZh ? session.roomZh : session.roomEn;
      buf.writeln('BEGIN:VEVENT');
      buf.writeln('UID:${session.id}@apscvir');
      buf.writeln('DTSTAMP:$now');
      buf.writeln('DTSTART:${_formatUtc(session.startTime.toUtc())}');
      buf.writeln('DTEND:${_formatUtc(session.endTime.toUtc())}');
      buf.writeln('SUMMARY:${_escape(title)}');
      if (description.isNotEmpty) {
        buf.writeln('DESCRIPTION:${_escape(description)}');
      }
      if (location.isNotEmpty) {
        buf.writeln('LOCATION:${_escape(location)}');
      }
      buf.writeln('BEGIN:VALARM');
      buf.writeln('ACTION:DISPLAY');
      buf.writeln('DESCRIPTION:${_escape(title)}');
      buf.writeln('TRIGGER:-PT15M');
      buf.writeln('END:VALARM');
      buf.writeln('END:VEVENT');
    }
    buf.writeln('END:VCALENDAR');
    return buf.toString();
  }

  /// Writes the ICS to a temp file and opens the platform share sheet.
  static Future<void> share(
    List<SessionModel> sessions, {
    required bool isZh,
    String fileName = 'my-schedule.ics',
    String subject = 'APSCVIR My Schedule',
  }) async {
    final content = build(sessions, isZh: isZh);
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$fileName');
    await file.writeAsString(content);
    await Share.shareXFiles([
      XFile(file.path, mimeType: 'text/calendar', name: fileName),
    ], subject: subject);
  }

  static String _formatUtc(DateTime dt) {
    final u = dt.toUtc();
    String two(int n) => n.toString().padLeft(2, '0');
    return '${u.year.toString().padLeft(4, '0')}${two(u.month)}${two(u.day)}'
        'T${two(u.hour)}${two(u.minute)}${two(u.second)}Z';
  }

  /// Escape per RFC 5545: backslash, newline, comma, semicolon.
  static String _escape(String text) {
    return text
        .replaceAll('\\', r'\\')
        .replaceAll('\n', r'\n')
        .replaceAll('\r', '')
        .replaceAll(',', r'\,')
        .replaceAll(';', r'\;');
  }
}
